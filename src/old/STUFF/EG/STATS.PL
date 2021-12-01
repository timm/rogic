 statss :-
	reset,
        stats has [sum=0,sumSquared=0,n=0].

 :- statss.

 stats(L,S) :- fresh0(stats,S0),stats(L,S0,S).

 %XXX sometimes generates n?1. and do disappears
 item(H) in stats ?-
	%sum`        is sum? +H,
	n`          is n? +1.
	%sumSquared` is sumSquared? +H*H.

 do([H|T]) in stats ?- item(H),do(T).
 do([])    in stats.

 
 egStats :- stats(do([1,2,3]),S),write(S),nl.

  egStats0 :-
	statss,
	stats has [n=0,sum=0,sumSquared=0],
	spy(makeMethod),
	makeMethod((n in stats ?- n` is n? + 1),Out),
	portray_clause(Out).

 egStats1 :-
	statss,
	spy(makeMethod),
	makeMethod((item(H) in stats ?-
	               n`          is n?   + 1
	               %sum`        is sum? + H,
	               %sumSquared` is sumSquared? + H*H
		       ),Out),
        portray_clause(Out).

 egStats2 :-
	statss,
	spy(makeMethod),
	expand_term(do([])    in stats,Out),
	portray_clause(Out).
