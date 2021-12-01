% the optimizer

 zip(A,B)   :- zip(A,1,B).
 zip(A,M,C) :- once(zip0(A,M,B)), zip1(B,M,C).
 
 zip0(A,          _,'_self'(A)) :- var(A).
 zip0((A;B),      _,('_self'(A);  '_do'(B))):- var(A).
 zip0((A;B),      _,(  '_do'(A);'_self'(B))):- var(B).
 zip0((A;B),      _,  '_do'(B)) :- A == true.
 zip0((A;B),      _,  '_do'(A)) :- B == true.
 zip0((_;_),      2,'_no'('unzip-able disjunct')).
 zip0((X;Y),      _,     (X;Y)).
 zip0((A=A),      2,      true).
 zip0(A,          _, '_self'(A)) :- var(A).
 zip0((A,B),      _,('_self'(A),'_do'(B))) :- var(A).
 zip0((A,B),      _,('_do'(A),'_self'(B))) :- var(B).
 zip0((A,B),      _,  '_do'(B)) :- A == true.
 zip0((A,B),      _,  '_do'(A)) :- B == true.
 zip0((A=A,B),    2,  '_do'(B)).
 zip0((A,B=B),    2,  '_do'(A)).
 zip0(((A,B),C),  _   ,(A,B,C)).
 zip0((A,B),      _,     (A,B)).
 zip0((A->B),     _,  (A -> B)).
 zip0(not(A),     _,      \+ A).
 zip0(\+ A,       _,      \+ A).
 zip0((A :- B),   _,     (A:-B)).
 zip0(A,          in(_,_,_),'_method'(A)).
 zip0(A,          _,  '_act'(A))  :- eval(A).
 zip0(A,          _,  '_self'(A)) :- freeze(A).
 zip0(A,          _, '_self'(A))  :- knownBuiltIn(A).
 zip0(A,          _,   '_do'(B))  :- solo(A),myclause(A,B).
 zip0(A,          _, '_self'(A)).
 
 zip1('_do'(A0),  M,     A) :- zip(A0,M,A).
 zip1(true,       _,  true).
 zip1('_self'(A), _,     A).
 zip1('_act'(A),  _,  true) :- A.
 zip1('_no'(X),   _,  true) :- complain(X).
 zip1(\+ A0,      M,  \+ A) :- zip(A0,M,A).
 zip1('_method'(A0),in(C,M,N), A)  :-
	makeMethodCall(A0,C,M,A1),
	zip(A1,N,A).
 zip1((A :- B),   M,     R) :-
	zip(B,M,TB),
	(TB==true->R=A; R=(A:-TB)).
 zip1((A0 -> B0), M,     R) :-
	zip(A0,M,A),
	zip(B0,M,B),
	(A==true -> R=B;  R=(A->B)).
 zip1((A0;B0),    M,     R) :-
	zip(A0,M,A),
	zip(B0,M,B),
	(B==true -> R=A; (A==true -> R=B ;  R=(A;B))).
 zip1((A0,B0),    M,     R) :-
	zip(A0,M,A),
	zip(B0,M,B),
	(B==true -> R=A; (A==true -> R=B ;  R=(A,B))).

 