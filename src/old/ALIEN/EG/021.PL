%% early version fo the vulcan compiler driver
:- [lib/io].

go:-	+[law/vulcan],
	commandLineArgument(theory,F),
	In= (eg/th/F/mercury),
	sformat(File0,'eg/th/~p/mercury.pl',[F]),
	string_to_atom(File0,File),
	(exists_file(File)
	->	sformat(Out0,'~w/vulcan.pl',[eg/th/F]),
		string_to_atom(Out0,Out),
		+[ops,In],
		tell(Out),
		forall(output(X), listing(X)),
		told
	;	 write(missing(File)),nl).
	

