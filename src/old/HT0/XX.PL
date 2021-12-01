:- module(shell, [fred/0, tom/1]).


fred :- fred(1).

fred(X) :- print(X),nl,jane.

jane :- print(jane),nl.

tom(X) :- tom(X,1).

tom(X,Y) :- print(tom(X,Y)),nl, jane.