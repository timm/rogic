o1(X) :- option(maxNumber,N), X is random(N)/N.

rand(Min,Max,X) :- X is Min + (Max-Min)*o1.

/*rs([W/H|T],Sum,H) :-
	rand(0,1) > H/Sum,!,
	
rs(In,Out) :-
	length(In,L),
	rs(In,L,_,Out).

rs([H],_,1,[H]).
rs([H|Rest],L,N,Out) :-
    rs(Rest,L,N0,Temp),
    once(r0(N0,L,H,Temp,Out)),
    N is N0 + 1.
*/

r0(N,L,X,[H|T],[X,H|T]) :- rand(0,1) < N/L.
r0(_,_,X,[H|T],[H,X|T]) .

rone(All,One,Rest) :- length(All,N), rone(All,N,One,Rest,_).

rone([H],_,H,[],0) :- !.
rone([H|T],N0,X,Out,N) :-
	N is N0 - 1,
	Pos is random(N0) + 1,
	oneLessN(Pos,[H|T],One,Rest),
	(X=One, Out=Rest
	; Out=[One|Tail],
	  N1 is N0 - 1,
	  rone(Rest,N1,X,Tail,_)).

oneLessN(1,[H|T],H,T) :- !.
oneLessN(N0,[H|T],X,[H|Rest]) :-
	N is N0 - 1,
	oneLessN(N,T,X,Rest).	

rones([],L,L).
rones([H|T],L,Others) :- rone(L,H,Rest), rones(T,Rest,Others).
