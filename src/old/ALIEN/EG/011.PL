%% timing btree vs member
:- +[lib/timer, lib/lists, lib/io, lib/btree].


btree_vs_member :- 
	member(A,[10,20,30]),
        member(N,[10,30,60,70,80,90,100,1000,2500,5000]),
	doit(A,N),
	fail.
btree_vs_member:- nl.

kv(A,X,X=Thing) :- aItem(X,A,aa(_,Thing)).

doit(A,N) :-
	nl,
	prin(settingUp),
	cprins([a,A,n,N]),
	randomList(N,L1),
	L1=[I1,I2,I3,I4|_],
	sort(L1,L1s),

	maplist(kv(A),L1s,KV1s),
	cprin(l2tin),
	l2t(KV1s,_,BTree),
	cprin(l2tout),
	length(L1s,Len1),
	
	(member(I1=_,KV1s),
	 bfind(I1,_,BTree,_)
        -> cprin(ok)
        ;  cprin('ERROR')),

	cprins([len1,Len1,ready]),

	timeIt(member(I1=_,KV1s),T1),
	timeIt(member(I2=_,KV1s),T2),
	timeIt(member(I3=_,KV1s),T3),
	timeIt(member(I4=_,KV1s),T4),
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
	cprins([bfind/member,SpeedUp]),
	!.

aItem(Id,A,aa(Id,Assertion)) :-
	functor(Assertion,aa,A),
	arg(1,Assertion,Id),
	numbervars(Assertion,x,0,_).

go :- watch(btree_vs_member).
