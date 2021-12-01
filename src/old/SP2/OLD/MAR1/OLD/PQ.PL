%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   File   : pq.pl                                                            %
%   Purpose: Implement priority queues in Prolog.                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- module(pq, [
	insertPQ/4,
	removePQ/4,
	sizePQ/2,
	newPQ/1,
        emptyPQ/1,
	pq_to_list/2,
	list_to_PQ/2,
	min_of_PQ/3,
        heapsort/2
		 ]).


/* emptyPQ(Q) is true if queue Q is empty */
emptyPQ(empty).
newPQ(empty).


/*  INSERTION :
 *  insertPQ(+OldPQ, +Key, +Datum, -?NewPQ)
 *  inserts the new Key-Datum pair into the heap.  */

insertPQ(empty, NewKey, NewDatum, pq(NewKey, Datum, empty, empty)) :-
	enqueue(NewDatum, _, Datum).
insertPQ(pq(SameKey, OldDatum, LPQ, RPQ), SameKey, NewDatum, pq(SameKey, Datum, LPQ, RPQ)) :-
	enqueue(NewDatum, OldDatum, Datum).
insertPQ(pq(OldKey, OldDatum, LPQ, RPQ), NewKey, NewDatum, pq(OldKey, OldDatum, NLPQ, RPQ)) :-
	OldKey @< NewKey, !,
	insertPQ(LPQ, NewKey, NewDatum, NLPQ).
insertPQ(pq(OldKey, OldDatum, LPQ, RPQ), NewKey, NewDatum, pq(NewKey, Datum, NLPQ, RPQ)) :-
	OldKey @> NewKey, !,
	enqueue(NewDatum, _, Datum),
	insertPQ(LPQ, OldKey, OldDatum, NLPQ).


/*  DELETION :
 *  removePQ(+OldPQ, ?Key, ?Datum, -NewPQ)  */

removePQ(pq(Key, DatumList, PQ, empty), Key, Datum, NewPQ) :- 
	!, dequeue(DatumList, Datum, Temp),
	( emptyQueue(Temp) -> NewPQ = PQ ; NewPQ = pq(Key, Temp, PQ, empty) ).


/*  pq_to_list(+PQ, -List)
 *  returns the Key-Datum pairs in PQ as
 *  List, sorted into ascending order of Keys.  */
removePQ1(pq(Key, Datum, PQ, empty), Key, Datum, PQ) :- !.

pq_to_list(empty,[]).
pq_to_list(PQ,[K-D|T]) :-
   removePQ1(PQ,K,D,PQ1),
   pq_to_list(PQ1,T).


/* ====================================================================== */

/*
The predicate pushPQ(OldPQ,NewPQ) is true if NewPQ is a heap given a
"pseudo-heap" OldPQ. A pseudo-heap is a priority queue, where the
priority queue invariants are all true, with a possible exception of
the ordered property for the root of the tree. If LV, the element in
the left subtree, is smaller than both RV and Val, we exchange LV and
Val, pushing Val down the left subtree.  Otherwise, if Val is smaller
than RV, then we exchange these two, pushing Val down the right
subtree.  Note that we are not adding or deleting elements, so we
don't do any subtree swapping.  Finally, if Val is smaller than either
RV or LV, we are finished.

*/

pushPQ(pq(Key, Datum,pq(KeyL, DatumL,PQLL,PQLR),pq(KeyR, DatumR,PQRL,PQRR)), 
       pq(KeyL, DatumL,NLPQ,pq(KeyR, DatumR,PQRL,PQRR)) ) :-
  KeyL =< KeyR,
  KeyL < Key, !,
  pushPQ(pq(Key, Datum,PQLL,PQLR),NLPQ).

pushPQ(pq(Key, Datum,pq(KeyL, DatumL,PQLL,PQLR),pq(KeyR, DatumR,PQRL,PQRR)), 
       pq(KeyR, DatumR,pq(KeyL, DatumL,PQLL,PQLR),NRPQ )) :-
  KeyR < KeyL,
  KeyR < Key, !,
  pushPQ(pq(Key, Datum,PQRL,PQRR),NRPQ).

pushPQ(pq(Key, Datum,pq(KeyL, DatumL,PQLL,PQLR),pq(KeyR, DatumR,PQRL,PQRR)), 
       pq(Key, Datum,pq(KeyL, DatumL,PQLL,PQLR),pq(KeyR, DatumR,PQRL,PQRR)) ) :-
  Key =< KeyL,
  Key =< KeyR, !.

pushPQ(pq(Key, Datum,empty,pq(KeyR, DatumR,PQRL,PQRR)), 
       pq(Key, Datum,empty,pq(KeyR, DatumR,PQRL,PQRR)) ) :-
  Key =< KeyR, !.

pushPQ(pq(Key, Datum,empty,pq(KeyR, DatumR,PQRL,PQRR)), 
       pq(KeyR, DatumR,empty,pq(Key, Datum,PQRL,PQRR)) ) :-
  KeyR < Key.

pushPQ(pq(Key, Datum,empty,empty),
       pq(Key, Datum,empty,empty)).
/*

We remove an element from a subtree (maintaining the balance
invariant) using remanyPQ(Key,Datum,LQ,RQ).  This predicate finds the
right--most element which either has only a right child, or is itself
the right leaf of a node with two children.  Swapping occurs in the
latter case.

*/

remanyPQ(Key, Datum, pq(Key, Datum,empty,PQ),PQ) :- !.
remanyPQ(Key, Datum, pq(Key1, Datum1,LPQ,RPQ), pq(Key1, Datum1,NLPQ,LPQ)) :-
   remanyPQ(Key, Datum,RPQ,NLPQ).

% list_to_PQ(+L,-PQ) converts list L of Key-Datum pairs into a priority queue.
list_to_PQ(L,PQ) :-
   list_to_PQ(L,empty,PQ).

% list_to_PQ(L,PQ1,PQ2) adds elements of list L of Key-Datum pairs
%  to PQ1 forming PQ2
list_to_PQ([],P,P).
list_to_PQ([K-D|T],P1,P3) :-
   insertPQ(P1,K,D,P2),
   list_to_PQ(T,P2,P3).

% nlist_to_PQ(+L,-PQ) converts list L of numbers into a priority queue.
nlist_to_PQ(L,PQ) :-
   nlist_to_PQ(L,empty,PQ).

% nlist_to_PQ(L,PQ1,PQ2) adds elements of list L of numbers
%  to PQ1 forming PQ2
nlist_to_PQ([],P,P).
nlist_to_PQ([K|T],P1,P3) :-
   insertPQ(P1,K,K,P2),
   nlist_to_PQ(T,P2,P3).

%   pq_to_nlist(+PQ, -List)
%   returns the Keys in PQ as
%   List, sorted into ascending order.  

pq_to_nlist(empty,[]).
pq_to_nlist(PQ,[K|T]) :-
   removePQ(PQ,K,_,PQ1),
   pq_to_nlist(PQ1,T).

% heapsort(+L,-S) sorts list L os numbers into list S
heapsort(L,S) :-
   nlist_to_PQ(L,PQ),
   pq_to_nlist(PQ,S).

% sizePQ(Q,S) is true if queue Q contains S elements.
sizePQ(empty,0).
sizePQ(pq(_,_,L,R),S) :-
   sizePQ(L,S1),
   sizePQ(R,S2),
   S is S1 + S2 + 1 .

% min_of_PQ(+PQ, ?Key, ?Datum)
% returns the Key-Datum pair with smallest Key
min_of_PQ(pq(Key,Datum,_,_),Key,Datum).
