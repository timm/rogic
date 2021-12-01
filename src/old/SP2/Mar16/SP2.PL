sp2(S) :-

    % Step 1 %
    % All nodes are unvisited and
    % no node is below a cut edge
    % : for each v in V do
    % :   D[v] <- infinity
    % :   C[v] <- 0
    % : end for
	wmeSetup(sp2),
	wmeZap(sp2),
	flag(edgeSum, _, 0),

    % Step 2 %
    % Initialize PQ and Z
    % : PQ <- Z <- 0
	newPQ(PQ0),

    % Step 3 %
    % Create an artificial root node, r 
    % Place the artificial root node into SP
    % : let r be an artificial node of G
    % : SP <- {r}
	gensym(r,Root),
	insertSP(Root),

    % Step 4 %
    % : TP <- 0

    % Step 5 %
    % : for each initial node s in S do
    % :   PQ <- PQ + {(0, (r,s))}
    % : end for
	initRoots(Root, S, PQ0, PQ1),

    % Step 6 %
    % : while PQ is not empty do
	!, whileLoop(PQ1),

    % Step 7 %
    % : SP <- SP - {r}
	clearRoots(Root),

    % Step 8 % (kind of)
    % Complete SP and TP
	wmeShow(sp2).


initRoots(_, [], Out, Out).
initRoots(Root, [Node|Rest], In, Out) :-
	createEdge(E, Root, Node),
	insert2PQ(In, 0, e(E, Root, Node), Temp),
	initRoots(Root, Rest, Temp, Out).

clearRoots(Root) :-
	retract(sprime(Root)),
	retractall(zprime(Root, _)),
	forall(e(Id, Root, Node), retractEdge(Id, Root, Node)).


whileLoop(PQ) :-
	deleteMin(PQ, D, e(E,U,V), PQ1), !,		% Step 6a
	whileLoop1(D, E, U, V, PQ1).

whileLoop(PQ) :- emptyPQ(PQ).


whileLoop1(_D, _E, _U, V, PQ) :-
	visited(V), !,
	whileLoop(PQ).

whileLoop1(D, _E, U, V, PQ) :-
	cond6c(U, V, D), !,
	whileLoop(PQ).

whileLoop1(D, E, U, V, PQ) :-
	visit(V, D),				% Step 6d
	step6e(U, V, E),			% Step 6e
	insertZP(U, V),				% Step 6f
	step6g(V, D, All),			% Step 6g
	flag(edgeSum, Old, Old+D),
	flag(preCoaxed, _, 0),
	preCoaxing(D, E, U, V),			% pre-coaxing
	step6g_a(All, PQ, PQ1),
	whileLoop(PQ1).


cond6c(U, V, D) :-
	bar(U, BarU),
	bar(V, BarV),
	d(BarV, D),
	tprime(BarV),
	\+ zprime(BarU, BarV).

step6e(U, V, _E) :-
	bar(V, BarV),
	sprime(U),
	\+ sprime(BarV), !,
	insertSP(V).

step6e(U, V, E) :-
	insertTP(V),
	( sprime(U) -> insertCut(V, E) ;
	           ( cutEdge(U, EId),
	             insertCut(V, EId) ) ).

step6g(V, D, Ws) :-
	setof(W, W^collectWs(V, D, W), Ws), !.

step6g(_V, _D, []).

collectWs(V, D, Next) :-
	e(E, V, W),
	lambda(E, Lambda),
	D0 is D + Lambda,
	Next = D0-e(E,V,W).

preCoaxing(D, E, U, V) :-
	Coin is random(2) + 1,
	heuristic(Coin, D, E, U, V),
	heuristic(3,    D, E, U, V).

step6g_a(All, PQ, PQ1) :-
	flag(preCoaxed, PreCoaxed, PreCoaxed),
	PreCoaxed = 0, !,
	insertPQs(All, PQ, PQ1).
step6g_a(_, PQ, PQ).


d( X, D) :- d0(X, D), !.
d(_X, sp2_infinity).

visited(V) :-
	d0(V, _D).

visit(V, _D) :-
	visited(V), !.

visit(V, D) :-
	assert(d0(V, D)).

insertSP(X) :- sprime(X), !.
insertSP(X) :- assert(sprime(X)).

insertTP(X) :- tprime(X), !.
insertTP(X) :- assert(tprime(X)).

insertZP(X, Y) :- zprime(X,Y), !.
insertZP(X, Y) :- assert(zprime(X,Y)).

insertCut(V, _C) :- cutEdge(V, _), !.
insertCut(V,  C) :- assert(cutEdge(V, C)).


createEdge(Id,  U, V) :- e(Id, U, V), !.
createEdge(Id1, U, V) :-
	flag(e, Id1, Id1+1),
	flag(e, Id2, Id2+1),
	bar(U, BarU),
	bar(V, BarV),
	assert(e(Id1, U,    V)),
	assert(e(Id2, BarU, BarV)),
	assert(lambda(Id1, 0)),
	assert(lambda(Id2, 0)).


retractEdge(Id1, U, V) :-
	bar(U, BarU),
	bar(V, BarV),
	e(Id1,    U,    V),
	e(Id2, BarU, BarV),
	retract(e(Id1,    U,    V)),
	retract(e(Id2, BarU, BarV)),
	retract(lambda(Id1, _)),
	retract(lambda(Id2, _)).

	