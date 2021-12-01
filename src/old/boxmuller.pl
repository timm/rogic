box_muller(M,S,N) :-
     w(W0,X),
     W is sqrt((-2.0 * log(W0))/W0),
     Y1 is X * W,
     N is M + Y1*S.

w(W,X) :-
     X1 is 2.0 * ranf - 1,
     X2 is 2.0 * ranf - 1,
     W0 is X1*X1 + X2*X2,
     (W0  >= 1.0 -> w(W,X) ; W0=W, X = X1).

 :- arithmetic_function(ranf/0).

ranf(X) :-     N =  65535, X is random(N)/(N-1).

test :- tell('c:/temp/dat'), test1, told.
test1 :- between(1,10000,_),box_muller(10,2,N),fail.
test1.
	
 
