
prints([X]) :- !,write(X).
prints(X)   :- write(X).

mybagof(X,Y,Z) :- bagof(X,Y,Z),!.
mybagof(_,_,[]).

oneLessN(1,[H|T],H,T) :- !.
oneLessN(N0,[H|T],X,[H|Rest]) :- N is N0 - 1, oneLessN(N,T,X,Rest).	
bassert(X) :- assert(X).
bassert(X) :- retract(X),fail.
