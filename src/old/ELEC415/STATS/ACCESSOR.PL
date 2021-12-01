% accessors- stuff for the term accessing

% expansion magic
term_expansion(Functor=Fields,Out) :-
	makeAccessors(Functor=Fields,Out).

makeAccessors(X,Out) :-
	bagof(One,X^makeAccessor(X,One),Out).

makeAccessor(Functor=Fields,Out) :-
	length(Fields,Arity),
	functor(Term1,Functor,Arity),
	functor(Term2,Functor,Arity),
	nth1(Pos,Fields,Item),
	joinArgs(Pos,Old,New,Term1,Term2),
	Out =.. [Functor,Item,Old,New,Term1,Term2].

joinArgs(N,Old,New,T1,T2) :-
	T1 =.. [_|L0],
	T2 =.. [_|L],
	joinArgs(1,N,L0,Old,New,L).
joinArgs(N,N,[Old|Rest],Old,New,[New|Rest]).
joinArgs(N0,N1,[X|L0],Old,New,[X|L]) :-
	N0 < N1,
	N2 is N0 + 1,
	joinArgs(N2,N1,L0,Old,New,L).

% lint magic 
goal_expansion(stats(Attr,_,_,_,_),_) :-
	nonvar(Attr),
	\+ stats(Attr,_,_,_,_),
	source_location(File, Line),
	format('E> ~w, near line ~w\n\t~w : unknown attribute\n',
               [File,Line,Attr]),
	fail.
	
goal_expansion(o(Op,_,_),_) :-
	nonvar(Op),
	\+ clause(o(Op,_,_),_),
	source_location(File, Line),
	functor(Op,Functor,Arity),
	format('E> ~w, near line ~w\n\t ~w : unknown operation\n',
               [File, Line,Functor/Arity]),
	fail.

% optimization magic
goal_expansion(o(X,Y,Z),Out) :-	
	optimizing,
	clause(o(X,Y,Z),Out).
