:- dynamic optimizing/0.
optimizing.

% expansion magic
term_expansion(Functor=Fields,Out) :-
        makeAccessors(Functor=Fields,Out).

makeAccessors(X,Out) :-
        bagof(One,X^makeAccessor(X,One),Out).

makeAccessor(Op=Fields,Out) :-
	atom_concat(Op,0,Functor),
	length(Fields,Arity),
	functor(Term,Functor,Arity),
	(touch(Functor,Arity,Fields,Op,Out)
        ;magic(M),
	 runiv(M,[oP/Op
                ,terM/Term
                ,aritY/Arity
                ,functoR/Functor
                ,fieldS/Fields
                ],Out)).

% var stuff
touch(F,A,All,Op,Out) :- 
        functor(Term1,F,A),
        functor(Term2,F,A),
        nth1(Pos,All,Item),
        joinArgs(Pos,Old,New,Term1,Term2),
	Out =.. [Op,Item,Old,New,Term1,Term2].

joinArgs(N,Old,New,T1,T2) :-
        T1 =.. [_|L0],
        T2 =.. [_|L],
        joinArgs(1,N,L0,Old,New,L).
joinArgs(N,N,[Old|Rest],Old,New,[New|Rest]).
joinArgs(N0,N1,[X|L0],Old,New,[X|L]) :-
        N0 < N1,
        N2 is N0 + 1,
        joinArgs(N2,N1,L0,Old,New,L).

% some magic
magic((:- discontiguous oP/3)).
magic((:- op(999,fx,oP))).
magic((portray(X) :- 
	  nonvar(X),
	   X=terM,
           write(functoR/aritY))).
magic((oP(X,Y,Z) :- Body)) :-
	clause(oP(X,Y,Z),Body).
magic((goal_expansion(X,Y) :- Z)) :-
	member(F/A,[oP/5,oP/3]),
	functor(X,F,A),
	clause(goal_expansion(X,Y),Z).

% primitives
oP(X is A) --> oP(X,_,A).
oP(X =  A) --> oP(X,A,A).
oP([])     --> [].
oP([H|T])  --> oP(H), oP(T).

% lint magic
goal_expansion(oP([],A,A),true).
goal_expansion(oP([H|T],A,B),(oP(H,A,C),oP(T,C,B))).

goal_expansion(oP(Attr,_,_,_,_),_) :-
        nonvar(Attr),
        \+ oP(Attr,_,_,_,_),
        source_location(File, Line),
        format('E> ~w, near line ~w\n\t~w::~w is an unknown attribute\n',
               [File,Line,oP,Attr]),
        fail.

goal_expansion(oP(Op,_,_),_) :-
        nonvar(Op),
        \+ clause(oP(Op,_,_),_),
        source_location(File, Line),
        functor(Op,Functor,Arity),
        format('E> ~w, near line ~w\n\t ~w::~w is an unknown operation\n',
               [File, Line,oP,Functor/Arity]),
        fail.

% optimizing
goal_expansion(oP(X,Y,Z),Out) :-
        optimizing,
        clause(oP(X,Y,Z),Out).

