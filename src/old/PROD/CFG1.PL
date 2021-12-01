%%%% Main drivers
%%% Setting options
%Blast all previous knowledge of this option
%and set a new value:
%<
set(X=Y) :-
	retractall(option(X,_)),
	assert(option(X,Y)).
%>
%%% Accessing options
%Run down a list of accessors.
%<
[] := []    :- !.
[H0|T0] := [H|T] :- !, H0 := H, T0 := T.
%>
%Primitive accessor.
%<
X := Y      :-  option(X,Z),!, Y=Z.
%>
%Complain if option not known.
%<
X := _      :- !, barph(missingOption(X)).
%>
%Boolean options- check for a ``1'' value.
%<
?X          :- atomic(X), X := 1.
%>
%Process the command line options.
%<
commandLine :-
	current_prolog_flag(argv, Argv),
	append(_, [--|Args], Argv), !,
	concat_atom(Args, ' ', SingleArg),
	term_to_atom(Term, SingleArg),
	c2l(Term,List),
	forall(member(One,List), set(One)).
commandLine.
%>