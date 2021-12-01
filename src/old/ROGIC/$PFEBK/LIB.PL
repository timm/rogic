runiv(T,L1) :-	T  =.. L0, once(maplist(runiv1,L0,L1)).

runiv1(H,H)  :- var(H). 
runiv1(H,H)  :- atomic(H).
runiv1(H0,H) :- runiv(H0,H).

:- dynamic r/2,i/3.
:- discontiguous r/2,i/3.

term_expansion(wme(X),Out) :-
	makeWme(X,Out).

makeWme(X,[r(What,New)|Out]) :-
	X =.. [What|L],
	functor(X,What,Arity),
	functor(New,What,Arity),
	findall(i(What,Item,Pos),
		  nth1(Pos,L,Item),
                Out).

fPlace(W,K,I) :-
	functor(W,F,_),
	i(F,K,I).

o([],W,W).
o([H|T],W0,W) :- o(H,W0,W1), o(T,W1,W).

o(K=V,W,W) :- 
	fPlace(W,K,I),
	arg(I,W,V).
o(K was V0 is V,W,W) :- 
	fPlace(W,K,I),
	arg(I,W,V0),
	setarg(I,W,V).
o(K is V,W,W) :-
	fPlace(W,K,I),
	arg(I,W,V0),
	setarg(I,W,V).
o(+K,W,W) :- 
	o(K was Old is New,W0,W),
	New is Old + 1.
o(-K,W,W) :-
	o(K was Old is New,W0,W),
	New is Old - 1.

wme(ht0(iteration,goals,maxProved)).
wme(kb(goalN,time,route)).


		
