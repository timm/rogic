% readtdat.pl

% read in a file of time simulation data in the following format:
% name = aString.
% time,   m1,    m2.
%   t1,   n1,    n2.
%   t2,   n3,    n4.
%
% where:
%       each line ends with a ".".
%       each line is comma delimited,
%       each line shows measures of mX at tY.
%	nX is a number or "-" for unknown value
% Generates ins and outs to either perform comparisons between two trials
% (inter-trial), or perform comparisons between time steps (intra-trial).

% Read in .run files, checking data and generating INP/OUT pairs and times
% from all models.  This generates data for inter-trial or intra-trial
% comparisons, depending on the Comp flag.
readTimeData(FileStem,Dialect,Comp-PercKeep,Link,KnownTerms,IOData,Times) :-
	theory_file(Dialect, FileStem, '.run.*', RunFile),
	expand_file_name(RunFile, RunFiles),
	runFilesRead(RunFiles, KnownTerms, CellData, Times0),
	members(Times0, Times),
	( Comp = inter -> genInterInOuts(Times, Link, CellData, IOData0)
			| genIntraInOuts(Times, Link, CellData, IOData0) ),
	dropIOs(PercKeep, IOData0, IOData).


%-----------------------------------------------------------------------------
% Code to read, check and extract data
%-----------------------------------------------------------------------------
% Read each file and generate name plus cell values and information for all
% experiment files.
runFilesRead([], _, [], []).
runFilesRead([F|Files], KnownTerms, [Name-Cells|Data], [Times|AllT]) :-
	file2List(F, List),
	compileLines(List, KnownTerms, Details, Times),
	addTerms(Details, Name, Cells),
	runFilesRead(Files, KnownTerms, Data, AllT).

% Given the list of the read lines paired with line numbers, and the known
% column headers (names of the measures), check lines of file are correct.
compileLines([],         _,          [],          []).
compileLines([Line-H|T], KnownTerms, [Data|Rest], [Time|Times]) :-
	\+ once(errorLine(H, Line, KnownTerms)),
	c2l(H, List),	% convert line into a list
	extractLine(List, Line, Data, Time), !,
	compileLines(T, KnownTerms, Rest, Times).

% Return processed data (previously checked), given line and line number
% information.  Three objects are
% returned: name(_) for the run file name, terms([...]) list of the column
% names, and cells([cell(Column, Time, Value, CorrespondingTerm)|...])
% for the actual values.  The Term is added to cell elements later.
extractLine([name = What],  1, name(What),   []).
extractLine([time|Terms],   2, terms(Terms), []).
extractLine([Time|Numbers], N, cells(Cells), [Time]) :-
	N > 2,
	makeCells(Numbers, 1, Time, Cells0),
	sort(Cells0, Cells).

% From a list of values (row), the column and row/time numbers, generate a
% cell value for each value in each column.
makeCells([],    _,    _,    []).
makeCells([H|T], Col0, Time, [cell(Col0,Time,H,_)|Rest]) :-
	Col is Col0 + 1,
	makeCells(T, Col, Time, Rest).


% Extract experiment name and include term titles to cell information (final
% part of cell/4).
addTerms(List, Name, Cells) :-
	member(name(Name), List),			% select name
	member(terms(Terms), List),			% select term labels
	setof(Cell, List^getCell(List,Cell), Cells),	% select cells
	populateCells(Cells, Terms).			% add terms to cells

getCell(List, cell(A,B,C,D)) :-	
	member(cells(Cells), List),
	member(cell(A,B,C,D), Cells).

populateCells([], _).
populateCells([cell(Column,_,_,Term)|Cells], Terms) :-
	nth(Terms, Column/Term),
	populateCells(Cells, Terms).


%-----------------------------------------------------------------------------
% Error checking: given the case and a line number (args 1 and 2), either
% display an appropriate error or return the checked data.
%-----------------------------------------------------------------------------
% write out single error message
simoops(LineNumber, Message) :-
	write_list(['E[', LineNumber, ']: ', Message]).

% Non-ground case.
errorLine(X,Line,_) :- 
	\+ ground(X), 
	simoops(Line, [X,': not ground']).

% Failed line read.
errorLine(failedRead,Line,_) :-               
	simoops(Line, [failedRead]).

% Check name in place on first line.
errorLine(X,1,_)  :- 
	\+ X=(name=_),
	simoops(1, ['First line must start with ''name = aString''']).

% Check time column in place.
errorLine(X,2,_)  :- 
	\+ X=(time,_), 
	simoops(2, ['Second line must start with ''time, ''']).

% Check that further rows are numeric.
errorLine(X,L,_) :-
	L > 3,
	inside(Item, X),
	\+ number(Item),
	simoops(L, ['Non-numeric ', Item]).

% Check that column labels are known
errorLine((time,Terms), 2, KnownTerms) :-
	inside(Item, Terms),
	\+ member(Item, KnownTerms),
	simoops(2, ['Unknown term ', Item]).		


%-----------------------------------------------------------------------------
% Code for generating the inter comparison INs and OUTs from cell information
%-----------------------------------------------------------------------------
% From the values from each experiment, generate the In-Out information.
genInterInOuts(_, _, [], []).
genInterInOuts(Times, Link, [Exp0|CellData], NewIOData) :-
	genInterInOuts(Times, Link, Exp0, CellData, IOs),
	genInterInOuts(Times, Link, CellData, IOData),
	append(IOs, IOData, NewIOData).

genInterInOuts(_, _, _, [], []).
genInterInOuts(Times, Link, N0-C0, [N1-C1|Rest], [N0/N1-In-Out|Data]) :-
	getInterIOs(C0, C1, =, Times, Link, In),
	getInterIOs(C0, C1, >, Times, Link, Out),
	genInterInOuts(Times, Link, N0-C0, Rest, Data).

% Given the cells from two experiments, return the comparisons to be included
% in the IN or OUT set.  A comparison is made on the time step of the cell
% depending whether an IN (= First) or an OUT (> First) term is required.  If
% there are no terms an empty list is returned.
getInterIOs(C0, C1, Ord, Times, Link, IOs) :-
	findall(IO, getInterD(C0,C1,Ord,Times,Link,IO), IOs).

% Return a delta between two experiments after checking that the cells being
% compared have the same term and are in the same time.  Also check whether
% the cells are the first time step (IN set) or subsequent (OUT set).
getInterD(Cells0, Cells1, Comp, [First|_], Link, delta(Term,Time,Change)) :-
	getCell(Cells0, Term, Time, Value1),
	compare(Comp, Time, First),
	getCell(Cells1, Term, Time, Value2),
	changeDirection(Value2, Value1, Link, Change).


%-----------------------------------------------------------------------------
% Code for generating the intra comparison INs and OUTs from cell information
%-----------------------------------------------------------------------------
% From the values from each experiment, generate the In-Out information.
genIntraInOuts(_, _, [], []).
genIntraInOuts(Times, Link, [Name-Cells|CellData], [Name-In-Out|IOData]) :-
	getIntraIOs(Cells, =, Times, Link, In),
	getIntraIOs(Cells, >, Times, Link, Out),
	genIntraInOuts(Times, Link, CellData, IOData).

% Given the cells from an experiment, return the comparisons to be included
% in the IN or OUT set.  A comparison is made on the time tick of the cell
% depending whether an IN (= 1) or an OUT (> 1) term is required.  If there
% are no terms an empty list is returned.
getIntraIOs(Cells, Ord, Times, Link, IOs) :-
	findall(IO, getIntraD(Cells,Ord,Times,Link,IO), IOs).

% Return a delta for a term between two times after checking that the cells
% being compared have the same term and are in adjacent times.  Also check
% whether the cells are the first time tick (IN set) or subsequent (OUT set).
getIntraD(Cells, Comp, [First|Times], Link, delta(Term,Time1,Change)) :-
	getCell(Cells, Term, Time0, Value1),
	compare(Comp, Time0, First),
	after(Time0, [First|Times], [Time1|_]),
	getCell(Cells, Term, Time1, Value2),
	changeDirection(Value2, Value1, Link, Change).


%-----------------------------------------------------------------------------
% Utility code for INs and OUTs generation
%-----------------------------------------------------------------------------
% Select cell from Cells.
getCell(Cells, Term, Time, Value) :- member(cell(_,Time,Value,Term),Cells).

% Determine whether the first arguement is less than, greater than or equal
% to the second term returning, for example down if less than.
changeDirection(V2, V1, Link, Delta) :-
	compare(Order, V2, V1), 
	changeName(Order, Delta, Link).

changeName(=, std, explicit).
changeName(<, down, _).
changeName(>, up, _).


%-----------------------------------------------------------------------------
% Code to remove percentage of IO data
%-----------------------------------------------------------------------------
% dropIOs -- given IOs and percentage of those to keep, remove the unrequired
% cells, selected at random
dropIOs(_, [], []).
dropIOs(100.0, IOData, IOData).
dropIOs(Perc, [N-In0-Out0|IOData0], [N-In-Out|IOData]) :-
	percRandomSelect(In0,  Perc, In),
	percRandomSelect(Out0, Perc, Out),
	dropIOs(Perc, IOData0, IOData).
