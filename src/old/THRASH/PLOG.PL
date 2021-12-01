:- load_files([ops,olog,config],[silent(true),if(changed)]).

:- dynamic me/1,linting/0,foldable/2.
:- discontiguous foldable/2.

xpand((X,Y :- Z),[:- discontiguous(X/3),Out]) :-
	retractall(me(_)),
	assert(me(X)),
	xpand1(X,Y,Z,Out),
	retractall(me(_)).

xpand1(X,Y,Z,Out) :-
	Head0 =.. [X,Y],
	expand_term((Head0 --> Z),Expanded),
	(Expanded = (Head :- Body0)
         -> tidy_body(Body0,Body),
            (Body==true
	          -> Out=Head
	          ;  Out=(Head :- Body))
        ;   Out= Expanded).

xpandme(X,(`(Before,In,Temp),Y,`(After,Temp,Out))) :-
  functor(X,F,A0),
  A is A0 - 2,
  known(F,A),
  X =.. L0,
  append(Left0,[In,Out],L0),
  wrap(Left0,Before,[],After,[],Left),
  Y =.. Left.

swaps1(F,A,        Z) :-
	Z  =.. [F,A,_,_],
	lint(F,A,Z).
swaps3(F,A,    X,Y,Z) :-
	Z0 =.. [F,A, X,Y],
	lint(F,A,Z0),
	fold(A,Z0,Z).
swaps5(F,A,B,C,X,Y,Z) :-
	Z  =.. [F,A,B,C,X,Y],
	lint(F,A,Z).

lint(F,A,Z) :-
	linting,
	nonvar(A),
	\+ clause(Z,_),
	source_location(File, Line), file_base_name(File,Base),
        format('%HUH? ''~w.~w'' at ''~w'', near line ~w\n',
              [F,A,Base,Line]),!.
lint(_,_,_).

fold(A,Z0,Z) :- nonvar(A),me(F),foldable(F,A),clause(Z0,Z), !.
fold(_,Z,Z).

wrap(X0,BeforeActions,AfterActions,X) :-
	wrap(X0,BeforeActions,[],AfterActions,[],X).

wrap([],B,B,A,A,[]).
wrap([ H|T0],B0,B,A0,A,[H|T]) :-
	var(H),
	!,
	wrap(T0,B0,B,A0,A,T).
wrap([?(H)|T0],[>>(H,V)|B0],B,A0,A,[V|T])  :-
	!,
	wrap(T0,B0,B,A0,A,T).
wrap([!(H)|T0], B0,B, [<<(H,V)|A0],A,[V|T]) :-
	!,
	wrap(T0,B0,B,A0,A,T).
wrap([H|T0], B0,B, A0,A,[H |T]) :-
	atomic(H),
	!,
	wrap(T0,B0,B,A0,A,T).
wrap([H0|T0], B0,B, A0,A,[H|T]) :-
	!,
	wrap(H0,B0,B1,A0,A1,H),
	wrap(T0,B1,B, A1,A,T).
wrap(In,B0,B,A0,A,Out) :-
	\+ atomic(In),
	In =.. L0,
	wrap(L0,B0,B,A0,A,L),
	Out =.. L.

tidy_body(A, A)             :- var(A), !.
tidy_body((A,B), (A, TB))   :- var(A), !, tidy_body(B, TB).
tidy_body((A,B), (TA, B))   :- var(B), !, tidy_body(A, TA).
tidy_body(((A,B),C), R)     :- !, tidy_body((A,B,C), R).
tidy_body((true,A), R)      :- !, tidy_body(A, R).
tidy_body((A,true), R)      :- !, tidy_body(A, R).
tidy_body((A,B), (TA, TB))  :- !, tidy_body(A, TA), tidy_body(B, TB).
tidy_body((A;B), (TA; TB))  :- !, tidy_body(A, TA), tidy_body(B, TB).
tidy_body((A->B), (TA->TB)) :- !, tidy_body(A, TA), tidy_body(B, TB).
tidy_body(A, A).

term_expansion((X,Y),Out) :-
	term_expansion((X,Y :- []),Out).
term_expansion((X,Y,inline :-  Z),[foldable(X,Y)|Out]) :- !,
	term_expansion((X,Y :- Z),Out).
term_expansion((X,Y :- Z),Out) :-
	xpand((X,Y :- Z),Out).

goal_expansion(`(X,Y,Z),`(F,X,Y,Z)) :-
	me(F).
goal_expansion(`(_,A,X,X), true) :-
	A == [].
goal_expansion(`(F,[A|T],X,Y),(`(F,A,X,Z),`(F,T,Z,Y))) :-
	nonvar(A).
goal_expansion(`(F,X,Y,Z),Term) :- var(X),!,
	Term =.. [F,X,Y,Z]. % cant use swaps3 since we cant lint or fold
                            % variables
goal_expansion(`(F,>>(A,B),X,Y),Out) :-
	swaps5(F,A,B,B,X,Y,Term),
	(var(A) -> Out=Term ; Term, Out=true).
goal_expansion(`(F,<<(A,B),X,Y),Out) :-
	swaps5(F,A,_,B,X,Y,Term),
	(var(A) -> Out=Term ; Term, Out=true).
goal_expansion(`(F,X,Y,Z),Term) :-
	me(F),
	swaps3(F,X,Y,Z,Term).
goal_expansion(`(F,X,Y,Y),Term) :-
	\+ me(F),
	swaps1(F,X,Term).
% should be loaded as late as possible since EVERYTHING
% loaded after this will be passed through this goal_expansion
goal_expansion(X,Out) :-
	me(_),
	xpandme(X,Out).

/*now why did i need this exactly??
mine(X) :-
	nonvar(X),
	me(X).*/