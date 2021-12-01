
forwardSweep :- in(I),	forwardSweep1(I), fail.
forwardSweep.

forwardSweep1(X) :- inStar(X), !.
forwardSweep1(X) :- culled(X), !.
%forwardSweep1(X) :- andVertex(X), !, \+ unSatisfiedParent(X), forwardSweep2(X).
forwardSweep1(X) :- forwardSweep2(X).

forwardSweep2(X) :- assert(inStar(X)), kid(X,Kid), forwardSweep1(Kid).

