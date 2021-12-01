:- op(1002,xfy,ror).
:- op(1001,xfy,rand).

odd :- 0 is random(2).

X ror  Y :- odd -> (X;Y) ; (Y;X).
X rand Y :- odd -> (X,Y) ; (Y,X).

macro(changeDelta(Now,Delta)) :-
	Vals1=[-1,0,1],
	Vals2=[-1,0,1],
	member(Old,Vals1),
	member(Now,Vals2),
	compare(Comp,Now,Old),
	delta1(Comp,Delta).

conflict(X,New) :-
	oldValue(X,Old),
	\+ New=Old.	
conflict(now(X),New) :-
	oldValue(X,Delta),
	\+ changeDelta(New,Delta).
conflict(X,Delta) :-
	X \= now(_),
	oldValue(now(X),New),
	\+ changeDelta(New,Delta).

assume(X,New) :- 
	oldValue(X,New), !.
assume(X,New) :- 
	conflict(X,New), !,
	fail.
assume(X,New) :- 
	hash_term(X,H),
	(asserta(val(H,X,New)) 
        ;retract(val(H,X,New)),  
         fail).

kbUp(X,Y,P) :-
	clause(kb1(X,Y,P),Goals),
	Goals.

kb(X,0,_) :-
	+thing(X,uds), !,
	((kbUp(X, 1,[]) -> A=1; A=0) rand
	 (kbUp(X,-1,[]) -> B=1; B=0)
        ),
	(A=1,B=1 % proved via competing influences
        ;A=0,B=0 % proved via isolation
        ).

kb(X,Y,_) :-	
	+in(X,Y).

kb(X,Y,Path) :-
	assume(X,Y),
	\+ member(X=Y,Path),
	%kbWatch(X,Y,Path),
	kb1(X,Y,[X=Y|Path]).

kbWatch(X,Y,P) :-
	watch(t),!, 
        length(P,L), 
        (mytab(L,'|    '), write('??'(X=Y)),nl
        ;mytab(L,'|    '), write('XX'(X=Y)),nl,fail
        ).
kbWatch(_,_,_).

mytab(N,C) :-
	forall(between(1,N,_),write(C)).
	
	
