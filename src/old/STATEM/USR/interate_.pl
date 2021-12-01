iterate  is t + [todo,f,done,time].
+ step --> 
	todo = [],!.
+ step -->
	time = T  \T+1,
        next = X0 \X1,
        f    = F,
	{call(F,X0,X1)}.
+ next -->
	todo := [X|L]\L, 
        done := D    \[X|D].
+ new(Todo,F,T) -->
	empty,
	todoIs = Todo,
        doneIs  = [],
	fIs     = F,
	timeIs  = T. 
+ empty -->  blank.
end(iterate).

