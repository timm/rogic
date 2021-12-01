  eg(1,[7086
  ,5745
  ,8964
 ,12455
 ,16491
 ,19796
 ,21738
 ,22517
 ,21362
 ,18828
 ,15212
 ,11266
 , 7726
 , 4877
 , 2933
 , 1608
 ,  803
 ,  339
 ,  161
 ,   62
 ,   26
 ,    4
 ,    0
 ,    0
 ,    1
 ,    0]).

eg(2,[  5835
,  3657
,  5220
,  7109
,  9237
, 11430
, 13603
, 15414
, 16252
, 16688
, 16201
, 14625
, 12955
, 10945
,  8798
,  6516
,  4792
,  3245
,  2202
,  1259
,   798
,   441
,   256
,    84
,    62
,    24
,    14
,     4
,     3
,     1
,     1
]).

eg(2,[7086
  ,5745
  ,8964
 ,12455
 ,16491
 ,19796]).


sum([H|T],S) :- sum(T,H,S).
sum([],N,N).
sum([H|T],In,Out) :- Temp is In + H, sum(T,Temp,Out).

p(L,G,Ps) :-
	sum(L,S),
	N is round(S/G),
	p1(L,1,1,0,N,Ps).

p1([],_,_,_,_,[]).
p1([_],Bucket,Pos,_,_,[Bucket=Pos]) :- !.
p1([H|T],Bucket,Pos,Temp,Max,[Bucket=Pos|Rest]) :-
	Temp1 is H + Temp,
	Temp1 < Max,!,
	Pos1 is Pos + 1,
	p1(T,Bucket,Pos1,Temp1,Max,Rest).
p1([H|T],Bucket,Pos,_,Max,Rest) :-
	Bucket1 is Bucket + 1,
	p1([H|T],Bucket1,Pos,0,Max,Rest). 
