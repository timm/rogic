term_expansion(X = Y,Out) :-
	bagof(Z,X^Y^access(X=Y,Z),Out).

access(Handle = Wme,(portray(Term) :- write(Handle))) :-
	functor(Wme,  Functor,Arity),
	functor(Term, Functor,Arity).
access(Handle = Wme,  goal_expansion(X,true)) :-
	optimize(Handle,Wme,X).
access(Handle = Wme,Out) :-
	functor(Wme,  F,Arity),
	arg(Pos,Wme,Item),
        joinArgs(F,Arity,Pos,Old,New,Term1,Term2),
	Out   =.. [Handle,Item,Old,New,Term1,Term2].

joinArgs(F,Arity,Pos,Old,New,Term1,Term2) :-
	length(L1,Arity),
	Pos0 is Pos - 1,
	length(Before,Pos0),
	append(Before,[Old|After],L1),
	append(Before,[New|After],L2),
	Term1 =.. [F|L1],
	Term2 =.. [F|L2].

optimize(Handle,Wme,Out) :-
	functor(Wme, F,A),
	functor(X,   F,A),
	functor(Y,   F,A),
	(Out= isa(Handle,X)
	;Out= self(X,X,X)
        ;Out= self(X,Y,X,Y)).
