swaps(What,Swaps,Out) :-
        bagof(One,What^headBody(What,One),Temp),
	maplist(runiv(Swaps),Temp,Out).

headBody(Functor/Arity,One) :-
	functor(Head,Functor,Arity),
	clause(Head,Body),
	(Body=true -> One=Head ; (One=(Head :- Body))).
	
runiv(Swaps,Term0,Term) :-
        Term0 =..L0,
        once(maplist(runiv1(Swaps), L0, L)),
        Term =.. L.

runiv1(_,H,H)  :- var(H).
runiv1(Swaps,Old,New)  :- atomic(Old), member(Old/New,Swaps),!.
runiv1(_,H,H) :- atomic(H).
runiv1(Swaps,H0,H) :- runiv(Swaps,H0,H).

select([],[]).
select([H|T0],[H|T]) :- '#P'(H), !, select(T0,T).
select([_|T0],T) :- select(T0,T).

:- op(999,xfx,with).

term_expansion(Mine is Skeleton/Arity with Swaps,Out) :-
	swaps(Skeleton/Arity,[Skeleton/Mine|Swaps],Out).

myVowels is select/2 with ['#P'/vowel].
myCons   is reject/2 with ['#P'/vowel].

vowel(97).  %a
vowel(101). %e
vowel(105). %i
vowel(111). %o
vowel(117). %u

