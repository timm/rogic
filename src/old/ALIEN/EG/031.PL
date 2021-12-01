%% hh2x ht5 4 worlds
:- write('% hope you ran venusc hh2x first'), nl.
:- +[law/abduct, eg/th/hh2x/vulcan, eg/th/hh2x/vulcan1].

go:-watch(go1).

go1:-   Ins0 =[aa,bb,ii,hh],
	Outs0=[not ee,not ff,gg,not ll,mm],
	maplist(asLs,[Ins0,Outs0],[Ins,Outs]),
	print(in(Ins)/out(Outs)),nl,
	union(Ins,Outs,Facts),
	tprint(ht5(ins(Ins),outs(Outs),facts(Facts))),
	ht5(Ins,Outs,Facts,Worlds),
	showWorlds(Worlds).

asLs(X,Y) :- maplist(asL,X,Y).
asL(not X,X@t(1)=f) :- !.
asL(X,X@t(1)=t).
