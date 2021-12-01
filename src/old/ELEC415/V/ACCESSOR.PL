% auto-writing the accessor
term_expansion(X=L,Out) :-
	makeAccessors(X=L,Out).

makeAccessors(X,Out) :-
	bagof(One,X^makeAccessor(X,One),Out).

% serious prolog guru magic starts
makeAccessor(Functor=Fields,Out) :-
	length(Fields,Arity),
	functor(Term1,Functor,Arity),
	functor(Term2,Functor,Arity),
	nth1(Pos,Fields,Item),
	joinArgs(Pos,Old,New,Term1,Term2),
	Out =.. [Functor,Item,Old,New,Term1,Term2].

joinArgs(N,Old,New,T1,T2) :-
    T1 =.. [_|L0],
    T2 =.. [_|L],
    joinArgs(1,N,L0,Old,New,L).
joinArgs(N,N,[Old|Rest],Old,New,[New|Rest]).
joinArgs(N0,N1,[X|L0],Old,New,[X|L]) :-
    N0 < N1,
    N2 is N0 + 1,
    joinArgs(N2,N1,L0,Old,New,L).
% end serious prolog guru magic

% optimization
goal_expansion(o(X,Y,Z),Out) :-
	clause(o(X,Y,Z),Out).

