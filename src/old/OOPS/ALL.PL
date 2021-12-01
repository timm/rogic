prim(bool(X),X).

isPrim(Prim,Dashed) :-
	prim(X,_),
	functor(X,Prim,_),
	dashed(Prim,Dashed).

usePattern(prim, ['#me'/Dashed, '#prim'/Prim]) :-
	isPrim(Prim,Dashed).

usePattern(fact, ['#me'/Dashed, '#fact'/Prim]) :-
	isPrim(



value(X,Y) :- prim(X,Y),!.
value(X,X).