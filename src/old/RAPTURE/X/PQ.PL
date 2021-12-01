%%%% a priority queue implemented as a heap of 
%%%% difference lists. 
:- module(pq,[pq/1,pq/2,pq/3]).

%pq/2
pq(empty,q(_,V,_,L,R)) :- var(L), var(R), fifo(empty,V).
pq(new(Inits),      Q) :- l2q(Inits,Q).
pq(show,            Q) :- nl,qprint(Q).
pq(asList(L),       Q) :- q2l(Q,L).

%pq/3
pq(poke( K,V   )) --> qpokes(K,[V],0,_).
pq(poke( K,V, D)) --> qpokes(K,[V],0,D0), {D is D0}.
pq(pokes(K,Vs  )) --> qpokes(K,Vs, 0,_).
pq(pokes(K,Vs,D)) --> qpokes(K,Vs, 0,D0), {D is D0}.
pq(pull( V))      --> qpullmin(V,0,_ ).
pq(pull( V,D))    --> qpullmin(V,0,D0),   {D is D0}.

pq(pokings([]),   Q, Q) :-  pq(blank(Q)).
pq(pokings([K-V|T]))    --> pq(poke(K,V)),pq(pokings(T)).
pq(pullings([]),  Q, Q) :-  pq(blank(Q)).
pq(pullings([V|Vs]))    --> pq(pull(V)), pq(pullings(Vs)).
pq(balance,       Q0,Q)  :- q2l(Q0,L),	pq(blank(Q1)),l2q1(L,Q1,Q).


%pq/1
pq(blank(q(_,_,_,_,_))).
pq(demo1) :-
	Inits=[2-200,4-400,12-1201,7-701,9-900,9-9001,11-1100],
	pq(new(Inits),Q1),
	pq(pokings([2-201,9-9001]),Q1,Q2),
	pq(show,Q2),nl,
	pq(pullings([_,_,_,_,_,_,_,_]),Q2,Q3),
	pq(show,Q3).
pq(demo2) :-
	Inits=[2-200,4-400,12-1201,7-701,9-900,9-9001,11-1100],
	pq(new(Inits),Q),
	write(Q),nl,
	pq(show,Q),nl,	
	pq(pokings([5-50,10-100,20-200,30-300,40-400,50-500,60-600]),Q,Q1),
	pq(show,Q1),nl,
	pq(balance,Q1,Q2),
	pq(show,Q2),nl.

% printing
qprint(Q) :- qprint(Q,0,' |  ',''), assert(x(1)).
qprint(X,_,_,_) :- var(X), !.
qprint(q(K,V,E,L,R),In,C,Prefix) :-
        N is round(In), 
	forall(between(1,N,_),write(C)),
	write(Prefix), write(E), 
	write(' '), write(K), write(=), fifo(show,V),nl,
	qprint(L,In+1,C,' < '),
	qprint(R,In+1,C,' > ').
	
% convert the tree into a list
% note: destroys the tree as a side-effect
q2l(Q,Out) :- 
	fifo(empty,In),
	q2l(Q,In,Temp),
	fifo(asList(Out),Temp).

q2l(X,Out,Out) :- var(X),!.
q2l(q(K,V0,_,L,R),In,Out) :-
	fifo(asList(V),V0),
	q2l(L,In,Temp),
	fifo(poke(K-V),Temp,Temp1),
	q2l(R,Temp1,Out).
	
% covert a list  into a balanced q. list may be key-value
% pairs or just key symbols
l2q(KVs0,Q) :- 
	pq(blank(Q0)), 
	maplist(isPair,KVs0,KVs1),
	sort(KVs1,KVs),
	l2q1(KVs,Q0,Q).

isPair(X-Y,X-Y) :- !.
isPair(X,X-_).

l2q1([],Q,Q) :- !.
l2q1([K-V],Q0,Q) :- asList(V,V1),qpokes(K,V1,_,Q0,Q),!.
l2q1(L,Q0,Q) :-
	halve(L,Left,K-V,Right),
	asList(V,V1),
	qpokes(K,V1,_,Q0,Q1),
	l2q1(Left,Q1,Q2),
	l2q1(Right,Q2,Q).

asList([X|Y],[X|Y]) :- !.
asList(X,[X]).

halve([X],[],X,[]).
halve([X,Y|L],[X|Front],Mid,Back) :-
	halve1(L,[Y|L],Front,[Mid|Back]).

halve1([_,_|Count], [H|T], [H|F], B) :- !,
        halve1(Count, T, F, B).
halve1(_, B, [], B).

% add items
qpokes(K,Vs,D,Q0,Q) :-
	qpokes(K,Vs,1,D0,Q0,Q),
	D is D0.

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

