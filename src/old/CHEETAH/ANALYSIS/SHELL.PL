(o) is dat - [ orsCostCombine, r8cost, r8chances
             , r9cost, r9chances, r10cost
             , r10chances, r11cost, r11chances
             , baseball, content, enthusiasm
             , exercise, football, happy, healthy
             , likesSweat, overweight, rich, running
             , sick, smoker, swimming, tranquil,class
             ].



o(X) :- o(X,_,_).

o(one,X,X) :- nonvar(X),!.
o(one,X,X) :- o(get,X,X).
o X=Y --> o one, o(X,Y,Y).


o numeric(X) --> member(X,[ r8cost, r8chances
                          , r9cost, r9chances, r10cost
                          , r10chances, r11cost, r11chances]).
o oneOf(X)   --> member(X,[orsCostCombine, baseball, content, enthusiasm
             , exercise, football, happy, healthy
             , likesSweat, overweight, rich, running
             , sick, smoker, swimming, tranquil,class]).

o(minMax(X,Min,Max)) -->
	o(numeric(X)),
	setof(Y,X^o(X=Y),[Min|Rest]),
	last(Max,[Min|Rest]).
o range(X,[Step,Min,Max]) -->
	o numeric(X), 
	o minMax(X,Min,Max), 
	Step is (Max - Min)/9.
o(range(X,Range))  --> 
	o oneOf(X),
	setof(Y,X^o(X=Y),Range).

o show --> o(X=Y), format('~15> = ~w\n',[X,Y]), fail.
o show --> [].

o classify(_Ranges,C,X,Y) -->
	o class=C,
	o oneOf(X),
        X \= class,
	o X=Y.
        
o classify(Ranges,C,X,Y) -->
	o class=C,
	o numeric(X),
	member(X=[Step,_,_],Ranges),
	o X=Y0,
	Y is integer(Y0/Step) * Step.
	
        



