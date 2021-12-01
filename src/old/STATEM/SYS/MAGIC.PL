term_expansion((:- m(X), Y),All) :- findall(X,Y,All).

:- multifile pattern/2.

/*term_expansion((usePattern(P,Swaps) :- Body),Out) :- !,
	bagof(One, Body^P^Swaps^
                    (Body,
                     swaps(P,Swaps,One)), Out).
 
term_expansion(usePattern(P,Swaps),Out) :- 
	term_expansion((usePattern(P,Swaps):-true),Out). 
*/
	
swaps(P,Swaps,Out):-
	clause(pattern(P,Head),Body),
	(ground(Body), Body=true -> In=Head; In=(Head :- Body)),
	swap(In,Swaps,Out).

swap(X,Swaps,Y)   :- X =.. L0, maplist(swap1(Swaps),L0,L1), Y =.. L1.
swap1(_,H,H)      :- var(H),!.
swap1(Swaps,H0,H) :- member(H0/H,Swaps),!.
swap1(_,H,H)      :- atomic(H),!.
swap1(Swaps,H0,H) :- swap(H0,Swaps,H).


