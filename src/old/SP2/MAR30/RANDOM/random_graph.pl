random_graph(NodeNum, AndPercent, Fanout, LoadFile) :-

	rcheck_param(NodeNum, AndPercent, Fanout, LoadFile), !,

	format('\nGenerating a random graph of ~w nodes, ~w% ands, ~w fanouts...\n', [NodeNum, AndPercent, Fanout]),
	r_and_num(NodeNum, AndPercent, P, Ands),
	Ors is NodeNum - Ands,
	random_filename(NodeNum, P, LoadFile),
	!,
	time( (
		init_random,
		create_random_graph(Ors, Ands, Fanout),
		finish_random(LoadFile)
	) ),
	format('Done! Graphviz output to "~w.g"\n', [LoadFile]),
	format('Done! Prolog output to "~w.pl"\n\n', [LoadFile]).


create_random_graph(Ors, Ands, Fanout) :-
	reset_random, !,
	create_random_graph_nodes(Ors, Ands), !,
	create_random_graph_edges(Fanout).
%	create_random_starts_and_goals, !,
%	validate_random_graph(Ors, Ands, Fanout).


% ---------------------------------------------
create_random_graph_nodes(Ors, Ands) :-
	forall(between(1, Ors,  _), create_random_node(or) ),
	(  (Ands>0)
	-> forall(between(1, Ands, _), create_random_node(and))
	;  true  ).


% ---------------------------------------------
create_random_graph_edges(Fanout) :-
	rand_node(Node1),
	rand_node(Node2),
	create_random_edge(Node1, Node2),
	more_random_graph_edges(Fanout).

create_random_graph_edges(Fanout, to-Node) :- !,
	rand_node(ANode),
	create_random_edge(ANode, Node),
	more_random_graph_edges(Fanout).

create_random_graph_edges(Fanout, from-Node) :- !,
	rand_node(ANode),
	create_random_edge(Node, ANode),
	more_random_graph_edges(Fanout).

create_random_graph_edges(Fanout, Node) :-
	rand_node(ANode),
	create_random_edge(Node, ANode),
	more_random_graph_edges(Fanout).


% ---------------------------------------------
more_random_graph_edges(Fanout) :-
	random_node(_, Node, _),
	\+ random_edge(_, Node, _),
	\+ random_edge(_, _, Node), !,
	create_random_graph_edges(Fanout, Node).

more_random_graph_edges(Fanout) :-
	random_node(_, AndNode, and),
	rcounter(fanin, AndNode, FI),
	FI < 2, !,
	create_random_graph_edges(Fanout, to-AndNode).

more_random_graph_edges(Fanout) :-
	random_node(_, Node, _),
	rcounter(fanout, Node, FO),
	FO < Fanout, !,
	create_random_graph_edges(Fanout, from-Node).

more_random_graph_edges(_).


% ---------------------------------------------
validate_random_graph(_Ors, _Ands, _Fanout) :- !.

validate_random_graph(_Ors, _Ands, _Fanout) :-
	random_start(_),
	random_goal(_).

validate_random_graph(Ors, Ands, Fanout) :- !,
	create_random_graph(Ors, Ands, Fanout).

