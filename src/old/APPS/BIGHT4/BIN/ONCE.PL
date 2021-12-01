backwardSweep(Proofs) :-
        bagof(Proof,X^(out(X),once(proof(X,Proof))),Proofs).

