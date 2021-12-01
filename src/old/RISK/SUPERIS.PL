% requires timm's db.pl
% for an example, see superiseg.pl

:- op(1,fx,?), op(1,fx,!).

term_expansion((Table-Head :- Body),L) :-  
        bagof(X,Table^Head^Body^
                 method(-,Table,Head,Body,X),L).
term_expansion((Table-Head),X) :-
	term_expansion((Table-Head :- true),X).
term_expansion((Table=Head),X) :- 
        term_expansion((Table=Head :- true),X).
term_expansion((Table=Head :- Body),L) :- 
        bagof(X,Table^Head^Body^
                 method(=,Table,Head,Body,X),L).

method(Mode,A,Head0,Body0,Out) :-
	isa(A,In),
	method(Mode,In,Head0,Body0,Head,Body),
	(Body=true
	-> Out=Head
	; Out=(Head :- Body)).

method1(=,In,Head0,Body0,Head,Body) :-
	append2Args(Head0,In,Out,Head),
	swap(Body0,Body,In,Out).
method1(-,In,Head0,Body0,Head,Body) :-
	append1Arg(Head0,In,Head),
	swap(Body0,Body,In,_).

append1Arg(Old,In,New) :- 
	Old=.. L0,append(L0,[In],L),New=.. L.
append2Args(Old,In,Out,New) :- Old =.. 
	L0, append(L0,[In,Out],L), New=.. L.

swaps(X,X,In,In)   :- var(X),!.
swaps(-X,Y,In,In)  :- !,append1Arg(X,In,Y).
swaps(=X,Y,In,Out) :- !,append2Args(X,In,Out,Y).
swaps((W0->X0;Y0),(W->X;Y),In,Out) :- !,
	swaps(W0,W,In,Temp),
	swaps(X0,X,Temp,Out),
	swaps(Y0,Y,In,Out).
swaps((X;Y),Z,In,Out) :- !,
	(Z0=X;Z0=Y),
	swaps(Z0,Z,In,Out).
swaps(?X,Y,In,In) :- !,	touch(In,X,Y,_,_).
swaps(!X,Y,In,Out) :- !, touch(In,X,_,Y,Out).
swaps([],[],Out,Out) :- !,
swaps([H0|T0],[H|T],In,Out) :- !,
	swaps(H0,H,In,Temp),
	swaps(T0,T,Temp,Out).
swaps(X,Y,In,Out)  :- 
	X =.. L0, 
	swaps(L0,L1,In,Out),
	Y =.. L1.
















