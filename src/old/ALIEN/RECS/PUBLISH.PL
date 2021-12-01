term_expansion(publish(Term),Out) :-
    setof(One,publish1(Term,One),Out).

publish1(Term,(Head :- Body)) :-
    Term =.. [F|Args],
    accessorName(F,Ac),
    member(Arg,Args),
    Term1 =.. [Arg,X],
    Term2 =.. [Arg,X,X],
    Head  =.. [Ac,Term1,R0,R],
    Body  =.. [Ac,Term2,R0,R].
