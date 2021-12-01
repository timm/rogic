term_expansion((X the Y),Z) :- dd(X,Y,Z).
term_expansion((X a   Y),Z) :- eg(X,Y,Z).
term_expansion(A=B, []) :- assignOption(A=B).
