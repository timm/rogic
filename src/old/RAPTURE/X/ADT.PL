m(pq).
m(fifo).

adt(verb(V)) :- 
	member(A,[1,2,3]), 
	m(F),
	member(F,[pq,fifo]),
	functor(What,F,A),
	arg(1,What,Arg),
	clause(What,_),
	functor(Arg,W,_),print(W),nl,fail.
