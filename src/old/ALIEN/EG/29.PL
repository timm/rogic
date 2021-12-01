:- +[lib/io].

go :- watch(go).

go1 :-  +[law/venus],
	commandLineArgument(theory,F),
	In= (eg/th/F/theory),
	sformat(File0,'eg/th/~p/theory.pl',[F]),
	string_to_atom(File0,File),
	(exists_file(File)
	->
		sformat(Out0,'~w/venus.pl',[eg/th/F]),
		string_to_atom(Out0,Out),
		+[ops,In],
		tell(Out),
		write(':- [ops].'),nl,
		forall(output(X), listing(X)),
		told
	; write(missing(File)),nl).


