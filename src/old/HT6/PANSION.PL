term_expansion(def(F,A,L),Out) :-
	bagof(One,F^A^L^defWme(F,A,L,One),Out).

defWme(Functor,_,Fields,X) :-
        length(Fields,Arity),
	nth1(N,Fields,Name is Default),
	functor(In, Functor,Arity),
	functor(Out,Functor,Arity),
	joinArgs(N,Old,New,In,Out),
	X =.. [Functor,Name,Old,New,Default,In,Out].
defWme(Functor,_,Fields,
       (portray(X) :- nonvar(X),X=Y,
                      write(workingMemory(Functor)))) :-
	length(Fields,Arity),
	functor(Y,Functor,Arity).
defWme(_,A,_,(:- op(999,fx,A))).
defWme(Functor,Access,Fields, (touch(Wme0,Action,Wme1)  :- Do)) :-
	length(Fields,Arity),
	functor(Wme0, Functor,Arity),
	Do =.. [Access,Action,Wme0,Wme1].
defWme(Functor,Access,_, (goal_expansion(Goal,Xpand) :- nonvar(A))) :-	
	Goal=..   [Access,A is B,In,Out],
        Xpand =.. [Functor,A,_,B,_,In,Out].
defWme(Functor,Access,_, (goal_expansion(Goal,Xpand) :- nonvar(A))) :-	
	Goal=..   [Access,A = B,In,Out],
        Xpand =.. [Functor,A,B,B,_,In,Out].
defWme(Functor,Access,_, (goal_expansion(Goal,Xpand) :- nonvar(A))) :-	
	Goal=..   [Access,A ^ B ^ C,In,Out],
        Xpand =.. [Functor,A,B,C,_,In,Out].
defWme(Functor,Access,Fields,Out) :-
	clause('#S'(A,B,C),D),
	runiv(('#S'(A,B,C) :- D),
                ['#F'/Functor
                ,'#I'/Fields
                ,'#S'/Access
                ],Out).

joinArgs(N,Old,New,T1,T2) :-
    T1 =.. [_|L0],
    T2 =.. [_|L],
    joinArgs(1,N,L0,Old,New,L).
joinArgs(N,N,[Old|Rest],Old,New,[New|Rest]).
joinArgs(N0,N1,[X|L0],Old,New,[X|L]) :-
    N0 < N1,
    N2 is N0 + 1,
    joinArgs(N2,N1,L0,Old,New,L).

'#S'(new)      --> '#S'('#I').
'#S'(X is A)   --> '#F'(X,_,A,_).
'#S'(reset(X)) --> '#F'(X,_,A,A).
'#S'(X=A)      --> '#F'(X,A,A,_).
'#S'(X ^ A ^ B) --> '#F'(X,A,B,_).
'#S'(+ X)      --> '#F'(X,Y,Z,_), {Z is Y + 1}.
'#S'(- X)      --> '#F'(X,Y,Z,_), {Z is Y - 1}.
'#S'(X >= Y)   --> '#F'(X,Z,Z,_), {Z >= Y}.
'#S'(X >  Y)   --> '#F'(X,Z,Z,_), {Z >  Y}.
'#S'(X <  Y)   --> '#F'(X,Z,Z,_), {Z <  Y}.
'#S'(X =< Y)   --> '#F'(X,Z,Z,_), {Z =< Y}.
'#S'(X << H)   --> '#F'(X,T,[H|T],_).
'#S'(X >> H)   --> '#F'(X,[H|T],T,_).
'#S'([])       --> [].
'#S'([H|T])    --> '#S'(H), '#S'(T).
'#S'(show)     --> {nl}, '#S'(numbervars), '#S'(X=Y),{format('~12P = ~w\n',[X,Y]),fail}.
'#S'(show)     --> [].
'#S'(numbervars,W,W) :- numbervars(W,0,_).
'#S'(W0/W,W0,W).

term_expansion(( ?X = Y  --> Z),Out) :- 
	xpand((?X = Y --> Z),Out).

%-------------------------------------

goal_expansion(dec(M,N),(M > 0, N is M - 1)).
goal_expansion(rand(X,Y,A,B),do(rand(Out),A,B)) :- r2l(X rand Y,Out).
goal_expansion(ror(X,Y,A,B),  do(ror(Out),A,B)) :- r2l(X ror  Y,Out).

r2l(X ror Y,   [X|Rest]) :- !, r2l(Y,Rest).
r2l(X rand Y,  [X|Rest]) :- !, r2l(Y,Rest).
r2l(X,         [X]).

xpand((?In = Out --> Y),[(def(In,Out,W0,W) :- Body)]) :-
	appendl(In,Out,All),
	X =.. All,
	expand_term((X --> Y),(Head :- Body)),
	Head =.. L,
	append(_,[W0,W],L).

appendl(X0,Y0,L) :- 
	asList(X0,X),
	asList(Y0,Y), 
	append(X,Y,L).
