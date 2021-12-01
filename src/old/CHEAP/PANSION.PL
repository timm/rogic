term_expansion(( ?X = Y  --> Z),Out) :- 
	xpand((?X = Y --> Z),Out).

goal_expansion(ror(X, Y,A,B), do(X ror  Y,A,B)).
goal_expansion(rand(X,Y,A,B), do(X rand Y,A,B)).

xpand((?In = Out --> Y),[(def(In,Out,W0,W) :- Head),(Head :- Body)]) :-
	appendl(In,Out,All),
	X =.. All,
	expand_term((X --> Y),(Head :- Body)),
	Head =.. L,
	append(_,[W0,W],L).

appendl(X0,Y0,L) :- 
	asList(X0,X),
	asList(Y0,Y), 
	append(X,Y,L).
