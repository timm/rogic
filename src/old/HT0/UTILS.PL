av(L,Av) :-
	length(L,N),
	sum(L,S),
	Av is S/N.

sum([],0).
sum([H|T],N) :- sum(T,N1), N is H + N1.