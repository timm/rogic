%% timing btree vs assert
:- +[lib/timer, lib/lists, lib/io, lib/btree].

btree_vs_assert :- 
	member(A,[10,20,30]),
        member(N,[10,50, 60,70,80,90,100,300,600,1000,2500,5000]),
	doit(A,N),
	fail.
btree_vs_assert:- nl.

kv(A,X,X=Thing) :- aItem(X,A,aa(_,Thing)).

doit(A,N) :-
	nl,
	prin(settingUp),
	cprins([a,A,n,N]),
	randomList(N,L1),
	L1=[I1,I2,I3,I4|_],
	sort(L1,L1s),

	maplist(kv(A),L1s,KVs),
	cprin(l2tin),
	l2t(KVs,_,BTree),
	cprin(l2tout),

	aAssertions(A,L1),
	length(L1s,Len1),
	cprins([len1,Len1,ready]),

	(bfind(I1,It,BTree,_),
         getA(I1,It)
         -> cprin(ok)
         ;  cprin(error)),

	timeIt(getA(I1,_),T1),
	timeIt(getA(I2,_),T2),
	timeIt(getA(I3,_),T3),
	timeIt(getA(I4,_),T4),
	T5 is T1 + T2 + T3 + T4,

	/*print(I1),
	bprint(BTree),
	bfind(I1,_,BTree,B1),
	bprint(B1),
*/
	timeIt(bfind(I1,_,BTree,_),T6),
	timeIt(bfind(I2,_,BTree,_),T7),
	timeIt(bfind(I3,_,BTree,_),T8),
	timeIt(bfind(I4,_,BTree,_),T9),
	T10 is T6 + T7 + T8 + T9,

	SpeedUp is integer((T10*100)/T5),
	cprins([bfind/getA,SpeedUp]),
	!.

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

go :- watch(btree_vs_assert).
