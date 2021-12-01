
do(X,Y) :- atomic(X) -> X=Y; do1(X,Y).

do1(X + Y, X+Y).
do1(X = Y + Z,X-Y=Z).
do1(X = Y - Z,X+Y=Z).
do1(X0=Y0/Z0,Z*X=Y)     :- do(X0,X), do(Y0,Y), do(Z0,Z).
do1(X0=Y0/Z0,1=Y/(X*Z)) :- do(X0,X), do(Y0,Y), do(Z0,Z).

demo(N,Out) :- forall(demo1(N,Out),(print(Out),nl)).

demo1(1,Z) :- do(a=b/c,Z).

subterm(X,X).
subterm(In, X) :- compound(In), arg(_,In,Arg),
                  subterm(Arg,X).

words(X,X=Words)  :- bagof(Word,X^word(X,Word),Words).
word(X,W)   :- subterm(X,W), atomic(W), W\=[].

eg(1,[a=2,b=3,c=a+b,d=c*2]).

go(N,Words0,Words1,Solved,Words) :-
	eg(N,All),
	maplist(words,All,Words0),
	maplist(constants,Words0,Words1),
	solve(Words1,Solved,Words).

solve([],[],[]).
solve([Eq=[X]|T],[X|Solved],Rest) :- !,solve(T,Solved,Rest).
solve([H|T],Solved,[H|Rest])    :- solve(T,Solved,Rest).

go1(Done,Words0,Words1) :-
	maplist(constants,Words0,Words1),
	eliminate(Done,Words0,Words1).

constants(Eq=L0,Eq=L) :- constants1(L0,L).

constants1([],[]).
constants1([H|T0],T) :- number(H), !,constants1(T0,T).
constants1([H|T0],[H|T]) :- constants1(T0,T).


	
	


	

