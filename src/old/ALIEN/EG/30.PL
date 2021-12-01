:- +[lib/io].

go :- watch(go1).

go1 :-  commandLineArgument(theory,   aasimp,    F),
	commandLineArgument(comp,     law/venus, Comp),	
	commandLineArgument(in,       theory,    In0),
	commandLineArgument(out,      venus,     Out0),
	
	In= (eg/th/F/In0),
	asString('eg/th/~p/~p.pl',[F,In0],       File),
	asString('~w/~p.pl',      [eg/th/F,Out0],Out),

	maplist(exists,[directory=eg/th/F
		       ,theoryFile=File
		       ,complier=Comp
		       ,systemsFile=ops
                       ],_),

	print(Out0), write(' -> '),
	+[Comp,ops,In],

	tell(Out),
	write(':- [ops].'),nl,
	forall(output(X), listing(X)),
	told.

exists(What=F,What=F) :- 
	exists1(F)
	-> true
	;  print(missing(What=F)),
	   nl,
           halt.

exists1(F0) :-
	asString('~w',[F0],F1),
	asString('~w.pl',[F0],F2),
	member(F,[F1,F2]),
	(exists_file(F)
	;exists_directory(F)
        ),
	!.
