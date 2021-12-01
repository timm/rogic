random_graph(NodeNum, AndPercent, Base) :-

	rcheck(NodeNum, AndPercent, Base), !,

	format('\nGenerating a random tree of ~w nodes (~w% ands)...\n', [NodeNum, AndPercent]),
	random_filename(NodeNum, AndPercent, Base),
	percent_to_num(NodeNum, AndPercent, Ands),
	Ors is NodeNum - Ands,
	!,
	time( (
		init_random,
		create_random_graph(NodeNum, Ors, Ands),
		finish_random(Base)
	) ),
	format('Done! Graphviz output to "~w.rnd"\n', [Base]),
	format('Done! Prolog output to "~w.pl"\n\n', [Base]).


create_random_graph(Num, Ors, Ands) :-
	reset_random, !,
	create_random_graph_nodes(Ors, Ands), !,
	create_random_graph_edges(Num), !,
	create_random_starts_and_goals, !,
	validate_random_graph(Num, Ors, Ands).


% ---------------------------------------------
create_random_graph_nodes(Ors, Ands) :-
	forall(between(1, Ors,  _), create_node(or) ),
	forall(between(1, Ands, _), create_node(and)).


% ---------------------------------------------
create_random_graph_edges(NodeNum) :-
	rand_node(NodeNum, Node1),
	rand_node(NodeNum, Node2),
	create_edge(Node1, Node2),
	more_random_graph_edges(NodeNum).

create_random_graph_edges(N, Node) :-
	connected_rand_node(N, Node0),
	Coin is random(2),
	( (Coin = 0)
	-> create_edge(Node, Node0)
	;  create_edge(Node0, Node) ),
	more_random_graph_edges(N).


% ---------------------------------------------
more_random_graph_edges(N) :-
	random_node(Node, _),
	\+ random_edge(Node, _),
	\+ random_edge(_, Node), !,
	create_random_graph_edges(N, Node).

more_random_graph_edges(N) :-
	random_node(Node, and),
	Node > 0,
	\+ random_edge(_, Node), !,
	create_random_graph_edges(N, Node).

more_random_graph_edges(N) :-
	random_node(Node, and),
	Node > 0,
	setof(From, random_edge(From, Node), FromS),
	length(FromS, Num),
	Num < 2, !,
	create_random_graph_edges(N, Node).

more_random_graph_edges(_).


% ---------------------------------------------
validate_random_graph(_Num, _Ors, _Ands) :-
	random_start(_),
	random_goal(_).

validate_random_graph(Num, Ors, Ands) :- !,
	create_random_graph(Num, Ors, Ands).

