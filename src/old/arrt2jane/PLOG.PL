:- + [olog].

:- X=(nofold/2,(<--)/2), discontiguous(X),multifile(X), dynamic(X).
:- dynamic linting/0, optimizing/0.

optimizing. linting. 

term_expansion(-F::Term,nofold(F,Term)) :- !.
term_expansion(- ::Term,nofold(F,Term)) :- !, me(F).
term_expansion( F :: Head,Out) :- 
	term_expansion((F :: Head <-- []),Out).
term_expansion(:: Head,Out) :-
	me(F),
	term_expansion((F :: Head <-- []),Out).
term_expansion(( :: Head <-- Body), Out) :-
	me(F),
	term_expansion((F :: Head <-- Body),Out).
term_expansion((F :: Head0 <-- Body), Out) :- !,
	retractall(me(_)),
	assert(me(F)),
	Head =.. [F,Head0],
	expand_term((Head --> Body),Out).
term_expansion((Head <-- Body),Out) :-
	term_expansion((:: Head <-- Body),Out).
	
goal_expansion(::(X,Y,Z), ::(F,X,Y,Z)) :- me(F).

goal_expansion(::(F,X,Y,Z),Out) :- var(X), !,Out =.. [F,X,Y,Z].
goal_expansion(::(_,{X},Y,Y),X) :- nonvar(X).

% tricks that can be defined in terms of recursive expands to o/3
goal_expansion(::(F,[A],X,Y),     ::(F,A,X,Y)).
goal_expansion(::(F,[A,B|T],X,Y),(::(F,A,X,Z),::(F,[B|T],Z,Y))).
goal_expansion(::(F,A has B,X,Y),(::(F,A = L,X,Y),member(B,L))).
goal_expansion(::(F,A \=  B,X,Y),(::(F,A=C,X,Y),C \= B)).

% accessors that call on the structure stored in me/5
goal_expansion(::(F,fresh,_,X),true) :- blank(F,X).
goal_expansion(::(F,fetch,X,X),X)    :- blank(F,X).

% accessors that need both the old and new values
% i.e. that use o/5
goal_expansion(::(F,A =  B,X,Y),T) :- swaps5(F,A,B,B,X,Y,T).
goal_expansion(::(F,A := B,X,Y),T) :- swaps5(F,A,_,B,X,Y,T).
goal_expansion(::(F,+A,    X,Y),(T,C is B +1)) :- swaps5(F,A,B,C,X,Y,T).
goal_expansion(::(F,-A,    X,Y),(T,C is B -1)) :- swaps5(F,A,B,C,X,Y,T).
goal_expansion(::(F,A << B,X,Y),T) :- swaps5(F,A, Old,    [B|Old],X,Y,T).
goal_expansion(::(F,A >> B,X,Y),T) :- swaps5(F,A,[B|Rest],Rest,   X,Y,T).

% the base case for expanding o/3: must go last
goal_expansion(::(F,X,Y,Z),Term) :- mine(F),   swaps3(F,X,Y,Z,Term).
goal_expansion(::(F,X,Y,Y),Term) :- \+ mine(F),swaps1(F,X,Term).

% support code
mine(X) :- nonvar(X), me(X).
blank(F,X) :- Get =.. [F,_,_,_,_,X], once(Get). 
swaps1(F,A,        Z) :- Z  =.. [F,A,    _,_], lint(F,A,Z).
swaps3(F,A,    X,Y,Z) :- Z0 =.. [F,A,    X,Y], lint(F,A,Z0), fold(F,A,Z0,Z).
swaps5(F,A,B,C,X,Y,Z) :-
	mine(F),
	Z  =.. [F,A,B,C,X,Y], lint(F,A,Z).
swaps5(F,A,B,C,X,X,Z) :-
	\+ mine(F),
	Z  =.. [F,A,B,C,_,_], lint(F,A,Z).

lint(F,A,Z) :-
	linting,
	nonvar(A),
	\+ clause(Z,_),
	source_location(File, Line), file_base_name(File,Base),
	functor(A,Functor,Arity),
        format('%W> ~w.~w unknown  at ~w, near line ~w\n',
              [F,Functor/Arity,Base,Line]),!.
lint(_,_,_).

fold(F,A,Z0,Z) :-
	optimizing,
	nonvar(A),
	\+ nofold(F,A),
	clause(Z0,Z),
	!.
fold(_,_,Z,Z).



