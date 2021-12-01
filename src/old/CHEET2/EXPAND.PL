term_expansion(X if Y,Out) :- bagof(One,X^Y^xpandRule(X if Y,One),Out).

xpandRule(X if Y,rule(X,L)) :-
	simp(Y,Z),
	t2l(Z,L).

simp(X,Y) :- simp1(X,Y),!.
simp1(not X and Y,    Out) :- simp(not X or   not Y,Out).
simp1(not (X rand Y), Out) :- simp(not X ror  not Y,Out).

simp1(not (X or Y),   Out) :- simp(not X and  not Y,Out).
simp1(not (X ror Y),  Out) :- simp(not X rand not Y,Out).
simp1(not not X,      Out) :- simp(X,Out).
simp1(not X,          X=f).

a if b and c and d or e.
