yuck(X) :- format('% E> ~w\n',[X]), fail.
die(X) :- format('% E> ~w\n',[X]), halt.

%%%%%%%%%%%%%%%%%
swap(List,Skeleton,Out) :-
	clause(Skeleton,Body),
	runiv((Skeleton :- Body),List,Out).

runiv(Term0, Swaps,Term) :-
        Term0 =..L0,
        once(maplist(runiv1(Swaps), L0, L)),
	Term =.. L.

runiv1(_,H,H)  :- var(H).
runiv1(Swaps,Old,New)  :- atomic(Old), member(Old/New,Swaps),!.
runiv1(_,H,H) :- atomic(H).
runiv1(Swaps,H0,H) :- runiv(H0,Swaps,H).

%%%%%%%%%%%%%%%
say(X) :- write(X),nl.
%%%%%%%%%%%%%%%


:- format_predicate('>',padChars(_,_)).
:- format_predicate('<',charsPad(_,_)).
:- format_predicate('.',pdots(_,_)).
:- format_predicate('S',twiddle(_,_)).


padChars(default,A) :- padChars(5,A).
padChars(S,A) :-
        writeThing(A,Thing,N),
        Pad is S - N,
        forall(between(1,Pad,_),put(32)),
        write(Thing).

charsPad(default,A) :- charsPad(5,A).
charsPad(S,A) :-
        writeThing(A,Thing,N),
        atom_length(A,N),
        Pad is S - N,
        write(Thing),
        forall(between(1,Pad,_),put(32)).

writeThing(X,S,L) :- sformat(S,'~w',[X]), string_length(S,L).

twiddle(default,A) :- twiddle(25,A).
twiddle(W,N) :-
        N1 is round(N/W),
        forall(between(1,N1,_),put(126)).
