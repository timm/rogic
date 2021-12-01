:- ensure_loaded(olog).
:- dynamic linting/0, optimizing/0.
optimizing. linting.
	
term_expansion((F o Head --> Body), Out) :-
	retractall(me(_)),
	assert(me(F)),
	X =.. [F,Head],
	expand_term((X --> Body),Out).

goal_expansion(o(X,Y,Z),o(F,X,Y,Z)) :- me(F).

goal_expansion(o(_,{X},Y,Y),X) :- nonvar(X).
% tricks that can be defined in terms of recursive expands to o/3
goal_expansion(o(F,[A],X,Y),     o(F,A,X,Y)) :- nonvar(A).
goal_expansion(o(F,[A,B|T],X,Y),(o(F,A,X,Z),o(F,[B|T],Z,Y))) :- nonvar(A).
goal_expansion(o(F,A has B,X,Y),(o(F,A = L,X,Y),member(B,L))).
goal_expansion(o(F,A \=  B,X,Y),(o(F,A=C,X,Y),C \= B)).

% accessors that call on the structure stored in me/5
goal_expansion(o(F,fresh,_,X),true) :- blank(F,X).
goal_expansion(o(F,fetch,X,X),X)    :- blank(F,X).

% accessors that need both the old and new values
% i.e. that use o/5
goal_expansion(o(F,A =  B,X,Y),T) :- swaps5(F,A,B,B,X,Y,T).
goal_expansion(o(F,A := B,X,Y),T) :- swaps5(F,A,_,B,X,Y,T).
goal_expansion(o(F,+A,    X,Y),(T,C is B +1)) :- swaps5(F,A,B,C,X,Y,T).
goal_expansion(o(F,-A,    X,Y),(T,C is B -1)) :- swaps5(F,A,B,C,X,Y,T).
goal_expansion(o(F,A << B,X,Y),T) :- swaps5(F,A, Old,    [B|Old],X,Y,T).
goal_expansion(o(F,A >> B,X,Y),T) :- swaps5(F,A,[B|Rest],Rest,   X,Y,T).

% the base case for expanding o/3: must go last
goal_expansion(o(F,X,Y,Z),Term) :- mine(F),   swaps3(F,X,Y,Z,Term).
goal_expansion(o(F,X,Y,Y),Term) :- \+ mine(F),swaps1(F,X,Term).

% support code
mine(X) :-
	nonvar(X),
	me(X).
blank(F,X) :-
	Get =.. [F,_,_,_,_,X], once(Get). 
swaps1(F,A,        Z) :- Z  =.. [F,A,    _,_], lint(F,A,Z).
swaps3(F,A,    X,Y,Z) :- Z0 =.. [F,A,    X,Y], lint(F,A,Z0), fold(A,Z0,Z).
swaps5(F,A,B,C,X,Y,Z) :- Z  =.. [F,A,B,C,X,Y], lint(F,A,Z).

lint(F,A,Z) :-
	linting,
	nonvar(A),
	\+ clause(Z,_),
	source_location(File, Line), file_base_name(File,Base),
        format('%HUH? ''~w.~w'' at ''~w'', near line ~w\n',
              [F,A,Base,Line]),!.
lint(_,_,_).

fold(A,Z0,Z) :- optimizing, nonvar(A),clause(Z0,Z), !.
fold(_,Z,Z).

