demo(1) :-
	repeat,
	once(@when(A,B,C,D,E,F)),
	print(when(A,B,C,D,E,F)),
	nl,
	get(113),
	!.
