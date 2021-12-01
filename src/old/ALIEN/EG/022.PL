%% early version of the vulcan1 compiler driver
:- [lib/io].

go :- go1.

go1 :-	+[law/vulcan1],
	switch('-theory',F),
	In= (eg/th/F/vulcan),
	sformat(File0,'eg/th/~p/vulcan.pl',[F]),
	string_to_atom(File0,File),
	(exists_file(File)
	->	sformat(Out0,'~w/vulcan1.pl',[eg/th/F]),
		string_to_atom(Out0,Out),
		+[In],
		write('vulcan1 -> '),
		tell(Out),
		forall(optimise1(Thing), format('~p.~n',[Thing])),
		told
	;	 write(missing(File)),nl).
