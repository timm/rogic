stringOfLength(L,S) :-
	stringOfLength(L,' ',S).

stringOfLength(L0,Char,Out) :-
	L is L0,
	(L > 0
	-> 	length(Temp,L),
		name(Char,[Value]),
		stringOfLength1(Temp,Value),
		name(Out,Temp)
	| 	Out = '').

stringOfLength1([],_).
stringOfLength1([Char|Rest],Char) :-
	stringOfLength1(Rest,Char).
