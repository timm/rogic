
dotty(Dot,Eps) :-
	sformat(Todo1,'cmd /c "c:\\program files\\graphviz\\bin\\dotty.exe" ~w',[Dot]),
	%sformat(Todo2,'if exist ~w del ~w',[Eps,Eps]),
	sformat(Todo3,'cmd /c "c:\\program files\\graphviz\\bin\\dot.exe" -Tps ~w > ~w',
	             [Dot,Eps]),
	win_exec(Todo1,iconic),
        %win_exec(Todo2,iconic),
	win_exec(Todo3,iconic).

report :- report('kb.dot','kb.eps').

report(F1,F2) :-
	tell(F1),
	report1,
	told,
	dotty(F1,F2).
	
report1 :-
	format('digraph G {
        rankdir=LR;
	ranksep=0.2
        node [shape=plaintext]\n',[]),
	report2(Edges),
	forall(member(e(A0,B0,C),Edges),
	       (nameOf(A0,A),
	        nameOf(B0,B),
		format('\t"~w" [label="~w"]\n',[A0,A]),
				format('\t"~w" [label="~w"]\n',[B0,B]),
		format('\t"~w" -> "~w" [label="~w"]\n',[A0,B0,C]))
	   ),
	format('}\n',[]).

report2(Edges) :-
	bagof(E,edge(E),All),
%	All=Edges.
	pruneEdges(All,Edges).

pruneEdges([],[]).
pruneEdges([e(Y=t, Z,'')|Tail],Out) :-
%	print(-Y),nl,
	invented1(Y),
	select(e(X,Y=t,L),Tail,Less),!,%print(+pruned),nl,
	pruneEdges([e(X,Z,L)|Less],Out).
pruneEdges([H|T],[H|Out]) :-
	pruneEdges(T,Out).


xx(E1,E2) :-
	X = (authorization=t),
	Y = (authorization(1)),
	L = "?0.1 ",
	Z = rand(rand2049),
	E1=e(X,Y=t,L),
	E2=e(Y=t,Z,'').

invented1(Z) :-
	functor(Z,_,1),
	arg(1,Z,N),
	number(N).
	
+ (nameOf(T,What) :- !), comb(What),T =.. [What,_].
nameOf(X=t,X) :- !.
nameOf(X,X).

edge(Edge) :-
	clause(rule(_,?X=Y,_,Cost0,Chances0,_,_),do(How,_,_)),
	must(inRange(Cost,Cost0)),
	must(inRange(Chances,Chances0)),
	label('?',Chances,Chances1),
	label('$',Cost,Cost1),
	sformat(Tag,'~w~w',[Chances1,Cost1]),
	edge1(How,X=Y,Tag,Edge).

label('$',0,  '') :- !.
label('?',1,  '') :- !.
label(Prefix,X,  S) :- sformat(S,'~w~w ',[Prefix,X]).

must(X) :- X,!.
must(X) :- print(failed(X)),nl,fail.
+ (edge1(Term,From,L,E) :-
	gensym(What,Id0),
	Id =.. [What,Id0],
	(E=e(Id,From,  L) ;
	member(Arg,Args),
	edge1(Arg,Id,'',E))
    ),
	comb(What),
	Term =.. [What,Args].
	
edge1(?To,From, L,e(To,From,L)).



% SWI unix users:    these command should work ok with standard
%                    utilities, once graphviz is compiled on your system.
%                    (to find graphviz, go to Google).
% SWI windows users: dot -Tgif network.dot > network.gif SHOULD work,
%                    and then you wont need the eps2gif magic. However,
%                    I can't test that on my LINUX box
magicCommand(genEps,'dot -Tps network.dot > network.eps').
magicCommand(eps2gif,'ee network.eps &').


style(and,ellipse).
style(or,box).
style(not,triangle).
style(mutex,dashed).

edges2Dot(Edges) :-
	tell('network.dot'),
	edges2Dot1(Edges),
	told,
	forall(magicCommand(_,X),shell(X)).
 
edges2Dot1(Edges) :-
	write('digraph G {'),nl,
	defNodes(Edges,and,_),
	defNodes(Edges,or,Ors),
	defNodes(Edges,not,Nots),
	defYesEdges(Edges),
	defNoEdges(Ors,Nots),
        write('}'), nl.

defYesEdges(Edges) :-
	member(e(To,From,Id),Edges),
	format('\t"~w" -> "~w" [label="~w"];\n',[To,From,Id]),
        fail.
defYesEdges(_).

defNoEdges(Ors,Nots) :-
	style(mutex,Style),
	member(not X, Nots),
	member(X,Ors),
	format('\t"~w" -> "~w" [style=~w,dir=both];\n',[X,not X,Style]),
	fail.
defNoEdges(_,_).

defNodes(Edges,Type,All) :-
	style(Type,Shape),
	types(Type,Edges,All),
	forall(member(One,All),
	       format('\t"~w" [shape=~w]\n',[One,Shape])).

