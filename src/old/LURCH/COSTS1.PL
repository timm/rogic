costs(X) :- todos(All),length(All,X),!.
costs(0).

todo(X) :- memo(_,X,0), X \= (claim of _).

todos(All) :- bagof(X,todo(X),All),!.
