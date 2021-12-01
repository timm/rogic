:- [db].

def([maxDepth=10,world=0,proof=0]).

o(A = B,W0,W)  :- field(A,B,B,W0,W).
o(A is B,W0,W) :- field(A,_,B,W0,W).
o(A <  B,W0,W) :- field(A,Old,[B|Old],W0,W).
o([],W,W).
o([H|T],W0,W)  :- o(H,W0,W1),o(T,W1,W).


run(do((X,Y)))--> run(do(X)), run(do(Y)).
run(do(X))    --> X \= ((_,_)), run(X).
run((X,Y))    --> {c2l((X,Y),N,List)},run(thrash(N,L)).
run(thrash(0,[])).
run(thrash(N,L0)) :-
	


c2l((X0,Y),N1,[X|Z]) :- !, c2l(Y,N,Z), N1 is N + 1.
c2l(X,1,[X]).

oneLessAtN(1,[H|T],H,T) :- !.
oneLessAtN(N0,[H|T],Out,[H|Rest]) :-
	N is N - 1,
	oneLessAt(N,T,Out,Rest).
s
/*


prove0(X) --> newProofItem(X), ok2Use(X). 

%prove(_) :- 1 is random(9), X is cputime, forever(Y), X > Y,!,fail.

prove((X,Y))--> !, prove(X), prove(Y).
prove(X)    --> {in(X)}, prove0(X).
prove(X)    --> 
	prove0(X), 
	{aClause(X,Y)}, 
        incN, 
        prove(Y).

incN(prove(N0,P,A), prove(N,P,A)) :- N is N0 + 1.

ok2Use(X,P,P) :- culled(X),!,fail. 
ok2Use(X,P,P) :- fact(X),!. 
ok2Use(X,prove(N,P,A0),prove(N,P,A)) :- 
	whenWhat(X,WW), insert(A0,WW,N/eq,A).

newProofItem(X,prove(N,P0,A),prove(N,P,A)) :-
	whenWhat(X,WW),	insert(P0,WW,N/after,P).

getPath(P,prove(P,A),prove(P,A)).
putPath(P,prove(_,A),prove(P,A)).

aClause(X,Z) :- 
	findall(C, (clause(X,C0)
                   ,orderSubGoals(C0,C)
                   ), L0), 
	orderClauses(L0,L),
	member(Z,L).

*/
