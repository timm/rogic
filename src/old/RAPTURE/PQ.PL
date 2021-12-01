% priority queue
% tim@menzies.com; dec 99 
% Assumes many values stored under the same key.
%
% All we can do with such queues in nq (enqueue) and dq (dequeue).
% dq extracts a value ofthe smallest key.
% dq is  "stable"; i.e. values are extracted in the order they are entered.
% As a side-effect of removing the last value of a key, that key is deleted
% as well.
%
% Implemented as a simple binary tree of difference lists. 
%
% Heavy use of meta-logical stuff (var, nonvar) and dirty cuts. Ends justifies
% the means: runs like the clappers; experiments showed that this worked 
% within 30% of runtimes of the SICTUS' heaps.

:- module(pq, [
	nqs/2,      % batch update: Key-Value pairs to pq
	nq/4,       % add 1 item
	dq/3,       % pop 1 item, of lowest value
	pqprint/1,  % pretty print whole tree	
	pqdemo/0    % show your stuff
	]).

nqs(Pairs,Q) :-nqs(Pairs,_,Q).

nqs([],Q,Q).
nqs([K-V|Pairs],Q0,Q) :- nq(K,V,Q0,Q1), nqs(Pairs,Q1,Q).

nq(K,V,pq(K,Old,L,R),pq(K,New,L,R)) :- !,
	(var(Old)
	-> New = [V|Rest]-Rest
	;  Old = (H-[V|Rest]),
	   New = (H-Rest)).
nq(K,V,pq(K0,V0,L0,R),pq(K0,V0,L,R)) :-
        K < K0, !,
        nq(K,V,L0,L).
nq(K,V,pq(K0,V0,L,R0),pq(K0,V0,L,R)) :-
        nq(K,V,R0,R).

dq(_,_,X,_) :- var(X),!,fail.
dq(K,V,pq(K0,V0,L0,R),Out) :-
	dq(K,V,L0,L), !,
	dqgc(K0,V0,L,R,Out).
dq(K,V,pq(K1,[V1|T]-End,L,R),Out) :- 
	nonvar(V1), !,
	V=V1,
	K=K1,
	(var(T) 
	-> New=_ 
   	;  New=(T-End)),
	dqgc(K,New,L,R,Out).
dq(K,V,pq(K0,V0,L,R0),Out) :-
	dq(K,V,R0,R),
	dqgc(K0,V0,L,R,Out).

dqgc(K,V,L,R,pq(K,V,L,R)) :- 
	(nonvar(V);nonvar(L);nonvar(R)),!.
dqgc(_,_,_,_,_).

pqprint(Q) :- pqprint(Q,0,'| ' ,'').
pqprint(X,_,_,_) :- var(X), !.
pqprint(pq(K,V,L,R),In,C,Prefix) :-
        N is round(In), 
	forall(between(1,N,_),write(C)),
	write(Prefix), 
	(var(V) 
	-> print(K = - )
        ;  print(K), 
	   write(' = '),
           copy_term(V,V1-[]), 
           print(V1)), nl,
	pqprint(L,In+1,C,<),
	pqprint(R,In+1,C,>).

pqdemo :-
	In=[10-one,2-two,14-fourteen, 8-eight,4-g,4-g,2-twos,20-twenty],
	nqs(In,Q0),pqdemo1(Q0,_).

pqdemo1 --> pqdemo2,pqdemo2,pqdemo2,pqdemo2,pqdemo2,pqdemo2.
	
pqdemo2(Q0,Q) :-
	pqprint(Q0),
	dq(K,V,Q0,Q),
	print(smallest(K,V)),nl.
