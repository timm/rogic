

% simple beta (fast!!!)
beta(N,X) :- beta1(N,X),!.
beta(N,X) :- N1 is 1 - N, beta1(N1,Y),X is 1 - Y.

beta1(0.50,X) :- X is r.
beta1(0.60,X) :- X is r^0.67.
beta1(0.67,X) :- X is r^0.5.
beta1(0.75,X) :- X is r^0.33.
beta1(0.80,X) :- X is r^0.25.
beta1(0.9,X)  :- X is r^(1/9).

% integer gamma
gamma(Mean,Alpha,Out) :-
	Beta is Mean/Alpha,
	gamma1(Alpha,Beta,Out).

gamma1(Alpha,Beta,Gamma) :-
	Alpha > 20
	-> 	Mean is Alpha * Beta,
		Var is sqrt(Alpha*Beta*Beta),
		normDist(Mean,Var,0.0001,Gamma,_)
	;	gamma(Alpha,Beta,0,Gamma).

gamma(0,_,X,X).
gamma(Alpha,Beta, In, Gamma) :-
	Alpha > 0,
	Temp is In + ( -1 * Beta * log(1-r)),
	Alpha1 is Alpha - 1,
	gamma(Alpha1,Beta,Temp,Gamma).

% general normal
normDist(M,S,Acc,X,R) :-
	norm(M,M,S,Top),
	R is random(1000)/1000*Top,
	normDist(M-(4*S),M,R,Acc,M,S,Temp),
	(0 is random(2)
	-> X is Temp
	;  X is M + (M-Temp)).

normDist(MinX,MaxX,_,_,_,_,MinX) :-  
	Ratio is MinX/MaxX,
	abs(Ratio - 1) < 10^(-3), !.
normDist(MinX,MaxX,R,Acc,M,S,Out) :-
	norm(MinX,M,S,MinY),
	(abs(R-MinY) < Acc
	-> Out is MinX
	;  normDist(MinX,MinY,MaxX,R,Acc,M,S,Out)).

normDist(MinX,MinY, MaxX,R,Acc,M,S,Out) :-
	Half is (MinX+MaxX)/2,
	(MinY < R
	-> normDist(Half, MaxX,R,Acc,M,S,Out)
	;  normDist(MinX,Half,R,Acc,M,S,Out)).

norm(X,M,S,Y) :-
	Y is (1/(sqrt(2*pi)*S))*e^(-1*((X-M)^2)/(2*S*S)).


