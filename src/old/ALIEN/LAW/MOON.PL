:- [ops,basic].

% descretise the variables

:- Stuff= (used/3,numberLine/2),
   (discontiguous Stuff),
   (dynamic       Stuff).

inf(X) :- X is 2^30.
ninf(Y) :- inf(X), Y is -1*X.

output(*).

spock(X) :-
	format('%Hope you ran "moonc ~a" first\n',[X]),
	asString('eg/th/~p/vulcan.pl',[X],One),
	asString('eg/th/~p/vulcan1.pl',[X],Two),
	load_files([One,Two],[silent(true)]).
	
term_expansion(* N if X then Y,Out) :-
	fix(* N if X then Y,N,Out).

fix(X               , N,_) :-  var(X),!,print(fail(varin(N))), fail.
fix(*N if X0 then Y0, Id,*N if X then Y):- !,fix(X0,Id,X),fix(Y0,Id,Y).
fix(X0 and Y0       , N,X and Y       ) :- !,fix(X0,N,X),fix(Y0,N,Y).
fix(X0 or Y0        , N,X or  Y       ) :- !,fix(X0,N,X),fix(Y0,N,Y).
fix(not X0          , N,not X         ) :- !,fix(X0,N,X).
fix(X0              , _,X             ) :-  mathsOp(X0,X),!.
fix(X               , _,X).

mathsOp(X,Sym) :-
	maths(X,_,_,_,used(A,B)),
	asString('~w',[B],Sym),
	ensure(used(A,B,Sym)).

maths(A>=B  , A,>=,B, used(A, A >= B)).
maths(A>B   , A,> ,B, used(A, A >B)  ).
maths(A is B, A,is,B, used(A, A is B)). 
maths(A=<B  , A,=<,B, used(A, A =< B)).
maths(A<B   , A,< ,B, used(A, A<B)   ).

generateDefs :-
	used(_,_,X),
	ensure(* boolean are [X]),
	fail.
generateDefs.

generateNumberLines :-
	retractall(numberLine(_,_)),
	mathsAttribute(Attr),
       	keyPoints(Attr,Points),
	ensure(numberLine(Attr,Points)),
	fail.
generateNumberLines.

mathsAttribute(Attr) :-
	setof(A,X1^X2^used(A,X1,X2), All),
	member(Attr,All).

keyPoints(A,All) :- setof(One, A^keyPoint(A,One), All).
keyPoint(_,X)    :- inf(X).
keyPoint(_,X)    :- ninf(X).
keyPoint(A,   X) :- used(A,Op,_), maths(Op,A,_,X,_).

oneOfs(Attr,All) :-
	ninf(F),
	Comp=(Attr>=F),
	bagof(One,Comp^aka(Comp,One),All).

% reverse as well
akas(Out) :- akas(Out,_).
akas(Out,Attr) :-
	mathsAttribute(Attr),
	oneOfs(Attr,All),
	(Out=(*range(Attr) are oneOf= All)
        ; Out=(*range(Attr) are [Attr])).
akas(Out,Attr) :-
	mathsAttribute(Attr),
	used(Attr,Comp,X),
	bagof(One,Comp^aka(Comp,One),Parts),
	mathsOr(Parts,Attr,Ors),
	( flag(aka,N,N+1),
          Out=(* aka(N) if Ors then X)
        ; flag(aka,N,N+1),
          Out=(* aka(N) if not Ors then not X) 
                      % legal since no
                      % other way to prove not X
        ).

mathsOr([X],A,A=X).
mathsOr([X,Y|Z],A,A=X or Rest) :- mathsOr([Y|Z],A,Rest).

aka(Comp,Part) :-
	maths(Comp,Attr,Op,Value,_),
	numberLine(Attr,Line),
	append(Lhs,[Value|Rhs],Line),
	aka1(Op,Lhs,Value,Rhs,Part).

aka1(=,   _Lhs, Value,  _Rhs,Value) :- print(warn(=)),nl.
aka1(is,  _Lhs, Value,  _Rhs,Value).
aka1(>,   _Lhs, _Value, Rhs, X         ) :- aka2([Value|Rhs],X), X \= Value.
aka1(>=,  _Lhs, Value,  Rhs, X         ) :- aka2([Value|Rhs],X).
aka1(<,    Lhs, Value,  _Rhs,X         ) :- append(Lhs,[Value],L), aka2(L,X), X \= Value.
aka1(=<,   Lhs, Value,  _Rhs,X         ) :- append(Lhs,[Value],L), aka2(L,X).

aka2(List,Item          ) :- 
	member(Item,List), \+inf(Item), \+ninf(Item).
aka2(List,One .. Two):- oneTwo(List,One,Two).
	
	
 
	






