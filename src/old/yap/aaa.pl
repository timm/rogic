
:- op(700,xfy,and).

goal_expansion(X and Y and Z1,Out) :- !, 
    goal_expansion(X and Y,Z0), 
    goal_expansion(Z0 and Z1,Out).


goal_expansion(X and Y,(X,Y)).

x(1) :- bb and cc.

bb.
cc.
