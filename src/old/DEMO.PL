delar(L,Ans) :-
	append([_|Ans],[_,_],L).

portray([H1,H2,H3|_]) :-
	write([H1,H2,H3]),
	write('...').