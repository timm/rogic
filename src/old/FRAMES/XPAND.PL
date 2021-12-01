term_expansion(X =Wme,Out) :-
	bagof(Y,X^access(X,Y),Out).

access(X = Wme,Out) :-
	functor(Wme,  Functor,Arity),
	functor(Term1,Functor,Arity),
	functor(Term2,Functor,Arity),
	arg(Pos,Wme,Item),
	joinArgs(Pos,Old,New,Term1,Term2),
	Out =.. [Functor,Item,Old,New,Term1,Term2].

joinArgs(N,Old,New,T1,T2) :-
	T1 =.. [_|L0],
	joinArgs(1,N,L0,Old,New,L),
	T2 =.. [_|L].
joinArgs(N,N,[Old|Rest],Old,New,[New|Rest]).
joinArgs(N0,N1,[X|L0],Old,New,[X|L]) :-
	N0 < N1,
	N2 is N0 + 1,
	joinArgs(N2,N1,L0,Old,New,L).

term_expansion(<> X,Out) :-
	bagof(Y,X^xpand(X,Y),Out).


xpand(X0 or Y0,Z) :-(Z0=X0;Z0=Y0),xpand(Z0,Z).

