goal_expansion(>=(X,Y,     Z,Z), X >= Y).
goal_expansion(>(X,Y,      Z,Z), X > Y).
goal_expansion(=(X,Y,      Z,Z), X = Y).
goal_expansion(\=(X,Y,     Z,Z), X \= Y).
goal_expansion(<(X,Y,      Z,Z), X < Y).
goal_expansion(=<(X,Y,     Z,Z), X =< Y).
goal_expansion(flag(A,B,C, Z,Z), flag(A,B,C)).
goal_expansion(format(A,B, Z,Z), format(A,B)).
goal_expansion(fail(       Z,Z), fail).
goal_expansion(is(X,Y,     Z,Z), X is Y).
goal_expansion(say(X,      Z,Z), (print(X),nl)).
goal_expansion(member(A,B, Z,Z), member(A,B)).
goal_expansion(bagof(A,B,C,Z,Z), bagof(A,B,C)).
goal_expansion(setof(A,B,C,Z,Z), setof(A,B,C)).
goal_expansion(last(A,B,   Z,Z), last(A,B)).
goal_expansion(o(A,B,C),  _) :-
	\+ clause(o(A,B,C),_),
	print(bad(A)),
	fail.

