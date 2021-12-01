go1 :- 
(X is 558 ;
between(1,18,X0),
X is X0 * 1000
; X = 18803),
Y is (2*(10^(-11))*(X^3)) - 
      ((2*(10^(-9)))*(X^2)) + (0.0003*X) -0.04,
format('~w ~w~n',[X,Y]),
fail.

go :- 
(X is 558 ;
between(1,18,X0),
X is X0 * 1000
; X = 18803),
Y is (2*(10^(-6))*(X^1.7213)),
format('~w ~w~n',[X,Y]),
fail.
