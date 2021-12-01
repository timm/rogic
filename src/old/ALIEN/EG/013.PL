%% timing memberchk vs assert
:- +[lib/timer, lib/lists, lib/io].


memberchk_vs_assert :- 
	member(A,[10,20,30]),
        member(N,[10,20,30,40,50,60,70,80,90,100,1000,2500,5000]),
	doit(A,N),
	fail.
memberchk_vs_assert:- nl.


doit(A,N) :-
	nl,
	prin(settingUp),
	cprins([a,A,n,N]),
	randomList(N,L1),
	L1=[I1,I2,I3,I4|_],
	sort(L1,L1s),
	aItems(L1s,A,L2s),
	aAssertions(A,L1),
	length(L1s,Len1),
	cprins([len1,Len1,ready]),

	(getA(I1,It1),
         memberchk(I1-aa(I1,It1),L2s)
         %,nl, print(it1(It1)),
         %nl, print(it2(It2))
        -> cprin(ok)
        ;  cprin(error)),

	timeIt(getA(I1,_),T1),
	timeIt(getA(I2,_),T2),
	timeIt(getA(I3,_),T3),
	timeIt(getA(I4,_),T4),
	T5 is T1 + T2 + T3 + T4,

	timeIt(memberchk(I1-_,L2s),T6),
	timeIt(memberchk(I2-_,L2s),T7),
	timeIt(memberchk(I3-_,L2s),T8),
	timeIt(memberchk(I4-_,L2s),T9),
	T10 is T6 + T7 + T8 + T9,

	SpeedUp is integer((T10*100)/T5),
	cprins([memberchk/getA,SpeedUp]),
	!.

% XXX does it actually complete?
% reduce the variance

:- dynamic aa/2.
:- index(aa(1,0)).

aAssertions(A,L) :- 
	retractall(aa(_,_)),
	member(Id,L), 
	aAssertion(Id,A), 
	fail.
aAssertions(_,_).

aAssertion(Id,A) :-
	aItem(Id,A,I),
	assert(I).

aItem(Id,A,aa(Id,Assertion)) :-
	functor(Assertion,aa,A),
	arg(1,Assertion,Id),
	numbervars(Assertion,x,0,_).

aItems([],_,[]).
aItems([H|T],A,[H-Item|Rest]) :-
	aItem(H,A,Item),
	aItems(T,A,Rest).

getA(Id,A) :- aa(Id,A).

go :- watch(memberchk_vs_assert).
