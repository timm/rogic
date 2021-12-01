%%% Equations 
%% Define some quick accessors to our variables. %<
variables(All) :- bagof(One,variable(One),All).

variable((Head :- value(One,Y))) :-
	setof(V,variable1(V),All),
	member(One,All),
	arithmetic_function(One/0),
	Head =.. [One,Y].

variable1(X) :- lookUp1(_,X,_,_), atom(X).
variable1(X) :- member(X,[a,b,c,d]).

genVars.
%>