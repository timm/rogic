stats([],_,Out,Out).
stats([[X,_,_,_,_,_]|T],X,in(N1,N2,N3,N4,N5,N6),Out) :- 
	N1a is N1 + 1, 
	stats(T,X,in(N1a,N2, N3, N4, N5, N6 ),Out).
stats([[_,X,_,_,_,_]|T],X,in(N1,N2,N3,N4,N5,N6),Out) :- 
	N2a is N2 + 1, 
	stats(T,X,in(N1, N2a,N3, N4, N5, N6 ),Out).
stats([[_,_,X,_,_,_]|T],X,in(N1,N2,N3,N4,N5,N6),Out) :- 
	N3a is N3 + 1, 
	stats(T,X,in(N1, N2, N3a,N4, N5, N6 ),Out).
stats([[_,_,_,X,_,_]|T],X,in(N1,N2,N3,N4,N5,N6),Out) :- 
	N4a is N4 + 1, 
	stats(T,X,in(N1, N2, N3, N4a,N5, N6 ),Out).
stats([[_,_,_,_,X,_]|T],X,in(N1,N2,N3,N4,N5,N6),Out) :- 
	N5a is N5 + 1, 
	stats(T,X,in(N1, N2, N3, N4, N5a,N6 ),Out).
stats([[_,_,_,_,_,X]|T],X,in(N1,N2,N3,N4,N5,N6),Out) :- 
	N6a is N6 + 1, 
	stats(T,X,in(N1, N2, N3, N4, N5, N6a),Out).

go(rmember1) :-
	bagof(One,one(10000,One),All),
	member(X,[a,b,c,d,e,f]),
	stats(All,X,in(0,0,0,0,0,0),Out),
	write(X=Out),
	nl,
	fail.
go(rmember1).

%one(N,L) :-	between(1,N,_), bagof(X,rmember1([a,b,c,d,e,f],6,X),L).
one(N,L) :-	between(1,N,_), bagof(X,x([a,b,c,d,e,f],X),L).

