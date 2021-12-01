term_expansion((+X:-Y),Out) :- !, bagof(One,X^Y^xpand((X:-Y),One),All).
term_expansion((+X),Out)    :- bagof(One,X^Y^xpand((X:-true),One),All).

given b...
a :- b,c,d.
k :- l,g,f.
s :- i,j,;.

x(X,Y)           :- var(X),!.
x([],[])         :- !.
x([H0|T0],[H|T]) :- !,x(H0,H), x(T0,T).
x((X0,Y0),(X,Y)) :- !,x([X0,Y0],[X,Y]).
x((X0|Y0),Z)     :- !,(x(X0,Z) ; x(Y0,Z)).
x(not(X,Y),Z)    :- !,x((not(X);not(Y)),Z)).
x(not(X;Y),Z)    :- !,x(not(X,Y),Z).
x(not

negate(X,not(X)).
i(X,not(X)).
i(not(X),X).
