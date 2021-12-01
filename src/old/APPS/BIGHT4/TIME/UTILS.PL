% utils.pl

% Defines a number of utility function which may be used throughout the 
% compilation and abduction of time series data sets.

%-----------------------------------------------------------------------------
% Code for reading and writing lists.
%-----------------------------------------------------------------------------
% Read the lines of a file into a list, including line numbers.
file2List(File, List) :-
	see(File),
	current_stream(File, _, Stream),
	read(Item),
	file2List1(Item, 1, Stream, [], List0),
	seen,
	reverse(List0, List).

file2List1(end_of_file, _, _, List, List) :- !.
file2List1(X, Line0, Stream, In, Out) :- 
	Line is Line0 + 1,
	(read(Item0)
	->	Item = Item0
	|       Item = failedRead),
	file2List1(Item, Line, Stream, [Line0-X|In], Out).


% Read in file F and store the lines in the list L, without line numbers.
reads(F,L) :-
	see(F),
	read(X),
	reads1(X,L),
	seen.

reads1(end_of_file,[]) :-!.
reads1(X,[X|Rest]) :-
	read(Y),
	reads1(Y,Rest).


% Write list L and store the lines in the file F using dialect D
writes(D, L, F) :-
	tell(F),
        write('% '), write(D), nl,
	writes1(L, names),
	writes1(L, theory),
	writes1(L, theoryDetail),
	told.

% write out WMEs by categories.
writes1(Terms, Category) :-
	nl, nl, write('%---------------------------------------'), nl,
        write('% ['),
        print(Category), write('] related facts'), nl,
	wme(Category, Term),
	functor(Term, This, Arity), 
	nl, write('% '),
        print(This/Arity), nl,
	bagof(Term, Terms^This^(member(Term,Terms), functor(Term,This,_)),
		Wmes),
	writes1(Wmes),
	fail.
writes1(_,_).

% write out list of WMEs.
writes1([]) :- !.
writes1([L|Rest]) :-
	print(L), write('.'), nl,
	writes1(Rest).


%-----------------------------------------------------------------------------
% List generation and manipulation
%-----------------------------------------------------------------------------
% Converts any value into a list containing those items, with the additional
% effect of converting tuples into single elements within the list.
c2l(X, [X]) :- var(X), !.
c2l((X,Y), [X|Rest]) :- !, c2l(Y,Rest).
c2l(X, [X]).


% Writes out each element of a list followed by a new line.
write_list([]) :- nl.
write_list([H|T]) :- write(H), write_list(T).


% Flattens a list and sorts it.
members --> flatten, sort.


% Returns true if the given item is a list, false otherwise.  What's the
% difference between this and listp?
list(X) :- var(X), !, fail.
list([]).
list([_|_]).


% Given a list and a list of items to remove, return the first list with the
% required items deleted.
deletes(L, [], L).
deletes(L0, [H|T], L) :- delete(L0, H, L1), deletes(L1, T, L).


% Returns two items which were adjacent in a list.
neighbours([X,Y|_],X,Y).
neighbours([_,Y|Z],A,B) :- neighbours([Y|Z],A,B).


% Given one list returns the list with duplicate items removed (removing the
% first encountered item until no duplicates remain).
unique([],[]).
unique([H|T],[H|Rest]) :-
	\+ member(H,T),!,
	unique(T,Rest).
unique([_|T],Rest) :-
	unique(T,Rest).


% Assuming list elements are lists, append all elements into one list.
appends([H|T],Out) :- appends(T,H,Out).
appends([],Out,Out).
appends([L|Ls],In,Out) :-
	append(In,L,Temp),
	appends(Ls,Temp,Out).


% Apply nth1 using a list of indices.
nth1List([], _, []).
nth1List([P|Positions], List, [Val|Values]) :-
	nth1(P, List, Val),
	nth1List(Positions, List, Values).


% Randomly select a number of values from a list
randomSelect(List, Number, Values) :-
	length(List, L),
	urandoms(Number, L, Positions),
	nth1List(Positions, List, Values).


% Randomly select a rounded percentage of values from a list
percRandomSelect(List, Perc, Values) :-
	length(List, N),
	%Keep is round(Perc * N / 100.0),
	Keep is integer(Perc * N / 100.0), %TUM
	print((keep=Keep, perc=Perc)),nl,
	urandoms(Keep, N, Positions),
	nth1List(Positions, List, Values).


% Generates a list of N unique random numbers, between 1 and Top inclusive.
% The code ensures that the maximum number of items may be selected.
urandoms(N, Top, List) :-
	(N > Top -> N1 is Top | N1 is N),
	urandoms(N1, Top, [], List0),
	sort(List0, List).

urandoms(0, _, In, In).
urandoms(N, Top, In, Out) :-
	N > 0,
	R is random(Top) + 1,
	(member(R, In)
	 -> urandoms(N, Top, In, Out)
	  | N1 is N - 1,
	    urandoms(N1, Top, [R|In], Out)
	).
