term_expansion(io=List, Out) :-
	flag(sp2_io, _, 1),
	make_goals(List, Out).

make_goals(List, Out) :-
	findall(One, make_goal(List, One), Out).

make_goal(List, io(N, Input, Output)) :-
	member(always(Input, Output), List),
	flag(sp2_io, N, N+1).


