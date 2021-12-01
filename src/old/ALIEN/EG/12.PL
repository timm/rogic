:- +[lib/timer, lib/lists, lib/io, lib/btree].


memberchk_vs_member :- 
	member(A,[10,20,30]),
        member(N,[10,30,60,70,80,90,100,1000,2500,5000,10000]),
	doit(A,N),
	fail.
memberchk_vs_member:- nl.

kv(A,X,X=Thing) :- aItem(X,A,aa(_,Thing)).

doit(A,N) :-
	nl,
	prin(settingUp),
	cprins([a,A,n,N]),
	randomList(N,L1),
	L1=[I1,I2,I3,I4|_],
	sort(L1,L1s),

	maplist(kv(A),L1s,KV1s),
	length(L1s,Len1),
	
	(member(I1=_,KV1s),
	memberchk(I1=_,KV1s)	
        -> cprin(ok)
        ;  cprin('ERROR')),

	cprins([len1,Len1,ready]),

	timeIt(member(I1=_,KV1s),T1),
	timeIt(member(I2=_,KV1s),T2),
	timeIt(member(I3=_,KV1s),T3),
	timeIt(member(I4=_,KV1s),T4),
	T5 is T1 + T2 + T3 + T4,

	timeIt(memberchk(I1=_,KV1s),T6),
	timeIt(memberchk(I1=_,KV1s),T7),
	timeIt(memberchk(I1=_,KV1s),T8),
	timeIt(memberchk(I1=_,KV1s),T9),
	T10 is T6 + T7 + T8 + T9,

	SpeedUp is integer((T10*100)/T5),
	cprins([memberchk/member,SpeedUp]),
	!.

aItem(Id,A,aa(Id,Assertion)) :-
	functor(Assertion,aa,A),
	arg(1,Assertion,Id),
	numbervars(Assertion,x,0,_).

go :- watch(memberchk_vs_member).
