% capsule.pl

% auto-build accessors

/* ---------------------------
e.g.
d=date(year,month,day,daysThisMonth).

becomes

d(year,         A,B,date(A,C,D,E),date(B,C,D,E)).
d(month,        A,B,date(C,A,D,E),date(C,B,D,E)).
d(day,          A,B,date(C,D,A,E),date(C,D,B,E)).
d(daysThisMonth,A,B,date(C,D,E,A),date(C,D,E,B)).

---------------------------- */

term_expansion(X=Y,Z) :-
	capsules(X=Y,Z).

capsules(X = Y,Out) :-
	% the bagof trick- define a method
	% to find one solution. wrap it in
	% a bagof to find them all.
	bagof(Z,X^Y^capsule(X=Y,Z),Out).

capsule(Handle = Term,Out) :-
	functor(Term,F,Arity),
	% arg backtracks through all Items in Pos 
	arg(Pos,Term,Item),
        joinArgs(F,Arity,Pos,Old,New,Term1,Term2),
	% names accessor generated here
	Out =.. [Handle,Item,Old,New,Term1,Term2].

joinArgs(F,Arity,Pos,Old,New,Term1,Term2) :-
	length(L1,Arity),
	Pos0 is Pos - 1,
	length(Before,Pos0),
	append(Before,[Old|After],L1),
	append(Before,[New|After],L2),
	Term1 =.. [F|L1],
	Term2 =.. [F|L2].
