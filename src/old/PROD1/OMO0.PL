%%%%Pre-load actions
%%%Hooks
/* Fast assertions of named variables. */
%<
term_expansion((X;Y :- Z),Out) :-
	multis(((X;Y) :- Z),Out).
%>
%Instantiate named fields
%<
term_expansion(Functor is Fields,Out) :-
	fields(Fields,Functor,Out).
%>