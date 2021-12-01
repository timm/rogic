% eliza- to understand the following, you need to know
% that lurch only memos on the clauses listed as choice/2
% facts. 

benefit(X,Y) :- b(X,1,B), Y is B.

b(X,In,Out) :- once(b0(X,What)), b1(What,In,Out).

b0(X,             oops(var) ) :- var(X).
b0(true,                  1 ). 
b0(qualifier(_,W), times(W) ).
b0((A,B),              Op/L ) :- score((,),Op),  c2l((A,B),L).
b0((A;B),              Op/L ) :- score((;),Op),  d2l((A,B),L).
b0(A,            abduced(A) ) :- choices(A,Ind), memo(Ind,A,0).
b0(A,          claused(A,R) ) :- choices(A,Ind), memo(Ind,A,R).
b0(A,          claused(A,_) ) :- clause(A,_). 
b0(_,                     1 ).
       
b1(1,              In,   In ).
b1(times(W),       In, W*In ).
b1(Op/L0,          In, In*Y ) :- maplist(benefit,L0,L), do(Op,L,Y).
b1(claused(A,R),   In,  Out ) :- weights(A,W), clause(A,B,R), b(B,In*W,Out).
b1(abduced(A),     In, In*W ) :- weights(A,W). 
b1(oops(X),        _,     _ ) :- barph(X).

do(min,L,Min)    :- min(L,Min).
do(average,L,Av) :- average(L,Av).
	
