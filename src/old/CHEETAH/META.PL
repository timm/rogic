syms(Syms) :- 
	clause(rule(A,B,C,D,E,F,G),Z), 
	rsyms([rule(A,B,C,D,E,F,G),Z],Syms).

rsyms(X,All) :- 
	setof(One, X^(rmember(X,One),
	              label(known,One)
                     ),All).
