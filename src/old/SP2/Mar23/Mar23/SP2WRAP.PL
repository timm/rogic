sp2_control(CoaxTries) :-
	CoaxTries >= 0, !,
	repeatLoop_3(CoaxTries).

sp2_control(_,_) :-
	print(internalPanicEmailProgrammerNow),
	nl,
	fail.

repeatLoop_3(CoaxTries) :-
	Time1 is cputime,
	sp2,
	Time2 is cputime,
	Time is Time2 - Time1,

	percentCoveredGoals(CoveredGoals),
	percentCoveredGraph(CoveredGraph),

	format('SP2 : ~w seconds\n', [Time]),
	format('Covered ~w% goals + ~w% graph\n\n', [CoveredGoals, CoveredGraph]),

	repeatLoop_3a(CoaxTries).


repeatLoop_3a(CoaxTries) :-
	percentCoveredGoals(Covered),
	Covered \= 100,
	CoaxTries > 0, !,

	nl, nl,

	Time1 is cputime,
	time(sp2),
	Time2 is cputime,
	Time is Time2 - Time1,

	percentCoveredGoals(CoveredGoals),
	percentCoveredGraph(CoveredGraph),

	format('CoaxTries #~w: ~w seconds\n', [CoaxTries, Time]),
	format('Covered ~w% goals + ~w% graph\n\n', [CoveredGoals, CoveredGraph]),

	NewCoaxTries is CoaxTries - 1, 
	repeatLoop_3a(NewCoaxTries).

repeatLoop_3a(_0).

percentCoveredGoals(Percent) :-
	countN(goal(_G), Goal),
	countN(achievedGoal(_AG), AchievedGoal),
	Percent is AchievedGoal/Goal*100.

achievedGoal(Goal) :-
	goal(Goal),
	( sprime(Goal) ; tprime(Goal) ).


percentCoveredGraph(Percent) :-
	countN(n(_, _), Gs),
	countN(z(_), Zs),
	Percent is Zs/Gs*100.


z(Node) :-
	(sprime(Node) ; tprime(Node)).

