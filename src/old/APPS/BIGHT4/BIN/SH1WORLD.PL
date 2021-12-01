%sweepNumbers goes/
%\+connected2Exogeny goes.

fastworlds(Worlds) :-
	fastworlds(_,Worlds).
fastworlds(Proofs,Worlds) :-
	wmeClear(run),
	fastproofs(Proofs,Details),
	bagof(World,Proofs^Details^
                    world(Proofs,Details,World),
	      Worlds),
	sweepNumbers(Details,Proofs,Worlds).

fastproofs(Proofs,details(AB,A,Objects)) :-
	facts(F),
	factsSweep(F),
	tick(proofs,forwardSweep),
	forwardSweep, 
	find_a(F,A), 
	find_ac,
	tick(proofs,clumping),
	%find_clumps,
	tick(proofs,backwardsSweep),
	fastbackwardSweep(Proofs), 
	find_ab(Proofs,AB, Objects).

% backwards sweep

fastbackwardSweep(Proofs) :- 
	outs(Outs),
	set_new(Forbids0),
	fastbackwardSweep1(Outs,Forbids0,[],Proofs).

fastbackwardSweep1([]        ,_       ,Proofs, Proofs).
fastbackwardSweep1([Out|Outs],Forbids0,Proofs0,Proofs) :-
	fastproof(Forbids0,Out,Proof), !,
	p(forbids,Proof,Forbids1),
	fastbackwardSweep1(Outs,Forbids1,[Proof|Proofs0],Proofs).
fastbackwardSweep1([_|Outs],Forbids0,Proofs0,Proofs) :-
	fastbackwardSweep1(Outs,Forbids0,Proofs0,Proofs).
	
fastproof(_,X,_)       :- culled(X),                !, fail.	
fastproof(Forbids,X,P) :- ok2Fail(X),\+ inStar(X), !, 
                          fastproof0(X,isolated,Forbids,P).
fastproof(_,X,_)       :- \+ inStar(X),             !, fail.
fastproof(Forbids,X,P) :- in(X), out(X),            !, 
	                  fastproof0(X,easy,Forbids,P).
fastproof(Forbids,X,P) :- fastproof0(X,edges,Forbids,P0), ascend(X,P0,P).

fastproof0(X,Type,Forbids, 
           p(Id,X,Cost,Edges,Vertices,Forbids, AB, Roots, Type)) :-
	sets_empty([Edges,AB,Roots]),
%	noGoods(X,Forbids),
	set_with([X],Vertices),
	Cost = 0,
	newN(Id).



