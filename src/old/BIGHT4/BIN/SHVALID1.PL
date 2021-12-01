% --------------------------------------------------
validate(Worlds,Proofs,BestCover,BestWorlds) :-
	tick(proofs,validate),
	outs(All),
	provedViaIsolation(Proofs,NIsolated),
	set_size(All,Outs),
	Note = note(Outs,NIsolated),
	Worlds=[BestWorld|_],
	BestWorlds=[BestWorld],
	cover(BestWorld,Note,_,BestCover).
/*
	worlds_with_best_cover(Worlds,Note,   0,        [],
	                                      BestCover,BestWorlds).

worlds_with_best_cover([],_,                  BestCover, BestWorlds,
	                                      BestCover, BestWorlds).
worlds_with_best_cover([World|Worlds],Note,   BestCover0,BestWorlds0,
	                                      BestCover, BestWorlds) :-
	cover(World,Note,_,N),
	compare(Order,N,BestCover0),
	worlds_with_best_cover1(Order,N,World,Worlds, Note,
                                              BestCover0,BestWorlds0,
	                                      BestCover, BestWorlds).

worlds_with_best_cover1(<,_,_,Worlds,Note,    BestCover0,BestWorlds0,
	                                      BestCover, BestWorlds) :-
	worlds_with_best_cover(Worlds,Note,   BestCover0,BestWorlds0, 
                                              BestCover, BestWorlds).
worlds_with_best_cover1(=,_,World,Worlds,Note,BestCover0,BestWorlds0,
	                                      BestCover, BestWorlds) :-
	worlds_with_best_cover(Worlds,Note,   BestCover0,[World|BestWorlds0],
	                                      BestCover, BestWorlds).
worlds_with_best_cover1(>,N,World,Worlds,Note,_,         _,
			                      BestCover, BestWorlds) :-
	worlds_with_best_cover(Worlds,Note,   N,         [World],
			                      BestCover, BestWorlds).
*/
provedViaIsolation(Proofs,0) :- var(Proofs),!.
provedViaIsolation(Proofs,N) :-
	bagof(Item,Proofs^provedViaIsolation1(Proofs,Item),Items),!,
	length(Items,N).
provedViaIsolation(_,0).

provedViaIsolation1(Proofs,Isolated) :-
	set_member(Proof,Proofs),
	p(x,Proof,Isolated),
	p(type,Proof,isolated).
	
cover(World,note(Outs,NIsolated),Covered,N) :-
	outsInEdges(World,Covered),
	set_size(Covered,Size),
	N is (Size+NIsolated)/Outs.

outsInEdges(World,Outs) :- set_new(Outs0), outsInEdges1(World,Outs0,Outs).

outsInEdges1([],Outs,Outs).
outsInEdges1([Edge|Edges],Outs0,Outs) :-
	verticesInEdge(Edge,Parent,Child),
	outsInEdges2([Parent,Child],Outs0,Outs1),
	outsInEdges1(Edges,Outs1,Outs).

outsInEdges2([],Outs,Outs).
outsInEdges2([H|T],Outs0,Outs) :- 
	out(H), 
	!, 
	set_addel(Outs0,H,Outs1),
	outsInEdges2(T,Outs1,Outs).
outsInEdges2([_|T],Outs0,Outs) :-
	outsInEdges2(T,Outs0,Outs).

