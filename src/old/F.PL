f(X,M,S,F) :-
	F is 1/(sqrt(2*pi)*S)*e^(-1*((X-M)^2)/(2*S*S)).

ff(X,Y0,Z) :-
	F = 250,
	between(-500,0,W),
	X is W/100,
	f(X,0,1,Y0),
	Y is round(Y0*F)/F,
	Z is round(Y*F/2).

go :-
	tell('ff.csv'),go1,told.

go1 :- forall(ff(X,Y,Z), format('~p,~p,~p\n',[X,Y,Z])).
