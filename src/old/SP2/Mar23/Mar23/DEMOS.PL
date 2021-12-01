demo(random(N,P), CoaxTries) :- !,
	random_graph(N, P, LoadFile),
	init_sp2(LoadFile, OutFiles),
	run_sp2(LoadFile, CoaxTries, OutFiles).

demo(random(InFile), CoaxTries) :- !,
	string_concat('rgraph/', InFile, LoadFile),
	init_sp2(LoadFile, OutFiles),
	run_sp2(LoadFile, CoaxTries, OutFiles).

demo(io(InFile, N), CoaxTries) :- !,
	string_concat('egs/', InFile, LoadFile),
	init_sp2(LoadFile, OutFiles),
	io(N, Input, Output),
	expandIO(Input, Output),
	run_sp2(LoadFile, CoaxTries, OutFiles).

demo(InFile, CoaxTries) :-
	string_concat('egs/', InFile, LoadFile),
	init_sp2(LoadFile, OutFiles),
	run_sp2(LoadFile, CoaxTries, OutFiles).


% ----------------------------------------
run_sp2(LoadFile, CoaxTries, [FileSp2|FileTxt]) :-
	format('\nStarting SP2 for ~w...\n', [LoadFile]),

	tell(FileTxt),
	print_current_time, nl,
	sp2_control(CoaxTries),
	wmeShow(sp2),
	told,

	finish_sp2([FileSp2|FileTxt]),
	format('Finished! Stat output file: ~w.txt\n', [FileSp2]),
	format('Finished! Graphviz output file: ~w.sp2\n\n', [FileTxt]).

init_sp2(LoadFile, OutFiles) :-
	wmeSetup(all),
	wmeZap(all),
	[LoadFile],
	outfilenames(LoadFile, OutFiles).


% ----------------------------------------
outfilenames(Base, OutFiles) :-
	outfilenames(Base, 0, OutFiles).

outfilenames(In, N, OutFiles) :-
	string_concat(In,   '_',   Temp),
	string_concat(Temp, N,     Base),
	string_concat(Base, '.sp2', FileSp2),
	string_concat(Base, '.txt', FileTxt),
	M is N + 1,
	(  exists_file(FileSp2)
	-> outfilenames(In, M, OutFiles)
	;  OutFiles = [FileSp2|FileTxt]
	).


% ----------------------------------------
finish_sp2([GraphOut|_]) :-
	tell(GraphOut),
	format('digraph z {\n', []),
	forall(zprime(From, To), print_graphviz_edge(From, To)),
	format('}\n', []),
	told.

print_graphviz_edge(From, To) :-
	n(From, F),
	n(To,   T),
	format('"~w" -> "~w"\n', [From/F, To/T]).


% ----------------------------------------
expandIO(Input, Output) :-
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

