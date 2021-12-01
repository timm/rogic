insertPQs(L,Q) :- insertPQs(L,-,Q).

insertPQs([],X,X).
insertPQs([X-Y|Tail],In,Out) :-
        nl,print(X-Y),nl,
        ((X-Y) = (3-eight) -> spy(insertPQ); true),
	insertPQ(In,X,Y,Temp),
        showPQs(Temp),
	insertPQs(Tail,Temp,Out).

removePQs(empty, []).
removePQs(PQ, [Key-Datum|L]) :-
	( removePQ(PQ, Key, Datum, NewPQ) -> removePQs(NewPQ,L) ).


pops(-,[]).
pops(Q,[K-V|Out]) :-
  removePQ(Q,K,V,Q1),
  pops(Q1,Out).


showPQs(PQ) :-
       showPQ(PQ,'',0).

%showPQ(empty,_,_).
showPQ(-,_,_).
showPQ(pq(K,V,L,R),Before,N) :-
  tab(N),
  write(Before),
  qshow(V,Show),
  write(K-Show),nl,
  showPQ(L,'<',N+4),
  showPQ(R,'>',N+4).

newPQ(-).

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
