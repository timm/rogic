%
% Term expansion #1:
%    Expanding "known=[H|T]" to defined/1
%
term_expansion(known=[H|T],Out) :-
	knowns([H|T],Out).

knowns(In,All) :-
	setof(One,In^known(In,One),All).

known(L, [defined(X), defined(BarX)]) :-
	member(X, L),
	bar(X, BarX),
	\+ defined(X),
	\+ defined(BarX).



%
% Term expansion #2:
%    Expanding "if X then Y"
%
term_expansion(if X then Y, Out) :-
	xpands(if X then Y, Out).

xpands(Pre, Post) :-
	setof(Out, xpand(Pre, [], Out), Post).

xpand(if X0 then Y0, In, Out) :- 
	deMorgan(Y0, Y1),
	xpandPostAnd(Y1, Y),
	deMorgan(X0, X1),
	xpandPreAnd(X1, X, In, Out0),
	xpand1(if X then Y, Out0, Out1),
	member(Out, Out1),
	\+ isOld(Out).

isOld(e(_, From, To)) :- !,
	e(_, From, To).
isOld(X) :- X, !.


% --------
deMorgan(X1 and Y1, X and Y) :-	!,
	deMorgan(X1, X),
	deMorgan(Y1, Y). 

deMorgan(X or Y, Z) :- !,
	(Z0=X ; Z0=Y),
	deMorgan(Z0, Z).

deMorgan(not (X and Y), Z) :- !,          % deMorgan 1
	deMorgan(not X or not Y, Z).

deMorgan(not (X or  Y), Z) :- !,          % deMorgan 2
	deMorgan(not X and not Y, Z).

deMorgan(not not X, Z) :- !,              % not not X = X
	deMorgan(X, Z).

deMorgan(X, X). 

% --------
xpand1(if X and Y then Z, In, Out) :- !, 
	gensym(and, And),
	walk(  X,   And, In,   Out0),
	walk2Ands(Y,   And, Out0, Out1),
	walk(  And, Z,   Out1, Out).

xpand1(if X then Z, In, Out) :-
	walk(  X,  Z, In, Out).

xpandPreAnd(X and Y, And, In, Out) :- !,
	newAndNode(And),
	walk(X, And, In, Out0),
	walk2Ands(Y, And, Out0, Out).
xpandPreAnd(X, X, L, L).

xpandPostAnd(X and Y, Out) :- !,
	( (Out=X) ; xpandPostAnd(Y, Out) ).
xpandPostAnd(X, X).

walk2Ands(X and Y, And) -->
	walk(X, And), !,
	walk2Ands(Y, And).
walk2Ands(X, Y) -->
	walk(X, Y).

% --------
walk(A, B, In, Out) :- !,
	addEdgesToList(A, B, In, [e(E1, F1, T1), e(E2, F2, T2), AndOrF, AndOrT|Rest]),
	flag(e1, E1, E1+1), flag(e2, E2, E2-1),
	Out = [lambda(E1, 1),
	       lambda(E2, 1),
	       e(E1, F1, T1),
	       e(E2, F2, T2),
	       n(F1, AndOrF),
	       n(F2, AndOrF),
	       n(T1, AndOrT),
	       n(T2, AndOrT)|Rest].
addEdgesToList(not X, not Y, In, Out) :- !,
	ok(X, AndOrX), ok(Y, AndOrY),
	bar(X, BarX),  bar(Y, BarY),
	Out = [e(_, BarX, BarY),
	       e(_, X,    Y),
	       AndOrX,
	       AndOrY|In].
addEdgesToList(not X, Y, In, Out) :- !,
	ok(X, AndOrX), ok(Y, AndOrY),
	bar(X, BarX),  bar(Y, BarY),
	Out = [e(_, BarX, Y),
	       e(_, X,    BarY),
	       AndOrX,
	       AndOrY|In].
addEdgesToList(X, not Y, In, Out) :- !,
	ok(X, AndOrX), ok(Y, AndOrY),
	bar(X, BarX),  bar(Y, BarY),
	Out = [e(_, X,    BarY),
	       e(_, BarX, Y),
	       AndOrX,
	       AndOrY|In].
addEdgesToList(X, Y, In, Out) :- !,
	ok(X, AndOrX), ok(Y, AndOrY),
	bar(X, BarX),  bar(Y, BarY),
	Out = [e(_, X,    Y),
	       e(_, BarX, BarY),
	       AndOrX,
	       AndOrY|In].
% --------
