/*
 * bar(X, BarX):
 *    bar(a, bar_a), or
 *    bar(bar_a, a)
 */
bar(N, BarN) :-
	nonvar(N),
	number(N), !,
	BarN is N * -1.

bar(N, BarN) :-
	nonvar(BarN),
	number(BarN), !,
	N is BarN * -1.

bar(-X, B) :- nonvar(X), !, B = X.

bar(X, -X).



/*
 *
 */
newAndNode(And) :-
	gensym(and, And).

barAnd(-And) :-
	n(And, and).

andNode(And) :-
	n(And, and).

showAndsInZ :-
	n(And, and),
	( sprime(And) ; tprime(And) ),
	print(And), nl,
	fail.
showAndsInZ.

showBadAndsInZ :-
	n(And, and),
	inZ(And),
	badAnd(And),
	print(And), nl,
	fail.
showBadAndsInZ.

showPrecondsOf(AndNode) :-
	n(AndNode, and),
	e(_, Pre, AndNode),
	print(Pre), nl,
	fail.
showPrecondsOf(_) :- nl.

showSatisfiedPrecondsOf(AndNode) :-
	n(AndNode, and),
	e(_, Pre, AndNode),
	inZ(Pre),
	print(Pre), nl,
	fail.
showSatisfiedPrecondsOf(_) :- nl.


z(Node) :-
	(sprime(Node) ; tprime(Node)).

inZ(Node) :-
	sprime(Node).

inZ(Node) :-
	tprime(Node).
/*
 *
 */
ok(X) :-
	defined(X), !.

ok(X) :-
	dummy(X), !.

ok(X) :-
	atom_concat(and, M, X),
	name(M, Y),
	name(N, Y),
	integer(N), !.

ok(X) :-
	print(unknown(X)), nl, fail.

ok(X, or) :-
	defined(X), !.

ok(X, or) :-
	dummy(X), !.

ok(X, and) :-
	atom_concat(and, M, X),
	name(M, Y),
	name(N, Y),
	integer(N), !.

ok(X, _) :-
	print(unKnown(X)), nl, fail.


/*
 *
 */
resetLambda :-
	forall( lambda(Node, D),
	        ( retract(lambda(Node, D)), assert(lambda(Node, 1)) )
	      ).

%
% maxDelta(N) :
%	N = sum of lambda's
%
maxDelta(N) :-
	resetMaxDelta,
	runMaxDelta,
	reportMaxDelta(N).

resetMaxDelta :-
	flag(deltas, _, 0).

runMaxDelta :-
	forall(lambda(_, W), flag(deltas, Old, Old+W)).

reportMaxDelta(N) :-
	flag(deltas, N, N),
	flag(max_delta, _, N).


% ----------------------------------------
graphviz(z, File) :-
	string_concat(File, '.z', Filename),
	tell(Filename),
	format('digraph z {\n', []),
	draw_z,
	format('}\n', []),
	told,
	format('Z has been drawn to "~w".\n', [Filename]).

graphviz(g, File) :-
	string_concat(File, '.g', Filename),
	tell(Filename),
	format('digraph g {\n', []),
	draw_e,
	format('}\n', []),
	told,
	format('G has been drawn to "~w".\n', [Filename]).



draw_z :-
	setof(S, From^To^(zprime(From, To), graphviz_edge(From, To, S)), Ss),
	forall(member(graphviz(F, T, Style), Ss), format('"~w" -> "~w" [style=~w]\n', [F, T, Style])).

draw_e :-
	setof(S, draw_e(S), Ss),
	forall(member(graphviz(F, T, Style), Ss), format('"~w" -> "~w" [style=~w]\n', [F, T, Style])).

draw_e(S) :-
	e(Id, From, To),
	Id > 0,
	graphviz_edge(From, To, S).


graphviz_edge(BarX, BarY, graphviz(X/AX, Y/AY, solid)) :-
	neg(BarX), neg(BarY), !,
	bar(X, BarX), bar(Y, BarY),
	n(X, AX), n(Y, AY).

graphviz_edge(BarX, Y, graphviz(X/AX, Y/AY, dotted)) :-
	neg(BarX), !,
	bar(X, BarX),
	n(X, AX), n(Y, AY).

graphviz_edge(X, BarY, graphviz(X/AX, Y/AY, dotted)) :-
	neg(BarY), !,
	bar(Y, BarY),
	n(X, AX), n(Y, AY).

graphviz_edge(X, Y, graphviz(X/AX, Y/AY, solid)) :-
	n(X, AX), n(Y, AY).


neg(-_).
neg(N) :- number(N), N < 0.
