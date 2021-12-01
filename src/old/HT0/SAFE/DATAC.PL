term_expansion(*[rx=RXs|FXs],L) :-
	findall(X,getGo(RXs,FXs,X),L).

getGo(RXs,FXs,
        (go(NTH,A,C) :- ht0(Gs,Is,Facts,A,C))) :-
	allRX(RXs,AllRX),
	twoExperiments(RXs,One,Two),	
	nth1(One,RXs,Exp1), 
	nth1(Two,RXs,Exp2),
	getIns(AllRX,Exp1,Exp2,[],Is),
	getGoals(One,Two,FXs,Gs),
	union(Gs,Is,Facts),
	flag(ngo,NTH,NTH+1).

twoExperiments(L,X,Y) :-
	length(L,N),
	between(1,N,X), between(1,N,Y),
	(asymmetricLinks -> \+ X=Y; Y > X). 

asymmetricLinks :- about(_,asym,_).

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
	(Delta=0 
        -> In1=In0
        ;  In1=[Action=V2,change(Action)=Delta|In0]),
	getIns(Actions,Exp1,Exp2,In1,In).

exp_status(Action,Exp,1) :- member(Action,Exp), !.
exp_status(_,_,-1).

c2n(Val1,Val2,Delta) :-
	compare(Comp,Val1,Val2),
	c2n1(Comp,Delta).

c2n1(<,-1). c2n1(=,0). c2n1(>,1).