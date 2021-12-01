sp2 :-

    % Step 1 %
    % All nodes are unvisited and
    % no node is below a cut edge
    % : for each v in V do
    % :   D[v] <- infinity
    % :   C[v] <- 0
    % : end for

    % Step 2 %
    % Initialize PQ and Z
    % : PQ <- Z <- 0

	initSP2(PQ),

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
	initRoots(Root, PQ, PQ1),

    % Step 6 %
    % : while PQ is not empty do
	flag(heuristic4, _, 0),
	!, whileLoop(PQ1), !,

    % Step 7 %
    % : SP <- SP - {r}
	clearRoots(Root),
	cleanUpSp2,

    % Step 8 %
    % Complete SP and TP
	true.


initSP2(PQ):-
	flag(heuristics, _, 0),
	flag(heuristic1, _, 0),
	flag(heuristic2, _, 0),
	flag(heuristic3, _, 0),
	flag(heuristic4, _, 0),
	wmeSetup(sp2),
	wmeZap(sp2),
	maxDelta(_),
	newPQ(PQ).


initRoots(Root, In, Out) :-
	bagof(Node, start(Node), Nodes),
	initRoots(Root, Nodes, In, Out).

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

whileLoop1(_D, _E, U, V, PQ) :-
	flag(heuristic4, H1, H1),
	heuristic(4, U, V),
	flag(heuristic4, H2, H2),
	H1 \= H2, !,
	whileLoop(PQ).

whileLoop1(D, _E, U, V, PQ) :-
	cond6c(U, V, D), !,
	whileLoop(PQ).

whileLoop1(D, E, U, V, PQ) :-
	visit(V, D),				% Step 6d
	step6e(U, V, E),			% Step 6e
	insertZP(U, V),				% Step 6f
	step6g(U, V, D, PQ, PQ1),		% Step 6g
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


step6g(U, V, D, PQ, PQ1) :-
	heuristics(U, V, H),
	(  (H=0)
	-> collectWs(V, D, PQ, PQ1)
	;  ( PQ1 = PQ,
	     assert(badNode(V)) )
	).


heuristics(U, V, H) :-
	flag(heuristics, Before, Before),
	Coin is random(2) + 1,
	heuristic(Coin, U, V),
	heuristic(3,    U, V),
	flag(heuristics, After, After),
	H is After - Before.
	

collectWs(V, D, PQ, PQ1) :-
	setof(W, V^D^getW(V, D, W), Ws), !,
	insertPQs(Ws, PQ, PQ1).

collectWs(_, _, PQ, PQ).


getW(V, D, Next) :-
	e(E, V, W),
	lambda(E, Lambda),
	D0 is D + Lambda,
	Next = D0-e(E,V,W).





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
	flag(e1, Id1, Id1+1),
	flag(e2, Id2, Id2-1),
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



cleanUpSp2 :-
	badNode(Node),
	removeFromZ(Node),
	fail.

cleanUpSp2.

removeFromZ(Node) :-
	retract(zprime(_, Node)),
	retract(cutEdge(Node, _)),
	retract(d0(Node, _)),
	fail.

removeFromZ(Node) :-
	sprime(Node),
	retract(sprime(Node)).

removeFromZ(Node) :-
	tprime(Node),
	retract(tprime(Node)).


sp2HeuristicsStat(H, H1, H2, H3, H4) :-
	flag(heuristics,  H,  H),
	flag(heuristic1, H1, H1),
	flag(heuristic2, H2, H2),
	flag(heuristic3, H3, H3),
	flag(heuristic4, H4, H4).



