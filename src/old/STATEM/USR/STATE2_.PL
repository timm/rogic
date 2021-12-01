std is t + [name]. 
+ event(true).
ok.

rList is t + [size,items].
+ give(L) --> items := L, {length(L,s)}, size := S.
+ take(I) --> size=S, items=L, {N is random(S), nth0(N,L,I).
end(rList).

stddev1 is std + [itemsChecked : rList
                 ,itemsStatus  : rList
                 ,itemsAvailable : rList].
+ itemsChecked(itemChecked(X))     --> itemsChecked@take(X).
+ itemsAvailable(itemAvailable(X)) -->  itemsAvailable@take(X).
+ itemsStatus(itemStatus(X))       --> itemsStatus@take(X).
+ init -->  
	o super(init),
	o name := checkingStuff,
	o itemsChecked0(C),
	length(C,CN),
	o itemsChecked1 := CN/C,
	o itemsAvailable0(A),
	length(A,AN),
	o itemsAvailable1 := AN/A,
	o itemsStatus0(S),
	length(S,SN),
	o itemsStatus1 := SN/S.
+ event(X) --> 
	o itemAvailable(X) 
        ; o itemChecked(X).
end(stddev1).

state is t + [name,nErrors].
+ arrive --> o entry, o do.
+ leave  --> o exit.
% some "do nothing" slots
+ entry.
+ exit.
+ do.
ok.

transistion is t + [name,up,down].
+ do --> o event, o guard, o sideEffect, o transist.
+ event.
+ transist.
+ guard.
+ sideEffect.
+ event.
+ init --> o super(init).
ok.

db:std1 is stddev1.
+ itemsChecked0(  [all,       some]).
+ itemsAvailable0([all,       some]).
+ itemsStatus0(   [requested, received]).
ok.

checkingS is state.
+ init --> o super(init), o name := checking.
+ do   --> o checkItem.
+ checkItem.
ok.

dispatchingS is state.
+ init --> o super(init), o name := dispatching.
ok.

waitingS is state.
cancelledS is state.
deliveredS is state.

t1 is transistion.
+ from(checkingS).
+ to(dispatchingS).
+ guard --> o event(itemsChecked(all)),
	    o event(itemsAvailable(all)).
ok.

t2 is transistion.
+ from(waitingS).
+ to(dispatchingS).
+ event(tt).
ok.










