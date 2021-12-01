:- op(999,xfy, or).
:- op(998,xfy,and).
:- op(997,fy, not).

xpand(not (A0 and B0), Out)      :- !, xpand(not A0 or not B0,Out).
xpand(not (A0 or B0),  Out)      :- !, xpand(not A0 and not B0,Out).
xpand(A0 and B0,       A and B)  :- !, xpand(A0,A), xpand(B0,B).
xpand(A0 or B0,        C          ) :- !, (xpand(A0,C); xpand(B0,C)).
xpand(not in(A,X),     absent(A,X)) :- !.
xpand(not absent(A,X), in(A,X)    ).
xpand(A,               A          ).

test(Y) :-
	xpand(not (in(a,s) and in(b,t) or in(a,s)),Y).
