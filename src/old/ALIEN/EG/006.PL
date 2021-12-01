%% timing set_member_chk vs asert
:- +[lib/timer, lib/lists, lib/io].


set_member_chk_vs_assert :- 
	member(A,[10,20,30,40,50]),
        member(N,[10,100,1000,2500,5000]),
	doit(A,N),
	fail.
set_member_chk_vs_assert :- nl.


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

	timeIt(getA(I1,_),T1),
	timeIt(getA(I2,_),T2),
	timeIt(getA(I3,_),T3),
	timeIt(getA(I4,_),T4),
	T5 is T1 + T2 + T3 + T4,

	timeIt(set_member_chk(I1-_,L2s),T6),
	timeIt(set_member_chk(I2-_,L2s),T7),
	timeIt(set_member_chk(I3-_,L2s),T8),
	timeIt(set_member_chk(I4-_,L2s),T9),
	T10 is T6 + T7 + T8 + T9,

	SpeedUp is integer((T10*100)/T5),
	cprins([set_member_chk/getA,SpeedUp]),
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

go :- watch(set_member_chk_vs_assert).
