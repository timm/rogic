swi(args,Args)             :- unix(argv(Args)).
swi(index,X)               :- index(X).
swi(format(A,B,C))         :- format(A,B,C).
swi(sformat(A,B,C))        :- sformat(A,B,C).
swi(string_to_atom(S,Out)) :- string_to_atom(S,Out).
swi(setarg(N,T,New))       :- setarg(N,T,New).
swi(flag(X,Y,Z))           :- flag(X,Y,Z).
swi(flag(X,Y))             :- flag(X,Y,Y).
