%% ggdeepx ht5
:- write('% hope you ran venusc ggdeepx first'), nl.
:- +[law/abduct, eg/th/ggdeepx/vulcan, eg/th/ggdeepx/vulcan1].

go:-watch(go1).

go1:-   T=t(1),
        Ins =[aa@T=t,bb@T=t],
	Outs=[ee@T=t,ff@T=t,gg@T=f,hh@T=f,ii@T=t],
	union(Ins,Outs,Facts),
	tprint(ht5(ins(Ins),outs(Outs),facts(Facts))),
	ht5(Ins,Outs,Facts,Worlds),
	showWorlds(Worlds).


