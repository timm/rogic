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


/*
 * bar(X, BarX):
 *    bar(a, bar_a), or
 *    bar(bar_a, a)
 */
bar(X, BarX) :-
	atom(X), !,
	bar1(X, BarX).

bar(N, BarN) :-
	number(N), !,
	BarN is N * -1.

bar(X, BarX) :-
	X =.. [F|Args],
	bar1(F, BarF),
	BarX =.. [BarF|Args].

bar1(BarX, X) :- atom_concat(bar_, X, BarX), !.
bar1(X, BarX) :- atom_concat(bar_, X, BarX).


%
% barAnd(BarAnd) :
%	BarAnd is a bar_and node
%
barAnd(BarAnd) :-
	n(BarAnd, and),
	atom_prefix(BarAnd, bar_).

andNode(And) :-
	n(And, and).

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


%
% maxDelta(N) :
%	N = sum of lambda's
%
maxDelta(N) :-
	resetMaxDelta,
	runMaxDelta,
	reportMaxDelta(N).

resetMaxDelta :-
	flag(deltas, _, 0).

runMaxDelta :-
	forall(lambda(_, W), flag(deltas, Old, Old+W)).

reportMaxDelta(N) :-
	flag(deltas, N, N),
	flag(max_delta, _, N).


%
%
%
ok(X) :-
	defined(X), !.

ok(X) :-
	print(unknown(X)), nl, fail.

ok(X, or) :-
	defined(X), !.
ok(X, and) :-
	atom_concat(and, M, X),
	name(M, Y),
	name(N, Y),
	integer(N), !.
ok(X, and) :-
	atom_concat(bar_and, M, X),
	name(M, Y),
	name(N, Y),
	integer(N), !.
ok(X, _) :-
	print(unknown(X)), nl, fail.


setIndex(Term) :-
	functor(Term, F, A),
	length(L1, A),
	maplist(setIndex1, L1, L2),
	Term =.. [F|L2],
	index(Term).

setIndex1(_, 1).


%-------------------
print_terms(Term) :-
	forall(Term, format('~w.\n', [Term])),
	nl.


print_current_time :-
	get_time(Time),
	convert_time(Time, TimeString),
	print(TimeString), nl.
