wme(demo, y, start(_StartNode)).
wme(demo, y, goal(_GoalNode)).
wme(demo, n, sp2source(_LoadFile)).
wme(demo, y, sp2output(_OutFile)).

wme(graph, n, io(_N, _In, _Out)).
wme(graph, n, if _IF).
wme(graph, n, n(_Node, _AndOr)).
wme(graph, n, e(_ID, _From, _To)).
wme(graph, n, defined(_X)).
wme(graph, n, dummy(_DummyNode)).
wme(graph, n, lambda(_Node, _D)).
wme(graph, y, start(_StartNode)).
wme(graph, y, goal(_GoalNode)).

wme(sp2, y, d0(_Node, _D)).
wme(sp2, y, sprime(_Node)).
wme(sp2, y, tprime(_Node)).
wme(sp2, y, zprime(_Frome, _To)).
wme(sp2, y, cutEdge(_Node, _EdgeId)).
wme(sp2, y, badNode(_Node)).

wme(coax, y, lambda(_X, _W)).


wmeSetup(all) :-
	wme(_, Which),
	functor(Which, F, A),
	(dynamic F/A),
	(discontiguous F/A),
	setIndex(Which),
	fail.

wmeSetup(all) :-
	wme(_, _, Which),
	functor(Which, F, A),
	(dynamic F/A),
	(discontiguous F/A),
	setIndex(Which),
	fail.

wmeSetup(What) :-
	wme(What, y, Which),
	functor(Which, F, A),
	(dynamic F/A),
	(discontiguous F/A),
	setIndex(Which),
	fail.

wmeSetup(_What).



wmeZap(all) :-
	wme(_, Which),
	retractall(Which),
	fail.

wmeZap(all) :-
	wme(_, _, Which),
	retractall(Which),
	fail.

wmeZap(all) :-
	flag(e1, _, 1),
	flag(e2, _, -1),
	fail.

wmeZap(What) :-
	wme(What, y, Which),
	retractall(Which),
	fail.

wmeZap(_What).



wmeShow(all) :-
	wme(_, _, Which),
	listing(Which),
	nl,
	fail.

wmeShow(What) :-
	wme(What, _, Which),
	listing(Which),
	nl,
	fail.

wmeShow(_What) :- nl.




