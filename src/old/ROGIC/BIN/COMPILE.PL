%%%%%%%%%%%%%%%%%%
% rule compiler

xpand((-X,(Y <- -+Z)),Out) :- !, xpands([(Y <- -now(X), -+Z),(Y <-  X)],Out).
xpand((-X,(Y <- ++Z)),Out) :- !, xpands([(Y <- -now(X), ++Z),(Y <- -X)],Out).
xpand((-X,(Y <-  -Z)),Out) :- !, xpands([(Y <- -now(X),  -Z),(Y <-  X)],Out).
xpand((-X,(Y <-   Z)),Out) :- !, xpands([(Y <- -now(X),   Z),(Y <- -X)],Out).
xpand(( X,(Y <- -+Z)),Out) :- !, xpands([(Y <-  now(X), -+Z),(Y <- -X)],Out).
xpand(( X,(Y <- ++Z)),Out) :- !, xpands([(Y <-  now(X), ++Z),(Y <-  X)],Out).
xpand(( X,(Y <-  -Z)),Out) :- !, xpands([(Y <-  now(X),  -Z),(Y <- -X)],Out).
xpand(( X,(Y <-   Z)),Out) :- !, xpands([(Y <-  now(X),   Z),(Y <-  X)],Out).
xpand((X <- Y),Out) :- 
	\+ number(Y), !,
	xpand(Y,V,H),
	expand_term((wme+val of X= V --> o hop(val of X =V,H)),Out).

xpand((X <- N),Out) :-
	number(N),
	expand_term((wme+val of X= N --> o hop(val of X =N,true)),Out).

xpand((X0 | Y0), V,(X ror Y))    :- !, xpand(X0,V,X), xpand(Y0,V,Y).
xpand((X0 , Y0), V,(X rand Y))   :- !, xpand(X0,V,X), xpand(Y0,V,Y).
xpand(-now(X),_,  now of X = -1) :- !.
xpand( now(X),_,  now of X = 1)  :- !. 
xpand(    ++X,V,  creator(V,V1)      o val of X = V1) :- !.
xpand(    +-X,V,  destroyer(V,V1)    o val of X = V1) :- !.
xpand(    -+X,V,  invcreator(V,V1)   o val of X = V1) :- !.
xpand(    --X,V,  invdestroyer(V,V1) o val of X = V1) :- !.
xpand(     -X,V,  inverse(V,V1)      o val of X = V1) :- !.
xpand(      X,V,  direct(V,V1)       o val of X = V1).

/*xpands(X,Y) :- xpands(X,[],Y).
xpands([],Out,Out).
xpands([H|T],In,Out) :- 
	xpand(H,Temp0),
	asList(Temp0,Temp1),
	append(In,Temp1,Temp2),
	xpands(T,Temp2,Out).
	*/
xpands(L,All) :-
	setof(One,L^xpands1(L,One),All).
xpands1(These,One) :-
	member(Item,These),
	xpand(Item,X),
	asList(X,L),
	member(One,L).
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% table of experimental results compiler
genScenario([rx=Rx0|Results],Out) :-
	allIns(Rx0,All),
	getIns(Rx0,All,Rx),
	maplist(additR,[rx=Rx|Results],S1),	
	transpose(S1,S),
	expand_term(ht0+scenarios(S),Out).

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% gizmo that turns results table into  i/o pairs
getScenario(S,N,In,Goals) :-
	flag(nthScenario,_,1),
	twoMembers(S,[rx/Rx1|E1],[rx/Rx2|E2]),
	delta(E1,E2,Goals,_),
	delta(Rx1,Rx2,In0,InsNow),
	append(In0,InsNow,In),
	flag(nthScenario,N1,N1+1),
	N=N1.

delta([],_,[],[]).
delta([X/ValX|Xs],[X/ValY|Ys],
      [val of X=Delta|Rest],
      [now of X=ValY |Nows]   ) :-
	number(ValX),number(ValY),!,
	compare(Comp,ValY,ValX),
	delta1(Comp,Delta),
	delta(Xs,Ys,Rest,Nows).
delta([_|Xs],[_|Ys], Rest,Nows) :-
	delta(Xs,Ys,Rest,Nows).

delta1(<,-1). delta1(=,0). delta1(>,1).