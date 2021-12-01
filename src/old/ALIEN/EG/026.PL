%% ffshape ht5 (two worlds)
:- write('% hope you ran venusc ffxshape first'), nl.
:- +[law/abduct, eg/th/ffxshape/vulcan, eg/th/ffxshape/vulcan1].

go:-watch(go1).

go1:-   T=t(1),
        Ins =[aa@T=t,mm@T=t],
	Outs=[ee@T=t,kk@T=t,hh@T=f,ii@T=t],
	union(Ins,Outs,Facts),
	tprint(ht5(ins(Ins),outs(Outs),facts(Facts))),
	ht5(Ins,Outs,Facts,Worlds),
	showWorlds(Worlds).
