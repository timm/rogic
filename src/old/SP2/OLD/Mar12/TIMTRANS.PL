:- op(990,fx,*).
:- op(100,xfx,++).
:- op(100,xfx,--).
:- op(100,xfx,+-+).
:- op(100,xfx,+--).
:- op(100,xfx,--+).
:- op(100,xfx,---).



term_expansion(*X ++ Y,Out) :- xpands(if X then Y,Out).
term_expansion(*X -- Y,Out) :- xpands(if not X then Y,Out).
term_expansion(*[rx=RXs|FXs],L) :- !, getGos(RXs,FXs,L).

term_expansion(*[H|T],Out) :-
  knowns([H|T],Out).

getGos(RXs,FXs,L) :-
        findall(X,getGo(RXs,FXs,X),L).

  xxx :- (*[rx=RXs|FXs]) =  (*
[rx     = [     [],   [dex],  [coldSwim],  [dex,coldSwim]]
,nna    = [  0.122,  0.105,       0.210,       0.246]
,cortico= [129,     11.3,      1232.0,        32.8]
,acth   = [ 89,      0.0,       240.0,         0.0]
]),
	print(rx(RXs)),nl,
	print(fx(FXs)),nl,
	getGos(RXs,FXs,L),

	 forall(member(One,L),(nl,print(One),nl)).

getGo(RXs,FXs,io(NTH,Bars2,Bars1)) :- 
        allRX(RXs,AllRX),
        twoExperiments(RXs,One,Two),
        nth1(One,RXs,Exp1),
        nth1(Two,RXs,Exp2),
        getIns(AllRX,Exp1,Exp2,[],Is),
	kludge(Is,Bars2),
        getGoals(One,Two,FXs,Gs),
	kludge(Gs,Bars1),
        %union(Gs,Is,Facts),
        flag(ngo,NTH,NTH+1).

kludge(Gs,Bars) :-
	maplist(kludge1,Gs,Bars).

kludge1(X=1,X).
kludge1(X= -1, BarX) :-
	bar(X,BarX).

twoExperiments(L,X,Y) :-
        length(L,N),
        between(1,N,X), between(1,N,Y),
        Y > X.

getGoals(One,Two,Fxs,Goals) :-
        findall(Goal,getGoal(One,Two,Fxs,Goal),Goals).

getGoal(One,Two,Fxs,Thing=Delta) :-
        member(Thing=FX,Fxs),
        nth1(One,FX,Val1),  nth1(Two,FX,Val2),
        number(Val1),       number(Val2),
        c2n(Val2,Val1,Delta).

allRX(RXs,L) :- setof(Action,RXs^oneRX(RXs,Action),L).
oneRX(RXs,X) :- member(RX,RXs),member(X,RX).

getIns([],_,_,In,In).
getIns([Action|Actions],Exp1,Exp2,In0,In) :-
        exp_status(Action,Exp1,V1),
        exp_status(Action,Exp2,V2),
        c2n(V2,V1,Delta),
        (Delta=0
        -> In1=In0
        ;  In1=[Action=V2|In0]),
        getIns(Actions,Exp1,Exp2,In1,In).

exp_status(Action,Exp,1) :- member(Action,Exp), !.
exp_status(_,_,-1).

c2n(Val1,Val2,Delta) :-
        compare(Comp,Val1,Val2),
        c2n1(Comp,Delta).

c2n1(<,-1). c2n1(=,0). c2n1(>,1).
