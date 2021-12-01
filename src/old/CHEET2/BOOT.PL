base(handle,  X,Y,def(X,A,B,C,D),def(Y,A,B,C,D)).
base(functor, X,Y,def(A,X,B,C,D),def(A,Y,B,C,D)).
base(arity,   X,Y,def(A,B,X,C,D),def(A,B,Y,C,D)).
base(fields,  X,Y,def(A,B,C,X,D),def(A,B,C,Y,D)).
base(blank,   X,Y,def(A,B,C,D,X),def(A,B,C,D,E)).
join(             def(A,B,C,D,E),X,Y) :- 
           base(X,def(A,B,C,D,E),Y).

goal_expansion(base(X=Y,A,B),base(X,Y,Y,A,B)).
goal_expansion(base(X is Y,A,B),base(X,Y,Y,A,B)).

goal_expansion(base(A,B,C),Out) :-
	nonvar(A),
	bagof(D,A^B^C^clause(base(A,B,C),D),[One]).

base(new(X)) -->

base(fresh,_,Fresh) :-  once(base(





