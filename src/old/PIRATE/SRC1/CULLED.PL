
prettyPrint0(Term,One) :-
	functor(Term,S0,Arity),
	functor(Blank,S0,Arity),
	accessorName(S0,S1),
	clause(pp0(Blank),Body),
	subF((pp0(Blank) :- Body),[struct0/S0,struct1/S1,pp0/pp],One).

wmes1(Term,One) :-	
	functor(Term,S1,_), 
	accessorName(S1,S0), 
	expandStruct0(S0,S1,One).

%% tree stuff

term2Tree(X,Y) :- term2Tree1(X,Y), !.

term2Tree1(X, l(var,X)) :- 
	var(X).
term2Tree1(Term,Out) :- 
	functor(Term,Functor,Arity), 
	term2Tree2(Arity,Term,Functor,Out).

term2Tree2(0,Term,_,l(Term)).
term2Tree2(1,Term,Functor,n(Functor,X)) :-
	arg(1,Term,X0),	term2Tree(X0,X).
term2Tree2(2,Term,Functor,n(Functor,X,Y)) :-
	arg(1,Term,X0), term2Tree(X0,X),
	arg(2,Term,Y0),	term2Tree(Y0,Y).
term2Tree2(_,Term,Functor,l(Functor,Term)).

tPrint(T) :- tPrint(T,0).

tPrint(l(X),N)     :- wln(N,l(X)).
tPrint(l(X,Y),N)   :- wln(N,l(X,Y)).
tPrint(n(X,Y),N)   :- wln(N,X), N1 is N+3, tPrint(Y,N1).
tPrint(n(X,Y,Z),N) :- wln(N,X), N1 is N+3, tPrint(Y,N1), tPrint(Z,N1).
