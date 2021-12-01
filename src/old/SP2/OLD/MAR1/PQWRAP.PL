

removePQs(empty, []).
removePQs(PQ, [Key-Datum|L]) :-
	( removePQ(PQ, Key, Datum, NewPQ) -> removePQs(NewPQ,L) ).


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


insertPQs(L,Q) :- insertPQs(L,-,Q).

insertPQs([],X,X).
insertPQs([X=Y|Tail],In,Out) :- 
	insertPQ(In,X,Y,Temp),
	insertPQs(Tail,Temp,Out).

pqtest1(Q) :-
	insertPQs([3=one
	          ,2=two
	          ,3=three
	          ,2=four
	          ,1=five
                  ,5=six
                  ,6=seven
                  ,1.1=eight
                  ],Q).

pqtest2(Q) :-
	insertPQs([3=one
	          ,2=two
	          ,3=three
	          ,2=four
	         ,1=five
                  ,5=six
                  ,6=seven
                  ,1.1=eight
                  ],Q).

pops(-,[]).
pops(Q,[K=V|Out]) :-
  removePQ(Q,K,V,Q1),
  pops(Q1,Out).



showPQs(PQ) :-
       showPQ(PQ,'',0).

showPQ(empty,_,_).
showPQ(-,_,_).
showPQ(pq(K,V,L,R),Before,N) :-
  tab(N),
  write(Before),
  qshow(V,Show),
  write(K=Show),nl,
  showPQ(L,'<',N+4),
  showPQ(R,'>',N+4).


newPQ(empty).
