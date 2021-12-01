goal_expansion(X rand Y,Out) :- r2c(X rand Y,Out).
goal_expansion(X ror Y, Out) :- r2c(X ror  Y,Out).

r2c(X0 ror Y0,   (X;Y)) :- !, r2c(X0,X), r2c(Y0,Y).
r2c(X0 rand Y0,  (X,Y)) :- !, r2c(X0,X), r2c(Y0,Y).
r2c(X,           X).
