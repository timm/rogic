 term_expansion(X*Z if Y,Out) :-
 	xpand(X*Z if Y,Out).
 
 xpand(Id*Y if X,(p(Y,V,W0,W) :- Z)) :-
 	xpand1(claim(Id) and X,V,Z,[],Vars,W0,W),
 	Used = [used(Y)|Vars],
 	forall(member(One,Used),ensure(One)).
 
 xpand1(A,B,C,L0,L,D,E) :-
 	once(xpand2(A,B,C,L0,L,D,E)).
 
 % should really add demorgan here
 xpand2(X0 or Y0, V, (X;Y),L0,L,W0,W) :-
 	xpand1(X0,V,X,L0,L1,W0,W),
 	xpand1(Y0,V,Y,L1,L, W0,W).
 xpand2(X0 and Y0, V, (X,Y),L0,L,W0,W) :-
 	xpand1(X0,V,X,L0,L1,W0,W1),
 	xpand1(Y0,V,Y,L1,L, W1,W).
 xpand2(not X,V,(neg(X,V,V1),q(X,V1,W0,W)),L,[used(X)|L],W0,W).
 xpand2(X=Y    ,_,           q(X,Y, W0,W), L,[used(X)|L],W0,W).
 xpand2(X \= Y ,V,           Out,          L0,L,         W0,W) :-
	   xpand2(X = Z and  neg(X,Z,Y),V,Out,L0,L,      W0,W).
 xpand2(      X,V,           q(X,V, W0,W), L,[used(X)|L],W0,W).

 ensure(X) :- X,!.
 ensure(X) :- assert(X).