% utils- stuff that should work in every application

oneLess([H|T],H,T).
oneLess([H|T],One,[H|Less])  :- oneLess(T,One,Less).

oStatus :-
        optimizing,!,
        format('WARNING: optimization is ENABLED.\n(code will be quirker and harder to debug)\n',[]).
oStatus :-
        format('Optimization is DISABLED.\n',[]).

normDist(Mean,StdDev,X) :-
	Acc is Mean/10000,
	normDist(Mean,StdDev,Acc,X,_).

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

