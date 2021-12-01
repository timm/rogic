% always      100%
% usually      88%
% often        64%
% sometimes    50% 
% occasionally 36%
% seldom       12%
% never         0%

always       :- X is 1,          X > 0.5.
usually      :- X is beta(0.75), X > 0.5.
often        :- X is beta(0.6),  X > 0.5.
sometimes    :- X is beta(0.5),  X > 0.5.
occasionally :- X is beta(0.4),  X > 0.5.        
seldom       :- X is beta(0.25), X > 0.5.        
never        :- X is 0,          X > 0.5.

inRange1(X,            X)               :- number(X).
inRange1(+++X to Y,    range(X,Y,0.2 )) :- number(X), number(Y), X < Y.
inRange1(++X  to Y,    range(X,Y,0.25)) :- number(X), number(Y), X < Y.
inRange1(+X   to Y,    range(X,Y,0.33)) :- number(X), number(Y), X < Y.
inRange1(X    to +Y,   range(X,Y,0.67)) :- number(X), number(Y), X < Y.
inRange1(X    to ++Y,  range(X,Y,0.75)) :- number(X), number(Y), X < Y.
inRange1(X    to +++Y, range(X,Y,0.8 )) :- number(X), number(Y), X < Y.
inRange1(X    to Y,    range(X,Y,0.5 )) :- number(X), number(Y), X < Y.

inRange(X,Y) :- inRange1(X,Y),!.
inRange(X,_) :- yuck(badRange(X)).
range(X,X,_,X).
range(X,Y,Z,Out) :-
	Out is (beta(Z)*(Y-X)) + X.
	
prob(A,B) :- B is min(1,max(0,A)).
r(N)      :- N  is random(10000)/10000.
rand(R,N) :- N  is random(R).

% does nothing- left over from when i thought i
% could do random numbers in prolog
reset_seed. 

oneLessN(1,[H|T],H,T) :- !.
oneLessN(N0,[H|T],X,[H|Rest]) :- N is N0 - 1, oneLessN(N,T,X,Rest).	

rone(L,X) :- rone(L,X,_).

rone([H],H,[]) :- !.
rone([H|T],X,Out) :-
	length([H|T],N),
	Pos is rand(N) + 1,
	oneLessN(Pos,[H|T],One,Rest),
	(X=One, Out=Rest
	; Out=[One|Tail],
	  rone(Rest,X,Tail)).

% simple beta (fast!!! but only workds for
% mean - 0.9,0.8,0.75,0.67,0.6,0.5,0.4,0.33,0.25,0.2,0.1

beta(N,X) :- beta1(N,X),!.
beta(N,X) :- N1 is 1 - N, beta1(N1,Y),X is 1 - Y.

beta1(0.50,X) :- X is r.
beta1(0.60,X) :- X is r^0.67.
beta1(0.67,X) :- X is r^0.5.
beta1(0.75,X) :- X is r^0.33.
beta1(0.80,X) :- X is r^0.25.
beta1(0.9,X)  :- X is r^(1/9).
beta1(1,1).

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


