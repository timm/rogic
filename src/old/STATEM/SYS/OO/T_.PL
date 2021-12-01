% defining true
% classic boot strap problem: have to hand code some
% of these predicates

:- discontiguous t_ / 3.

t_(X,T) :- t_(X,T,_).

oo(t,What)           :- t_(What,t(_),_).
oo(t(X),What)        :- t_(What,t(X),_).
oo(new(t),M)         :- t_(init,t(_),New), t_(M,New,_).

oo(t,What,Out)       :- t_(What,t(_),Out).
oo(new(t),What,Out)  :- t_(init,_,Temp), t_(What,Temp,Out).
oo(t(X),What,Out)    :- t_(What,t(X),Out).

t_(X,_,_)            :- not('#known'(t,X)),
	                barph(X,'not known').

'#known'(t,_~>_).
% ~> is the match operator to method outputs (arity 1)
t_(X~>Y,In,Out) :- 
	Call =.. [X,Y],
	oo(In,Call,Out).

'#known'(t,_ := _).
% := is the transfer operator to slots
t_(X := Y,In,Out) :-
	var(Y),!,
        Call =.. [X,_,Y],
        oo(In,Call,Out).
t_(X:=Y\Z,In,Out) :- !, 
	Call =.. [X,Y,Z],
	oo(In,Call,Out).
t_(X := Type@Calls,In,Out) :- !, 
	oo(new(Type),Calls,New),
	Call =.. [X,_,New],
        oo(In,Call,Out).
t_(X := Y,In,Out) :- !,  % tacky: same as first call without the var
	Call =.. [X,_,Y],  % but every time i try to clean it up, the
        oo(In,Call,Out). % cleaned version is worse that this

%XXXX
%3 ?- oo(new(std),[name=fred,name := Y\john,start := state@[name=fred]],X), write(X).
%%E> start(_G1123, state(3, fred, _G1060, _G1061)) not known

'#known'(t,_@_).
t_(X@Y,_,_) :- var(X),!,
	barph(Y,'message receiver unbound').
t_(Type=X@Calls,In,In) :- !, 
	oo(new(Type),Calls,X).
t_(up@Call,In,Out) :- !,oo(In,super(Call),Out).
t_(me@Call,In,Out) :- !,oo(In,Call,Out).
t_(X@Call,In,Out)  :- oo(In,X:=Y\Z,Out), oo(Y,Call,Z). 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% kludge to make the following methods expand
% to "t" stuff plus knowns
:- swi(flag(currentFrame,_,t)).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

with [].
with [H|T] <-- H, T.

with '#fields'([id]).
with '#inits0'(['#init_id']).
with '#init0' <-- '#inits0'(All), All.
with '#init_id' <-- 
	{flag(id,X,X+1)}, 
	= V, 
	{swi(setarg(1,V,X))}.
with '#types'([posint]).
with access(X) <-- = X.
with arity(1).
with blank(Id,B) <-- 
	functor(F), arity(A), 
	{functor(B,F,A), arg(1,B,Id)}.
with downcast <-- dob=D, {print(dob(D)),nl}.
with functor(t).
with id(X) <-- = Y, {arg(1,Y,X)}.
with identity(I) <-- 
	blank(Id,I),
	= V,
	{arg(1,V,Id)}.   
with id(_,_)  <-- {barph(error,'can not reset ids')}.
with init.
with isa(X)    <-- functor(X).
with isa(X)    <-- up@isa(X).
with noop(_).
with put       <-- {barph(t,'cannot commit stack objects')}.
with value(X)  <-- value(X). % internal compiler trick
with = X       <-- = X. % internal compiler trick




