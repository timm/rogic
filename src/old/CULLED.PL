
swaps(Functor,Arity,Swaps,Out) :-
	functor(Head,Functor,Arity),
	clause(Head,Body),
	runiv(Swaps,(Head :- Body),Out).
	
runiv(Swaps,T0,T) :- T0 =..L0, once(maplist(runiv1(Swaps), L0, L)), T =.. L.

runiv1(_,H,H)  :- var(H).
runiv1(Swaps,Old,New)  :- atomic(Old), member(Old=New,Swaps),!.
runiv1(_,H,H)  :- atomic(H).
runiv1(Swaps,H0,H)  :- runiv(Swaps,H0,H).
