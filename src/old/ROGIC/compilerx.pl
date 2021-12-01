genScenario([rx=Rx0|Results],scenarios(S)) :-
	allIns(Rx0,All),
	getIns(Rx0,All,Rx),
	maplist(additR,[rx=Rx|Results],S1),	
	transpose(S1,S).

transpose(M0,M) :-
	length(M0,L),
	bagof(Col,M0^L^column(M0,L,Col),M).

column(M,L,C) :-
	between(1,L,I),
	maplist(nth1(I),M,C).

additR(X=L,Out) :- maplist(addit(X),L,Out).
addit(X,Y,X/Y).

allIns(Ins,All) :-
	setof(Y,X^Ins^(member(X,Ins),
	                member(Y,X)),All).

getIns([],_,[]).
getIns([Rx0|Rxs0],All,[Rx|Rxs]) :-
	getIns1(All,Rx0,Rx),
	getIns(Rxs0,All,Rxs).

getIns1([],_,[]).
getIns1([Action0|Actions0],Mentioned,[Action|Actions]) :-
	getIns2(Action0,Mentioned,Action),
	getIns1(Actions0,Mentioned,Actions).

getIns2(Action,Mentioned,Action/1) :- 
	member(Action,Mentioned),!.
getIns2(Action,_,Action/ -1). 
