/*
 * QUEUE :
 * provides efficient QUEUE operation
 */


qpush(X-Y, Z, X-Y) :- var(Z), !.
qpush(X,V-V,[X|V]-V) :- var(V),!.
qpush(X,L-[X|T],L-T).

qpop([X|T]-T1, X, T-T1) :- nonvar(X).   % print(removed(X)).


%emptyQueue([_V]-[_V]).

q1([X|T]-T) :- nonvar(X),var(T).

qshow(X,Y) :- copy_term(X,Y-[]).

complete(L-[],L).

q(X) :- var(X),!,fail.
q([_|T]-T) :- var(T).


/* 
 * PRINTL :
 * print items in a list
 */

printl([]) :- nl.
printl([H|T]) :-
	print(H), nl,
	printl(T).

timeit(Goal, N) :-
	T1 is cputime,
	forall(between(1,N,_), Goal),
	T2 is cputime,
	DT is T2 - T1,
	format('time taken to run ~w ~w times = ~w\n', [Goal, N, DT]).


/*
 * bar(X, BarX):
 *    bar(a, bar_a), or
 *    bar(bar_a, a)
 */
bar(BarX, X) :- atom_concat(bar_, X, BarX), !.
bar(X, BarX) :- atom_concat(bar_, X, BarX).

barAndNode(BarX) :-
	n(BarX, and),
	atom_concat(bar_, _, BarX).

countN(X, N) :-
	resetCountN,
	runCountN(X),
	reportCountN(N).

resetCountN :-
	flag(counter,_,0).

runCountN(X) :-
	forall(X, flag(counter, Old, Old+1)).
	
reportCountN(N) :- 
	flag(counter,N,N).

maxDelta(N) :-
	resetMaxDelta,
	runMaxDelta,
	reportMaxDelta(N).

resetMaxDelta :-
	flag(deltas,_,0).

runMaxDelta :-
	forall(lambda(_,W),flag(deltas,Old,Old+W)).

reportMaxDelta(N) :-
	flag(deltas,N,N).
