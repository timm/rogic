 demo(0) :-
	Rule = (23*a = b),
	xpand(Rule,X),
	portray_clause(X).

 demo(1) :-
	Rule = (23*a = not b),
	xpand(Rule,X),
	portray_clause(X),
	listing(neg).

 demo(2) :-
	listing(used),
	listing(context).

 demo(3) :-
	listing(defs).
 

 demo(4) :-
	print(showq),nl.

 demo(5) :-
	listing([do,do1,do2]).

 demo(10) :-
 	th(t000),
 	forall(do([d=1],[start=1],W),
 	       show(W)).

 demo(11) :- print(handleKnowledgeFromKsources),nl.

 demo(12) :-
 	th(t000),
 	forall(do([trust=tim, d=1],[start=1],W),
 	       show(W)).
 demo(13) :-
 	th(sym16),
 	forall(do([],[start=1],W),
 	       show(W)).

