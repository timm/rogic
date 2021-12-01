wme(graph, n, n(_Node, _AndOr)).
wme(graph, n, e(_ID, _From, _To)).
wme(graph, n, defined(_X)).

wme(sp2, y, d0(_V,_W)).
wme(sp2, y, sprime(_V)).
wme(sp2, y, tprime(_V)).
wme(sp2, y, zprime(_Frome, _To)).
wme(sp2, y, cutEdge(_Node, (_From, _To))). %XXX

wme(sp2wrap, n, sprime(_V)).
wme(sp2wrap, n, tprime(_V)).
wme(sp2wrap, n, zprime(_From, _To)).
wme(sp2wrap, y, sprime2(_V)).
wme(sp2wrap, y, tprime2(_V)).
wme(sp2wrap, y, zprime2(_From, _To)).

wme(coax, y, lambda(_X, _W)).

wmeSetup(What) :-
	wme(What, y, Which),
	functor(Which, F, A),
	(dynamic F/A),
	fail.
wmeSetup(_What).

wmeZap(What) :-
	wme(What, y, Which),
	retract(Which),
	fail.
wmeZap(_What).

wmeShow(What) :-
	wme(What, _, Which),
	nl,
	Which,
	print(Which),
	nl, fail.
wmeShow(_What).


