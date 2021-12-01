
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
handlE(X is Y)  --> handlE(X,_,Y).
handlE(X = Y)  --> handlE(X,Y,Y).

handlE(X >= Y)       --> handlE(X = Z), {Z >= Y}.
handlE(X > Y)        --> handlE(X = Z), {Z > Y}.
handlE(X < Y)        --> handlE(X = Z), {Z < Y}.
handlE(X =< Y)       --> handlE(X = Z), {Z =< Y}.
handlE(X in W .. Y)  --> handlE(X = Z), {Z >= W, Z < Y}.

handlE(blank(terM),X,X).
handlE(fetch,_,terM) :- terM.
handlE(match,terM,terM) :- terM.
handlE(me(X),X,X).

handlE([],X,X).
handlE([H|T],X,Z) :- handlE(H,X,Y), handlE(T,Y,Z).

