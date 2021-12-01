dialect_file(defedge).  
dialect_file(classes).   
dialect_file(links).   
dialect_file(ok2fail).   
dialect_file(rules).   
dialect_file(i). 

dialect_files(D,[dialects,D,F]) :- dialect_file(F).

load_dialect(D) :- 
	wmeClear(dialect), 
	dialect_files(D,F),
	my_file(F,'.pl',Path),
	my_consult(Path),
	fail.
load_dialect(_) :-
	link(Op,_,_),
	op(700,xfx,Op),
	fail.
load_dialect(_).

known_dialect(D) :-
	my_file([data,dialect,D],F),
	exists_file(F).

load_theory(Dialect,Fname) :-
	data(Fname,_,_),
	sformat(S,'% [~q]: already loaded. Reload?',[Fname]),
	yesno(S),
	!,
	load_theory1(Dialect,Fname).
load_theory(Dialect,Fname) :-
	not(data(Fname,_,_)),
	!,
	load_theory1(Dialect,Fname).
load_theory(_,_).
	
load_theory1(Dialect,Fname) :-
	format('loading [~q]~n',[Fname]),
	wmeClear,
	load_dialect(Dialect),
	theory_file(Dialect,Fname,'.dat',Data),
	theory_file(Dialect,Fname,'.net',Net),
	my_consult(Data),
	my_consult(Net).

% dialect indendepent things
links(Link,C1,V1,C2,V2) :-
	can_effect(C1,C2),
	possibleValue(C1,V1), 
	possibleValue(C2,V2),
	link(Link,C1/V1,C2/V2).

pos(C/V)     :- class(C,_,Pos,_,_,_), member(V,Pos).
neg(C/V)     :- class(C,_,_,_,Neg,_), member(V,Neg).
neutral(C/V) :- class(C,_,_,Neu,_,_), member(V,Neu).

possibleValue(C,V) :- pos(C/V) | neg(C/V) | neutral(C/V).

domain(C,Out) :- 
	class(C,_,Pos,Neg,Neu,_), 
	append(Pos,Neg,Temp1), 
	append(Temp1,Neu,Out).

labels(Labels) :-
	member(Label,Labels), 
	op(700,xfx,Label),
	fail.
labels(_).

% check missing theory details
% and nodes

compile(D,File) :-
	load_dialect(D),
	theory_file(D,File,'.the',Theory),
	theory_file(D,File,'.net',Network),
	theory_file(D,File,'.obs',Observations),
	theory_file(D,File,'.dat',Data),
	compile_theory(D,Theory,Network),
	compile_observations(D,Observations,Data).

theory_file(D,Head,Type,Out) :-
	my_file([dialects,D,theories,Head],Type,Out).

compile_theory(D,In,Out) :-
	compile_theory_generate(D,In),
	compile_theory_print(Out,D).

compile_theory_generate(D,In) :-
	see(In),
	current_stream(In,_,Stream),
	compileTheoryFile(Stream,1,D,0,10),
	seen,
	editRules.

compile_theory_print(Out,D) :-
	tell(Out),
	write('% '), write(D),nl,
        wmePrint1(_,names),wmePrint1(_,theory), 
	wmePrint1(_,theoryDetail),
	told.

compile_observations(D,In,Out) :-
	exists_file(In),
	!,
	see(In),
	current_stream(In,_,Stream),
	compileObservationsFile(Stream,1,D,0,10),
	seen,
	tell(Out),
	wmePrint1(_,data),
	told.

compile_observations(_,In,_) :-
	print('missing observations file ['),print(In),print(']'),nl.

compileTheoryFile(_,_,_,Errors0,MaxErrors) :-  
	Errors0 > MaxErrors , !,
	write('Compile cancelled: too many errors'), nl.
compileTheoryFile(S,N,File,Errors0,MaxErrors) :-  
	line_count(S,Line),
	read(Thing),
	(Thing = end_of_file
        ->  true
        |   compileTheoryFile1(Thing,N,File,Line,Errors0,Errors1),
	    N1 is N + 1,
	    compileTheoryFile(S,N1,File,Errors1,MaxErrors)).

compileTheoryFile1(Thing,N,File,Line,Errors0,Errors1) :- 
	compileTheory1(Thing,N,Messages,Result),
	assertResults(Messages, Result,N,Thing),
	compilerMessages(Messages,Thing,File,Line,Errors0,Errors1),
	!.
compileTheoryFile1(_,_,_,_,E,E).

% really must generalise this to a "compile file" predicate
compileObservationsFile(_,_,_,Errors0,MaxErrors) :-  
	Errors0 > MaxErrors , !,
	write('Compile cancelled: too many errors'), nl.
compileObservationsFile(S,N,File,Errors0,MaxErrors) :-  
	line_count(S,Line),
	read(Thing),
	(Thing = end_of_file
        ->  true
        |   compileObservationsFile1(Thing,N,File,Line,Errors0,Errors1),
	    N1 is N + 1,
	    compileObservationsFile(S,N1,File,Errors1,MaxErrors)).

compileObservationsFile1(Thing,N,File,Line,Errors0,Errors1) :- 
	compileObservations1(Thing,N,Messages,Result),
	assertResults(Messages, Result,N,Thing),
	compilerMessages(Messages,Thing,File,Line,Errors0,Errors1),
	!.
compileObservationsFile1(_,_,_,_,E,E).

assertResults(Messages,_,_,_)    :- member(e=_,Messages), !.
assertResults(_,Results,N,Thing) :- ensures([source(N,Thing)|Results]).

compilerMessages([],        _,    _,    _,   Errors, Errors).
compilerMessages([M|Ms],    Thing,File, Line,Errors0,Errors) :-
	compilerMessage(M,  Thing,File, Line,Errors0,Errors1),
	compilerMessages(Ms,Thing,File, Line,Errors1,Errors).

compilerMessage(e=X,Thing,File,Line,E0,E) :- 
	E is E0 + 1,
	compilerMessage1('E',X,File,Line,Thing).
compilerMessage(w=X,Thing,File,Line,E,E) :- 
	compilerMessage1('W',X,File,Line,Thing).

compilerMessage1(What,X,File,Line,Thing) :-
	format('~w> [~w] ~q: ~w : [~q]~n',[What,File,Line,X,Thing]).

compileTheory1(X,_,                  
	[e='variable on input'],
	[]) :- 
	\+ ground(X).

compileTheory1(name = X,_,
	[],                     
	[d(X)]).

compileTheory1(objects(Class) = _Thing,_,
	[e= unknownType(Class)], 
	[]) :-
	\+ isAClass(Class,_).

compileTheory1(objects(_Class) = List,_,
	[e=badList], 
	[]) :-
	\+ listp(List).

compileTheory1(objects(Class0) = List,N,
	[], 
	Out) :-
	isAClass(Class0,Class),
	compileObjects(List,Class,N,[],Out).

compileTheory1(if W then not Edge,_,[e='unknown objects'],[]) :-
	defEdge(_,Edge,X,Y),
	(\+ o(_,W,event)
        ; \+ o(_,X,_)
	; \+ o(_,Y,_)
	),!.

compileTheory1(if W then Edge,_,[e='unknown objects'],[]) :-
	defEdge(_,Edge,X,Y),
	(\+ o(_,W,event)
        ; \+ o(_,X,_)
	; \+ o(_,Y,_)),!.

compileTheory1(if _ then not Edge,_,[],[]) :-
	defEdge(_,Edge,_,_).

compileTheory1(if _ then Edge,_,[],[]) :-
	defEdge(_,Edge,_,_).

compileTheory1(Edge,_,[e='unknown objects'],[]) :-
	defEdge(_,Edge,X,Y),
	(\+ o(_,X,_)
	; \+ o(_,Y,_)),!.

compileTheory1(Edge,N,[],Out) :-
	defEdge(Label,Edge,From,To),
	compileEdge(Label,From,To,N,Out).

compileTheory1(_,_,[e='?'],    []).

compileObservations1(observations = Events + _Measurements,_,
	[e='observation events must be a list'],
	[]) :-
	\+ listp(Events).

compileObservations1(observations = Events + _Measurements,_,
	[e=notKnownEvents(Nots)],
	[]) :-
	notGoodEvents(Events,[],Nots),
	\+ Nots = [].

compileObservations1(observations = _Events + Measurements,_,
	[e='observation measurements must be a list'],
	[]) :-
	\+ listp(Measurements).

compileObservations1(observations = _Events +  Measurements,_,
	[e=notKnownMeasures(Nots)],
	[]) :-
	notGoodMeasure(Measurements,[],Nots),
	\+ Nots = [].

compileObservations1(observations = _Events + _Measurements,_,
	[e='missing ''name'''],
	[]) :-
	\+ d(_).

compileObservations1(observations = Events + Measurements,_,
	[],
	[data(Name,Events,Measurements)]) :-
	d(Name).
  
compileObservations1(_,_,[e='?'],    []).

compileEdge(Op,O1,O2,N,Out) :-
	bagof(Assertion,Op^O1^O2^N^compileEdge1(Op,O1,O2,N,Assertion),Out).

compileEdge1(Op,O1a,O2a,N,Out) :-
	event2EventChange(O1a,O1),
	event2EventChange(O2a,O2),
	o(Oid1,O1,Class1),
	o(Oid2,O2,Class2),
	links(Op,Class1,Value1,Class2,Value2),
	oli(Oid1,Lid1),
	l(Lid1,O1, Value1),
	lvi(Lid1,  Vid1),
	oli(Oid2,Lid2),
	l(Lid2,O2, Value2),
	lvi(Lid2,  Vid2),
	newN(Id),
	member(Out, [e(Id,Vid1,Vid2,1,N),ei(Vid1,Id), ebi(Vid2,Id)]).

isAClass(X,X) :- class(X,_,_,_,_,_),!.
isAClass(X,Y) :- class(Y,X,_,_,_,_).

event2EventChange(X,change(X)) :-
	coi(event,Oid),
	o(Oid,X,_), !.
event2EventChange(X,X).

notGoodEvents([],Out,Out).
notGoodEvents([Events |Eventss],In, Out) :- 
	notOfClass(Events,event,In,In1),
	notGoodEvents(Eventss,In1,Out).

notGoodMeasure([],Out,Out).
notGoodMeasure([X - _Values|Rest],In,Out) :-
	(o(_,X,measure) -> Next = In | Next = [X|In]),
	notGoodMeasure(Rest,Next,Out), !.

notOfClass([],     _,Out,Out).
notOfClass([O |Os],C,In, Out) :- \+ o(_,O,C),!,	notOfClass(Os,C,[O|In],Out).
notOfClass([_O|Os],C,In, Out) :- notOfClass(Os,C,In,Out).


compileObjects([],_,_,List,List).
compileObjects([Object|Objects],Class,N,List0,List) :-
	compileObject(Object,Class,N,List0,Temp),
	compileObjects(Objects,Class,N,Temp,List).

compileObject(Object,event,N,In,Out) :- !,
	% special processing for events: generate eventchanges
	% as a side effect of compiling events.
	compileObject1(change(Object),eventChange,N,In,  Temp),
	compileObject1(Object,        event,      N,Temp,Out).

compileObject(Object,Class,N,In,Out) :-
	compileObject1(Object,Class,N,In,Out).

compileObject1(Object,Class,_,In,[o(Oid,Object,Class),coi(Class,Oid)|Out]) :-
	compileObjectType(Class,Type),
	newN(Oid),
	domain(Class,D),
	andLiteralVertices(D,Object,Oid,Type,In,Out).

compileObjectType(and,and) :- !.
compileObjectType(_,or).

andLiteralVertices([],_,_,_,Out,Out).
andLiteralVertices([Value|Values],Object,Oid,Type,Out0,Out) :-
	newN(Lid), 
	Vid = Lid,
	andLiteralVertices(Values,Object,Oid,Type,[oli(Oid,Lid),
			                      l(Lid,Object,Value), 
			                      lvi(Lid,Vid),
                                              v(Vid,Lid,Type)|Out0],
			                     Out).

steadyConnections(All) :-
	bagof(X,Out1^Out2^(steadyConnection(Out1,Out2),
	                   (member(X,Out1) | member(X,Out2))),
	      All).

steadyConnection(Out1,Out2) :-
	S = steadies,
	steadyVertex(V),
	posNeg(V,PosV,NegV),
	parent(PosV,Pos),
	parent(NegV,Neg),
	value(Pos,Object1,_),
	value(Neg,Object2,_),
	\+ Object1 = Object2,
	newN(E1), newN(E2), newN(E3),
	Out1 = [e(E1,Pos,Vand,   0,S),
	        e(E2,Neg,Vand,   0,S),
		e(E3,Vand,    V,1,S),
		ei(Pos,E1), ei(Neg,E2), ei(Vand,E3),
		ebi(Vand,E1),    ebi(Vand,E2), ebi(V,E3)],
	newAnd(_,Vand,Out2).

newAnd(AndObject,AndVertex,AndStuff) :-
	gensym(and,AndObject),
	compileObject(AndObject,and,_,[],AndStuff),
	member(v(AndVertex,_,and),AndStuff).

insertAnds([],_,Out,Out).
insertAnds([H|T],Va,In,Out):- 
	insertAnd(H,Va,In,Temp), 
	insertAnds(T,Va,Temp,Out).

insertAnd(e(_,V1,V2,C,S),Va,In,
	[e(E1,V1,Vand,0,and(S)),  ei(V1,E1),   ebi(Vand,E1),
	 e(E2,Vand,V2,C,and(S)),  ei(Vand,E2), ebi(V2,E2),
	 e(E3,Va,Vand,0,and(S)),  ei(Va,E3),   ebi(Vand,E3)
	 | Rest ]) :- !,
	newAnd(_AndObject,Vand,AndStuff),
	newN(E1), newN(E2), newN(E3),
	append(AndStuff,In,Rest).

insertAnd(_,_,Out,Out).

editRules :-	
	downTo(10,1,Priority), 
	editRule(Priority,Addits,Retracts), 
	retracts(Retracts),
	ensures(Addits), 
	fail.
editRules.

/*editRule(9,
	[e(Eid,V1,V2,1,eventTacit1),ei(V1,Eid), ebi(V2,Eid)],
	[]) :-
	object2Value(eventChange,change(Object),arrived,V1),
	object2Value(event,      Object,        present,V2),
	newN(Eid).

editRule(9,
	[e(Eid,V1,V2,1,eventTacit2),ei(V1,Eid), ebi(V2,Eid)],
	[]) :-
	object2Value(eventChange,change(Object),left,  V1),
	object2Value(event,      Object,        absent,V2),
	newN(Eid).
*/

/* commented out by Sam 20/5/97
editRule(8,Out,[]) :-
	source(N,if Abler then Y),
	\+ Y = not _,
	defEdge(Edge,Y,From,To),
	compileEdge(Edge,From,To,abler(N),ProposedEdges),
	object2Value(event,Abler,present,AblerV),
	insertAnds(ProposedEdges,AblerV,[],Edges),
	compileEdge(Edge,change(Abler),To,abler(N),Extras),
	member(Out,[Extras,Edges]).
*/

editRule(8,Out,[]) :-
	source(N,if DisAbler then not Y),
	defEdge(Edge,Y,From,To),
	compileEdge(Edge,From,To,disabler(N),ProposedEdges),
	object2Value(event,DisAbler,absent,DisAblerV),
	insertAnds(ProposedEdges,DisAblerV,[],Edges),
	(oppEdge(Edge,Opp) | oppEdge(Opp,Edge)),
	compileEdge(Opp,change(DisAbler),To,disabler(N),Extras),
	member(Out,[Extras,Edges]).

editRule(7,Out,[]) :- % steady vertices
	steadyConnections(Out).

editRule(6,
	[parents(V,All)],
	[]) :-
	vertex(V),
	setof(P,V^parent(V,P),All).

editRule(6,
	[kids(V,All)],
	[]) :-
	vertex(V),
	setof(K,V^kid(V,K),All).

editRule(6,
	[i(V1,V2)],
	[]) :- 
	invariant(i(V1,V2)).

editRule(5,
	[i(V1,V2),i(V2,V1)],
	[]) :-
	l(Lid1,Object,absent),
	l(Lid2,change(Object),arrived),
	lvi(Lid1,V1),
	lvi(Lid2,V2).

editRule(5,
	[i(V1,V2),i(V2,V1)],
	[]) :-
	l(Lid1,Object,present),
	l(Lid2,change(Object),left),
	lvi(Lid1,V1),
	lvi(Lid2,V2).
	
editRule(3,
	[noGoods(V,Set)],
	[]) :-
	vertex(V),
	setof(V1,V^i(V,V1), Set).








































	





























