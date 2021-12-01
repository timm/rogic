% misc utils

  myclause(A, B) :-
        \+ predicate_property(A,built_in),
        clause(A, B).

 swapItem([F|_], F,Old,New,
	          [Old |Rest],[New |Rest]).
 swapItem([_|Fs],F,Old,New,
	          [Skip|L0],[Skip|L]) :-
	swapItem(Fs,F,Old,New,L0,L).

 chars(File) :- 
    see(File), get_byte(X), ignore(chars1(X)), seen.
    
 chars1(-1) :- !.
 chars1(X)  :- put(X), get_byte(Y), chars1(Y).

 runtime(N,G,T) :-
	T1 is cputime,
	repeats(N,G),
	T2 is cputime,
	repeats(N,true),
	T3 is cputime,
	T is ((T2-T1) -(T3-T2)).

 repeats(N,G) :- between(1,N,_),once(G),fail.
 repeats(_,_).
 
 ensure(X) :- X,!.
 ensure(X) :- assert(X).

 demand(X,_) :- X,!.
 demand(_,Y) :- complain(Y),fail.

 solo(X)    :- F='$so_', flag(F,_,0), \+ solo1(F,X), flag(F,1,1).
 solo1(F,X) :- myclause(X,_), flag(F,N,N+1), N > 1, !.

 complain(X) :-
	source_location(Path, Line),
	file_base_name(Path,File),
	format('%E> ~w at line ~w: ~w\n',[File,Line,X]).
 
