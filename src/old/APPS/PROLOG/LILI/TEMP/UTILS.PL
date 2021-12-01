:- op(1150,fx,say).

term_expansion(opp(X,Y),[
		opp(X,Y),opp(Y,X),
		]).

term_expansion((say X/2 ; Y),All) :-!,	
	bagof(One,X^Y^say2(X,Y,One),All).


term_expansion((say X ; Y),All) :-!,	
	bagof(One,X^Y^say1(X,Y,One),All).

say1(X,Y,Term) :- Term=..[X,Z], membero(Z,Y).
say2(X,Y,Term) :- Term=..[X,First,Second], membero((First,Second),Y).

membera(X,X) :- var(X),!.
membera(X,(X,_)).
membera(X,(_,Y)) :- membera(X,Y).
membera(X,X) :- \+ X = (_,_).

membero(X,X) :- var(X),!.
membero(X,(X;_)).
membero(X,(_;Y)) :- membero(X,Y).
membero(X,X) :- \+ X = (_;_).

ensure(X) :- X, !.
ensure(X) :- assert(X).

after(X,[X|T],T).
after(X,[_|T],Y) :- after(X,T,Y).
