
pinStar(PinStar):- fSweepNumbers(A,Ac,Ab,PinStar,Pa,Pac,Worlds).
pa(Pa):- fSweepNumbers(A,Ac,Ab,PinStar,Pa,Pac,Worlds).
pac(Pac):- fSweepNumbers(A,Ac,Ab,PinStar,Pa,Pac,Worlds).

nproofs(NProofs) :- result(Th, Comp, Slow, X1, X2,
 Causes>Changes/Steadies,
 ClumpingP/ InStarPercentClumpAble,NClumps,
 NProofs/AverageProofSize/Sd - [MinSize,MaxSize] - All,
 NWorlds, NBestWorlds, BestPercentCovered, Time_seconds).

averageProofSize(AverageProofSize) :- result(Th, Comp, Slow, X1, X2,
 Causes>Changes/Steadies,
 ClumpingP/ InStarPercentClumpAble,NClumps,
 NProofs/AverageProofSize/Sd - [MinSize,MaxSize] - All,
 NWorlds, NBestWorlds, BestPercentCovered, Time_seconds).

nworlds(NWorlds) :-
result(Th, Comp, Slow, X1, X2,
 Causes>Changes/Steadies,
 ClumpingP/ InStarPercentClumpAble,NClumps,
 NProofs/AverageProofSize/Sd - [MinSize,MaxSize] - All,
 NWorlds, NBestWorlds, BestPercentCovered, Time_seconds).

fSweepPercent(X) :- ticks(T), member(forwardSweep-_/X,T).

av(X,Out) :- Term=..[X,Y], bagof(Y,Term,All), sum(All,Sum), length(All,N),
	Out is Sum/N,!.

sum([],0).
sum([H|T],Sum) :- sum(T,Temp), Sum is H+Temp.

report :- print(report), 
	  member(G,[fSweepPercent,pinStar,pa,pac,nproofs,averageProofSize,nworlds]),
	  print(','),
	  print(G), 
	  write(','),
	  av(G,X),
	  print(X), 
	  fail.
report :- nl.

