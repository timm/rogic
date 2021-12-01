/*parse(Expect,L,Out) :-
	In =.. [Expect,L,[]],
	prove(In,Temp),
	Out =.. [Expect,Temp].

%dull(atomic(_)).
%dull(number(_)).
dull(_ = _).
dull(append(_,_,_)).
dull('C'(_,_,_)).

prove((X,Y),Y) :-
	dull(Boring),dull(Y),
	Boring,
	proved(Y0,Y).
prove((X0,Y0),(X,Y)) :- 
	proved(X0,X),
	proved(Y0,Y).
prove((_,_),_) :- !, fail.
prove(X0,In) :- clause(X0,true),!,arg(1,X0,[In|_]). 
prove(X0,X) :- clause(X0,Y),prove(Y,X).

proved(X0,X) :-
	functor(X0,F,_), 
	X1=..[F,X],
	prove(X0,X).
*/