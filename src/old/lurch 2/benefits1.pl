% eliza- to understand the following, you need to know
% that lurch only memos on the clauses listed as choice/2
% facts. 

benefit(X,Y) :- b(X,Y0), Y is Y0.

b(X,Y) :- once(b0(X,What)), b1(What,Y).

b0(X,      oops(var))    :- var(X).
b0(true,  1 ). 
b0((A,B), Op/L )        :- score((,),Op),  c2l((A,B),L).
b0((A;B), Op/L )        :- score((;),Op),  d2l((A,B),L).
b0(A,     abduced(A) )  :- choices(A,Ind), memo(Ind,A,0).
b0(A,     claused(A,R)) :- choices(A,Ind), memo(Ind,A,R).
b0(A,     claused(A,_)) :- clause(A,_). 
b0(_,     1).
       
b1(1,            1).
b1(Op/L0,        Y) :- maplist(b,L0,L), do(Op,L,Y).
b1(claused(A,R), X*W) :- weights(A,W),  clause(A,B,R), b(B,X).
b1(abduced(A),   Y) :- weights(A,Y). 
b1(oops(X),      _) :- barph(X).

do(min,L,Min)    :- min(L,Min).
do(average,L,Av) :- average(L,Av).
	
