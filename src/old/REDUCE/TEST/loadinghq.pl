
go1 :-
	print([a=A,b=B,c=C,d=D]),
	nl,
	term2Details(a(A:key:asString, B=fred, C=charmed, D),L), 
	member(X,L),
	hPrint(X).

go1 :-  term2Details(a(_:key:asString, b=fred, _=charmed, _),_).
       % b cant be a var

go :- go1, fail.
go.
