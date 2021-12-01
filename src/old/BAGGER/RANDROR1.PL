goal_expansion(X rand Y,runRand(Out)) :- r2l(X rand Y,Out).
goal_expansion(X ror Y, runRor( Out)) :- r2l(X ror  Y,Out).

runRor(l(L,N)) :- rone(l(L,N),One,_), One.

runRand(l([],0)). 
runRand(l(L,N)) :- rone(l(L,N),One,Rest),One,runRand(Rest).

r2l(X ror Y,   l([X|Rest],N)) :- !, r2l(Y,l(Rest,N0)), N is N0 + 1.
r2l(X rand Y,  l([X|Rest],N)) :- !, r2l(Y,l(Rest,N0)), N is N0 + 1.
r2l(X,         l([X]     ,1)).
