% abdbctuion for prositional horn clauses over
% literals that are either bool (values: t,f]),
% one (mutually exclusive),  and num
%
% interface
%	rules in prefix list format [X|Y] where X is one of
%			and,or,not and Y is a literal
%			or a nested prefix list
%	a predicate: askable
%	a predidate: input
%	a predicate: output

term_expansion(opp(X,Y),[
                opp(X,Y),opp(Y,X)
                ]).

term_expansion(rule(X,Y),[rule(X,Y)|Rules]) :-
	bagof(rule(X,Xpanded),Y^axpandRule(Y,Xpanded),Rules).
	
axpandRule([],[]).
axpandRule([and|In],[and|Out]) :- 
	maplist(axpandRule1,In,Out).
axpandRule([not|In],[and|Out]) :-
	eaxpandRule(In,Temp),
	opps(Temp,Out).
axpandRule([or|In],Out) :-
	member(Temp,In),
	axpandRule(Temp,Out).
axpandRule(X in Y,[or|Items]) :-
	oneOf(X,Y,OneOf,Items),
	/*(subset(Y,OneOf)
	->	*/ % nned to do type checking here? or in another sweep?
	map(equals(X),OneOf,Items).
axpandRule(X,X) :-
	subject(X,S),
	num(S); bool(S). 

type(X,Y) :- parent(X,Y).
type(X,Y) :- parent(X,Z), type(Z,Y).

opps([],[]).
opps([H0|T0],[H|T]) :- opps(H0,H), opps(T0,T).
opps(X,Y)           :- opp(X,Y).

% everthing is assumable.
assumable(X) :- not(fact(X)).

fact(X) :- in(X) ; out(X).

opp(X in List,[or|Items]) :- 
	oneOf(X,OneOf),
	subtract(OneOf,List,Items0),
	map(equals(X),Items0,Items).

equals(X,Y,X = Y).

opp(X=t,X=f).
opp(X = A, X \= A).
opp(X >  A, X =< A).
opp(X >= A,X < A).


mutex(X,Y) :- opp(X,Y).
mutex(b is t, z is t).

% specialise(A,B)
% A isa specialisation of B
% If A is true, then B must be true
% If B is true, then A might be also true
specialise(X >= Y, X > Y).
specialise(X =< Y, X < Y).
specialise(X in Y, X in Z) :- 
	subset(Y,Z).
specialise(X,Y) :- 
	specialise(X,Z), 
	specialise(Z,Y).

% genearlise(A,B)
% A isa generalisation of B
% If A is true, then B might be true
% If B is true, then A must be true 
generalise(X,Y) :-
	specialise(Y,X).
