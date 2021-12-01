choices(X,Y) :- 
	clause(choice(X,_,_,_),_),
	copy_term(X,Y).

choice(cmm(X),                  cmm,          descrete,   X).
choice(defectDensity(_,X),      defectDensity,continuous, X).
choice(reworkByPhase(X,_,_,_),  reworkByPhase,descrete,   X).
choice(ivv(X,_),                ivv,          descrete,   X).
choice(reworkSaved(_,X),        reworkSaved,  continuous, X).
choice(leaks(L),                _,            continuous, L).
