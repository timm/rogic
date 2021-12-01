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
% the means. Runs like the clappers. Experiments showed that this worked 
% within 30% of a heap (KISS).

portray(pq(_,_,_,_)) :- write('PQ').

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

dq(_,X,_) :- var(X),!,fail.
dq(V,pq(K,V0,L0,R),Out) :-
	dq(V,L0,L), !,
	dqout(K,V0,L,R,Out).
dq(V,pq(K,[V1|T]-End,L,R),Out) :- 
	nonvar(V1), !,
	V=V1,
	(var(T) 
	-> New=_ 
   	;  New=(T-End)),
	dqout(K,New,L,R,Out).
dq(V,pq(K,V0,L,R0),Out) :-
	dq(V,R0,R),
	dqout(K,V0,L,R,Out).

dqout(K,V,L,R,pq(K,V,L,R)) :- 
	(nonvar(V);nonvar(L);nonvar(R)),!.
dqout(_,_,_,_,_).

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


