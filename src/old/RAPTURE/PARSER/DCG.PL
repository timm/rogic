demo :-
	 tokens(Tokens), 
	 program(Tokens,[],[],Wme,Tree), 
	 nlprint(Tree), nl,
	 forall(member(X,Wme),(print(X),nl)),nl.

term_expansion((X -> []),Out) :- !,
	Out =.. [X,Y,Y,Z,Z].
term_expansion((W -> X|Y),Out) :- !,
	bagof(One, X^Y^Z^(
                     dmember((X|Y),Z),
                     term_expansion((W -> Z),One)
                   ),
	      Out).
term_expansion((X -> Y),(Head :- Body)) :-
	Head =.. [X,Tin,Tout,Win,Wout,[X|Z]],
	c2l(Y,Y1),
	xpands(Y1,Y2,[],Z,Tin,Tout,Win,Wout),
	l2c(Y2,Body).

xpands([],[],Z,Z,T,T,W,W).
xpands([H0|T0],[H|T],Z0,Z,Tin,Tout,Win,Wout) :-
	xpand(H0,H, Z0,Z1,Tin,  Ttemp,Win,  Wtemp),
	xpands(T0,T,Z1,Z, Ttemp,Tout, Wtemp,Wout).

xpand(X,Y,Z0,Z,T0,T,W0,W) :-
	(xpand0(X,Y,T0,T,W0,W),
	 Z=Z0
	;xpand1(X,Y,Z1,T0,T,W0,W),
         append(Z0,[Z1],Z)
        ),
	!.

xpand0({X},              X,                      T,T,W, W).
xpand0(X ? Y,            lfind(X,Y,W0,W),        T,T,W0,W).
xpand0(X is Y,           lset(X,Y,W0,W),         T,T,W0,W).
xpand0(X << Y,           lpush(X,Y,W0,W),        T,T,W0,W).
xpand0(-- X,             lzap(X,W0,W),           T,T,W0,W).
xpand0(X ++ Y,           lmaths(X,Y,W0,W),       T,T,W0,W).


xpand1(L,append(L,T,T0), [terminals|L],            T0,T,W,W):- 
        is_list(L).
xpand1(X,Y,Z,                                    T0,T,W0,W):-
	functor(X,F,_),
	Y =.. [F,T0,T,W0,W,Z].

dmember((X|Y),Z) :- !, (Z=X;dmember(Y,Z)).
dmember(X,X).

c2l((X,Y0),[X|Y]) :- !, c2l(Y0,Y).
c2l(X,[X]).

l2c([H],H) :- !.
l2c([H|T],(H,Rest)) :- l2c(T,Rest).


mytab(N,C) :- forall(between(1,N,_),(write(C),write(' '))).
nlprint(L) :- nlprint(L,0).

nlprint([],_) :- !.
nlprint([H|T],D0) :- !,
	nl,
        mytab(D0,'|'),
	write(H),
	nlprint1(T,D0).

nlprint1([],_).
nlprint1([H|T],D0) :-
	(is_list(H) 
        ->  D is D0 + 1, nlprint(H,D)
        ;   write(' '), write(H)),
	nlprint1(T,D0).
 :- [grammar3].
:- listing(proctypes).
