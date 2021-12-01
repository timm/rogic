option(c,controlWorld,f,t,any,'hello stuff').

isAny(X,X).

isNum --> isGround, isNumber.
posInt(X,X) --> isNum, isInteger

isInt(X,X)    :- integer(X).
isAtom(X,X)   :- atomic(X).
isNumber(X,X) :- number(X).
isGround(X,X) :- ground(X).

default(controlWorld,f).

com(+X) :- option(X,Y,Plus,_),
	ignore(retract(control(X,_))),
	assert(control(X,Plus)).

com(-X) :- option(X,Y,_,Neg),
	ignore(retract(control(X,_))),
	assert(control(X,Neg)).

com(/X,Y) :- name(Y,[Char]).

com(/X,Y) :- name(Y,[Char|Chars]), maplist(com(/X),Char,_).
