bins(N,All,B) :-
	bins1(N,All,B0),
	unique(B0,B).

bins1(N,All,[H|Ls]) :-
	length([H|T],N),
	append([H|T],Rest,All),!,
	bins1(N,Rest,Ls).

bins1(_,[H|_],[H]).
bins1(_,[],[]).