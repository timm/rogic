wme(graph, n, io(_N, _In, _Out)).

wme(graph, n, start(_StartNode)).
wme(graph, n, goal(_GoalNode)).
wme(graph, n, if _IF).
wme(graph, n, n(_Node, _AndOr)).
wme(graph, n, e(_ID, _From, _To)).
wme(graph, n, defined(_X)).
wme(graph, n, lambda(_Node, _D)).

wme(sp2, y, d0(_Node, _D)).
wme(sp2, y, sprime(_Node)).
wme(sp2, y, tprime(_Node)).
wme(sp2, y, zprime(_Frome, _To)).
wme(sp2, y, cutEdge(_Node, _EdgeId)).
wme(sp2, y, badNode(_Node)).

wme(sp2wrap, n, sprime(_Node)).
wme(sp2wrap, n, tprime(_Node)).
wme(sp2wrap, n, zprime(_From, _To)).

wme(coax, y, lambda(_X, _W)).


wmeSetup(What) :-
	wme(What, y, Which),
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

wmeSetup(all) :-
	wme(_, Which),
	functor(Which, F, A),
	(dynamic F/A),
	(discontiguous F/A),
	setIndex(Which),
	fail.

wmeSetup(_What).



wmeZap(all) :-
	wme(_, _, Which),
	retractall(Which),
	fail.

wmeZap(all) :-
	wme(_, Which),
	retractall(Which),
	fail.

wmeZap(all) :-
	flag(e, _, 0),
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




