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
	xpanding(Pre, Post).

xpanding(if X then Y0, Out) :-
	setof(Y, Y0^deMorgan(Y0, Y), Ys),
	xpanding1(if X then Ys, Out), !.

xpanding1(if X then [H|T], [Out|Out3]) :-
	xpand2(H, Y, [], Out0), !,
	setof(Out, Out^xpand(if X then Y, Out), Outs),
	Out = [Out0|Outs],
	xpanding1(if X then T, Out3).
xpanding1(if _ then [], []).

xpand(if X0 then Y, Out) :- 
	deMorgan(X0, X1),
	xpand2(X1, X, [], Out0),
/**format('***** if ~w then ~w *****\n', [X, Y]),**/
	xpand1(if X then Y, Out0, Out1),
	member(Out, Out1),
	\+ isOld(Out).

isOld(e(_ID, From, To)) :- !,
	e(_ID, From, To).
isOld(X) :- X.

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
	xpandz(Y,   And, Out0, Out1),
	walk(  And, Z,   Out1, Out).

xpand1(if X then Z, In, Out) :-
	walk(  X,  Z, In, Out).

xpand2(X and Y, And, In, Out) :-
	e(_, X, And),
	( e(_, Y, And) ;
	  xpand2(Y, And, _, _) ), !,
	Out = In.
xpand2(X and Y, And, In, Out) :- !,
	gensym(and, And),
	walk(X, And, In, Out0),
	xpandz(Y, And, Out0, Out).
xpand2(X, X, L, L).

xpandz(X and Y, And) -->
	walk(X, And), !,
	xpandz(Y, And).
xpandz(X, Y) -->
	walk(X, Y).

% --------
walk(A, B, In, Out) :- !,
	addEdgesToList(A, B, In, [e(E1, F1, T1), e(E2, F2, T2), AndOrF, AndOrT|Rest]),
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
	flag(e,E1,E1+1), flag(e,E2,E2+1),
	Out = [e(E1, BarX, BarY),
	       e(E2, X,    Y),
	       AndOrX,
	       AndOrY|In].
addEdgesToList(not X, Y, In, Out) :- !,
	ok(X, AndOrX), ok(Y, AndOrY),
	bar(X, BarX),  bar(Y, BarY),
	flag(e,E1,E1+1), flag(e,E2,E2+1),
	Out = [e(E1, BarX, Y),
	       e(E2, X,    BarY),
	       AndOrX,
	       AndOrY|In].
addEdgesToList(X, not Y, In, Out) :- !,
	ok(X, AndOrX), ok(Y, AndOrY),
	bar(X, BarX),  bar(Y, BarY),
	flag(e,E1,E1+1), flag(e,E2,E2+1),
	Out = [e(E1, X,    BarY),
	       e(E2, BarX, Y),
	       AndOrX,
	       AndOrY|In].
addEdgesToList(X, Y, In, Out) :- !,
	ok(X, AndOrX), ok(Y, AndOrY),
	bar(X, BarX),  bar(Y, BarY),
	flag(e,E1,E1+1), flag(e,E2,E2+1),
	Out = [e(E1, X,    Y),
	       e(E2, BarX, BarY),
	       AndOrX,
	       AndOrY|In].
% --------
ok(X, or) :-
	defined(X), !.
ok(X, and) :-
	atom_concat(and, M, X),
	name(M, Y),
	name(N, Y),
	integer(N), !.
ok(X) :-
	print(unknown(X)), nl, fail.
