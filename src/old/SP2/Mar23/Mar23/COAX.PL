heuristic(1, _, V) :-
	andNode(V),
	\+ badAnd(V),
	e(EdgeId, U, V),
	tprime(U),
	sprime(V), !,
	heuristic1(U),
	flag(heuristic1, H1, H1+1),
	flag(heuristics, H, H+1),
	flag(coaxing, N, N+1),
	format('\theuristic1: ~w = ~w -> ~w\n', [EdgeId, U, V]).


heuristic(2, _, V) :-
	andNode(V),
	\+ badAnd(V),
	e(EdgeId, U, V),
	tprime(U),
	sprime(V), !,
	heuristic2(V),
	flag(heuristic2, H2, H2+1),
	flag(heuristics, H, H+1),
	flag(coaxing, N, N+1),
	format('\theuristic2: ~w = ~w -> ~w\n', [EdgeId, U, V]).


heuristic(3, U, V) :-
	e(EdgeId, U, V),
	barAnd(V), !,
	adjustWeight(EdgeId),
	flag(heuristic3, H3, H3+1),
	flag(heuristics, H, H+1),
	flag(coaxing, N, N+1),
	format('\theuristic3: baR_and ~w = ~w -> ~w\n', [EdgeId, U, V]).


heuristic(4, U, V) :-
	e(_, U, V),
	badAnd(V), !,
	flag(heuristic4, H4, H4+1),
	flag(heuristics, HS, HS+1),
	flag(coaxing, N, N+1).


heuristic(_N, _U, _V).


%
% badAnd(BadAnd) :
%	BadAnd is an AND node without all preconditions satisfied
%
badAnd(BadAnd) :-
	andNode(BadAnd),
	\+ barAnd(BadAnd),
	e(_, Pre, BadAnd),
	\+ (sprime(Pre) ; tprime(Pre)).

%
% adjustWeight(EdgeId)
%
adjustWeight(EdgeId) :-
	e(EdgeId, U, V),
	bar(U, BarU),
	bar(V, BarV),
	e(EdgeId2, BarU, BarV),
	flag(max_delta, Delta, Delta),
	retract(lambda(EdgeId,  _)),
	assert( lambda(EdgeId,  Delta)),
	retract(lambda(EdgeId2, _)),
	assert( lambda(EdgeId2, Delta)).


heuristic1(U) :-
	bar(U, BarU),
	d(U,    Du),
	d(BarU, Dbaru),
	( (Dbaru=sp2_infinity) ; (Dbaru>Du) ), !,
	cutEdge(U, EId),
	adjustWeight(EId),
	print(h1-1).


heuristic1(U) :-
	zprime(Wu, U),
	bar(U, BarU),
	zprime(Wbaru, BarU),
	bar(Wu, BarWu),
	BarWu = Wbaru, !,
	cutEdge(U, EId),
	adjustWeight(EId),
	print(h1-2).



heuristic1(U) :-
	bar(U, BarU),
	zprime(Wbaru, BarU),
	e(EId, Wbaru, BarU),
	adjustWeight(EId),
	print(h1-3).


heuristic2(V) :-
	bar(V, BarV),
	d(V,    Dv),
	d(BarV, Dbarv),
	\+ ( (Dbarv=sp2_infinity) ; (Dbarv<Dv) ), !,
	cutEdge(V, EId),
	adjustWeight(EId),
	print(h2-1).


heuristic2(V) :-
	bar(V, BarV),
	zprime(Wbarv, BarV),
	zprime(Wv, V),
	bar(Wv, BarWv),
	BarWv = Wbarv, !,
	cutEdge(V, EId),
	adjustWeight(EId),
	print(h2-2).


heuristic2(V) :-
	zprime(Wv, V),
	e(EId, Wv, V),
	adjustWeight(EId),
	print(h2-3).





