
missings(All) :- setof(One,missingt(One), All).

missingt(K) :-
     '#known'(C,K), \+ C= t,
	\+ '#known'(t,K).
