% interface
%	rules in prefix list format [X|Y] where X is one of
%			and,or,not and Y is a literal
%			or a nested prefix list
%	a predicate: askable
%	a predidate: input
%	a predicate: output

term_expansion(rule(X,Y),[rule(X,Y)|Rules]) :-
	bagof(rule(X,Xpanded),Y^xpandRule(Y,Xpanded),Rules).
	
xpandRule([],[]) :- 
xpandRule([and|In],[and|Out]) :- 
	maplist(xpandRule1,In,Out).
xpandRule([not|In],[and|Out]) :-
	expandRule(In,Temp),
	opps(Temp,Out).
xpandRule([or|In],Out) :-
	member(Temp,In),
	xpandRule(Temp,Out).
xpandRule(X,X) :-
	subject(X,S),
	numeric(S).

opps([],[]).
opps([H0|T0],[H|T]) :- opps(H0,H), opps(T0,T).
opps(X,Y)           :- opp(X,Y).