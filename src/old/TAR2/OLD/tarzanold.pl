% need numeric compatiabiliy
% need BIG paths

:- dynamic range/2,path/4.
:- op(800,xfx,@).
:- discontiguous f/1, node/7.
:- dynamic iwant/1.

term_expansion(iwants(L),[iwants(L),IWANT]) :-
	findall(One, wanteds(L,One),    IWANT).

wanteds(In,iwant(Attr)) :-
	member(Attr=_-[_|_]@_,In).
     
term_expansion((+X :- Y),All) :-
	findall(X,Y,All).

term_expansion(node(Source, Me, Parent, Range, Class),Out) :-
	(legal(Range,Attr,Values)
	-> trans(Range,Range1),
	   Out = node(Source,Me,Parent,Range1,Attr,Values,Class)
	;  Out = []).

trans(X,Y) :-
	X =.. [OP,Param,Attr0],
	trans1(OP,Attr0,OP1,Attr),
	Y =.. [OP1,Param,Attr],!.
trans(X,_) :- print(ooops(X)),nl.

legal(Range,Attr,Values) :-
	arg(1,Range,Attr),
	xpands(Range,Values),
	iwants(Wants), 
	fairNough(Attr,Wants,Values).

/*
	belief(BWant),
	(member(Attr=[Now|Nows]-_@BGot,Wants),  BGot >= BWant
	 -> intersection(Values,[Now|Nows],[_|_])
	;   (member(Attr=_-[Goal|Goals]@ _ , Wants) 
	     -> intersection(Values,[Goal|Goals],[_|_])
             ;  true)).
*/

fairNough(Attr,Wants,Values) :-
	member(Attr=Nows0-Goals@BGot,Wants)
	->	(belief(BWant),
		 BGot >= BWant
		->  Nows=Nows0
		;   Nows=[]
                ),
		union(Nows,Goals,All),
		fairNough1(All,Values)
	;	true.

fairNough1([],_).
fairNough1([H|T],Values) :-
	intersection(Values,[H|T],[_|_]).
	
xpands(t,t) :- !.
xpands(Thing,Range) :-
	bagof(Value,Thing^xpand(Thing,Value),Range),!.
xpands(Thing,Range) :-
	print(failedOn(xpands(Thing,Range))),nl,
	fail.

xpand(Thing,Number) :-
	Thing =.. [Op,Attr,Value],
	what(Attr,Type),
	range(Type,Number),
	Term =.. [Op,Number,Value],
	Term.
	
ensure(X) :- X -> true ; assert(X).
		
add(X=Y,Wme,[X=[H|T]|Less]) :-
	oneLess(Wme,X=Z,Less),!,
	intersection(Y,Z,[H|T]). %non-nil intersect
add(X=Y,Wme,[X=Y|Wme]).
	
oneLess([One|Less],One,Less).
oneLess([H|T],One,[H|Less]) :-
	oneLess(T,One,Less).

allNodes(Nodes) :-
	 setof(One,A^B^C^D^(
			path(A,B,C,D),
			member(One,D)),
		Nodes),!.
allNodes([]).

nNodes(Nodes) :-
	allNodes(All),
	length(All,Nodes).
g:-
	format('digraph G {rankdir=LR;~n',[]),
	format('subgraph cluster0 {~n',[]),
	format(' label="";~n 1 [label="start",shape=plaintext];~n}',[]),
	forall(classes,true),
	format(' subgraph cluster1 {~n',[]),
	format(' label=""; color=white;~n',[]),
	allNodes(All),
	forall(nodes(All),true),
	forall(edges(All),true),
	format('}~n',[]),
	format('}~n',[]).
	
classes :-
	range(classt,Class),
	format('~a [style=filled,color=black,label="~w"];~n',[Class,Class]).

nodes(All) :- 
	member(Me,All),
	node(_,Me,_,AV,_,_,_),
	format('~a [shape=plaintext,label="~w"];~n',[Me,AV]).
	
edges(All) :-  
	edges(1,All).

edges(Parent,All) :-
	node(_,Me,Parent,_,_,_,Class),
	Me \= Parent,
	member(Me,All),
	format('~a -> ~a;~n',[Parent,Me]),
	(Class=t
	->	edges(Me,All)
	;       format('~a -> ~a;~n',[Me,Class])).

reload :-
	treeFile(F),
	[F],
	makePaths.

n(F/A,N) :-
	functor(G,F,A),
	flag(n,_,0),
	forall(G,flag(n,Old,Old+1)),
	flag(n,N,N).

:- index(path(1,1,0,0)).
:- index(route(1,1,0)).

makePaths :-
	retractall(path(_,_,_,_)),	
	retractall(route(_,_,_)),
	forall((path1(Items),member(Item,Items)), assert(Item)).
	%forall(isCompatiable(Bid,Gid), assert(compatiable(Bid,Gid))).

isCompatiable(Bid,Gid) :-	
	path(_,Bid,_,_),
        path(_,Gid,_,_), 
        Gid \= Bid, 
        \+badChange(Bid,Gid).

path1([path(Class,Id,S,Nodes)|Routes]) :-
	path2(S,Id,Class,Nodes,Wme),
	findall(route(Id,Attr,Values),
                         member(Attr=Values,Wme) 
                      ,Routes).

path2(Source,Id,Class,Nodes,Wme) :-
	path2(Source,1,Id,Class,[_|Nodes],[],Wme).

path2(Source,Parent,Me,Class,[Parent,Me],Wme0,Wme) :-
	node(Source,Me,Parent,_,A,V,Class),
	Class \= t,
	add(A=V,Wme0,Wme).
path2(Source,Parent,Id,Class,[Parent|Rest],Wme0,Wme) :-
	node(Source,Me,Parent,_,A,V,t),
	add(A=V,Wme0,Wme1),
	path2(Source,Me,Id,Class,Rest,Wme1,Wme).

:- dynamic relevant1/3.

relevants :-
	rawFile(F),
	retractall(relevant1(_,_,_)),
	forall(relevant(Good,Bad,_,_,R),
               ensure(relevant1(Good,Bad,R))),
	forall(relevant1(Good,Bad,R),
		format('in,~p,to,~p,from,~p,via,~p~n',[F,Good,Bad,R])).

countUp(X,X) :- print(X),nl.

relevant(Good,Bad,Bid,Gid,Attr=[Int|Ints]) :-
	iwants(IW),
	pivotal(Good,Bad,Bid,Gid,Attr=Deltas),
	member(Attr= _ -[New|News]@_,IW), 
	intersection(Deltas,[New|News],[Int|Ints]). 
	
pivotal(Good,Bad,Bid,Gid,Attr=Diff) :-
	path(Bad,Bid,_,_),
	Diff = [_|_],
	goodChange(Bid,Bad,Good,Gid,[_|_],[_|_],Attr,Diff).

goodChange(Bid,Bad,Good,Gid, 
		BadValues,   % e.g. [_|_]   for a list at least 1 long
		GoodValues,  % e.g. [_|_]   for a list at least 1 long
                Attr,   % e.g. [_,_|_] for a list at least 2 long
        
        Diff) :-
	path(Good,Gid,_,_),
	Good \= Bad,
	\+badChange(Bid,Gid),
	route(Bid,Attr,BadValues), 	
	iwant(Attr), 
	route(Gid,Attr, GoodValues),
	deletes(BadValues,GoodValues,Diff).

deletes([],In,In).
deletes([H|T],In,Out) :-
	delete(In,H,Temp),
	deletes(T,Temp,Out).

badChange(Bid,Gid) :-
	route(Bid,Attr,BadValues), 	
	\+iwant(Attr), 
	route(Gid,Attr,GoodValues),
	intersection(GoodValues,BadValues,[]).


go :-
	time(go1).

go1   :- 
	write('relevants...'),nl,
	outFile(F),
	tell(F),
	relevants,	
	told,

	write('generating graph...'),nl,

	dotFile(Dot),
	tell(Dot), g, told,

	write('generating reports...'),nl,
	resFile(Res),
	tell(Res),
	nNodes(Nodes),
	n(path/4,Paths),
	n(relevant1/3,R),
	format('~p nodes ~p paths ~p graph ~p relevantChange(s)~n',
               [Nodes,Paths,Dot,R]),
	told.

subs(In,One) :- 
	setof(N-Sub,In^(sub(In,Sub),length(Sub,N)),All),
	member(_-One,All).

sub([],[]).
sub([H|T],[H|Rest]) :- sub(T,Rest).
sub([_|T],Rest) :- sub(T,Rest).


experiments(Treatments,Treatment,All) :-
	
	subs(Treatments,Treatment),
	bagof(Class-Ways,Treatment^experiment(Treatment,Class,Ways),All),
	 	nl,
	maplist(xreport(Treatment),All,_).

xreport(Treatment,What-N,_) :-
	format('~p | ~p | ~p   ~n', [Treatment,What,N]).

experiment(Treatment,Class,Ways) :-
	range(classt,Class),
	flag(ways,_,0),
	forall(acceptablePath(Class,Treatment),flag(ways,X,X+1)),
	flag(ways,Ways,Ways).

acceptablePath(Class,Rules) :-
	path(Class,Pid,_,_),
	\+ unacceptablePath(Pid,Rules).

unacceptablePath(Pid,Rules) :-
	member(Attr=Values,Rules),
	route(Pid,Attr,Used),
	intersection(Used,Values,[]).
	
	

