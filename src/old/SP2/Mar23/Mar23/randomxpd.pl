term_expansion(random_node(Node, AndOr), [defined(Node), n(Node, AndOr)]).

term_expansion(random_edge(From, To), [e(Id, From, To), lambda(Id, 1)]) :-
	flag(e, Id, Id+1).

term_expansion(random_start(Node), start(Node)).

term_expansion(random_goal(Node), goal(Node)).

