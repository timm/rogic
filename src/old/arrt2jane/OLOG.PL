:- +[base].

:- X=me/1, discontiguous(X),multifile(X), dynamic(X).


term_expansion(X = Y,Out) :-
	bagof(Z,X^Y^access(X=Y,Z),Out).

access(Handle = Wme,Out) :-
	functor(Wme,  Functor,Arity),
	arg(Pos,Wme,Item),
        joinArgs(1,Arity,Pos,L1,Old,New,L2),
        Term1 =.. [Functor|L1],
        Term2 =.. [Functor|L2],
	Out   =.. [Handle,Item,Old,New,Term1,Term2].
access(Handle = Wme,(portray(Term) :-
	               write(Handle))) :-
	functor(Wme,Functor,Arity),
	functor(Term, Functor,Arity).
access(Handle = _,(:- discontiguous Handle/3)).
access(Handle = _,Term) :-
	Term =.. [Handle,self(X),X,X].

joinArgs(M,N,_,[],_,_,[]) :- M > N,!.
joinArgs(N,Max,N,[Old|In],Old,New,[New|Out]) :- !,
	N1 is N + 1,
        joinArgs(N1,Max,N,In,Old,New,Out).
joinArgs(N0,Max,N,[X|L0],Old,New,[X|L]) :-
	N1 is N0 + 1,
	joinArgs(N1,Max,N,L0,Old,New,L).

