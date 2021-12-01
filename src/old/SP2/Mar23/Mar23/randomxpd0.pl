term_expansion(random_node(N, AndOr), [defined(Node), n(Node, AndOr)]) :-
	N > 0,
	atom_concat(node, N, Node).

term_expansion(random_node(N, AndOr), [defined(BarNode), n(BarNode, AndOr)]) :-
	N < 0,
	bar(N, M),
	atom_concat(node, M, Node),
	bar(Node, BarNode).

term_expansion(random_edge(From, To), [e(Id, FromNode, ToNode), lambda(Id, 1)]) :-
	From > 0,
	atom_concat(node, From, FromNode),
	To > 0,
	atom_concat(node, To, ToNode),
	flag(e, Id, Id+1).

term_expansion(random_edge(From, To), [e(Id, FromNode, BarToNode), lambda(Id, 1)]) :-
	From > 0,
	atom_concat(node, From, FromNode),
	To < 0,
	bar(To, T),
	atom_concat(node, T, ToNode),
	bar(ToNode, BarToNode),
	flag(e, Id, Id+1).

term_expansion(random_edge(From, To), [e(Id, BarFromNode, ToNode), lambda(Id, 1)]) :-
	From < 0,
	bar(From, F),
	atom_concat(node, F, FromNode),
	bar(FromNode, BarFromNode),
	To > 0,
	atom_concat(node, To, ToNode),
	flag(e, Id, Id+1).

term_expansion(random_edge(From, To), [e(Id, BarFromNode, BarToNode), lambda(Id, 1)]) :-
	From < 0,
	bar(From, F),
	atom_concat(node, F, FromNode),
	bar(FromNode, BarFromNode),
	To < 0,
	bar(To, T),
	atom_concat(node, T, ToNode),
	bar(ToNode, BarToNode),
	flag(e, Id, Id+1).

term_expansion(random_start(Node), start(Node)).

term_expansion(random_goal(Node), goal(Node)).

