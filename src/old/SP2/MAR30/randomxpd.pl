term_expansion(random_node(_, Node, AndOr), [defined(Node), n(Node, AndOr)]).

term_expansion(random_edge(_, From, To), [e(Id, From, To), lambda(Id, 1)]) :-
	flag(e1, Id, Id+1).


