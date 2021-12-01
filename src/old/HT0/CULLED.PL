% bizzarre.. the proof for no connection is the same
% as the proof for standard steady
%stds(Out) :- couldBeSteadies(All),
%             steadyViaNoConnection(All,Out).
                       
couldBeSteadies(L) :- 
	setof(X,couldBeSteady(X),L).
couldBeSteady(X) :-
	clause(x(X,T,1), x(Y,T,_)),
	clause(x(X,T,-1),x(Z,T,_)),
	\+ Y = Z.

isSteady(

steadyViaNoConnection(All,(x(X,T,0) :- Proof)) :-
	member(X,All),
	siblingParent(x(X,T,0),Ps),
	demorgan(not Ps,Proof).

siblingParent(x(X,T,V1),Out) :- 
	clause(x(X,T,V3),Out),
	\+ V3=V1.

l2c([X],X) :- !.
l2c([X|T],(X,Z)) :- l2c(T,Z).

l2d([X],X) :- !.
l2d([X|T],(X;Z)) :- l2d(T,Z).

pc((X,Y)) :- !,pc(X),pc(Y).
pc(X) :- write(X),nl.

demorgan(not (X,Y),Z)    :- !,demorgan((not X;not Y),Z).
demorgan(not (X;Y),Z)    :- !,demorgan((not X,not Y),Z).
demorgan((X,Y),(X1,Y1))  :- !,demorgan(X,X1),demorgan(Y,Y1).
demorgan((X;Y),Z)        :- !,(A=X;A=Y),demorgan(A,Z).
demorgan(not (x(X,T, 1)),x(X,T,-1)) :- !.
demorgan(not (x(X,T,-1)),x(X,T, 1)) :- !.
demorgan(X,X).

if "%1" == "" goto 
goto gatherArgs

:again
if "%PL_ARGS%"=="" goto end
echo using %PL_ARGS%
goto run

:gatherArgs
set PL_ARGS=
:loop
if "%1"=="" goto endloop
set PL_ARGS=%PL_ARGS% %1
shift
goto loop
:endloop

:run
%PL_% -- %PL_ARGS%

:end

swaps(P,Swaps,Out):- swaps(P,true,Swaps,Out).

swaps(P,Code,Swaps,Out) :-
	clause(cliche(P,Head),Body),
	(Body=true -> In=Head; In=(Head :- Body)),
	Code,
	swap(In,Swaps,Out).

swap(X,Swaps,Y)   :- X =.. L0, 
	maplist(swap1(Swaps),L0,L1), Y =.. L1.

swap1(_,H,H)      :- var(H),!.
swap1(Swaps,H0,H) :- member(H0/H,Swaps),!.
swap1(_,H,H)      :- atomic(H),!.
swap1(Swaps,H0,H) :- swap(H0,Swaps,H).

cliche(infer,after(s1)) :- 
	before(s2).
cliche(true,  x(1)).
cliche(false, x(0)).


rank(Gs0) --> 
	append(Gs0),
	msort, 
	bins, 
	msort, 
	maplist(newGoal1).


covered(X/_,X).
newGoal1(_-X,X).


ht0Control([],_).
ht0Control([ACP|Rest],Stuff0) :-
	setof(X,In^ht0Control1(Stuff0,X),L),
        dones(L,Dones),
	rank(Dones,Gs0,Gs),
	ht0Control(Rest,R2,Gs,Is,Fs).

newGoal(Gs, ht0(R,_,Is,Fs), ht(R,Gs,Is,Fs)).

best_acp([N-X|_],N,X).


dones(PAC,Dones) :- 
	findall(D,done1(PAC,D),Dones).

done1(PAC,D) :-
         member(_-pac(_,_,_,Ds),PAC),
	 member(D,Ds).
