%% ht5 bbsimp
:- write('% hope you ran venusc bbsimp first'), nl.
:- +[law/abduct,eg/th/bbsimp/vulcan, eg/th/bbsimp/vulcan1].

go:-watch(go1).

go1:-   Ins =[aa@t(1)=t],
	Outs=[bb@t(1)=t],
	union(Ins,Outs,Facts),
	ht5(Ins,Outs,Facts,Worlds),
	showWorlds(Worlds).
