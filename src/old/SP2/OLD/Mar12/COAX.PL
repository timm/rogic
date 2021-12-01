coax :-
	coaxCheck(_).

coaxCheck(Out) :-
	setof(And, coaxee(And), Ands),
	print(Ands),
	checkAnds(Ands, Out).

coaxee(X) :-
	n(X, and),
	zprime(_, X).

checkAnds([H|T], _Out) :-
	setof(From, From^zprime(From, H), Froms).