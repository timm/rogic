validate(Worlds,Proofs,BestCover,BestWorlds) :-
	tick(proofs,validate),
	outs(All),
	provedViaIsolation(Proofs,NIsolated),
	set_size(All,Outs),
	Note = note(Outs,NIsolated),
	Worlds=[BestWorld|_],
	BestWorlds=[BestWorld],
	cover(BestWorld,Note,_,BestCover),
	!.
