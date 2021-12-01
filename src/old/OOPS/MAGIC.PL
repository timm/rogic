:- multifile pattern/2.
term_expansion((usePattern(P,Swaps) :- Body),Out) :-
	bagof(One, Body^P^Swaps^
                    (Body,
                     swaps(P,Swaps,One)), Out).

swaps(P,Swaps,Out):-
	clause(pattern(P,Needs,Head),Body),
	\+ missing(P,Needs,Swaps),
	(Body=true -> In=Head; In=(Head :- Body)),
	swap(In,Swaps,Out).

swap(X,Swaps,Y)   :- X =.. L0, maplist(swap1(Swaps),L0,L1), Y =.. L1.
swap1(_,H,H)      :- var(H),!.
swap1(Swaps,H0,H) :- member(H0/H,Swaps),!.
swap1(_,H,H)      :- atomic(H),!.
swap1(Swaps,H0,H) :- swap(H0,Swaps,H).

missing(P,Wants,Got) :- 
	member(Want,Wants), 
	\+ member(Want/_,Gots),
	error(missingPatternSymbol(P,Want)).

dashed(In,Out)    :- name(In,Y),    name('_',D), 
                     append(Y,D,Z), name(Out,Z).

hasit(X,M0,M) :- clause(X,_), nonvar(M0), M=M0.


warn(X) :- print(stderr,X),nl.
error(X) :- print(stderr,X),nl, fail.


