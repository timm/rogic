load_demo(random(N, P, F)) :- !,
	random_graph(N, P, F, LoadFile),
	init_sp2(LoadFile).

load_demo(random(InFile)) :- !,
	string_concat('rgraph/', InFile, LoadFile),
	init_sp2(LoadFile).

load_demo(egs(InFile)) :- !,
	string_concat('egs/', InFile, LoadFile),
	init_sp2(LoadFile).

load_demo(LoadFile) :-
	init_sp2(LoadFile).

%----------
list_demo :-
	listing(io).

list_demo(N) :-
	io(N, Input, Output),
	format('\nInput  : ~w\n', [Input]),
	format('Output : ~w\n', [Output]).

%----------
run_demo(random(InNum, OutNum), CoaxTries) :-
	randomIO(InNum, OutNum),
	run_sp2(CoaxTries).

run_demo(io(Input, Output), CoaxTries) :-
	newIO(Input, Output),
	run_sp2(CoaxTries).

run_demo(N, CoaxTries) :-
	io(N, Input, Output),
	expandIO(Input, Output),
	run_sp2(CoaxTries).

% ----------------------------------------
init_sp2(LoadFile) :-
	wmeSetup(all),
	wmeZap(all),
	[LoadFile],
	assert(sp2source(LoadFile)).


% ----------------------------------------
outfilename(Base, OutFile) :-
	outfilename(Base, 1, OutFile).

outfilename(In, N, OutFile) :-
	string_concat(In,   '_',   Temp),
	string_concat(Temp, N,     Base),
	string_concat(Base, '.txt', File),
	M is N + 1,
	(  exists_file(File)
	-> outfilename(In, M, OutFile)
	;  OutFile = File
	).


% ----------------------------------------
run_sp2(CoaxTries) :-
	CoaxTries >= 0, !,

	resetLambda,

	sp2source(LoadFile),
	outfilename(LoadFile, OutFile),

	format('\nStarting SP2 for ~w...\n\n', [LoadFile]),

	tell(OutFile),

	print_current_time, nl,
	sp2_control(CoaxTries),

	told,

	sp2Stats(AvgTime, AvgGoals, AvgGraph, AvgCoaxing, H1, H2, H3, H4),
	AvgTimeMilli is AvgTime*1000, nl,
	format('Average run time      = ~2f ms  \n', [AvgTimeMilli]),
	format('Average goals covered = ~2f %   \n', [AvgGoals]),
	format('Average graph covered = ~2f %   \n', [AvgGraph]),
	format('Average coaxing       = ~w times\n', [AvgCoaxing]), nl,
	format('~5|H ~4+= H1 ~6++ H2 ~6++ H3 ~6++ H4\n', []),
	format('~5|~w ~4+= ~w ~6++ ~w ~6++ ~w ~6++ ~w\n', [AvgCoaxing, H1, H2, H3, H4]),
	nl,
	format('Finished! Text output file: ~w\n', [OutFile]).

run_sp2(_CoaxTries) :-
	format('Error: sp2_control(CoaxTries): CoaxTries < 0\n'), fail.

% ----------------------------------------
expandIO(Input, Output) :-
	wmeSetup(demo),
	wmeZap(demo),
	expandStart(Input),
	expandGoal(Output).

expandStart(Input) :-
	member(In,  Input),
	ok(In),
	assert(start(In)),
	fail.
expandStart(_Input).

expandGoal(Output) :-
	member(Out, Output),
	ok(Out),
	assert(goal(Out)),
	fail.
expandGoal(_Output).


% ----------------------------------------
newIO(Input, Output) :-
	expandIO(Input, Output),
	flag(sp2_io, N, N+1),
	assert(io(N, Input, Output)).


% ----------------------------------------
randomIO(Nin, Nout) :-
	bagof(Node, n(Node, or), Nodes),
	countN(n(_, or), Seed),
	Seed > Nin+Nout, !,
	NewSeed is Seed - Nin,
	generate_random_input(Nin,  Seed,    Input,  Nodes,  Unused),
	generate_random_input(Nout, NewSeed, Output, Unused, _),
	newIO(Input, Output).

randomIO(Nin, Nout) :-
	format('Not enough nodes to create ~w inputs and ~w outputs!\n', [Nin, Nout]),
	fail.

generate_random_input(0, _,    [],          Rest,  Rest).
generate_random_input(N, Seed, [Node|Used], Nodes, Unused) :-
	Index is random(Seed),
	nth0(Index, Nodes, Node),
	oneLess(Node, Nodes, RestNodes),
	NewSeed is Seed - 1,
	M is N - 1,
	generate_random_input(M, NewSeed, Used, RestNodes, Unused), !.

generate_random_output(0, _,    [],          Rest,  Rest).
generate_random_output(N, Seed, [Node|Used], Nodes, Unused) :-
	Index is random(Seed),
	nth0(Index, Nodes, Node),
	oneLess(Node, Nodes, RestNodes),
	NewSeed is Seed - 1,
	M is N - 1,
	generate_random_output(M, NewSeed, Used, RestNodes, Unused), !.



