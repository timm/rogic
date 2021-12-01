% optimization
goal_expansion(o(X,Y,Z),Out) :-
	clause(o(X,Y,Z),Out).

% dcg repair
goal_expansion(>(A,B,C,C), A > B).

%%%%%%%%%%%%%%%%%%%%%%%

% accessors
v(valuable,  A0, A, v(A0, B,  C), v(A, B, C)).
v(cost,      B0, B, v(A,  B0, C), v(A, B, C)).
v(maturity,  C0, C, v(A,  B, C0), v(A, B, C)).

% shell tricks
o(X=Y)       --> v(X,Y,Y).
o(mature)    --> o(maturity=Y), Y > 100.
o(expensive) --> o(cost=Y),     Y > 10000.

buyWine -->  o(mature), \+ o(expensive).

% writing the accessor




term_expansion(X=L,Out) :-
	makeAccessors(X=L,Out).

makeAccessors(X,Out) :-
	bagof(One,X^makeAccessor(X,One),Out).

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

newV= [valuable,cost,maturity].
