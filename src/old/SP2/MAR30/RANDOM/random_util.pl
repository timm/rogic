% ***************************
percent_to_num(N, P, Num) :-
	Num is floor(N * P / 100).


% ****************************
rbar(N, BarN) :-
	nonvar(N),
	number(N), !,
	BarN is N * -1.

rbar(N, BarN) :-
	nonvar(BarN),
	number(BarN), !,
	N is BarN * -1.

rbar(-X, B) :- nonvar(X), !, B = X.

rbar(X, -X).

rbarAnd(-And) :-
	n(And, and).

rneg(-_).
rneg(N) :- number(N), N < 0.


% ***************************
create_random_node(or) :-
	flag(random_or_node, Node, Node+1),
	assert_random_node(Node, or).

create_random_node(and) :-
	flag(random_and_node, N, N+1),
	create_random_and_node(N, Node),
	assert_random_node(Node, and).

create_random_and_node(N, Node) :-
	create_random_and_node(N, [], Temp),
	reverse(Temp, AscIIs),
	atom_codes(Node, AscIIs).

create_random_and_node(N, In, [Code|Out]) :-
	N >= 26, !,
	M is (N // 26) - 1,
	Code is (N mod 26) + 97,
	create_random_and_node(M, In, Out).

create_random_and_node(N, In, [Code|In]) :-
	Code is (N mod 26) + 97.

assert_random_node(Node, AndOr) :-
	random_node(Id, Node, AndOr), !,
	print(warning(already_defined(Id, Node, AndOr))), nl.

assert_random_node(Node, AndOr) :-
	rbar(Node, BarNode),
	flag(random_nodes, M, M+1),
	flag(random_nodes, N, N+1),
	assert(random_node(M, Node, AndOr)),
	assert(random_node(N, BarNode, AndOr)).


% ***************************
create_random_edge(Node1, Node2) :-
	Node1 = Node2, !.

create_random_edge(Node1, Node2) :-
	random_node(_, Node1, and),
	random_node(_, Node2, and), !.

create_random_edge(Node1, Node2) :-
	rbar(Node1, Node2), !.

create_random_edge(Node1, Node2) :-
	random_edge(_, Node1, Node2), !.

create_random_edge(Node1, Node2) :-
	random_edge(_, Node2, Node1), !.

create_random_edge(Node1, Node2) :-
	rbar(Node2, BarNode2),
	random_edge(_, Node1, BarNode2), !.

create_random_edge(Node1, Node2) :-
	rbar(Node1, BarNode1),
	random_edge(_, Node2, BarNode1), !.

create_random_edge(Node1, Node2) :-
	rbar(Node1, BarNode1),
	rbar(Node2, BarNode2),
	flag(random_edges, M, M+1),
	flag(random_edges, N, N+1),
	assert(random_edge(M, Node1,    Node2)),
	assert(random_edge(N, BarNode1, BarNode2)).


% ***************************
rand_node(Node) :-
	flag(random_nodes, Seed, Seed),
	NodeId is random(Seed),
	random_node(NodeId, ANode, _),
	Coin is random(2),
	( (Coin = 0)
	-> Node = ANode
	;  rbar(ANode, Node) ).


% ***************************
rcounter(FiFo, Node, N) :-
	reset_rcounter,
	run_rcounter(FiFo, Node),
	report_rcounter(N).

reset_rcounter :-
	flag(random_counter, _, 0).

run_rcounter(fanout, Node) :-
	forall(random_edge(_, Node, _), flag(random_counter, Old, Old+1)).

run_rcounter(fanin, Node) :-
	forall(random_edge(_, _, Node), flag(random_counter, Old, Old+1)).

report_rcounter(N) :-
	flag(random_counter, N, N).


% ***************************
% create_random_starts_and_goals :- !.
%
create_random_starts_and_goals :-
	collect_random_starts,
	collect_random_goals.

% ------------
collect_random_starts :-
	forall(good_random_start(Node), assert(random_start(Node))).

good_random_start(Out) :-
	random_node(_, Node, or),
	\+ random_edge(_, _, Node),
	rbar(Node, BarNode),
	\+ random_start(Node),
	\+ random_start(BarNode),
	Coin is random(2),
	( (Coin = 0)
	-> Out = Node
	;  Out = BarNode ).

% ------------
collect_random_goals :-
	forall(good_random_goal(Node), assert(random_goal(Node))).

good_random_goal(Out) :-
	random_node(_, Node, or),
	\+ random_edge(_, Node, _),
	rbar(Node, BarNode),
	\+ random_goal(Node),
	\+ random_goal(BarNode),
	Coin is random(2),
	( (Coin = 0)
	-> Out = Node
	;  Out = BarNode ).


% ***************************
random_filename(NodeNum, Percent, Filename) :-
	exists_directory(rgraph), !,
	rfilename(NodeNum, Percent, Filename).

random_filename(NodeNum, Percent, Filename) :-
	make_directory(rgraph),
	rfilename(NodeNum, Percent, Filename).

rfilename(NodeNum, Percent, Filename) :-
	string_concat('rgraph/rg', NodeNum, Str0),
	string_concat(Str0,        '_',     Str1),
	string_concat(Str1,        Percent, Base),
	rfilename1(Base, 0, Filename).

rfilename1(Base, N, Filename) :-
	string_concat(Base, '_',    Str0),
	string_concat(Str0, N,      Str),
	string_concat(Str,  '.pl', Temp),
	M is N + 1,
	(  exists_file(Temp)
	-> rfilename1(Base, M, Filename)
	;  Filename = Str
	).


% ****************************
:- index(r_maxPercent(1, 1, 1)).

r_maxPercent(15,   15,  0).
r_maxPercent(16,   20, 40).
r_maxPercent(21,   25, 55).
r_maxPercent(26,   30, 65).
r_maxPercent(31,   35, 70).
r_maxPercent(36, 1000, 75).

rbetween_range(nodes, N) :-
	integer(N),
	between(15, 1000, N).

rbetween_range(and_percent, N) :-
	integer(N),
	between(0, 75, N).

rbetween_range(fanout, N) :-
	integer(N),
	between(2, 6, N).

rcheck_param(NodeNum, AndPercent, Fanout, LoadFile) :-
	rbetween_range(nodes,  NodeNum),
	rbetween_range(and_percent,   AndPercent),
	rbetween_range(fanout, Fanout),
	var(LoadFile),
	!.

rcheck_param(_, _, _, _) :-
	format('Syntax: random_graph(+Nodes, +And%, +Fanout, -File)\n', []),
	format('        Nodes   = [15,  1000) \n'),
	format('        And%    = [ 0,    70] \n'),
	format('        Fanout  = [ 2,     6] \n'),
	format('        # of or = [15,  1000) \n'),
	fail.

r_and_num(NodeNum, Percent, P, Ands) :-
	r_maxPercent(Lo, Hi, P),
	between(Lo, Hi, NodeNum),
	Percent > P, !,
	format('~w% is too large for ~w nodes. Readjust to ~w%\n', [Percent, NodeNum, P]),
	percent_to_num(NodeNum, P, Ands).

r_and_num(NodeNum, Percent, Percent, Ands) :-
	percent_to_num(NodeNum, Percent, Ands).


% ****************************
wme(random, random_node(_NodeId, _Node, _AndOr)).
wme(random, random_edge(_EdgeId, _From, _To)).
wme(random, random_start(_StartNode)).
wme(random, random_goal(_GoalNode)).

init_random :-
	flag(random_or_node,  _, 1),
	flag(random_and_node, _, 0),
	flag(random_nodes,    _, 0),
	flag(random_edges,    _, 0),
	forall(wme(random, Term), ( retractall(Term),
	                            functor(Term, F, A),
	                            (dynamic F/A),
	                            (discontiguous F/A),
	                            random_setIndex(Term)
	                          ) ).

random_setIndex(Term) :-
	functor(Term, F, A),
	length(L1, A),
	maplist(random_setIndex1, L1, L2),
	Term =.. [F|L2],
	index(Term).

random_setIndex1(_, 1).


show_random :-
	wme(random, Term),
	listing(Term),
	nl,
	fail.
show_random.


reset_random :-
	wme(random, Term),
	retractall(Term),
	fail.
reset_random.


finish_random(LoadFile) :-
	string_concat(LoadFile, '.g', GraphFile),
	tell(GraphFile),
	format('digraph g {\n', []),
	draw_random_edges,
	format('}\n', []),
	told,

	string_concat(LoadFile, '.pl',  PrologFile),
	tell(PrologFile),
	forall(wme(random, Term), zap_random(Term)),
	told.

zap_random(Term) :-
	listing(Term),
	retractall(Term).

draw_random_edges :-
	setof(S, draw_random_edge(S), Ss),
	forall(member(graphviz(F, T, Style), Ss), format('"~w" -> "~w" [style=~w]\n', [F, T, Style])).

draw_random_edge(S) :-
	random_edge(_, From, To),
	draw_random_edge(From, To, S).


draw_random_edge(BarX, BarY, graphviz(X/AX, Y/AY, solid)) :-
	rneg(BarX), rneg(BarY), !,
	rbar(X, BarX), rbar(Y, BarY),
	random_node(_, X, AX), random_node(_, Y, AY).

draw_random_edge(BarX, Y, graphviz(X/AX, Y/AY, dotted)) :-
	rneg(BarX), !,
	rbar(X, BarX),
	random_node(_, X, AX), random_node(_, Y, AY).

draw_random_edge(X, BarY, graphviz(X/AX, Y/AY, dotted)) :-
	rneg(BarY), !,
	rbar(Y, BarY),
	random_node(_, X, AX), random_node(_, Y, AY).

draw_random_edge(X, Y, graphviz(X/AX, Y/AY, solid)) :-
	random_node(_, X, AX), random_node(_, Y, AY).


