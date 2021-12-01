/*
ignoring and
23 ?- report.
report,fSweepPercent,77.1862,pinStar,55.1579,pa,37.0508,pac,13.7795,nproofs,5.84844,averageProofSize,8.33203,nworlds,1.00781

using and

report,fSweepPercent,62.9782,pinStar,22.1122,pa,14.8543,pac,8.44104,nproofs,5.7953,averageProofSize,7.1361,nworlds,1.00692

*/

/*forwardSweep :- in(I),	forwardSweep1(I), fail.
forwardSweep.

forwardSweep1(X) :- inStar(X), !.
forwardSweep1(X) :- culled(X), !.
forwardSweep1(X) :- andVertex(X), !, \+ unSatisfiedParent(X), forwardSweep2(X).
forwardSweep1(X) :- forwardSweep2(X).

forwardSweep2(X) :- assert(inStar(X)), kid(X,Kid), forwardSweep1(Kid).

*/

forwardSweep :- ins(A), forwardSweep1(A,[],Out), ensures(Out).

forwardSweep1([],L,L).
forwardSweep1([H|T]) --> forwardSweep2(H), forwardSweep1(T).

forwardSweep2(H,In,In) :- memberchk(inStar(H),In),!.
forwardSweep2(H,In,In) :- culled(H),!.
forwardSweep2(H,In,Out) :-
	andVertex(H)
	-> (unsatisfiedParent(H,In)
	   -> forwardSweep3(H,In,Out)
           ;  Out=[inStar(H)|In]) 
	;  forwardSweep3(H,In,Out).

forwardSweep3(H,In,Out) :-
	kids(H,Kids)
	-> forwardSweep1(Kids,[inStar(H)|In],Out)
	;  Out= [inStar(H)|In].

culleds(A) :-
        my_setof(B, culled(B), A).

unsatisfiedParent(H,In) :-
	parents(H,P),
	\+memberchk(inStar(P),In).

