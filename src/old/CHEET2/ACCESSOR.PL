
term_expansion(Handle=This+Wme,Out) :-
	makeAccessors(Handle=This+Wme,Out).

makeAccessors(Handle=Functor+Term,Out) :-
	Functor \= array,
	base(accept(Handle=Functor+Term),_,Base),
	bagof(One,makeAccessor(Base,One),Out).
makeAccessors(Handle=array+Term,
	      [wmeSize(Handle,N,Functor)|Out]) :- 
	Term =.. [Functor,Arity],
	N is Arity - 1,
	bagof(I,between(0,N,I),All),
	Array =.. [Functor|All],
	expand_term(Handle=fact+Array,Out).

makeAccessor(Base,(portray(Blank) :-
			    write(Functor/Arity))
	                    ) :-
	base(blank=Blank,Base),
	base(functor=Functor,Base),
	base(arity=Arity,Base).
makeAccessor(Base,def(Handle,Base)) :-
	base(handle=Handle,Base).
makeAccessor(Base,Out) :-
	base(arity=Arity,Base),
	base(functor=Functor,Base),
	base(fields=Fields,Base),
	base(handle=Handle,Base),
	functor(Term1,Functor,Arity),
	functor(Term2,Functor,Arity),
	nth1(Pos,Fields,Item),
	joinArgs(Pos,Old,New,Term1,Term2),
	Out =.. [Handle,Item,Old,New,Term1,Term2].
makeAccessor(Base,Out) :-
	base(handle=Handle,Base),
	base(functor=Functor,Base),
	swap([base/Handle,def/Functor],Out).

joinArgs(N,Old,New,T1,T2) :-
	T1 =.. [_|L0], T2 =.. [_|L],
	joinArgs(1,N,L0,Old,New,L).
joinArgs(N,N,[Old|Rest],Old,New,[New|Rest]).
joinArgs(N0,N1,[X|L0],Old,New,[X|L]) :-
	N0 < N1, N2 is N0 + 1,
	joinArgs(N2,N1,L0,Old,New,L).

						