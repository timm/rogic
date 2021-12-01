
% genertes a number between 1 and Top
randoms(N,Top,Out) :-
	Top1 is Top + 1,
	randoms(N,Top1,[],Out).
randoms(0,_,In,In).
randoms(N,Top,In,Out) :-
	N > 0,
	R is random(Top) + 1,
	N1 is N - 1,
	randoms(N1,Top,[R|In],Out).

%-- maths
max([X],X).
max([X,Y|Z],Max) :- X > Y, !, max([X|Z],Max).
max([_,Y|Z],Max) :- max([Y|Z],Max).

sum([],0).
sum([H|T],Sum) :-
	sum(T,Temp),
	Sum is H + Temp.

average(L,A) :-
	sum(L,Sum),
	length(L,Size),
	(Size = 0 
	-> nl,nl,print(gotcha), nl, fail 
	|  A is Sum /Size).

xstats(L,stats(N,Min,Max,Sum,Average,Sd)) :-
	stats(L,N,Min,Max,Sum,Average,Sd).

stats(L, [n-N, min-Min,max-Max, sum-Sum,average-Average, sd-Sd]) :-
	stats(L,N,Min,Max,Sum,Average,Sd).

stats([H|T],N,Min,Max,Sum,Average,Sd) :-
	SumSquared0 is H*H,
	stats1(T,H,H,H,SumSquared0,Min,Max,Sum,SumSquared),
	length([H|T],N),
	Average is Sum / N,
	(N = 1 
	-> 	Var = 0, Sd = 0
	;	Var is ((N * SumSquared) - (Sum*Sum))/(N*(N-1)),
		Sd is sqrt(Var)).
	
stats1([],Min,Max,Sum,SumSquared,Min,Max,Sum,SumSquared).
stats1([H|T],Min0,Max0,Sum0,SumSquared0,Min,Max,Sum,SumSquared) :-
	Min1 is min(H,Min0),
	Max1 is max(H,Max0),
	Sum1 is Sum0 + H,
	SumSquared1 is SumSquared0 + (H*H),
	stats1(T,Min1,Max1,Sum1,SumSquared1,Min,Max,Sum,SumSquared).

%between(Start,_,Start).
%between(Start,Stop,N) :- 
%	Start < Stop,
%	Temp is Start + 1, 
%	between(Temp,Stop,N).

downTo(Max,N) :- downTo(Max,1,1,N).
downTo(Start,Stop,N) :- downTo(Start,Stop,1,N).

downTo(N,_,_,N).
downTo(Start,Stop,Inc,N) :-
	Stop < Start,
	Temp is Start - Inc,
	downTo(Temp,Stop,Inc,N).
	
newN(N) :-
	flag(uniqueNumbers,N,N+1).

 