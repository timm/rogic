:- multifile f/5.
:- discontiguous f/5.

%% read time support
term_expansion(def(L),All) :-
	bagof(One,L^defDB(L,One),All).

defDB(Spec,field(Field,Old,New,Term1,Term2)) :-
	maplist(arg(1),Spec,Fields),
	length(Fields,A),
	functor(Term1,wme,A),
	Term1 =.. [_|Fields1],
	nth1(N,Fields,Field),
	joinArgs(1,N,Fields1,Old,New,Fields2),
	Term2 =.. [wme|Fields2].
defDB(Spec,wme0(Init)) :-
	maplist(arg(2),Spec,Inits),
	Init=..[wme|Inits].
	
joinArgs(N,N,[Old|Rest],Old,New,[New|Rest]).
joinArgs(N0,N1,[X|L0],Old,New,[X|L]) :- 
	N0 < N1,
	N2 is N0 + 1,
	joinArgs(N2,N1,L0,Old,New,L).

%% runtime support

fields([],  W, W).
fields([H|T],W0,W) :-  field(H,W0,W1), fields(T,W1,W).

