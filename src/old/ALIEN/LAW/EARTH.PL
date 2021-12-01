:- [ops,basic].

output(*).



term_expansion(* X or Y,Out) :-
	xs(* X or Y,Out).

xs(* X, All) :-
	bagof(One,X^x(X,One),All).

x(In or false,*N  if true then In1) :-  !,
	x1(In,In1),
	flag(n,N,N+1).
                   
x(In,*N if not This then That) :-	
	memberO(This0,That0,In),
	x1(This0,This),
	x1(That0,That),
	flag(n,N,N+1).
	
memberO(One,Rest, X or Y or Z) :- !,
	(One=X, 
         Rest=(Y or Z)
        ;Rest=(X or Rest1),
         memberO(One,Rest1, Y or Z)
        ).
memberO(X,Y,X or Y).
memberO(Y,X,X or Y).

x1(X0 and Y0, X and Y) :- !, x1(X0,X), x1(Y0,Y).
x1(X0 or  Y0, X or  Y) :- !, x1(X0,X), x1(Y0,Y).
x1(not X0,    not X  ) :- !, x1(X0,X).
x1(X0,        X      ) :-
              xists(X0), 
	      solvable(X0,X),
	      ensure(*boolean are [X]).
	
xists(X) :- 
	functor(X,F,A), 
	functor(Blank,F,A), 
	(clause(Blank,__) 
        ; print(missingPredicate(F/A)),nl,fail),!.
solvable(X0,X) :-
	some(X0,X0,All),
	maplist(isGround,All,_),
	member(X,All).

isGround(X,X) :- ground(X),!.
isGround(X,_) :- print(empty(X)),nl,fail.

some(X,Y,Z) :- bagof(X,Y,Z),!.
some(_,Y,_) :- print(notPossible(Y)),nl,fail.







