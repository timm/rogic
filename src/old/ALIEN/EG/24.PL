:- write('% hope you ran venusc aasimp first'), nl.
:- +[law/abduct,eg/th/aasimp/vulcan, eg/th/aasimp/vulcan1].

go:-watch(go1).
go1:-   Ins =[aa@T=t],
	Outs=[bb@T=t],
	union(Ins,Outs,Facts),
	ht5(Ins,Outs,Facts,Worlds),
	showWorlds(Worlds).
