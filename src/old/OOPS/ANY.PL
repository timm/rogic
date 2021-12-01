
:- fact(any, isa(none)).

any_(value(Value),X,X) :- prim(X,Value),!.
any_(value(X),X,X).

none_(M,X,_) :- 
	functor(X,F,_), 
	print(sterr,doesNotUnderstand(F,M)),
	fail.