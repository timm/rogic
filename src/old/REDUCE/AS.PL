asString(X,X) :- var(X),!.
asString(X,Y) :- string_to_atom(X,Y).

posnum(X,X) :- number(X), X >= 0.