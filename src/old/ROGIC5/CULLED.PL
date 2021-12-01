:- dynamic eager/0.

keen :- lazy, assert(eager).
lazy :- retractall(eager).

:- keen.

run1([]) --> [].
run1(L,W0,W) :-
	rone(L,X=V,Rest),
	(q(X,V,W0,W1)
         -> run1(Rest,W1,W)
         ;  run1(Rest,W0,W)).

rone(L,Out,Rest) :-
	length(L,N),
	rone(L,N,Out,Rest,_).

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

report([],_,P,P).
report([X=V|Rest],W,P0,P) :-
	all(X,V0,V0,W,W),
	(V==V0 -> Inc=1 ; Inc=0),
	report(Rest,W,P0+Inc,P).
	
direct(       1, 1).
direct(      -1,-1).
creator(      1, 1).
destroyer(    1,-1).
invcreator(  -1, 1).
invdestroyer(-1,-1).
