
do([],W,W).
do([X|Y])    --> maybe ->  do(X), recall, do(Y); do(Y), recall, do(X). 
do(X rand Y) --> maybe ->  do(X), do(Y)        ; do(Y), do(X).
do(X ror  Y) --> maybe -> (do(X) ; do(Y))      ; (do(Y); do(X)).
do(?X=Y)     --> dTrace(X=Y).
do(?X \=  Y) --> do1(X,Z), neg(Z,Y).
do(?X =   Y) --> do1(X,Y).
do((X,Y))    --> do(X), do(Y).
do((X;Y))    --> do(X); do(Y).
do(X =    Y) --> {X=Y}.
do(+X)       --> {X=Y}.

neg(1,-1).    neg(-1,1).
neg(up,down). neg(down,up).
neg(t,f).     neg(t,f).
neg(t,f).     neg(true,false).

maybe --> {0 is random(2)}.

do1(X,Y,W0,W) :-
	wme(Path0,Before,W0),
	set_newel(Path0,X=Y,Path), % fails if not new
	wme(Path,Before,W1),
	(set_oldel(Before,X=Z)     % we've been here before
        -> Y=Z,
	   W=W1,
	   write(end(X)),nl,nl
        ;  def(X,Y,W1,W)).

wme(L1,L2,L1/L2) :- 
	isList(L1),
	isList(L2),
	!.

recall(Path/Before0,[]/Before) :-
	set_union(Path,Before0,Before).

?(A=B,C,D) :- 
	do(?A=B,C,D).

dTrace(X=Y,W,W) :-
	wme(P,_,W),
	forall(member(_,P), write('.. ')), 
	print(?X=Y),
	nl,fail.
