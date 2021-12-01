qpokes(K,Vs,D,D,q(K,Old,_,L,R),q(K,New,+,L,R)) :- 
	fifo(pokes(Vs),Old,New),!.
qpokes(K,Vs,D0,D,q(K0,V0,_,L0,R),q(K0,V0,+,L,R)) :-
        K < K0, !,
        qpokes(K,Vs,D0+1,D,L0,L).
qpokes(K,Vs,D0,D,q(K0,V0,_,L,R0),q(K0,V0,+,L,R)) :-
        qpokes(K,Vs,D0+1,D,R0,R).

% delete the smallest (left most) item
qpullmin(_,_,_,X,_) :- var(X),!,fail.
qpullmin(V,D0,D,q(K,V0,+,L0,R),q(K,V0,S,L,R)) :-
	qpullmin(V,D0+1,D,L0,L), !,
	qpullStatus(V0,L,R,S).
qpullmin(V,D,D,q(K,Old,+,L,R),q(K,New,S,L,R)) :- 
	fifo(pull(V),Old,New), !,
	qpullStatus(New,L,R,S).
qpullmin(V,D0,D,q(K,V0,+,L,R0),q(K,V0,S,L,R)) :-
	qpullmin(V,D0+1,D,R0,R),
	qpullStatus(V0,L,R,S).

qpullStatus(X,_,_,+) :- nonvar(X), \+ fifo(empty,X),!.
qpullStatus(_,X,_,+) :- nonvar(X), X=q(_,_,+,_,_),!.
qpullStatus(_,_,X,+) :- nonvar(X), X=q(_,_,+,_,_),!.
qpullStatus(_,_,_,-).

