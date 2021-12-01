% if componets dont fail, remove them from the consideration.
% if components always fail, then that scenario fails wiith 1
% r1 should be 0 ... ni
% set up components before calling them

:- module(compon,
	 [ main/1
	 ]).

load_mp :- current_predicate(_, user:mp_term(_,_,_,_)), !.
load_mp :- use_module(library(mp)).

:- load_mp.


inits(Out) :-
	Repeats=1000,
	Alphas=[todoby,2,18,2],
	findall(B,clause(beta1(B,_),_),Bs),
	Betas=[one|Bs],
	All= 

	%% scenario info
	% k= # scenarions
	[
	%++(k,                  [todoby,10,100,1])
	 ++(k,                  [todoby,2,2,1])

	% alpha= # times we expect to run each scenario
	,++(alphaMean,          [todoby,10,100,1])
	,++(alphaAlpha,         Alphas)

	% nc=# components
	,++(ncMean,             [todoby,2,2,1])
	,++(ncAlpha,            Alphas)

	% cm= # components in a scenario
	,++(cmMean,             Betas)

	%% component info
	% runs= # times we have run each component
	,++(runsAlpha,          Alphas)	
	,++(runsMean,           [todoby,1,50,1])

	% fals= # times we have seen a component fail
	,++(failsAlpha,          Alphas)	
	,++(failsMean,           [todoby,1,10,1])

	%% system data
	% number of times we have run the system
	,++(nMean,              [todoby,1,50,1])
	,++(nAlpha,             Alphas)

	% r= failures seen when the system runs
	,++(r, 			[todoby, 0.001, 0.5, 0.001])

        ], 
	between(1,Repeats,_), 
	maplist(use,All,Out).	



main(X) :- X is mp_is fac(100).

/* gcd(X,Y,Z) is true if Z is the greatest common divisor of X and Y.      
gcd(X,X,X):-X > 0.
gcd(X,Y,G):-gt(X,Y),plus(Y,X1,X),gcd(X1,Y,G).
gcd(X,Y,G):-gt(Y,X),plus(X,Y1,Y),gcd(X,Y1,G).

x IS y + x1
x1 s x - y

Y is X + Y1
Y1 is Y - X */

gcd(X,X,X) :- X > 0,!.
gcd(X,Y,G) :- X > Y, !,X1 is X - Y, gcd(X1,Y,G).
%gcd(X,Y,G)  :- X > Y,!, X1 is X mod Y, gcd(X1,Y,G).
gcd(X,Y,G) :- Y > X , Y1 is Y - X, gcd(X,Y1,G).

/*
gcd(0) <=> true.
gcd(N) \ gcd(M) <=> N=<M | L is M-N, gcd(L).
%gcd(N) \ gcd(M) <=> N=<M | L is M mod N, gcd(L).  % faster variant


% Sample queries

gcd(2),gcd(3).

gcd(1.5),gcd(2.5).

gcd(37*11*11*7*3),gcd(11*7*5*3),gcd(37*11*5).
*/

prints(Scenarios) :-
	nl,
	forall(nth1(Nth,Scenarios,S),
	       (print(scenario(Nth)=S),
 		nl)).	
reset :-
	retractall(c1(_,_)),
	retractall(c2(_,_,_,_)),
	inits(All),                      % K scenarios
	%nl,nl,write('=========='),
	components(Coms,NC),
	assert(c1(Coms,NC)),
	scenarios(Coms,NC,Scenarios,AlphasSum),   % Alphas is K long.
	assert(c2(Coms,NC,Scenarios,AlphasSum)).


sigma(All,Scenarios,Temps,1 - (Temp/AlphasSum),S) :-
	inits(All),                      % K scenarios
	%nl,nl,write('=========='),
	components(Coms,NC),
	scenarios(Coms,NC,Scenarios,AlphasSum),   % Alphas is K long.
	retractall(c2(_,_,_,_)),
	assert(c2(Coms,NC,Scenarios,AlphasSum)),
	maplist(sigma1,Scenarios,Temps),
	maplist(arg(1),Temps,Nums),
	sum(Nums,Temp),
	S mp_is 1 - (Temp/AlphasSum).

s1(All,Scenarios,Temps,1 - (Temp/AlphasSum),S)  :-
	c2(Coms,_,Scenarios,AlphasSum),
	maplist(sigma1,Scenarios,Temps),
	maplist(arg(1),Temps,Nums),
	sum(Nums,Temp),
	S mp_is 1 - (Temp/AlphasSum).	
	

components(Coms,NC) :-
	%val(ncMean,ncAlpha,NC),
	NC=2,
	length(Coms,NC),
	maplist(component,_,Coms).

component(_,A/B) :-
	val(runsMean,runsAlpha,Runs),
	val(failsMean,failsAlpha,A),
	B is max(1,Runs - A).
	
scenarios(Coms,NC,Scenarios,Sum) :-	
	%?(k,K), 
	K=2,
	?(alphaMean,Mean), 
	?(alphaAlpha,Alpha),
	gammas(Coms,NC,K,Alpha,Mean,1,1000,Scenarios),
	maplist(arg(1),Scenarios,Alphas),
	sum(Alphas,Sum).

gammas(Coms,NC,N,Alpha,Mean,Min,Max,Gammas) :-
	bagof(One,
             Coms^NC^N^Mean^Alpha^Min^Max^
		gammas1(Coms,NC,N,Mean,Alpha,Min,Max,One),
           Gammas).

portray(s(A,N,R,C)) :-
	write('s('),
	write([alpha=A,n=N,r=R]),
	write(',components=['),
	forall(member(CA/CB,C),format(' [a=~w/b=~w]',[CA,CB])),
	write('])').

/*
gammas1(Coms,NC,N,Mean,Alpha,Min,Max,
	s(Alpha_i,N_i,R_i,Coms_i)) :- 	
	between(1,N,_), 
	Beta is Mean/Alpha,
	gamma(Alpha,Beta,0,Gamma),
	X is max(Min,round(Gamma)),
	Alpha_i is min(Max,X),
	val(nMean,nAlpha,N_i),
	?(r,R),
	R_i  is round(R * N_i),
	val(cmMean,CM),
	CM_i is max(1,round(CM*NC)),
	length(Coms_i,CM_i),
 	findall(Com,rin(Com,Coms),L),
	append(Coms_i,_,L).
*/

gammas1([Com1,Com2],NC,2,Mean,Alpha,Min,Max,
%gammas1(Coms,NC,1,Mean,Alpha,Min,Max,
	s(Alpha_i,N_i,R_i,Coms_i)) :- 
	Beta is Mean/Alpha,
	gamma(Alpha,Beta,0,Gamma),
	X is max(Min,round(Gamma)),
	Alpha_i is min(Max,X),
	val(nMean,nAlpha,N_i),
	?(r,R),
	R_i  is round(R * N_i),
%	val(cmMean,CM),
%	CM_i is max(1,round(CM*NC)),
	Coms_i=[Com1,Com2].
gammas1([Com1,_],NC,2,Mean,Alpha,Min,Max,
%gammas1(Coms,NC,2,Mean,Alpha,Min,Max,
	s(Alpha_i,N_i,R_i,Coms_i)) :- 	
	Beta is Mean/Alpha,
	gamma(Alpha,Beta,0,Gamma),
	X is max(Min,round(Gamma)),
	Alpha_i is min(Max,X),
	val(nMean,nAlpha,N_i),
	?(r,R),
	R_i  is round(R * N_i),
	Coms_i=[Com1].

% do i need to have the componetns computed seperately?
sigma1(s(Alpha_i,N_i,R_i,Coms_i),Out is Alpha_i*As/Bs) :-
	mapn(N_i - R_i, L, a(N_i,R_i,L,Coms_i,A),A,As),
	mapn(N_i - R_i, L, b(N_i,R_i,L,Coms_i,B),B,Bs),
	Out is_mp Alpha_i*As/Bs,
	t((print('!!!!!!OUT'(Out is Alpha_i*As/Bs)),nl)).

a(N_i, R_i, L,Coms,A) :-
	maplist(c(N_i,L),Coms,List),
	prod(List,Prod),
	A is_mp (( -1)^(N_i - R_i - L))*combo(N_i - R_i, L)*Prod,
	t((print(a(A is (( -1)^(N_i - R_i - L))*combo(N_i - R_i, L)*Prod)),nl)).

c(N_i,L,A_ij / B_ij,C) :-
	C is_mp beta(A_ij, N_i - L + B_ij + 1),
	t((print(		beta(C is beta(A_ij, N_i - L + B_ij + 1))),nl)),
	goodBeta(C).

b(N_i,R_i,L,Coms,B) :-
	maplist(d(N_i,L),Coms,List),
	prod(List,Prod),
	B is_mp (( -1)^(N_i - R_i - L))*combo(N_i - R_i, L)*Prod,
	t((print(B is (( -1)^(N_i - R_i - L))*combo(N_i - R_i, L)*Prod), nl)).

d(N_i,L, A_ij/ B_ij,D) :-
	D is_mp beta(A_ij ,N_i - L + B_ij),
	goodBeta(D).

goodBeta(D) :- (D <0 ; D > 1),!,print(badBeta(D)),nl,fail.
goodBeta(_).
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


beta1(0.1,X)  :- X is 1- beta1(0.9).
beta1(0.2,X)  :- X is 1- beta1(0.8).
beta1(0.25,X) :- X is 1- beta1(0.75).
beta1(0.33,X) :- X is 1- beta1(0.67).
beta1(0.4,X)  :- X is 1- beta1(0.6).
beta1(0.50,X) :- X is rand.
beta1(0.60,X) :- X is rand^0.67.
beta1(0.67,X) :- X is rand^0.5.
beta1(0.75,X) :- X is rand^0.33.
beta1(0.80,X) :- X is rand^0.25.
beta1(0.9,X)  :- X is rand^(1/9).

val(Mean,Out) :-
	?(Mean,In),
	beta1(In,Out).

val(Mean,Alpha,X) :-
	val(Mean,Alpha,1,10^6,X). 
val(Mean,Alpha,Min,Max,X) :-
	?(Mean,MeanV), 
	?(Alpha,AlphaV), 
	X is_mp round(min(Max,max(Min,gamma(AlphaV,MeanV/AlphaV)))).

mapn(N0,L,Pred,One,Out) :- 
	N is N0,
	bagof(One,N^L^(between(0,N,L),Pred),All),
	sum(All,Out),	t((print(mapn(All,Out)),nl)).

prodn(N0,Pred,One,Out) :- 
	N is_mp N0,
	bagof(One,N^I^(between(1,N,I),Pred),All),
	prod(All,Out).



sum([H],H) :- !.
sum([H|T],Out) :- sum(T,Temp), Out is_mp H + Temp.

prod([H],H) :- !.
prod([H|T],Out) :- prod(T,Temp), Out is_mp H * Temp.

use(++(One,[N]),One=N) :-
	flag(One,_,N).
use(++(One,[one|L]),One=X) :- rin(X,L), !,flag(One,_,X).
use(++(One,[todoby,Start,Stop,Step]),One=New) :-
	Delta is integer((Stop-Start)/Step),
	X is random(Delta+1),
	New is max(Start,min(Stop,Start + (X*Step))),
	flag(One,_,New).

?(X,Y)  :- flag(X,Y,Y).

rin(X,L) :- length(L,N), rmember1(L,N,X).

rmember1([H],_,H) :- !.
rmember1([H|T],N,X) :-
	Pos is random(N) + 1,
	oneLessN(Pos,[H|T],Y,L),
	(X=Y
	; N1 is N - 1,
	  rmember1(L,N1,X)).

oneLessN(1,[H|T],H,T) :- !.
oneLessN(N0,[H|T],X,[H|Rest]) :-
	N is N0 - 1,
	oneLessN(N,T,X,Rest).	




fun(X,X) :- arithmetic_function(X).
:- maplist(fun,
	[beta/2,beta1/1,gamma/2,rand,combo/2,fact/1]
        ,_).

:- dynamic fact0/2.

fact(N,X) :- fact0(N,X),!.
fact(N,1) :- N < 2, !.
fact(N,Out) :-
	N1 is N - 1,
	fact(N1,Temp),
	Out is Temp * N,
	assert(fact0(N,Out)).

combo(N,K,C) :- C is_mp fac(N)/(fac(K)*fac(N-K)).

rand(X) :- X is random(10000)/10000.


sterling(X,1) :-  0 is X,!.
sterling(X,F) :-
	F is sqrt(2*pi*X)* X^X*e^(-X)* (1 + 1/(12*X) + 1/(288*X^2) - 139/(51840*X^3) - 571/(2488320*X^4) + 
                  163879/(209018880*X^5) + 5246819/(75246796800*X^6) - 534703531/(902961561600*X^7)).

beta(A,B,Beta) :- 
/*	A>80, B > 80,!,
	Beta is (sqrt(2*pi)/sqrt(A+B-1))*((A-1)/(A+B-1))^(A-0.5)*((B-1)/(A+B-1))^(B-0.5).
beta(A,B,Beta) :-
	A =< 80, B> 80,!,
	Beta is ((fact(A-1)* e^A)/((A+B-1)^A))*((B-1)/(A+B-1))^(B-0.5).
beta(A,B,Beta) :-
	A > 80, B=< 80,!,
	Beta is ((fact(B-1)* e^B)/((A+B-1)^B))*((A-1)/(A+B-1))^(A-0.5).
beta(A,B,Beta) :- */
	Beta is_mp (fac(A-1)*fac(B-1))/fac(A+B-1).

/*(A,B,Beta) :-
	print(beta(A,B)),
	sterling(A-1,X),
	sterling(B-1,Y),
	sterling(A+B-1,Z),
	Beta is (X*Y)/Z,
	print(beta(Beta)). */

/*beta(A,B,Beta) :-
	print(beta(A,B)),
	fact(A-1,X),
	fact(B-1,Y),
	fact(A+B-1,Z),
	Beta is (X*Y)/Z,
	print(beta(Beta)). */


/*beta(A,B,Beta) :-
	X is gamma(A,1),
	Y is gamma(B,1),
	(0 is X+Y
	->  Beta is 0
	;   Beta is X / (X+Y)).
*/

gamma(Alpha,Beta,Gamma) :-
	Alpha > 20
	-> 	Mean is Alpha * Beta,
		Var is sqrt(Alpha*Beta*Beta),
		x(Mean,Var,0.0001,Gamma,_)
	;	gamma(Alpha,Beta,0,Gamma).

%gamma(Alpha,Beta,Gamma) :-
%	gamma(Alpha,Beta,0,Gamma).
	
gamma(0,_,X,X).
gamma(Alpha,Beta, In, Gamma) :-
	Alpha > 0,
	Temp is In + ( -1 * Beta * log(1-rand)),
	Alpha1 is Alpha - 1,
	gamma(Alpha1,Beta,Temp,Gamma).

	
x(M,S,Acc,X,R) :-
	y(M,M,S,Top),
	R is random(1000)/1000*Top,
	x(M-(4*S),M,R,Acc,M,S,Temp),
	(0 is random(2)
	-> X is Temp
	;  X is M + (M-Temp)).

x(MinX,MaxX,_,_,_,_,MinX) :-  
	Ratio is MinX/MaxX,
	abs(Ratio - 1) < 10^(-3), !.
x(MinX,MaxX,R,Acc,M,S,Out) :-
	y(MinX,M,S,MinY),
	(abs(R-MinY) < Acc
	-> Out is MinX
	;  x(MinX,MinY,MaxX,R,Acc,M,S,Out)).

x(MinX,MinY, MaxX,R,Acc,M,S,Out) :-
	Half is (MinX+MaxX)/2,
	(MinY < R
	-> x(Half, MaxX,R,Acc,M,S,Out)
	;  x(MinX,Half,R,Acc,M,S,Out)).


y(X,M,S,Y) :-
	Y is (1/(sqrt(2*pi)*S))*e^(-1*((X-M)^2)/(2*S*S)).


gammaTest :-
	N=10000,
	BSize=2.5,
	Width is N/100,
	nTest(gammaTest(N,BSize,One),Width,One).

gammaTest(N,BSize,X) :-
	between(1,N,_),
	X is round(gamma(20,1) / BSize) * BSize.

betaTest :-
	N=1000,
	BSize=0.1,
	Width is N/1000,
	nTest(betaTest(N,BSize,One),Width,One).

betaTest(N,BSize,X) :-
	between(1,N,_),
	X is round(beta(50,50) / BSize) * BSize.

nTest(Goal,Width,One) :-
	print(1),nl,
	findall(One,Goal,Temp),
	print(2),nl,
	hgram(Temp,Width).

hgram(L,Width) :-	
	msort(L,All),
		print(3),nl,
	bins(All,[],Bins),
	forall(member(A-B,Bins), 
		(B1 is round(B /Width),
		 forall(between(1,B1,_),
                        write('*')
                       ), 
                 write(' '),
                 write(A),
                 nl
              ) ).
bins([],X,X).
bins([H|T],[H-N0|Rest],Out) :- !,
	N is N0 + 1,
	bins(T,[H-N|Rest],Out).
bins([H|T],In,Out) :-
	bins(T,[H-1|In],Out).

:-dynamic silent/0.
t(X) :- silent,!.
t(X) :- X.

ssh :- silent,!.
ssh :- assert(silent).

loud :- retractall(silent).


