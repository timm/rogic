
o(X) :- o(X,_,_).

o X is Y  --> o(X,_,Y).
o X = Y  --> o(X,Y,Y).

o X >= Y       --> o X = Z, {Z >= Y}.
o X > Y        --> o X = Z, {Z > Y}.
o X < Y        --> o X = Z, {Z < Y}.
o X =< Y       --> o X = Z, {Z =< Y}.
o X in W .. Y  --> o X = Z, {Z >= W, Z < Y}.

o(zap,X,X) :- 
	o(olD = Old,X,X),
	nonvar(Old) 
        -> retract(Old) 
        ;  true.
o fetch  --> o fetchPrim(Blank), o olD is Blank .

o(change,X,Z) :-
	o(zap,X,Y),
	o(meta(Y,New),Y,Z),
	assert(New).
