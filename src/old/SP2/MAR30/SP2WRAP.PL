sp2_control(CoaxTries) :-
	CoaxTries >= 0, !,
	countReachableNodes(N),
	flag(reachable, _, N),
	flag(sp2tries,  _, 0),
	flag(sp2time,   _, 0),
	flag(pgoals,    _, 0),
	flag(pgraph,    _, 0),
	flag(coaxing,   _, 0),
	flag(h1,        _, 0),
	flag(h2,        _, 0),
	flag(h3,        _, 0),
	flag(h4,        _, 0),
	repeatLoop_3(CoaxTries).


repeatLoop_3(CoaxTries) :-
	Time1 is cputime,
	time(sp2),
	Time2 is cputime,
	Time is Time2 - Time1,

	TimeMil is Time*1000,
	percentCoveredGoals(CoveredGoals),
	percentCoveredGraph(CoveredGraph),
	sp2HeuristicsStat(H, H1, H2, H3, H4),

	flag(sp2tries, Sp2tries, Sp2tries+1),
	flag(sp2time,  Sp2time,  Sp2time+Time),
	flag(pgoals,   Pgoals,   Pgoals+CoveredGoals),
	flag(pgraph,   Pgraph,   Pgraph+CoveredGraph),
	flag(coaxing,  C,        C+H),
	flag(h1,       OldH1,    OldH1+H1),
	flag(h2,       OldH2,    OldH2+H2),
	flag(h3,       OldH3,    OldH3+H3),
	flag(h4,       OldH4,    OldH4+H4),

	format('Try #~w:~10|~2f ms~8+ ~2f % goals~8+ ~2f % graph\n',
	[Sp2tries, TimeMil, CoveredGoals, CoveredGraph]),
	format('~10|~w ~4+= ~w ~6++ ~w ~6++ ~w ~6++ ~w\n', [H, H1, H2, H3, H4]), nl,

	continue_repeatLoop_3(CoaxTries).


continue_repeatLoop_3(CoaxTries) :-
	percentCoveredGoals(Covered),
	Covered \= 100,
	CoaxTries > 0, !,
	NewCoaxTries is CoaxTries - 1, 
	repeatLoop_3(NewCoaxTries).

continue_repeatLoop_3(_CoaxTries) :-
	sp2Stats(AvgTime, AvgGoals, AvgGraph, H, H1, H2, H3, H4),
	AvgTimeMilli is AvgTime*1000,
	format('Average run time      = ~2f ms  \n', [AvgTimeMilli]),
	format('Average goals covered = ~2f %   \n', [AvgGoals]),
	format('Average graph covered = ~2f %   \n', [AvgGraph]),
	format('Average coaxing       = ~w times\n', [H]),
	format('~5|H ~4+= H1 ~6++ H2 ~6++ H3 ~6++ H4\n', []),
	format('~5|~1f ~4+= ~1f ~6++ ~1f ~6++ ~1f ~6++ ~1f\n', [H, H1, H2, H3, H4]).


percentCoveredGoals(Percent) :-
	countN(goal(_G), Goal),
	countN(achievedGoal(_AG), AchievedGoal),
	Percent is AchievedGoal/Goal*100.

achievedGoal(Goal) :-
	goal(Goal),
	( sprime(Goal) ; tprime(Goal) ).


percentCoveredGraph(Percent) :-
	flag(reachable, Gs, Gs),
	countN(z(_), Zs),
	Percent is Zs/Gs*100.


sp2Stats(AvgTime, AvgGoals, AvgGraph, AvgCoaxing,
         AvgH1, AvgH2, AvgH3, AvgH4) :-
	flag(sp2tries, Sp2tries, Sp2tries),
	flag(sp2time,  Sp2time,  Sp2time),
	flag(pgoals,   Pgoals,   Pgoals),
	flag(pgraph,   Pgraph,   Pgraph),
	flag(coaxing,  Coaxing,  Coaxing),
	flag(h1,       H1,       H1),
	flag(h2,       H2,       H2),
	flag(h3,       H3,       H3),
	flag(h4,       H4,       H4),
	AvgGoals   is Pgoals  / Sp2tries,
	AvgGraph   is Pgraph  / Sp2tries,
	AvgTime    is Sp2time / Sp2tries,
	AvgCoaxing is Coaxing / Sp2tries,
	AvgH1      is H1      / Sp2tries,
	AvgH2      is H2      / Sp2tries,
	AvgH3      is H3      / Sp2tries,
	AvgH4      is H4      / Sp2tries.


% --------------------------------
countReachableNodes(N) :-
	(dynamic reached/1),
	newPQ(PQ0),
	initializeReachable(PQ0, PQ1),
	reachableLoop(PQ1),
	countN(reached(_), N), !,
	retractall(reached(_)).

initializeReachable(PQ0, PQ1) :-
	setof(Node, start(Node), Nodes),
	initializeReachable0(Nodes, PQ0, PQ1).

initializeReachable0([Node|Rest], PQ0, PQ1) :-
	insert2PQ(PQ0, 0, Node, Temp),
	initializeReachable0(Rest, Temp, PQ1).

initializeReachable0([], PQ, PQ).


reachableLoop(PQ) :-
	emptyPQ(PQ), !.

reachableLoop(PQ) :-
	deleteMin(PQ, D, Node, PQ1), !,		% Step 6a
	reachableLoop0(PQ1, D, Node).

reachableLoop0(PQ, _D, Node) :-
	reached(Node), !,
	reachableLoop(PQ).

reachableLoop0(PQ, D, Node) :-
	markReachable(Node),
	findAllReachable(Node, D, PQ, Out),
	reachableLoop(Out).

findAllReachable(From, D, In, Out) :-
	setof(To, From^D^findReachable(From, D, To), Tos),
	insertPQs(Tos, In, Out).
findAllReachable(_, _, PQ, PQ).

findReachable(From, D, D0-To) :-
	e(E, From, To),
	lambda(E, Lambda),
	D0 is D + Lambda.

markReachable(Node) :-
	reached(Node), !.
markReachable(Node) :-
	assert(reached(Node)).
