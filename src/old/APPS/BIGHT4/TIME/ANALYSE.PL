% analyse.pl

% Function to examine a trial of a model using a particular set of data.
% Summarises the data.  Parameters are:
%	Mutations	- number of mutations made to model
%	Measures	- percentage of qualitative data measured
%	Trials		- number of random trials of model mutations used
%	Tests		- number of data comparisons used

% Collects result information, if any available.
analyse(TimeSteps, Mutations, Measures, Trials, Tests) :-
	asserta(result(_,_,_,_,0,0,0,0)),
	findall(W-BW-Exp-Time,result(_,_,_,_,W,BW,Exp,Time),All),
	analyse(All, TimeSteps, Mutations, Measures, Trials, Tests).

analyse([_], _, _, _, _, _) :- !.
analyse(All0, TimeSteps, Mutations, Measures, Trials, Tests) :-
	Runs is Trials * Tests,
	select(All0, 0-0-0-0, All),
	unzip4(All, Ws, BWs, Exps, Times),
	writeGeneral(Ws, w, TimeSteps, Mutations, Measures, Runs),
	writeGeneral(BWs, b, TimeSteps, Mutations, Measures, Runs),
	writeGeneral(Exps, ea, TimeSteps, Mutations, Measures, Runs),
	writeGeneral(Times, s, TimeSteps, Mutations, Measures, Runs).

writeGeneral(Ls, Flag, TimeSteps, Mutations, Measures, Runs) :-
	average(Ls, Av),
	sd(Ls, Av, Sd),
	length(Ls, Succ),
	F is Runs - Succ,
	write(Mutations),	write(','),	% # of mutations
	write(Measures),	write(','),	% % of data measured
	write(TimeSteps),	write(','),	% # of time steps
	write(Flag),		write(','),	% flag for information type
	write(Av),		write(','),	% average for time step
	write(Sd),		write(','),	% standard deviation
	write(Runs),		write(','),	% # of trials * comparisons
	write(F),		nl.		% # of above which didn't work


%------------------------------------------------------------------------------
% Utility functions
%------------------------------------------------------------------------------
unzip4([], [], [], [], []).
unzip4([A-B-C-D|Rs], [A|As], [B|Bs], [C|Cs], [D|Ds]) :-
	unzip4(Rs, As, Bs, Cs, Ds).

max([X],X).
max([X,Y|Z],Max) :- X > Y, !, max([X|Z],Max).
max([_,Y|Z],Max) :- max([Y|Z],Max).

sum([],0).
sum([H|T],Sum) :-
        sum(T,Temp),
        Sum is H + Temp.

% Average the elements in a list.
average(L,A) :-
        sum(L,Sum),
        length(L,Size),
        (Size = 0
        -> nl, write('error: average of empty list'), nl, fail
        |  A is Sum / Size).

% Calculates the standard deviation of a list given the list and the average
% of that list (sd/3).  Alternatively sd/2 determines the average as well.
sd(L, A) :-
	average(L, Av),
	sd(L, Av, A).

sd(L, Av, A) :-
	sdsum(L, Av, Sum),
	length(L, N),
	(N < 2 -> A is 0 | A is sqrt(Sum / (N-1)) ).

sdsum([], _, 0).
sdsum([L|Ls], Av, Sum) :-
	Value is (L - Av) * (L - Av),
	sdsum(Ls, Av, Sum0),
	Sum is Value + Sum0.
