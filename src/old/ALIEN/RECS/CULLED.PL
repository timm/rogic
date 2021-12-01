defrec(Term,_,blank(F,Id,Blank)) :-
	functor(Term,F,A),
	functor(Blank,F,A),
        arg(1,Blank,Id).
