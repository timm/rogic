:- op(1002,xfy,ror).
:- op(1001,xfy,rand).
:- dynamic val/2,in/2,best/1.

odd :- 0 is random(2).

X ror  Y :- odd -> X   ; Y.
X rand Y :- odd -> X,Y ; Y,X.

assume(X,Y) :- in(X,Z), !,Y=Z. %q: what about outs?
assume(X,Y) :- val(X,Z),!,Y=Z.
assume(X,Y) :- assert(val(X,Y)).
assume(X,Y) :- retract(val(X,Y)), fail.

% termination condition?
kb(X,std,P) :- 
	type(X,uds), !,
	((kb(X, 1,P) -> A=1; A=0) rand
	 (kb(X,-1,P) -> B=1; B=0)
        ),
	(A=1,B=1 % proved via competing influences
        ;A=0,B=0 % proved via isolation
        ).

kb(X,Y,Path) :-
	in(X,Y).
kb(X,Y,Path) :-
	assume(X,Y),
	\+ member(X=Y,Path),
	kb1(X,Y,[X=Y|Path]).


