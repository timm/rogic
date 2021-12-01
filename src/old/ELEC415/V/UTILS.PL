:- format_predicate('P',padChars(_,_)).

padChars(default,A) :- padChars(5,A).
padChars(S,A) :-
    atom_length(A,N),
    Pad is S - N,
    forall(between(1,Pad,_),put(32)),
    write(A).
