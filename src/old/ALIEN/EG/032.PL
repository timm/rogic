%% iiands ht5 with ands
:- write('% hope you ran venusc iiands first'), nl.
:- +[law/abduct, eg/th/iiands/vulcan, eg/th/iiands/vulcan1].

go:-watch(go1).

go1:-   Ins  =[aa,bb,dd,ee,mm],
	Outs =[gg,hh,kk,ll],
	main(Ins,Outs,Worlds),
	showWorlds(Worlds).

main(Ins0,Outs0,Worlds) :-
	maplist(asLs,[Ins0,Outs0],[Ins,Outs]),
	print(in(Ins)/out(Outs)),nl,
	union(Ins,Outs,Facts),
	tprint(ht5(ins(Ins),outs(Outs),facts(Facts))),
	ht5(Ins,Outs,Facts,Worlds).

asLs(X,Y) :- maplist(asL,X,Y).
asL(not X,X@t(1)=f) :- !.
asL(X,X@t(1)=t).
