do(true).
do(no (X,Y))     :- do((no X; no Y)).
do(no (X;Y))     :- do((no X, no Y)).
do(no no X)      :- do(X).
do((X,Y))        :- asList((X,Y),L), do(L).
do((X;Y))        :- asList((X;Y),L), do(L).
do(and([],   _)).
do(and([H|T],N)) :- any(and([H|T],N),One,Next), do(One), do(Next).
do(or( [],   _)).
do(or( [H|T],N)) :- any(or([H|T],N),One,_), do(One).
do(?X)           :- match(X,Ys), !, select(Ys,Y), do(Y).
do(no ?X)        :- assume(X,f).
do(?X)           :- assume(X,t).

match(X,Xs)  :-
	bagof(One/Where,X^clause(X,One,Where),Xs).
select(Ys,Y) :-
	any(Ys,Y/Z),
	do(?used(Z)). 
assume(I,O)  :-
	memo(I,Old)
        -> O=Old
        ;  bassert(memo(I,O)).

bassert(X) :- assert(X).
bassert(X) :- retract(X),fail.

wme(memo(_,_)).
wme(used(_)).

zap :- wme(X), retract(X), fail.
zap.

report :-
	setof(X,(wme(X), X),L),
	checklist(report1,L).

report1(memo(used(X),t)) :- !,
	clause(A,B,X),
	portray_clause((A :- B)).
report1(X) :-
	format('~w.\n',[X]).

run(Goals) :-
	zap,
	do(Goals),
	recordBest.
runs(Tries,Goals) :- 
	forall(between(1,Tries,_),
	run(Goals)).

recordBest.


