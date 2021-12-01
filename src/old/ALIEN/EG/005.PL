%% timing memberchk vcs set_member_chk
:- +[lib/timer, lib/lists, lib/io].

memberchk_gt_set_member_chk :- 
        member(N,[10,100,1000,2500,5000,10000]),
	go1(N),
	fail.
memberchk_gt_set_member_chk :- nl.

go1(N) :-
	nl,
	print(settingUp),
        cprins([n,N]),
	randomList(N,L1),
	L1=[I1,I2,I3,I4|_],
	sort(L1,L1s),
	length(L1s,Len1),
	cprins([len1,Len1,ready]),

	(memberchk(I1,L1s), 
	 set_member_chk(I1,L1s)
        -> cprin(ok)
        ;  cprin(error)),

	timeIt(memberchk(I1,L1s),T1),
	timeIt(memberchk(I2,L1s),T2),
	timeIt(memberchk(I3,L1s),T3),
	timeIt(memberchk(I4,L1s),T4),
	T5 is T1 + T2 + T3 + T4,


	timeIt(set_member_chk(I1,L1s),T6),
	timeIt(set_member_chk(I2,L1s),T7),
	timeIt(set_member_chk(I3,L1s),T8),
	timeIt(set_member_chk(I4,L1s),T9),
	T10 is T6 + T7 + T8 + T9,

	SpeedUp is integer((T10*100)/T5),
	cprins([set_member_chk/memberchk,SpeedUp]),
	!.

go :- watch(memberchk_gt_set_member_chk).
	
