benefit(X,B) :- once(benefit0(X,Y)), benefit1(Y,B).

benefit0((X,Y), and(L)) :- c2l((X,Y),L).
benefit0((X;Y),  or(L)) :- d2l((X;Y),L).
benefit0(X,     support(X,C)) :- clause(X,C).
benefit0(X,       n(N)) :- weights(X,N). 
benefit0(X,     supp
benefit0(X,       n(1)) :- choices(X,Index), memo(Index,X,_).
benefit0(_,       n(0)).

benefit1(and([H|T]),N) :- maplist(benefit,[H|T],All), min(All,N).
benefit1(or([H|T]), N) :- maplist(benefit,[H|T],All), average(All,N).
benefit1(n(N),      N).

benefit(true,  1).
benefit(X, B) :- 
	prep(X,Op,L), !,
	maplist(benefit,L,All), 
	compute(Op,L,B).
benefit(A,B) :-
	weights(A,W),
	clause(A,B),
	benefit(B,B1),
	B is B1*W.
benefit(A,B) :-
	\+ clause(A,_),
	choices(X,Ind),
	memo(Ind,X,0),
	weights(A,W).
	
prep((A,B),min,L) :- c2l((A,B),L).
prep((A;B),average,L) :- d2l((A,B),L).

compute(min,L,Min) :- min(L,Min).
compute(average,L,Av) :- average(L,Av).
	