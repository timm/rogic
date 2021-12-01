% reach out and touch someone

%touch/1: just do it

 touch(X) :- touch(X,_,_).

% touch/2: do it and give me the result

 touch(X,Z) :- touch(X,_,Z).

% touch/3: given input, do it, give me the result

 touch(W=X,     Z0,Z) :- touch(W/X/X,        Z0, Z).
 touch(W:=X,    Z0,Z) :- touch(W/_/X,        Z0, Z).
 touch(W+X,    Z0,Z)  :- touch(W/Old/New,    Z0, Z),
	                 New is Old + X.
 touch(W<<X,    Z0,Z) :- touch(W/Old/[X|Old],Z0, Z).
 touch(W with X,Z0,Z) :- touch(W,            Z0,Z1),
	                 touch(X,            Z1, Z).
 touch(W/X/Y,   Z0,Z) :- touch(W,X,Y,Z0,Z).

