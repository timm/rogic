:- dynamic        helper3/1, helper5/1, touch/3, what/2, blank/2.
:- discontiguous  helper3/1, helper5/1, touch/3, what/2, blank/2.

:- op(999,xf,(`)).
:- op(999,fx,(!)).

goal_expansion(is(A,B,C,C),is(A,B)).
goal_expansion(>=(A,B,C,C),>=(A,B)).
goal_expansion(>(A,B,C,C),>(A,B)).
goal_expansion(=(A,B,C,C),=(A,B)).
goal_expansion(/=(A,B,C,C),/=(A,B)).
goal_expansion(<(A,B,C,C),<(A,B)).
goal_expansion(<=(A,B,C,C),<=(A,B)).
goal_expansion(number(A,C,C),number(A)).

`(X/Z0/Z, T0,T) :- touch(T0,X,Z0,Z,T).
`(X+Y,    T0,T) :- touch(T0,X,Z0,Z,T), Z is Z0+Y.
`(+X,     T0,T) :- touch(T0,X,Z0,Z,T), Z is Z0+1.
`(X<<Y,   T0,T) :- touch(T0,X,Z,[Y|Z],T).
`(X = Y!, T0,T) :- touch(T0,X,_,Y,T).
`(X = Y,  T, T) :- touch(T,X,Y,Y,T).
`((X,Y),  T0,T) :- `(X,T0,T1), `(Y,T1,T).

helper(Spec,H) :- Spec =.. [F|_], atom_concat(F,'_',H).

defs(Spec,Out) :-
	helper(Spec,Helper),
	arg(_,Spec,Field),
	def(Spec,Field,Old,New,T0,T),
	Out =.. [Helper,Field,Old,New,T0,T].

defs(X,  blank(H,B)) :- helper(X,H), functor(X,F,A), functor(B,F,A).
defs(X,  helper3(T)) :- helper(X,H), functor(T,H,3).
defs(X,  helper5(T)) :- helper(X,H), functor(T,H,5).
defs(X, (touch(Blank,Y,V0,V,T) :- Accessor)) :-
	functor(X,F,A),
	functor(Blank,F,A),
	helper(X,H),
	Accessor =.. [H,Y,V0,V,Blank,T].

def(Spec,Field,Old,New,T0,T) :-
    functor(Spec,F, A), Spec =.. [F|Fields],
    functor(T0,  F, A), T0   =.. [F|L0],
    functor(T,   F, A), T    =.. [F|L1],
    def1(Fields,Field,Old,New,L0,L1).

def1([X|_],X,Y0,Y,[Y0|T],[Y|T]) :- !.
def1([_|Xs],X,Y0,Y,[H|T1],[H|T2]) :- def1(Xs,X,Y0,Y,T1,T2).

term_expansion(define(Spec),All) :- bagof(One,Spec^defs(Spec,One),All).



solo(X) :-  Y='$Z_', flag(Y,_,0), \+ solo1(Y,X), flag(Y,1,1).

solo1(Y,X) :- clause(X,_),flag(Y,N,N+1),N > 1,!.

clause1(X,Y) :- solo(X), clause(X,Y).

xpand(X,Y) :- what(H,T), xpand1(X,H,T,Y),!.

xpand1(X,_,_,                 Out) :- helper3(X), clause1(X,Out).
xpand1(X,_,_,                true) :- helper5(X), solo(X), X.
xpand1(`(X,T0,T),        H,T0,Out) :- Temp =.. [H,X,T0,T], xpand1(Temp,H,T0,Out).
xpand1(`(X,T0,T),        _,T0,Out) :- clause1(`(X,T0,T),Out).
xpand1(touch(T0,F,X,Y,T),_,T0,Out) :- clause1(touch(T0,F,X,Y,T),Out).

% change some rule before Prolog asserts it
%term_expansion(X,Out) :-
	%helper1(X),
	%term_expansion((X --> []),Out).

term_expansion((`X --> Y),Out) :-
	ecg((`X --> Y),Out).

term_expansion(`X,Out) :- ecg((`X --> []),Out).

ecg((`X --> Y),Out) :-
	functor(X,H,_),
	blank(H,Blank),
	retractall(what(_,_)),
	assert(what(H,Blank)),
	expand_term((X --> Y),Temp),
	tidy(Temp,Out),
	retractall(what(_,_)).

tidy(A,C) :- tidy1(A,B), (B=(H :- true) -> C=H; C=B).

tidy1(A,C) :- once(tidy2(A,C)).

tidy2(A,             A) :- var(A). 
tidy2((A,B),    (A,TB)) :- var(A), tidy1(B,TB).
tidy2((A,B),    (TA,B)) :- var(B), tidy1(A,TA).
tidy2(((A,B),C),     R) :- tidy1((A,B,C), R).
tidy2((true,A),      R) :- tidy1(A,R).
tidy2((A,true),      R) :- tidy1(A,R).
tidy2((A;true),      R) :- tidy1(A,R).
tidy2((true;A),      R) :- tidy1(A,R).
tidy2((A;B),   (TA;TB)) :- tidy1(A,TA), tidy1(B,TB).
tidy2((A->B), (TA->TB)) :- tidy1(A,TA), tidy1(B,TB).
tidy2(not(A),  not(TA)) :- tidy1(A,TA).
tidy2((A :- B), R) :-
	tidy1(B,TB),(TB=true-> R=A; R=(A:-TB)).
tidy2((A,B),  R)   :-
	tidy1(A,TA), tidy1(B,TB),(TB=true -> R=TA; R=(TA,TB)).
tidy2(A,A).

goal_expansion(A,B) :- xpand(A,B).
