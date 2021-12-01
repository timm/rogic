term_expansion(X = Y,Out) :-
	bagof(Z,X^Y^access(X=Y,Z),Out).

access(Handle = Wme,(portray(Term) :-
	               write(Handle))) :-
	functor(Wme,Functor,Arity),
	functor(Term, Functor,Arity).	
access(Handle = Wme,Out) :-
	functor(Wme,  Functor,Arity),
	arg(Pos,Wme,Item),
        joinArgs(1,Arity,Pos,L1,Old,New,L2),
        Term1 =.. [Functor|L1],
        Term2 =.. [Functor|L2],
	Out   =.. [Handle,Item,Old,New,Term1,Term2].

joinArgs(M,N,_,[],_,_,[]) :- M > N,!.
joinArgs(N,Max,N,[Old|In],Old,New,[New|Out]) :- !,
	N1 is N + 1,
        joinArgs(N1,Max,N,In,Old,New,Out).
joinArgs(N0,Max,N,[X|L0],Old,New,[X|L]) :-
	N1 is N0 + 1,
	joinArgs(N1,Max,N,L0,Old,New,L).

term_expansion((o X --> Y), Out) :- 
	retractall(me(_)),
	functor(X,F,_),
	assert(me(F)),
	expand_term((X --> Y),Out).

% tricks that can be defined in terms of recursive expands to o/3
goal_expansion(o([A],X,Y),     o(A,X,Y)) :- nonvar(A).
goal_expansion(o([A,B|T],X,Y),(o(A,X,Z),o([B|T],Z,Y))) :- nonvar(A).
goal_expansion(o(A has B,X,Y),(o(A = L,X,Y),member(B,L))).
goal_expansion(o(A \=  B,X,Y),(o(A=C,X,Y),C \= B)).

% the base case for expanding o/3
goal_expansion(o(X,Y,Z),Term) :- swaps3(X,Y,Z,Term).

% accessors that call on the structure stored in me/5
goal_expansion(o(fresh,_,X),true) :- blank(X).
goal_expansion(o(fetch,X,X),X)    :- blank(X).

% accessors that need both the old and new values
% i.e. that use o/5
goal_expansion(o(A =  B,X,Y),T) :- swaps5(A,B,B,X,Y,T).
goal_expansion(o(A := B,X,Y),T) :- swaps5(A,_,B,X,Y,T).
goal_expansion(o(+A,    X,Y),(T,C is B +1)) :- swaps5(A,B,C,X,Y,T).
goal_expansion(o(-A,    X,Y),(T,C is B -1)) :- swaps5(A,B,C,X,Y,T).
goal_expansion(o(A << B,X,Y),T) :- swaps5(A, Old,    [B|Old],X,Y,T).
goal_expansion(o(A >> B,X,Y),T) :- swaps5(A,[B|Rest],Rest,   X,Y,Term).

% support code
blank(X) :-
	me(F),
	Get =.. [F,_,_,_,_,X],
	once(Get).
swaps3(A,X,Y,Z) :-
	nonvar(A),
	me(F),
	Z0 =.. [F,A,X,Y],
	lint(F,A,Z0),
	faster(Z0,Z).
swaps5(A,B,C,X,Y,Z) :- 
	nonvar(A),
	me(F),
	Z =.. [F,A,B,C,X,Y],
	lint(F,A,Z).

:- dynamic linting/0, optimizing/0.

optimizing. linting.
	
lint(F,A,Z) :-
	linting,
	\+ clause(Z,_),
	source_location(File, Line),
	file_base_name(File,Base),
        format('%HUH? ''~w.~w'' at ''~w'', near line ~w\n',
              [F,A,Base,Line]),
        !.
lint(_,_,_).

faster(Z0,Z) :- optimizing, clause(Z0,Z), !.
faster(Z,Z).

/*
a=b(c,d,kk).
o a(g) --> {print(2)}.
o a(f) --> o g, {print(1)}.
o a(1) --> o [fresh,blah=40,c=2,
	d := 23,+c,f,l,kk << 22,
	kk >> 10,
	kk has fred, fetch].

%HUH? 'a.blah' at 'd.pl', near line 25
%HUH? 'a.l' at 'd.pl', near line 25

?- listing(a).

a(g, A, B) :-
        print(2),
        B=A.
a(f, A, B) :-
        print(2),
        C=A,
        print(1),
        B=C.
a(1, A, b(B, C, D)) :-
        true,
        a(blah, 40, 40, b(E, F, G), H),
        a(c, 2, 2, H, I),
        a(d, J, 23, I, K),
        a(c, L, M, K, N),
        M is L+1,
        print(2),
        O=N,
        print(1),
        P=O,
        a(l, P, Q),
        a(kk, R, [22|R], Q, S),
        a(kk, [10|T], T, S, U),
        a(kk, V, V, U, b(B, C, D)),
        member(fred, V),
        b(B, C, D).

a(c, A, B, b(A, C, D), b(B, C, D)).
a(d, A, B, b(C, A, D), b(C, B, D)).
a(kk, A, B, b(C, D, A), b(C, D, B)).

*/