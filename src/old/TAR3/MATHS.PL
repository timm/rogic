:-      current_prolog_flag(max_integer,Y),
	assignOption(maxNumber=Y).

sum([H|T],S) :- sum(T,H,S).
sum([],S,S).
sum([H|T],S0,S) :- S1 is S0+H, sum(T,S1,S).

sumof(X,Y,Z) :- bagof(X,Y,Xs), sum(Xs,Z).

prod([H|T],P) :- prod(T,H,P).
prod([],P,P).
prod([H|T],P0,P) :- P1 is P0*H, prod(T,P1,P).

prodof(X,Y,Z) :- bagof(X,Y,Xs), prod(Xs,Z).

dist(L0,L) :- dist(L0,_,_,L).

dist(L0,Min,Max,L) :-
	msort(L0,[Min|L1]),
	dist([Min|L1],[],Min,Max,L).

dist([],X,Max,Max,X).
dist([H|T],[H-N0|Rest],_,Max,Out) :- !,
	N is N0 + 1,
	dist(T,[H-N|Rest],H,Max,Out).
dist([H|T],In,Min,Max,Out) :-
	dist(T,[H-1|In],Min,Max,Out).
