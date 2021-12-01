heuristic(1, U, V) :-
	andNode(V),
	tprime(U),
	sprime(V), !,
	heuristic1(U).


heuristic(2, U, V) :-
	andNode(V),
	tprime(U),
	sprime(V), !,
	heuristic2(V).


heuristic(3, U, V) :-
	e(EdgeId, U, V),
	barAnd(V), !,
	zprime(U, V),
	adjustWeight(EdgeId),
	flag(preCoaxed, PreCoaxed, PreCoaxed+1),
	format('\n\theuristic3: ~w = ~w -> ~w', [EdgeId, U, V]).

heuristic(3, U, V) :-
	e(EdgeId, U, V),
	badAnd(V), !,
	zprime(U, V),
	adjustWeight(EdgeId),
	flag(preCoaxed, PreCoaxed, PreCoaxed+1),
	format('\n\theuristic3: ~w = ~w -> ~w', [EdgeId, U, V]).


heuristic(_N, _U, _V).

%
% badAnd(BadAnd) :
%	BadAnd is an AND node without all preconditions
%
badAnd(BadAnd) :-
	andNode(BadAnd),
	e(_, Pre, BadAnd),
	\+ zprime(_, Pre).

%
% adjustWeight(EdgeId)
%
adjustWeight(EdgeId) :-
	e(EdgeId, U, V),
	bar(U, BarU),
	bar(V, BarV),
	e(EdgeId2, BarU, BarV),
	flag(edgeSum, W, W),
	NewWeight is W * 2,
	retract(lambda(EdgeId,  _)),
	assert( lambda(EdgeId,  NewWeight)),
	retract(lambda(EdgeId2, _)),
	assert( lambda(EdgeId2, NewWeight)).


heuristic1(U) :-
	bar(U, BarU),
	d(U,    Du),
	d(BarU, Dbaru),
	( Dbaru = sp2_infinity ; Dbaru > Du ), !,
	cutEdge(U, EId),
	adjustWeight(EId),
	flag(preCoaxed, PreCoaxed, PreCoaxed+1),
	format('\n\theuristic1: ~w = ~w', [EId, U]).


heuristic1(U) :-
	zprime(Wu, U),

	bar(U, BarU),
	zprime(Wbaru, BarU),

	bar(Wu, BarWu),
	BarWu = Wbaru, !,
	
	cutEdge(U, EId),
	adjustWeight(EId),
	flag(preCoaxed, PreCoaxed, PreCoaxed+1),
	format('\n\theuristic1: ~w = ~w', [EId, U]).


heuristic1(U) :-
	bar(U, BarU),
	zprime(Wbaru, BarU), % %%%%%%%%%%%%%
	e(EId, Wbaru, BarU),
	adjustWeight(EId),
	flag(preCoaxed, PreCoaxed, PreCoaxed+1),
	format('\n\theuristic1: ~w = ~w', [EId, U]).


heuristic2(V) :-
	zprime(Wv, V),
	e(EId, Wv, V),
	adjustWeight(EId),
	flag(preCoaxed, PreCoaxed, PreCoaxed+1),
	format('\n\theuristic1: ~w = ~w', [EId, V]).


heuristic2(V) :-
	bar(V, BarV),
	d(V,    Dv),
	d(BarV, Dbarv),
	\+ Dbarv = sp2_infinity,
	Dbarv < Dv, !,

	cutEdge(V, EId),
	adjustWeight(EId),
	flag(preCoaxed, PreCoaxed, PreCoaxed+1),
	format('\n\theuristic1: ~w = ~w', [EId, V]).


heuristic2(V) :-
	bar(V, BarV),
	zprime(Wbarv, BarV),

	zprime(Wv, V),
	bar(Wv, BarWv),

	BarWv = Wbarv, !,

	cutEdge(V, EId),
	adjustWeight(EId),
	flag(preCoaxed, PreCoaxed, PreCoaxed+1),
	format('\n\theuristic1: ~w = ~w', [EId, V]).


