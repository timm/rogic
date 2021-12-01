% some general utilities

% a trick to simplify pretty prints
:- format_predicate('>',padChars(_,_)).

padChars(default,A) :- padChars(5,A).
padChars(S,A) :-
    atom_length(A,N),
    Pad is S - N,
    forall(between(1,Pad,_),put(32)),
    write(A).

memo(0) :- !.
memo(X) :- 0 is X mod 50000,!, spit([' ',X]),nl.
memo(X) :- 0 is X mod 10000,!, spit([' ',X,' ']).
memo(X) :- 0 is X mod 1000, !, spit('.').
memo(_).

spit([H|T]) :- !,forall(member(One,[H|T]),write(One)),flush_output(user). 
spit(X) :- write(X),flush_output(user).
