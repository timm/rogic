eatTo(Y) :- repeat, get0(X), eaten(X,Y),!.

eaten(X,X).
eaten(10,_) :- print(user_error,unexpectedEndOFLine),halt.
