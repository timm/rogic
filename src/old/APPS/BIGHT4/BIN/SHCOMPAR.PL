kludgeLoad :-
	['c:/timm/shanghai/data/dialects/qcm/28symclf.out'].

totalClumpingTime(Out) :-
	bagof(N,clumpingTime(N),All),
	sum(All,Out).

clumpingTime(CTime) :- ticks(T), 
	member(clumping - CTime/_,T).

diffresult(Exp1,R1,R2) :-
	flag(diffresult,_,0),
	aResult(What,When,Exp1,Exp2,clumpOn, P1,R1),
	proofStructure(P1,_N1,_),
	aResult(What,When,Exp1,Exp2,clumpOff,P2,R2),
	proofStructure(P2,_N2,_),
	\+ P1 = P2,
	flag(diffresult,Old,Old + 1).

/*
	%proofs(P1,N1,Size1),
	%proofs(P2,N2,Size2),
	R1 = result(What,When,Exp1,Exp2,_IO1,_NClumps1,clumpOn/_CA,P1,_NWorlds,NBest1,BestP1,_Time1),
	R1,
%	T1    < CA,
%	N1    < T2,
%	Size1 < T3,
	R2 = result(What,When,Exp1,Exp2,_IO2,_NClumps2,clumpOff/0,P2,_NWorlds,NBest2,BestP2,_Time2),
%	R2,
%	N2    < T2,
%	Size2 < T3,
	\+ P1 = P2, %sameresults(P1,P2,NBest1,NBest2,BestP1,BestP2),
*/


sameresults(P,P,_NBest,_NBest2,_BestP,_BestP2).

aResult(What,When,X1,X2,C,P,R) :-
	R = result(What,When,X1,X2,_,C/_,_,P,_,_,_,_),
	R.

aWorld(W) :-
	result(_What,_When,_X1,_X2,_,_C/_,_,_P,W,_,_,_),
	\+ W = 0.

nWorlds(Stats) :-
	bagof(N,aWorld(N), All),
	stats(All,Stats).
	


proofStructure(N/Av - [_Min, _Max] - _All,N,Av).






