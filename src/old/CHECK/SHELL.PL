
:- discontiguous l/1,i/2.

term_expansion((:- A is Range),All) :-
	A =.. [range|Vars], !,
	bagof(One,Vars^Range^literal(Vars,Range,One),All).

literal(Vars,Range,l(L)) :-
	member(One,Range),
	member(Var,Vars), 
	L=.. [Var,One].
literal(Vars,Range,i(L1,L2)) :-
	member(One,Range),
	member(Two,Range), 
	\+ One=Two,
	member(Var,Vars), 
	L1=.. [Var,One],
	L2=.. [Var,Two].

oops(G1,G2,One,Two) :- 
	prove(G1,[],  How0), 
	prove(G2,How0,How ),
	member(One,How),
	member(Two,How),
	\+ One=Two,
	i(One,Two).

prove(X,How) :- prove(X,[],How).

prove((X,Y),In,Out) :- !,prove(X,In,Temp),prove(Y,Temp,Out).
prove(true, In,In)  :- !.
prove(X,    In,Out) :- clause(X,Y), contains(X,In,Temp), prove(Y,Temp,Out).

contains(X,[X|T],[X|T])  :- !.
contains(X,[],[X])       :- !.
contains(X,[H|T0],[H|T]) :- contains(X,T0,T).

