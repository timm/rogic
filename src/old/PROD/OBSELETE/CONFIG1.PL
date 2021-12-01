%%% Configuration Control %<
[] := []    :- !.
[H0|T0] := [H|T] :- !, H0 := H, T0 := T.
X := Y      :-  option(X,Z),!, Y=Z.
X := _      :-  !, barph(missingOption(X)).
?X          :- atomic(X), X := 1.
%>
set(X=Y) :- retractall(option(X,_)), assert(option(X,Y)).

commandLine :-
    current_prolog_flag(argv, Argv),
    append(_, [--|Args], Argv), !,
    concat_atom(Args, ' ', SingleArg),
    term_to_atom(Term, SingleArg),
    c2l(Term,List),
    forall(member(One,List), set(One)).
commandLine.
