/* :- op(700,xfy,and).

agoal_expansion(X and Y and Z1,Out) :- !, 
    goal_expansion(X and Y,Z0), 
    goal_expansion(Z0 and Z1,Out).


x :- y and z.

*/

ll(1).
ll(2).
