
a('target_critical_mission_phases'           ,p,m,m,p,m).
a('target_critical_commands'                 ,p,m,m,p,m).
a('target_critical_events'                   ,p,m,m,p,m).
a('onboard_checking'                         ,p,p,p,m,_).
a('reduce_flight_complexity'                 ,p,m,m,_,m).
a('test_fly_prototypes'                      ,p,m,m,_,_).
a('enhance_safing'                           ,p,p,p,m,_).
a('certification'                            ,p,_,_,_,_).
a('increase_vv'                              ,p,p,p,m,_).
a('reduce_onboard_autonomy'                  ,_,m,m,p,m).
a('reuse_across_missions'                    ,_,m,m,_,_).
a('increase_developer_capabilities'          ,p,m,m,_,_).
a('increase_developer_tool_use'              ,p,m,m,_,_).
a('implement_optional_functions_after_launch',_,m,_,_,_).
a('reduce_vv_cost'                           ,_,_,m,_,_).
a('increase_vv_speed'                        ,_,m,_,_,_).
a('increase_vv_capabilities'                 ,p,m,m,_,p).


as(L) :- findall(A,a(A,_,_,_,_,_),L).

%%% support stuff

any(X) :- setof(R/X,(X,R is random(2**30)),L),
          member(_/X,L).

%%% main

plans(F,X) :- tell(F), ignore(plan(X)),told.
plan(N) :- 
%	print('target_critical_mission_phases , target_critical_commands ,target_critical_events , onboard_checking , reduce_flight_complexity ,test_fly_prototypes , enhance_safing , certification , increase_vv ,reduce_onboard_autonomy , reuse_across_missions ,increase_developer_capabilities , increase_developer_tool_use ,implement_optional_functions_after_launch, reduce_vv_cost ,increase_vv_speed , increase_vv_capabilities,score,safetyU,devTimeU,devCostU,lifeCostU,capabilityU,score'),nl,
	forall(between(1,N,M),
               (say(M),once(plan1(Settings,L0)),
	        append(Settings,L0,L),
                printL(L))).

say(M) :- 0 is M mod 500 -> print(user,'.'),flush_output(user); true.

printL([H|T]) :- print(H), print(','), checklist(printL1,T),nl.
printL1(X) :- print(','), print(X).

plan1(Settings,R) :- 
	as(All0), 
	rsort(All0,All),
	%L is random(15)+1,
	L=3,length(Some,L),
	append(Some,_,All0),
	settings(All,Some,Settings),
	result(Some,R0),
	score(R0,R).

rsort(L0,L) :- findall(X,any(member(X,L0)),L).

settings([],_,[]).
settings([One|Rest],Used,[H|T]) :-
	(member(One,Used) -> H=y | H=n),
	settings(Rest,Used,T).

result([H|T],Out) :- 
	a(H,A,B,C,D,E),
	result(T,a(H,A,B,C,D,E),Out).

result([],X,X).
result([H|T],Temp,Out) :- 
	a(H,A,B,C,D,E),
	result1(a(_,A,B,C,D,E),Temp,Next),
	result(T,Next,Out).
	
result1(T0,T1,T) :-
	T0 =.. [a,_|L0],
	T1 =.. [a,_|L1],
	result2(L0,L1,L),
	T =.. [a,result|L].

result2([],[],[]).
result2([H1|T1],[H2|T2],[H|T]) :-	
	any(sum(H1,H2,H)),
	result2(T1,T2,T).

sum(p,p, p).
sum(p,m, m).
sum(p,m, p).
sum(m,m, m).
sum(m,p, p).
sum(m,p, m).

:- arithmetic_function(p/0).
:- arithmetic_function(m/0).

p(  1).
m( -1).

score(a(_, Safety, DevTime, DevCost, LifeCost, Capability),
        [S]) :-
	baseline(B),
	xpand(safety,U1),
	xpand(devTime,U2),
	xpand(devCost,U3),
	xpand(lifeCost,U4),
	xpand(cap,U5),
	S is U1*B*Safety + U2*B*DevTime  + U3*B*DevCost 
                         + U4*B*LifeCost + U5*B*Capability.
             
xpand(safety,  N) :- any(nbig(N)).
xpand(devTime, N) :- any(nlittle(N)).
xpand(devCost, N) :- any(nlittle(N)).
xpand(lifeCost,N) :- any(nsome(N)).
xpand(cap,     N) :- any(nlittle(N)).

nbig(10). nbig(9). nbig(8). nbig(7). nbig(6). nbig(5).

n10(10). n10(9). n10(8). n10(7). n10(6). n10(5). n10(4). n10(3). n10(2). n10(1).

nsome(5). nsome(4). nsome(3). nsome(2).

nlittle(3). nlittle(2). nlittle(1).

baseline(1000).

