
demo(Result) :-
	eg(_,X),
	buyWine(X,Result).

%:- write('try running :- demo(X).'),nl.



eliza(1) :-
	[t001],
	go([], % ie. no initial assumptions
	   [happy=t], % top level goal
	   _,
	   X),
	show(X).

eliza(10) :-
	[jim],
	[art1],
	go([],[goodProject=t],_,Y),
	show(Y).
