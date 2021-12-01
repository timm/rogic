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
	initRtoS(Root, S, PQ0, PQ1),

    % Step 6 %
    % : while PQ is not empty do
	!, whileLoop(PQ1),

    % Step 7 %
    % : SP <- SP - {r}
	retract(sprime(Root)),
	forall(zprime(Root, X), retract(zprime(Root, X))),

    % Step 8 % (kind of)
    % Complete SP and TP
	wmeShow(sp2).


createNode(X) :- defined(X), !.
createNode(X) :- 
	assert(defined(X)), 
	bar(X, BarX),
	assert(defined(BarX)).


initRtoS(_, [], Out, Out).
initRtoS(Root, [Node|Rest], In, Out) :-
	flag(e, E, E+1),
	insertPQ(In, 0, e(E, Root, Node), Temp),
	initRtoS(Root, Rest, Temp, Out).


whileLoop(PQ) :-
	removePQ(PQ, D, e(_E,U,V), PQ1), !,		% Step 6a
        whileLoop1(D, U, V, PQ1).

whileLoop(empty).

whileLoop1(_D, _U, V, PQ) :-
	visited(V), !,
	whileLoop(PQ).

whileLoop1(D, U, V, PQ) :-
	cond6c(U, V, D), !,
	whileLoop(PQ).

whileLoop1(D, U, V, PQ) :-
	visit(V, D),				% Step 6d
	step6e(U, V),				% Step 6e
	insertZP(U, V),				% Step 6f
	step6g(V, D, All),			% Step 6g
	coaxingFilter(All, Out),
	insertPQs(Out, PQ, PQ1),		% Step 6g
	whileLoop(PQ1).


cond6c(U, V, D) :-
	bar(U, BarU),
	bar(V, BarV),
	d(BarV, D),
	tprime(BarV),
	\+ zprime(BarU, BarV).

step6e(U, V) :-
	bar(V, BarV),
	sprime(U),
	\+ sprime(BarV), !,
	insertSP(V).

step6e(U, V) :-
	insertTP(V),
	( sprime(U) -> insertCut(V, (U,V)) ;
	           ( cutEdge(U, CutV),
	             insertCut(V, CutV) ) ).

step6g(V, D, Ws) :-
	setof(W, W^collectWs(V, D, W), Ws), !.

step6g(_V, _D, []).

collectWs(V, D, Next) :-
	e(E, V, W),
	lambda(E, Lambda),
	D0 is D + Lambda,
	Next = D0-e(E,V,W).

coaxingFilter([_D-e(E, U, V)|Rest], Out) :-
	barAndNode(V), !,
	format('***** e(~w, ~w, ~w)\n', [E, U, V]),
	coaxingFilter(Rest, Out).
coaxingFilter([H|Rest],             [H|Out]) :-
	coaxingFilter(Rest, Out).
coaxingFilter([], _L).


d( X, D) :- d0(X,D), !.
d(_X, inifinity).

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

