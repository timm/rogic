sp2_control(S, CoaxTries, MaxTries) :-
	MaxTries > 0,
	CoaxTries > 0, !,
	flag(maxCovered, _, 0),
	flag(covered, _, 0),
	repeatLoop3(S, MaxTries, CoaxTries).

sp2_control(_,_,_) :-
	print(internalPanicEmailProgrammerNow),
	nl,
	fail.

repeatLoop3(S, MaxTries, CoaxTries) :-
	flag(covered, C, C), C =\= 1,
	MaxTries > 0, !,
	repeatLoop3a(S, CoaxTries),
	randomize,
	M is MaxTries - 1,
	repeatLoop3(S, M, CoaxTries).
repeatLoop3(_, _) :- wmeShow(sp2wrap).

repeatLoop3a(S, CoaxTries) :-
	flag(covered, C, C), C =\= 1,
	CoaxTries > 0, !,
	sp2(S),
	getCoverage(Covered),
	flag(covered, _, Covered),
	updateMax,
	coaxOrReturn,
	NewCoaxTries is CoaxTries - 1,
	repeatLoop3a(S, NewCoaxTries).
repeatLoop3a(_).

getCoverage(C) :-
	countN(sprime(_SP), Sprime),
	countN(tprime(_TP), Tprime),
	countN(sgoal(_SG), Sgoal),
	countN(tgoal(_TG), Tgoal),
	C is (Sprime + Tprime) / (Sgoal + Tgoal).

percentCoveredGoals(Goals, Percent) :-
	length(Goals, L),
	nCoveredGoals(Goals, N),
	Percent is N*100/L.

nCoveredGoals(Goals,N) :- 
	countN(coveredGoal(Goals),N).

coveredGoal(Goals) :-
	member(G,Goals),
	zprime(G).

updateMax :-
	flag(maxCovered, Max, Max),
	flag(covered, Covered, Covered),
	Covered > Max,
	flag(maxCovered, _, Covered),
	insertPrime2.

insertPrime2 :-
	wmeSetup(sp2wrap),
	wmeZap(sp2wrap),
	forall(sprime(SP), assert(sprime2(SP))),
	forall(tprime(TP), assert(tprime2(TP))),
	forall(zprime(U, V), assert(zprime2(U, V))).

coaxOrReturn :-
	flag(covered, C, C), C =\= 1,
	coax.


