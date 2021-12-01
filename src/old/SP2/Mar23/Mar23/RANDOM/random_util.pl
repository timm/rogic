percent_to_num(N, P, Num) :-
	Num is floor(N * P / 100).

create_node(AndOr) :-
	flag(random_node, N, N+1),
	assert(random_node(N, AndOr)),
	rbar(N, BarN),
	assert(random_node(BarN, AndOr)).


create_edge(Node1, Node2) :-
	Node1 = Node2, !.

create_edge(Node1, Node2) :-
	rbar(Node1, Node2), !.

create_edge(Node1, Node2) :-
	random_edge(Node1, Node2), !.

create_edge(Node1, Node2) :-
	random_edge(Node2, Node1), !.

create_edge(Node1, _Node2) :-
	random_node(Node1, and),
	Node1 < 0, !.

create_edge(_Node1, Node2) :-
	random_node(Node2, and),
	Node2 < 0, !.

create_edge(Node1, Node2) :-
	rbar(Node1, BarNode1),
	rbar(Node2, BarNode2),
	assert(random_edge(Node1, Node2)),
	assert(random_edge(BarNode1, BarNode2)),
	flag(random_connected, N1, N1+1),
	assert(random_connected(N1, Node1)),
	flag(random_connected, N2, N2+1),
	assert(random_connected(N2, BarNode1)),
	flag(random_connected, N3, N3+1),
	assert(random_connected(N3, Node2)),
	flag(random_connected, N4, N4+1),
	assert(random_connected(N4, BarNode2)).





rand_node(NodeNum, Node) :-
	N is random(NodeNum) + 1,
	Coin is random(2),
	( (Coin = 0)
	-> Node = N
	;  rbar(N, Node) ).

connected_rand_node(N, Node) :-
	flag(random_connected, Seed, Seed),
	Seed = 0, !,
	rand_node(N, Node).

connected_rand_node(_, Node) :-
	flag(random_connected, Seed, Seed),
	Id is random(Seed),
	random_connected(Id, N),
	Coin is random(2),
	( (Coin = 0)
	-> Node is N
	;  rbar(N, Node) ).




create_random_starts_and_goals :-
	collect_random_starts,
	collect_random_goals.

collect_random_starts :-
	forall(good_random_start(Node), assert(random_start(Node))).


good_random_start(Out) :-
	random_node(Node, or),
	\+ random_edge(_, Node),
	rbar(Node, BarNode),
	\+ random_start(Node),
	\+ random_start(BarNode),
	Coin is random(2),
	( (Coin = 0)
	-> Out = Node
	;  Out = BarNode ).


collect_random_goals :-
	forall(good_random_goal(Node), assert(random_goal(Node))).


good_random_goal(Out) :-
	random_node(Node, or),
	\+ random_edge(Node, _),
	rbar(Node, BarNode),
	\+ random_goal(Node),
	\+ random_goal(BarNode),
	Coin is random(2),
	( (Coin = 0)
	-> Out = Node
	;  Out = BarNode ).


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
	string_concat(Str,  '.rnd', Temp),
	M is N + 1,
	(  exists_file(Temp)
	-> rfilename1(Base, M, Filename)
	;  Filename = Str
	).



% ****************************
wme(random, random_node(_Node, _AndOr)).
wme(random, random_edge(_From, _To)).
wme(random, random_connected(_N, _Node)).
wme(random, random_start(_StartNode)).
wme(random, random_goal(_GoalNode)).

init_random :-
	flag(random_node, _, 1),
	flag(random_connected, _, 0),
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


finish_random(Base) :-
	string_concat(Base, '.rnd', GraphFile),
	tell(GraphFile),
	format('digraph g {\n', []),
	forall(random_edge(From, To), logEdge(From, To)),
	format('}\n', []),
	told,

	string_concat(Base, '.pl',  LoadFile),
	tell(LoadFile),
	forall(wme(random, Term), zap_random(Term)),
	told.

zap_random(Term) :-
	listing(Term),
	retractall(Term).

logEdge(From, To) :-
	random_node(From, F),
	random_node(To,   T),
	format('"~w" -> "~w"\n', [From/F, To/T]).
% ****************************




rbar(X, BarX) :-
	atom(X), !,
	rbar1(X, BarX).

rbar(N, BarN) :-
	number(N), !,
	BarN is N * -1.

rbar(X, BarX) :-
	X =.. [F|Args],
	rbar1(F, BarF),
	BarX =.. [BarF|Args].

rbar1(BarX, X) :- atom_concat(rbar_, X, BarX), !.
rbar1(X, BarX) :- atom_concat(rbar_, X, BarX).




rcheck(NodeNum, AndPercent, Base) :-
	integer(NodeNum),
	integer(AndPercent),
	NodeNum >= 10,
	AndPercent > 0,
	M is floor(NodeNum*AndPercent/100),
	M > 0,
	var(Base), !.

rcheck(_, _, _) :-
	format('Syntax: random_graph(+Nodes, +And%, -File)\n', []),
	format('        Nodes >= 10\n', []),
	format('        And%  > 0\n', []),
	fail.

rcheck(NodeNum, AndPercent, _Base) :-
	M is floor(NodeNum*AndPercent/100),
	M =< 0,
	format('        Nodes*And/100 > 0\n', []),
	fail.

