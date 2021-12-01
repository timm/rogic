do(rand([]))    --> [].
do(rand([H|T])) --> {rone([H|T],One,Next)}, do(One), do(Next).
do(ror([H|T]))  --> {rone([H|T],One,_)}, do(One).
do((X,Y))       --> do(X), do(Y).
do((X;Y))       --> do(X); do(Y).
do(X =    Y) --> {X=Y}.
do(?X=Y)     --> o spy(X=Y),{fail}.
do(?X \=  Y) --> do(?X=Z), {neg(Z,Y)}.
do(?X =   Y) --> 
	o path  ^ Path0  ^ Path,
	o known ^ Before ^ After,
	o W0/W,
	{set_newel(Path0,X=Y,Path),        % fails if not new
	set_key(Before,X=Z,After,Status), % Status= (+) if its a new key
        (Status = (=)
        -> Y=Z,
	   o(end(X),W0,W)
        ;  Y=Z,
           def(X,Y,W0,W))}.

neg(1,-1).    neg(-1,1).
neg(up,down). neg(down,up).
neg(t,f).     neg(t,f).
neg(t,f).     neg(true,false).

?(A=B) :- o([new,debug is f],_,W), ?(A=B,W,_).

?(A=B,C,D) :- 
	do(?A=B,C,D).


