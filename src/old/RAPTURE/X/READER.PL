:- op(1000,xfx,if).
:- op(999,xfy,or).
:- op(998,xfy,and).
:- op(997,fy,not).

dm([],            [])      :- !.
dm([H0|T0],       [H|T])   :- !, dm(H0,H), dm(T0,T).
dm(A0 or  B0,     A or  B) :- !, dm([A0,B0],[A,B]).
dm(A0 and B0,     A and B) :- !, dm([A0,B0],[A,B]).
dm(not not A0,    A)       :- !, dm(A0,A).
dm(not (A and B), Out)     :- !, dm(not A or  not B,Out).
dm(not (A or  B), Out)     :- !, dm(not A and not B,Out).
dm(not A,         not A)   :- !.
dm(A,             A).

xpand(A0 and B0
	newV(and,
        

/*
ensure(X) :- w X,!.
ensure(X) :- wout X.

a at 34 if 
	b and c or d and not l.

*/
