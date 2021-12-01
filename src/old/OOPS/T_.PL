
:- fact(t, isa(false)).

t_(value(Value),X,X) :- prim(X,Value),!.
t_(value(X),X,X).
