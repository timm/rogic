% need a working memory of the p's actually used

requirementStrength(R,Out) :- 
	rStrength(R,S),
	sumof(I,F^R^realImpact(F,R,I),Sum),
	Out is S * Sum.

faultEffect(F,Out) :- 
	F=f(_), o(F,_),
	sumof(S*I,F^R^X^(impact(F,R,I,X), 
	                  rStrength(R,S))
             ,Out).

rStrength(R,S) :- o(R,r(_,S,_,_,_)).

realImpact(F,R,(1-E)*I) :-
	impact(F,R,I,_),
	effect(F,P,E,_),
	o(P,p(_,_,L,_,_,_)),
	random(100) > (1-L)*100.
	
