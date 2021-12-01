term_expansion(always(Inputs, Outputs), Out) :- 
	make_goals(always(Inputs, Outputs), Out).

make_goals(always(Inputs, Outputs), Out) :-
	setof(One, make_goal(Inputs, Outputs, One), Out).

make_goal(Inputs, _, start(In)) :-
	member(In, Inputs),
	bar(In, BarIn),
	\+ member(BarIn, Inputs),
	ok(In).

make_goal(_, Outputs, goal(Out)) :-
	member(Out, Outputs),
	bar(Out, BarOut),
	\+ member(BarOut, Outputs),
	ok(Out).


