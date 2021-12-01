newPQ(stablePQ(Counter, empty)) :-
	gensym(pq_counter, Counter),
	flag(Counter, _, 0).


emptyPQ(stablePQ(_, empty)).


insertPQs(List, Q) :-
	newPQ(Q0),
	insertPQs(List, Q0, Q).

insertPQs([],X,X).
insertPQs([Key-Datum|Rest], In, Out) :-
	insert2PQ(In, Key, Datum, Temp),
	insertPQs(Rest, Temp, Out).


insert2PQ(stablePQ(Counter, In), Key, Datum, stablePQ(Counter, Out)) :-
	flag(Counter, N, N+1),
	insertPQ(In, (Key/N), Datum, Out).


deleteMin(stablePQ(Counter, In), Key, Datum, stablePQ(Counter, Out)) :-
	removePQ(In, (Key/_N), Datum, Out).


remove4PQ(stablePQ(Counter, In), Key, Datum, stablePQ(Counter, Out)) :-
	removePQ(In, (Key/_N), Datum, Out).


removePQs(In, [Key-Datum|L]) :-
	remove4PQ(In, Key, Datum, Out), !,
	removePQs(Out, L).
removePQs(_,  []).


randomList(NumElem, Seed, List) :-
	nonvar(NumElem),
	nonvar(Seed),
	var(List),
	randomList1(NumElem, Seed, List).

randomList1(0,          _, []).
randomList1(NumElem, Seed, [Key-Value|List]) :-
	Key is random(Seed),
	V is random(26)+97,
	char_code(Value, V),
	M is NumElem-1,
	randomList1(M, Seed, List).
