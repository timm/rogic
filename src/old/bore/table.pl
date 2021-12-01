              %    capability -----------------------\        
              %    life cycle cost -----------------\ \
              %    development cost ---------------\ \ \
              %    development time --------------\ \ \ \ 
              %    safety -----------------------\ \,\,\,\
table1(target_critical_mission_phases,           +,+,+,-,-).    %  1
table1(target_critical_commands,                 +,+,+,-,-).    %  2
table1(target_critical_events,                   +,+,+,-,-).    %  3
table1(onboard_checking,                         +,-,-,+,0).    %  4
table1(reduce_flight_complexity,                 +,+,+,?,-).    %  5
table1(test_fly_prototypes,                      +,+,+,?,?).    %  6
table1(enhance_safing,                           +,-,-,+,?).    %  7
table1(certification,                            +,?,?,?,?).    %  8
table1(increase_vv,                              +,-,-,+,?).    %  9
table1(reduce_onboard_autonomy,                  ?,+,+,-,-).    % 10
table1(reuse_across_missions,                    ?,+,+,?,?).    % 11
table1(increase_developer_capabilities,          +,+,+,?,?).    % 12
table1(increase_developer_tool_use,              +,+,+,?,?).    % 13
table1(implement_optional_functions_after_launch,?,+,?,?,?).    % 14
table1(reduce_vv_cost,                           0,0,+,+,0).    % 15
table1(increase_vv_speed,                        0,+,0,0,0).    % 16
table1(increase_vv_capabilities,                 +,+,+,0,+).    % 17

u(X)  :- any(u0(X)).
u0(X) :- lo(X).
u0(X) :- med(X).
u0(X) :- hi(X).

lo(X) :- any(lo0(X)).
lo0(1).  lo0(2).  lo0(3).

med(X) :- any(med0(X)).
med0(4).  med0(5).  med0(6).  med0(7).

hi(X) :- any(hi0(X)).
hi0(8).  hi0(9).  hi0(10).

any(X) :- any1(clause(X,Y)),Y.

any1(X) :- setof(R/X,(X,R is random(2**30)), L), 
	   member(_/X, L).
 
row0(table1,X,[A,B,C,D,E]) :- any(table1(X,A,B,C,D,E)).

row(T,X,L) :- row0(T,X,L0), maplist(value,L0,L).

utility(safety,         X) :- hi(X).
utility(dev(cost),      X) :- med(X).
utility(dev(time),      X) :- med(X).
utility(lifeCycle(cost),X) :- med(X).
utility(capability,     X) :- lo(X).

utilities(L) :-
 	maplist(utility,
	         [safety,dev(cost),dev(time)
                 ,lifeCycle(cost),capability
                 ],
	        L).

allOptions(T,L) :- setof(X,T^Y^row0(T,X,Y),L).

sim(Use,YN,Score) :-
    Table = table1,         % what table to look at
    allOptions(Table,All),
    Inits = [0,0,0,0,0 ], % initial values for all colums
    R is random(Use) + 1,
    length(Used,R),
    utilities(Utils), 
    down(Used,[],Table,Inits,Impacts),
    maplist(yn(Used),All,YN),
    maplist(times,Utils,Impacts,Scores),
    sum(Scores,Score).

yn(All,One,One=X) :- member(One,All) -> X=y ; X=n.

% low level stuff
repeats(N,G) :- forall(between(1,N,_), G).

one(N,L0,L) :- bagof(X,N^L0^one1(N,L0,X),L).
one1(N,L,X) :- member(X,L),R is random(10000)/10000, R < N.

times(Util,Impact,Util*Impact).

down([],_,_,Out,Out).
down([One|Rest],Used,Table, Old,Out) :-
  row(Table,One,Next),  % "One" is a row ..
  \+ member(One,Used),  % .. which is not used before
  adds(Old,Next,New),   % add this to "Old"
  down(Rest,            % and recurse
       [One|Used],Table,New,Out).

sum([H|T],A) :- sum(T,H,A).
sum([],A,A).
sum([H|T],A0,A) :- A1 is H + A0,  sum(T,A1,A).

adds([],[],[]).
adds([H0|T0],[H1|T1],[H0+H1|T2]) :- adds(T0,T1,T2).

generateFigureThree :-
   sim(Used,_),
   tell('figure2.data'),
   forall(between(1,1000,_),
         (sim(Used,Score)
         ,format('~p\n',Score)
         )),
   told.

value(++,N) :- normal( 2, 0.5, N). % "++" has a mean of  2
value( +,N) :- normal( 1, 0.5, N). %  "+" has a mean of  1
value( -,N) :- normal(-1,   0, N). %  "-" has a mean of -1
value( ?,N) :- normal( 0,   1, N). %  "?" has a mean of  0

normal(Mean,Sd,N) :- w(W0,X),
                     W is sqrt((-2.0 * log(W0))/W0),
                     Y1 is X * W,
                     N is Mean + Y1*Sd.

w(W,X) :- F1 is random(65536)/65536,
          F2 is random(65536)/65536,
          X1 is 2.0 * F1 - 1,
          X2 is 2.0 * F2 - 1,
          W0 is X1*X1 + X2*X2,
          (W0  >= 1.0 -> w(W,X) ; W0=W, X = X1).
