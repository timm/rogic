
:- op(1,xfx,@).
:- [compile,utils, shell,switches].

% my abducibles are not goals with no bodies

% distinguish failed if false from fail
%A=assumptions
%C=covered
%G=goal
%I=in
%F=fact
%P=path -- path for and
% X,Y, general temps
% L list containing head and tail [H|T]
%WW : a time stamped assignment i.e. "Time@ X=Y"

:- dynamic fact/3,in/3, culled/3.

%:- index(fact(1,1,1)),index(in(1,1,1)),index(culled(1,1,1)).

in(x(A,B,C)) :- in(A,B,C).
fact(x(A,B,C)) :- fact(A,B,C).
culled(x(A,B,C)) :- culled(A,B,C).

ht0(Nth,Gs0,Is,Best,Covers) :-
	control(repeats1=R1),
	control(repeats2=R2),
	(R1 + R2 > 2
        -> ht0N(Nth,Gs0,Is,R1,R2,Best,Covers)
        ;  ht0One(Nth,Gs0,Is,Best,Covers)).

ht0N(Nth,Gs0,Is,R1,R2,Best,Covers) :-
	showX(nth=Nth),
	union(Gs0,Is,Fs),
	clean, setup(Is,Fs),
	maplist(isX,Gs0,Gs1),
	showX([inputs=Is,facts=Fs]),
	(setof(Out, Gs1^R1^R2^Is^Fs^
                     ht0Na(Gs1,R1,R2,Is,Fs,Out),
               All)
	-> once(last(P-A/C,All)),!,
	   Best=(P-A/C),
	   maplist(cc,All,Covers),
	   true
	   %format(' best,~w~n',[P])
%	   showX(best=list([cover=P,assumes=A,cover=C]))
        ;  print(oops),nl).

pp(P-_/_,_) :- print(p(P)),nl.

ht0Na(Gs0,R1,R2,Is,Fs,Out) :-
	length(Gs0,GsL),
        between(1,R1,Rx),
	%format('n1,~w~n',[Rx]),
	nll,
        showX(r1=Rx),
        orderGoals(Gs0,Gs),
        ht0Prim(R2,Gs,GsL,Is,Fs,0-[]/[],Out),
	%Out=(P-_A/_C),
	%format(' p,~w,',[P]),
	true.

ht0One(Nth,Gs0,Is,Out,P) :-
	ht0OneA(Nth,[],Gs0,Is,Out,P).

ht0OneA(Nth,A0,Gs0,Is,Out,[P]) :-
	nll,
	union(Gs0,Is,Fs),
	clean, setup(Is,Fs),
	maplist(isX,Gs0,Gs),
	showX([nth=Nth,r1=1,r2=1,goals=Gs, 
               inputs=Is,facts=Fs]),
	once(swa(Gs,swa(A0,[],[],[]),swa(A,C,D,_))),
	length(Gs,GsL),
	p(GsL,D,P),
	Out=(P-A/C),
	showResults(Out).


ht0Prim(0 ,  _,  _, _, _, PAC ,PAC).
ht0Prim(N0,Gs0,GsL,Is,Fs,PAC0,PAC) :-
        N0 > 0, %NN is 10-N0 +1,PAC0=(PP-_/_),
	%format(' n2,~w,p,~w,',[NN,PP]),
	showX([r2=N0,goals=Gs0]),
	once(swa(Gs0,swa([],[],[],[]),swa(A,C,D0,F0))),
	p(GsL,D0,P),
        (P=100
        ->   PAC= (100-A/C)
        ;    max_acp(PAC0,P-A/C,PAC1),
             showResults(PAC1),
	     orderGoals(D0,D), 
             orderGoals(F0,F),
	     append(F,D,Gs),
	     N is N0 - 1,
	     ht0Prim(N,Gs,GsL,Is,Fs,PAC1,PAC)).

max_acp(P0-_/_, P1-A1/C1, P1-A1/C1) :- P1 > P0,!.
max_acp(X,_,X).

p(N1,L,N) :- length(L,N2), N is round((N2*100)/N1).

showX([H|T]) :- !,forall((member(X=Y,[H|T]),control(show(X))),say([X,Y])).
showX(X=Y) :- !,forall(control(show(X)),say([X,Y])).

orderGoals(Gs0,Gs)   :- 
	(control(swapGoals)   
         -> rlswap(Gs0,Gs)
        ; Gs0=Gs),
	true. %print(og((Gs0 -> Gs))),nl.
orderSubGoals(Cs0,Cs):- 
	(control(swapSubGoals)
        -> rcswap(Cs0,Cs)
        ; Cs0=Cs),
        true. %print(osg((Cs0 -> Cs))),nl.
orderClauses(L0,L)   :- 
	(control(swapClauses) -> rlswap(L0,L)  ; L0=L),
	true. %print(oc((L0 -> L))),nl.

rlswap([],[]) :- !.
rlswap(In,Out) :- rlmembers(1,In,Out),!.
rlswap(In,_) :- 
	print(failed(rlswap(In))),nl, _ is 1/0, fail.

rcswap(In,Out) :- 
	c2l(In,Temp1), 
	rlmembers(1,Temp1,Temp2),
	l2c(Temp2,Out),!.
rcswap(In,_) :- print(failed(rlswap(In))),nl, _ is 1/0,fail.

c2l(X,_) :- var(X),!, print(varin(c2l(X))),nl, _ is 1/0,fail.
c2l((A,B),[A|Rest]) :- !, c2l(B,Rest).
c2l(A,[A]).

l2c(X,_) :- var(X),!, print(varin(l2c(X))),nl, _ is 1/0,fail.
l2c([A],A) :- !.
l2c([H|T],(H,Rest)) :- l2c(T,Rest).

/*rlswap(In,Out) :- rlM
	length(In,N),
	rlswap(N,In,Out).
rlswap(N,In,Out) :-
	N=0 
	-> In = Out
        ;  (rlswap0s(N,Size,In,All)
	   -> I is random(Size),
	      nth0(I,All,Out)
           ; print(failed(rlswap(N-In))),nl, fail).

rcswap(C0,C) :-
	csize(C0,N),
	rcswap(N,C0,C).
rcswap(N,C0,C) :-
	rcswap0s(N,Size,C0,All)
	-> I is random(Size),
	   nth0(I,All,C)
        ;  print(failed(rcswap(N))),nl.
*/

rlmembers(N0,L0,L) :- 
	length(L0,LSize),
	N is min(LSize^2,N0),
	between(1,N,_),
        bagof(One,rlmember(L0,One),L).

rlmember([H|T],Item) :- 
	length([H|T],L),
	Pos is random(L), 
	rlmember1(Pos,[H|T],Y,New), 
	(Item=Y;rlmember(New,Item)).

rlmember1(0,[H|T],H,T).
rlmember1(N0,[H|T],Out,[H|Rest]) :-
	N0 > 0,
	N is N0 - 1,
	rlmember1(N,T,Out,Rest).






showResults(X) :- forall(showR1(X),true).

showR1(_-A/_) :- control(showGuesses),say([guesses,A]).
showR1(_-_/C) :- control(showPaths),  member(x(X,_,Z)/B,C), say([X=Z,B]).
showR1(P-_/_) :- control(showCover),  say([cover,P]).

clean:- forall(member(Doomed,[in(_,_,_),fact(_,_,_),culled(_,_,_)]), 
        retractall(Doomed)).

setup(Is,Fs) :-
	forall(member(I0,Is),(isX(I0,x(X,T,V)),assert(in(X,T,V)))),
	forall(member(F0,Fs),(isX(F0,x(X,T,V)),assert(fact(X,T,V)))),
	forall((member(F0,Fs),opp(F0,F1)),
               (isX(F1,x(X,T,V)), assert(culled(X,T,V)))).

opp(X=1,X=0).
opp(X=1,X= -1).
opp(X=0,X=1).
opp(X=0,X= -1).
opp(X= -1,X=1).
opp(X= -1,X= 0).
opp(X=t,X=f).
opp(X=f,X=t).

isX(X=Y,x(X,0,Y)).

portray(x(X,0,Y)) :- control(show(succinct)), !,print(X=Y).
portray(0@ X = Z) :- control(show(succinct)), !,write(X = Z).
portray(X@ Y = Z) :-  control(show(succinct)),write(Y@X = Z).
portray(i(0@ X,Z,_)) :-  control(show(succinct)),!,write(X = Z).
portray(i(X@ Y,Z,_)) :-  control(show(succinct)),write(Y@X = Z).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
swa([],X,X).
swa([G|Gs]) --> swa1(G), swa(Gs).
swa([G|Gs]) --> failed(G),swa(Gs).

swa1(G,swa(A0,C,D,F),swa(A,[G/P|C],[G|D],F)) :-
	prove(G, prove(0,[],A0), prove(_,P,A)).

failed(G,swa(A,C0,D0,F0),swa(A,C,D,F)) :-
	xplicableIfIsolated(G), !,
	(\+ parentsReachable(G,A)
	  ->  C=[G/[viaIsolation]|C0],D=[G|D0],F=F0
          ;   C=C0,                   D=D0,    F=[G|F0]).
	
failed(G,swa(A,C,D,F),swa(A,C,D,[G|F])).

xplicableIfIsolated(x(_,_,0)).

parentsReachable(G,A) :-
	siblingParent(G,Sp),
	prove(Sp,prove(0,[],A),_).
    
siblingParent(x(X,T,V1),Out) :- 
	clause(x(X,T,V3),Out), 
	\+ V3=V1.
    
prove0(X) --> newProofItem(X), ok2Use(X). 

prove((X,Y))--> !, prove(X), prove(Y).
prove(X)    --> {in(X)}, prove0(X).
prove(X)    --> 
	prove0(X), 
	{aClause(X,Y)}, 
        incN, 
        prove(Y).

incN(prove(N0,P,A), prove(N,P,A)) :- N is N0 + 1.

ok2Use(X,P,P) :- culled(X),!,fail. 
ok2Use(X,P,P) :- fact(X),!. 
ok2Use(X,prove(N,P,A0),prove(N,P,A)) :- 
	whenWhat(X,WW), insert(A0,WW,N/eq,A).

newProofItem(X,prove(N,P0,A),prove(N,P,A)) :-
	whenWhat(X,WW),	insert(P0,WW,N/after,P).

getPath(P,prove(P,A),prove(P,A)).
putPath(P,prove(_,A),prove(P,A)).

aClause(X,Z) :- 
	findall(C, (clause(X,C0)
                   ,orderSubGoals(C0,C)
                   ), L0), 
	orderClauses(L0,L),
	member(Z,L).

% all terms must be convertable to the form
% When@ Who=What
whenWhat(x(Who,When,What),When@ Who=What) :- !.
whenWhat(X,                  0@ X=t).

insert([],New=That,L/_,[i(New,That,L)]).
insert([i(Old,This,L1)|T],New=That,L2/Com,Out) :-
	compare(C,New,Old),
        insert1(C,L2/Com, i(Old,This,L1),New=That,T,Out).

insert1(<,L/_,   Old,New=That,T, [i(New,That,L),Old|T]).
insert1(>,Com, Old,New,T, [Old|Rest] ) :- 
	insert(T,New,Com,Rest).
insert1(=,L/Com,  Old,New,T, [Old|T]) :- 
	insert2(Com,L,Old,New).

insert2(eq,   _, i(Old,This,_), Old=This).
insert2(after,L2,i(_,_,L1),_) :- L1 >= L2.









