/*
 * QUEUE :
 * provides efficient QUEUE operation
 */


qpush(X-Y, Z, X-Y) :- var(Z), !.
qpush(X,V-V,[X|V]-V) :- var(V),!.
qpush(X,L-[X|T],L-T).

qpop([X|T]-T1, X, T-T1) :- nonvar(X).   % print(removed(X)).

q1([X|T]-T) :- nonvar(X),var(T).

qempty(Q) :- complete(Q, L), L = [].

qshow(X,Y) :- copy_term(X,Y-[]).

complete(L-[],L).

q(X) :- var(X), !, fail.
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


%
% countN(X, N) :
%	N = number of X
%
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


%-------------------
print_terms(Term) :-
	forall(Term, format('~w.\n', [Term])),
	nl.


print_current_time :-
	get_time(Time),
	convert_time(Time, TimeString),
	print(TimeString), nl.


setIndex(Term) :-
	functor(Term, F, A),
	length(L1, A),
	maplist(setIndex1, L1, L2),
	Term =.. [F|L2],
	index(Term).

setIndex1(_, 1).


% ********
oneLess(H, [H|T], T).
oneLess(X, [H|T], [H|T2]) :- oneLess(X, T, T2).