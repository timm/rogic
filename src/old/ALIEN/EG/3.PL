:- +[lib/io, lib/lists, law/mercury].

go1 :-  load_files([ops, law/theory],[silent(true)]),
	forall(output(X),listing(X)).

go :- watch(go1).