:- op(990,fx,*).
:- op(950,fx,if).
:- op(90,fy,no).
:- op(800,xfx,then).
:- op(100,xfx,++).
:- op(100,xfx,--).
:- op(100,xfx,+-+).
:- op(100,xfx,+--).
:- op(100,xfx,--+).
:- op(100,xfx,---).

:- discontiguous x/3.
:- dynamic asymmetricLinkUsed/0.
:- discontiguous asymmetricLinkUsed/0.

about(--,sym,++). about(++,sym,--).
about(+-+,asym,--+). 
about(--+,asym,+-+). 
about(+--,asym,---).
about(---,asym,+--).

link(X ++  Y,++, X, 1,Y, 1).  
link(X ++  Y,++, X,-1,Y,-1).
link(X --  Y,--, X, 1,Y,-1). 
link(X --  Y,--, X,-1,Y, 1).
link(X +-+ Y,+-+,X, 1,Y, 1).
link(X +-- Y,+--,X, 1,Y,-1).
link(X --+ Y,--+,X,-1,Y, 1).
link(X --- Y,---,X,-1,Y,-1).
 
opposite(X,Y) :-
	link(X,Type,Up,_,Down,_),
	about(Type,_,Reverse),
	link(Y,Reverse,Up,_,Down,_).

term_expansion(* X,Out) :-
	bagof(One,One^xpand(X,One),Out).

nowX(X,Y) :- asString('~w_now',[X],Y).

membera(X,(Y,Z)) :- !,(X=Y; membera(X,Z)).
membera(X,X).

xpand(done,Stds) :- lints, stds(Stds).
xpand(done,L)    :- stuff2do(L).
xpand(check,[])  :- lints.
xpand(if no Ab then Z,Out) :-
	gensym(dummy,Dummy),
	(once(link(Z,Link,_,_,Y,_)),
	 xpand(Dummy ++ Y,Out)
        ;
         Out=[One|Two],
         link(Z,Link,X,S1,Y,S2),
         nowX(Ab,AbNow),
         One=(x(Dummy,T,S2) :- x(AbNow,T, -1),x(X,T,S1)),
         maybeAsyms(Link,Two)
        ).
xpand(if no Ab then Z,Out) :-  
	once((link(Z, Link, _,_,Y,_),
	      link(Z1,Link,Ab,_,Y,_),
              opposite(Z1,Z2))),
	xpand(Z2,Out).
xpand(if Ab then Z,Out) :-
	\+ Ab = (no  _ ),
	gensym(dummy,Dummy),
	(once(link(Z,Link,_,_,Y,_)),
	 xpand(Dummy ++ Y,Out)
        ;
         Out=[One|Two],
	 nowX(Ab,AbNow),
	 link(Z,Link,X,S1,Y,S2),
	 One=(x(Dummy,T,S2) :- x(AbNow,T, 1),x(X,T,S1)),
	 maybeAsyms(Link,Two)).
xpand(if Ab then Z,Out) :-  
        \+ Ab = (no _ ),
	once((link(Z,Link,_ , _,Y,_),
              link(Z1,Link,Ab,_,Y,_))),
	xpand(Z1,Out).
xpand(Z,[One|Two]) :- 
	link(Z,Link,X,S1,Y,S2),
	One=(x(Y,T,S2) :- x(X,T,S1)),
	maybeAsyms(Link,Two).
xpand(X=[H|T],datum(X,[H|T])).
xpand([H|T],Out) :-
	member(Thing,[H|T]),
	( Out= defined(Thing)
        ; Out= (:- discontiguous Thing/3)
        ; Out= (:- dynamic       Thing/3)).
xpand(true(X),x(X,_,1)).
xpand(false(X),x(X,_,0)).

maybeAsyms(Link,Out) :-
	about(Link,asym,_), 
         \+   asymmetricLinkUsed
        -> Out = [asymmetricLinkUsed]
        ;  Out = [].

stuff2do(L) :-
	datum(rx,RXs),
	findall(D=FX,( datum(D,FX), \+ D = rx),FXs),
	findall(X,getGo(RXs,FXs,X),L).

lints :- lints(L)
         ->  forall(member(X,L), 
	        format(user_error,"% oops(~p).~n",[X]))
         ;   true.

lints(Errors) :- 
	setof(X,lint(X),Errors).
lint(X) :- 
	clause(x(When,Who,What),Subs),
	lint((x(When,Who,What),Subs),X).
lint(x(Who,_,_),undefined(Who)) :- 
	\+ defined(Who).
lint((X,Y),Out) :- 
	lint(X,Out); lint(Y,Out).

stds((x(X,T,0) :- x(Y,T,V1), x(Z,T,V2))) :-
	clause(x(X,T,1), x(Y,T,V1)),
	clause(x(X,T,-1),x(Z,T,V2)),
	\+ Y = Z.

getGo(RXs,FXs,
        (go(NTH,Cover,L) :- ht0(NTH,Gs,Is,Cover,L))) :-
	allRX(RXs,AllRX),
	twoExperiments(RXs,One,Two),	
	nth1(One,RXs,Exp1), 
	nth1(Two,RXs,Exp2),
	getIns(AllRX,Exp1,Exp2,[],Is),
	getGoals(One,Two,FXs,Gs),
	\+ Gs= [],
	flag(ngo,NTH,NTH+1).

twoExperiments(L,X,Y) :-
	length(L,N),
	between(1,N,X), between(1,N,Y),
	(asymmetricLinks -> \+ X=Y; Y > X). 

asymmetricLinks :- once(asymmetricLinkUsed).

getGoals(One,Two,Fxs,Goals) :-
	findall(Goal,getGoal(One,Two,Fxs,Goal),Goals).

getGoal(One,Two,Fxs,Thing=Delta) :-
	member(Thing=FX,Fxs), 
	nth1(One,FX,Val1),  nth1(Two,FX,Val2),
	number(Val1),       number(Val2),
	c2n(Val2,Val1,Delta).

allRX(RXs,L) :-	setof(Action,RXs^oneRX(RXs,Action),L).
oneRX(RXs,X) :- member(RX,RXs),member(X,RX).

getIns([],_,_,In,In).
getIns([Action|Actions],Exp1,Exp2,In0,In) :-
	exp_status(Action,Exp1,V1),
	exp_status(Action,Exp2,V2),
	c2n(V2,V1,Delta),
	nowX(Action,AD),
	(Delta=0 
        ->  In1=[AD=V2|In0]
        ;   In1=[Action=Delta,AD=V2|In0]),
	getIns(Actions,Exp1,Exp2,In1,In).

exp_status(Action,Exp,1) :- member(Action,Exp), !.
exp_status(_,_,-1).

c2n(Val1,Val2,Delta) :-
	compare(Comp,Val1,Val2),
	c2n1(Comp,Delta).

c2n1(<,-1). c2n1(=,0). c2n1(>,1).












