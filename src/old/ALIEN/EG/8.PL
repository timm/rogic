:- +[lib/timer, lib/lists, lib/io, lib/btree].

set_member_chk_lt_btree :- 
	member(A,[10,20,30]),
        member(N,[10,20,30,40,50,60,70,80,90,100,1000,2500,5000]),
	doit(A,N),
	fail.
set_member_chk_lt_btree :- nl.

kv(X,X=x(X)).

doit(A,N) :-
	nl,
	prin(settingUp),
	cprins([a,A,n,N]),
	randomList(N,L1),
	L1=[I1,I2,I3,I4|_],
	sort(L1,L1s),
	maplist(kv,L1s,KVs),
	cprin(l2tin),
	l2t(KVs,_,BTree),
	cprin(l2tout),
        aItems(L1s,A,L2s),
	length(L1s,Len1),
	cprins([len1,Len1,ready]),

	timeIt(bfind(I1,_,BTree,_),T1),
	timeIt(bfind(I2,_,BTree,_),T2),
	timeIt(bfind(I3,_,BTree,_),T3),
	timeIt(bfind(I4,_,BTree,_),T4),
	T5 is T1 + T2 + T3 + T4,

	timeIt(set_member_chk(I1=_,L2s),T6),
	timeIt(set_member_chk(I2=_,L2s),T7),
	timeIt(set_member_chk(I3=_,L2s),T8),
	timeIt(set_member_chk(I4=_,L2s),T9),
	T10 is T6 + T7 + T8 + T9,

	SpeedUp is integer((T10*100)/T5),
	cprins([set_member_chk/bfind,SpeedUp]),
	!.

aItem(Id,A,aa(Id,Assertion)) :-
	functor(Assertion,aa,A),
	arg(1,Assertion,Id),
	numbervars(Assertion,x,0,_).

aItems([],_,[]).
aItems([H|T],A,[H=Item|Rest]) :-
	aItem(H,A,Item),
	aItems(T,A,Rest).

go :- watch(set_member_chk_lt_btree).
