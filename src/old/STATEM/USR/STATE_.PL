rList is t + [size,items]
with give(L) <-- 
	items := L, 
	{length(L,S)}, 
	size := S
    with take(I) <-- 
	size~>S, 
	items~>L, 
	{N is random(S), nth0(N,L,I)}.

list is t + [contents]
with one(One) <-- 
	contents~>C, 
	{length(C,Len), N is random(Len), nth0(N,C,One)}.

genericState is t + [name,owner: std,nErrors] 
with entry with exit with do
with arrive  <-- arrive0, entry, do
with arrive0 <-- name~>N, log(arrivingAt(N))
with log(X)  <-- {print(X),nl}.

std is genericState +  [start: state, current:state].
with getStartState(Y) <-- name~>X, oo(state,name~>X,Y).
with entry            <-- getStartState(X), X@entry.
with putStartState(X) <-- name := X.
with  goto(State)     <--
        State@name~>N,
	current := N,
	State@arrive.

state is genericState 
with getOwner(O) <-- owner~>Name, oo(std,name~>Name,O),!.
with arrive      <-- 
	up@arrive, nextEvent(E), E@event~>N, log~>event(N), E@arrive.
with nextEvent(One) <--
	name~>Name,
	{findall(T,oo(transistion,from(Name),T),All)},
	oo(new(list),[contents~>All,one(One)]).

end is state  * name := end
with arrive <-- arrive0.

transistion is genericState + [to : state ,from : state]
with  event with gaurd with sideEffect
with  do   <-- guard, exit.
with  exit <-- sideEffect, getOwner~>O, to~>To, O@goto(To).
% XXX path, event


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% what about gaurds like incomplete, invalid
% are gaurds state-level properties?

phoneState is state       * owner := phone.
phoneTrans is transistion * owner := phone.

connecting is phoneState. pinned  is phoneState.
talking    is phoneState. dialing is phoneState.

phoneThing is phoneState  with play(X) <-- {print(playing(X)),nl}.
timeout    is phoneThing  with do<-- play(message).
dialtone   is phoneThing  with do<-- play(dialtone).
invalid    is phoneThing  with do<-- play(message).
busy       is phoneThing  with do<-- play(busyTone).
ringing    is phoneThing  with do<-- play(ringingTone).

% XXX these assertions are not showing up. why?

is phoneTrans * path(dialtone,timeout) 
   with event(after(sec(15))).
is phoneTrans * path(dialing,timeout)
   with event(after(sec(15))).
is phoneTrans * path(dialing,dialing)
   with event(dail(_))
   with gaurd <-- event(incomplete).

is phoneTrans * path(dialing,invalid).
is phoneTrans * path(dialtone,dialing).
is phoneTrans * path(dialing,connecting).
is phoneTrans * path(connecting,busy).
is phoneTrans * path(connecting,ringing).
is phoneTrans * path(ringing,talking).
is phoneTrans * path(talking,pinned).
is phoneTrans * path(pinned,talking).






