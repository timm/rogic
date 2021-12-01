
or(Out) :-
	
	clause(x(A,_,C),Body),
	(Out=[C]-(A=C)
	;membera(x(B,_,D),Body),
	 Out=[D]-(B=D)),
	Out \= [0]-_.

ors(All,N) :- 
	setof(One,or(One),All), length(All,N).

:- dynamic n/2.
:- index(n(1,1,1)).

n0(n(X,Y,N1)) :- 
	ors(All,_), 
	nth1(N,All,One),
	arg(2,One,X=Y),
	(Y = -1
	-> Delta = 0
	;  Delta = 1),
	N1 is N + Delta.
	
flip(X=1  , X= -1, X=1).
flip(X= -1, X=  1, X= -1).

n0s :- 
	retractall(n(_,_,_)), 
	forall(	n0(X),
		assert(X)).



%rule(IF,Then).

rulesp(F) :-
	rules(All),
	length(All,N2),
	N is N2 /2,
	tell(F),
	write(N),nl,
	forall(member(One,All),format('~a ~a ~a ~a~n',One)),
	told.

rules(All) :-
	setof(One,rule1(One),All).

rule1(Out) :-
	rule2(A0,P0,C0,W),
	flip(P0,BPa=BPv,Pa=Pv),
	flip(C0,BCa=BCv,Ca=Cv),
	n(Pa,Pv,P),
	n(Ca,Cv,C),
	n(BPa,BPv,BP),
	n(BCa,BCv,BC),
	(Out = [A0,P,C,W]
	;Out = [A0,BP,BC,W]
	).
	
rule2(0,C=D,A=B,0) :-
	clause(x(A,_,B),x(C,_,D)),
	B \= 0.

rule2(1,X=Y,A=B,0) :-
	clause(x(A,_,B),(x(C,_,D),x(E,_,F))),
	B \= 0,
	member(X=Y,[C=D,E=F]).

ands(N) :-findall(X,and(X),L),length(L,N).
and(1) :- clause(x(_,_,_),(_,_)).


p(X=A,N) :- bagof(X=A,parent(X=A),All),length(All,N),!.
p(_,0).



parent(X=A) :-
	clause(x(X,1,A),Body),
	membera(_,Body).

xxx(L,L2) :-
	findall(N,(setof(One,or(One),_All)
                  ,member(X=A,_All)
                  ,p(X=A,N)
                  ),L1),
         msort(L1,L),
	 sort(L,L2).

yyy(Key,L) :-
	xxx(All,Keys),
	member(Key,Keys),
	subtract(All,[Key],Minus),
	length(Minus,L2),
	length(All,L1),
	L is L1 - L2.
	

thing(X=A) :- clause(x(X,_,A),_).

thing(X=A) :- clause(x(_,_,_),Body),membera(x(X,_,A),Body).


things(All) :- setof(One,thing(One),All).

sizea((_,X),1+N) :- !,sizea(X,N).
sizea(_,1).

membera(X,(Y,Z)) :- !,(X=Y;membera(X,Z)).
membera(X,X).

mean(L,M) :- length(L,S), sum(L,Sum), M is Sum/S.

sum([],0).
sum([H|T],Out) :- sum(T,Temp), Out is Temp + H.

x(acthProduction, A, 1) :-
	x(crf, A, 1).
x(acthProduction, A, -1) :-
	x(crf, A, -1).
x(acth, A, 1) :-
	x(acthProduction, A, 1).
x(acthProduction, A, -1) :-
	x(hypox, A, 1).
x(acthProduction, A, 1) :-
	x(hypox, A, -1).
x(cortisolProduction, A, 1) :-
	x(acth, A, 1).
x(cortisolProduction, A, -1) :-
	x(acth, A, -1).
x(cortisolProduction, A, 1) :-
	x(dummy1, A, 1).
x(cortisolProduction, A, -1) :-
	x(dummy1, A, -1).
x(dummy1, A, 1) :-
	x(guan_now, A, -1),
	x(sns, A, 1).
x(dummy1, A, -1) :-
	x(guan_now, A, -1),
	x(sns, A, -1).
x(cortisolProduction, A, -1) :-
	x(guan, A, 1).
x(cortisolProduction, A, 1) :-
	x(guan, A, -1).
x(cortisol, A, 1) :-
	x(dummy2, A, 1).
x(cortisol, A, -1) :-
	x(dummy2, A, -1).
x(dummy2, A, 1) :-
	x(adrx_now, A, -1),
	x(cortisolProduction, A, 1).
x(cortisol, A, 1) :-
	x(adrx, A, -1).
x(cortisol, A, -1) :-
	x(corticoidProduction, A, 1).
x(acthProduction, A, -1) :-
	x(glucocorticoid, A, 1).
x(acthProduction, A, 1) :-
	x(glucocorticoid, A, -1).
x(glucocorticoid, A, 1) :-
	x(corticoidProduction, A, 1).
x(glucocorticoid, A, 1) :-
	x(dex, A, 1).
x(glucocorticoid, A, -1) :-
	x(dex, A, -1).
x(glucocorticoid, A, 1) :-
	x(acutEdex, A, 1).
x(glucocorticoid, A, -1) :-
	x(acutEdex, A, -1).
x(glucocorticoid, A, 1) :-
	x(chroniCdex, A, 1).
x(glucocorticoid, A, -1) :-
	x(chroniCdex, A, -1).
x(catechole, A, 1) :-
	x(dummy3, A, 1).
x(catechole, A, -1) :-
	x(dummy3, A, -1).
x(dummy3, A, 1) :-
	x(adrx_now, A, -1),
	x(catecholeProd, A, 1).
x(catechole, A, 1) :-
	x(adrx, A, -1).
x(catechole, A, -1) :-
	x(catecholeDisp, A, 1).
x(catecholeProd, A, 1) :-
	x(dummy4, A, 1).
x(catecholeProd, A, -1) :-
	x(dummy4, A, -1).
x(dummy4, A, 1) :-
	x(guan_now, A, -1),
	x(sns, A, 1).
x(dummy4, A, -1) :-
	x(guan_now, A, -1),
	x(sns, A, -1).
x(catecholeProd, A, -1) :-
	x(guan, A, 1).
x(catecholeProd, A, 1) :-
	x(guan, A, -1).
x(da, A, 1) :-
	x(daProduction, A, 1).
x(da, A, -1) :-
	x(da2Hva, A, 1).
x(da, A, 1) :-
	x(prl, A, 1).
x(da, A, -1) :-
	x(prl, A, -1).
x(daProduction, A, -1) :-
	x(aluminium, A, 1).
x(daProduction, A, 1) :-
	x(aluminium, A, -1).
x(hva, A, 1) :-
	x(dummy5, A, 1).
x(hva, A, -1) :-
	x(dummy5, A, -1).
x(dummy5, A, 1) :-
	x(msg_now, A, -1),
	x(da2Hva, A, 1).
x(hva, A, 1) :-
	x(msg, A, -1).
x(da2Hva, A, -1) :-
	x(parg, A, 1).
x(da2Hva, A, 1) :-
	x(parg, A, -1).
x(glucagon, A, 1) :-
	x(glucagonProd, A, 1).
x(glucagon, A, -1) :-
	x(glucagonDis, A, 1).
x(glucagonProd, A, 1) :-
	x(dummy6, A, 1).
x(glucagonProd, A, -1) :-
	x(dummy6, A, -1).
x(dummy6, A, 1) :-
	x(guan_now, A, -1),
	x(sns, A, 1).
x(dummy6, A, -1) :-
	x(guan_now, A, -1),
	x(sns, A, -1).
x(glucagonProd, A, -1) :-
	x(guan, A, 1).
x(glucagonProd, A, 1) :-
	x(guan, A, -1).
x(glucagonProd, A, -1) :-
	x(glucose, A, 1).
x(glucagonProd, A, 1) :-
	x(glucose, A, -1).
x(glucagonProd, A, -1) :-
	x(insulin, A, 1).
x(glucagonProd, A, 1) :-
	x(insulin, A, -1).
x(glucose, A, 1) :-
	x(chroniCglucose, A, 1).
x(glucose, A, -1) :-
	x(chroniCglucose, A, -1).
x(glucose, A, 1) :-
	x(fromGut, A, 1).
x(glucose, A, 1) :-
	x(fromLiver, A, 1).
x(glucose, A, -1) :-
	x(brainGlucoseUptake, A, 1).
x(brainGlucoseUptake, A, 1) :-
	x(glucose, A, 1).
x(brainGlucoseUptake, A, -1) :-
	x(glucose, A, -1).
x(glucose, A, -1) :-
	x(toTissue, A, 1).
x(brainGlucose, A, 1) :-
	x(brainGlucoseUptake, A, 1).
x(toTissue, A, 1) :-
	x(temp1, A, 1).
x(toTissue, A, -1) :-
	x(temp1, A, -1).
x(temp1, A, 1) :-
	x(glucose, A, 1).
x(temp1, A, -1) :-
	x(glucose, A, -1).
x(temp1, A, 1) :-
	x(insulin, A, 1).
x(temp1, A, -1) :-
	x(insulin, A, -1).
x(fromLiver, A, 1) :-
	x(temp2, A, 1).
x(fromLiver, A, -1) :-
	x(temp2, A, -1).
x(temp2, A, -1) :-
	x(insulin, A, 1).
x(temp2, A, 1) :-
	x(insulin, A, -1).
x(temp2, A, 1) :-
	x(glucocorticoid, A, 1).
x(temp2, A, -1) :-
	x(glucocorticoid, A, -1).
x(temp2, A, -1) :-
	x(pns, A, 1).
x(temp2, A, 1) :-
	x(pns, A, -1).
x(temp2, A, 1) :-
	x(catechole, A, 1).
x(temp2, A, -1) :-
	x(catechole, A, -1).
x(temp2, A, 1) :-
	x(dummy7, A, 1).
x(temp2, A, -1) :-
	x(dummy7, A, -1).
x(dummy7, A, -1) :-
	x(guan_now, A, -1),
	x(sns, A, 1).
x(dummy7, A, 1) :-
	x(guan_now, A, -1),
	x(sns, A, -1).
x(temp2, A, 1) :-
	x(guan, A, 1).
x(temp2, A, -1) :-
	x(guan, A, -1).
x(temp2, A, 1) :-
	x(glucagon, A, 1).
x(temp2, A, -1) :-
	x(glucagon, A, -1).
x(brainGlucoseUptake, A, -1) :-
	x(twoDg, A, 1).
x(brainGlucoseUptake, A, 1) :-
	x(twoDg, A, -1).
x(insulin, A, 1) :-
	x(fromPancreas, A, 1).
x(insulin, A, -1) :-
	x(toKidneys, A, 1).
x(toKidneys, A, 1) :-
	x(insulin, A, 1).
x(toKidneys, A, -1) :-
	x(insulin, A, -1).
x(temp3, A, 1) :-
	x(dummy8, A, 1).
x(temp3, A, -1) :-
	x(dummy8, A, -1).
x(dummy8, A, -1) :-
	x(guan_now, A, 1),
	x(sns, A, 1).
x(dummy8, A, 1) :-
	x(guan_now, A, 1),
	x(sns, A, -1).
x(temp3, A, -1) :-
	x(guan, A, 1).
x(temp3, A, 1) :-
	x(guan, A, -1).
x(temp3, A, -1) :-
	x(catechole, A, 1).
x(temp3, A, 1) :-
	x(catechole, A, -1).
x(temp3, A, 1) :-
	x(glucagon, A, 1).
x(temp3, A, -1) :-
	x(glucagon, A, -1).
x(temp3, A, 1) :-
	x(glucose, A, 1).
x(temp3, A, -1) :-
	x(glucose, A, -1).
x(temp3, A, 1) :-
	x(pns, A, 1).
x(temp3, A, -1) :-
	x(pns, A, -1).
x(fromPancreas, A, 1) :-
	x(temp3, A, 1).
x(fromPancreas, A, -1) :-
	x(temp3, A, -1).
x(insulin, A, 1) :-
	x(insulinBolis, A, 1).
x(insulin, A, -1) :-
	x(insulinBolis, A, -1).
x(insulin, A, 1) :-
	x(insulin10, A, 1).
x(insulin, A, -1) :-
	x(insulin10, A, -1).
x(insulin, A, 1) :-
	x(insulin30, A, 1).
x(insulin, A, -1) :-
	x(insulin30, A, -1).
x(insulin, A, 1) :-
	x(chroniCinsulin, A, 1).
x(insulin, A, -1) :-
	x(chroniCinsulin, A, -1).
x(fromPancreas, A, 1) :-
	x(tolbut10, A, 1).
x(fromPancreas, A, -1) :-
	x(tolbut10, A, -1).
x(fromPancreas, A, 1) :-
	x(tolbut20, A, 1).
x(fromPancreas, A, -1) :-
	x(tolbut20, A, -1).
x(fromPancreas, A, 1) :-
	x(tolbut30, A, 1).
x(fromPancreas, A, -1) :-
	x(tolbut30, A, -1).
x(fromPancreas, A, 1) :-
	x(chroniCtolbut, A, 1).
x(fromPancreas, A, -1) :-
	x(chroniCtolbut, A, -1).
x(da, A, -1) :-
	x(neProduction, A, 1).
x(ne, A, 1) :-
	x(dummy9, A, 1).
x(ne, A, -1) :-
	x(dummy9, A, -1).
x(dummy9, A, 1) :-
	x(msg_now, A, -1),
	x(neProduction, A, 1).
x(ne, A, 1) :-
	x(msg, A, -1).
x(ne, A, -1) :-
	x(ne2dhpg, A, 1).
x(ne, A, -1) :-
	x(ne2Epin, A, 1).
x(dhpg, A, 1) :-
	x(dummy10, A, 1).
x(dhpg, A, -1) :-
	x(dummy10, A, -1).
x(dummy10, A, 1) :-
	x(msg_now, A, -1),
	x(ne2dhpg, A, 1).
x(dhpg, A, 1) :-
	x(msg, A, -1).
x(crf, A, 1) :-
	x(dhpg, A, 1).
x(crf, A, -1) :-
	x(dhpg, A, -1).
x(sns, A, 1) :-
	x(dhpg, A, 1).
x(sns, A, -1) :-
	x(dhpg, A, -1).
x(neControl, A, 1) :-
	x(stress, A, 1).
x(neControl, A, -1) :-
	x(stress, A, -1).
x(neControl, A, -1) :-
	x(glucocorticoid, A, 1).
x(neControl, A, 1) :-
	x(glucocorticoid, A, -1).
x(neControl, A, -1) :-
	x(brainGlucose, A, 1).
x(neControl, A, 1) :-
	x(brainGlucose, A, -1).
x(neProduction, A, 1) :-
	x(neControl, A, 1).
x(neProduction, A, -1) :-
	x(neControl, A, -1).
x(ne2dhpg, A, 1) :-
	x(neControl, A, 1).
x(ne2dhpg, A, -1) :-
	x(neControl, A, -1).
x(ne2dhpg, A, 1) :-
	x(ne, A, 1).
x(ne2dhpg, A, -1) :-
	x(ne, A, -1).
x(ne2dhpg, A, -1) :-
	x(aluminium, A, 1).
x(ne2dhpg, A, 1) :-
	x(aluminium, A, -1).
x(ne2Epin, A, 1) :-
	x(ne, A, 1).
x(neProduction, A, 1) :-
	x(hgh, A, 1).
x(neProduction, A, -1) :-
	x(hgh, A, -1).
x(neProduction, A, -1) :-
	x(insulin, A, 1).
x(neProduction, A, 1) :-
	x(insulin, A, -1).
x(stress, A, 1) :-
	x(swimstr, A, 1).
x(stress, A, -1) :-
	x(swimstr, A, -1).
x(stress, A, 1) :-
	x(etherstr, A, 1).
x(stress, A, -1) :-
	x(etherstr, A, -1).
x(neProduction, A, 1) :-
	x(yoh, A, 1).
x(neProduction, A, -1) :-
	x(yoh, A, -1).
x(ne2dhpg, A, -1) :-
	x(parg, A, 1).
x(ne2dhpg, A, 1) :-
	x(parg, A, -1).
x(stress, A, 1) :-
	x(gentle, A, 1).
x(stress, A, -1) :-
	x(gentle, A, -1).
x(neControl, A, -1) :-
	x(diaz, A, 1).
x(neControl, A, 1) :-
	x(diaz, A, -1).
x(neControl, A, -1) :-
	x(chroniCdiaz, A, 1).
x(neControl, A, 1) :-
	x(chroniCdiaz, A, -1).
x(vagus, A, 1) :-
	x(pns, A, 1).
x(vagus, A, -1) :-
	x(pns, A, -1).
x(pns, A, 1) :-
	x(insulin, A, 1).
x(pns, A, -1) :-
	x(insulin, A, -1).
x(pns, A, 1) :-
	x(fiveHIAA, A, 1).
x(pns, A, -1) :-
	x(fiveHIAA, A, -1).
x(pns, A, -1) :-
	x(sns, A, 1).
x(pns, A, 1) :-
	x(sns, A, -1).
x(prlRelease, A, -1) :-
	x(da, A, 1).
x(prlRelease, A, 1) :-
	x(da, A, -1).
x(pPrl, A, -1) :-
	x(da, A, 1).
x(pPrl, A, 1) :-
	x(da, A, -1).
x(pPrl, A, -1) :-
	x(prlRelease, A, 1).
x(prl, A, 1) :-
	x(dummy11, A, 1).
x(prl, A, -1) :-
	x(dummy11, A, -1).
x(dummy11, A, 1) :-
	x(hypox_now, A, -1),
	x(prlRelease, A, 1).
x(prl, A, 1) :-
	x(hypox, A, -1).
x(sateity, A, 1) :-
	x(fiveHIAA, A, 1).
x(sateity, A, -1) :-
	x(fiveHIAA, A, -1).
x(sateity, A, -1) :-
	x(brainGlucose, A, 1).
x(sateity, A, 1) :-
	x(brainGlucose, A, -1).
x(serotonin, A, 1) :-
	x(dummy12, A, 1).
x(serotonin, A, -1) :-
	x(dummy12, A, -1).
x(dummy12, A, 1) :-
	x(msg_now, A, -1),
	x(serotoninProduction, A, 1).
x(serotonin, A, 1) :-
	x(msg, A, -1).
x(serotonin, A, -1) :-
	x(serotoninTOfiveHIAA, A, 1).
x(fiveHIAA, A, 1) :-
	x(serotoninTOfiveHIAA, A, 1).
x(serotoninProduction, A, -1) :-
	x(hgh, A, 1).
x(serotoninProduction, A, 1) :-
	x(hgh, A, -1).
x(serotoninProduction, A, -1) :-
	x(t4, A, 1).
x(serotoninProduction, A, 1) :-
	x(t4, A, -1).
x(serotoninTOfiveHIAA, A, 1) :-
	x(t4, A, 1).
x(serotoninTOfiveHIAA, A, -1) :-
	x(t4, A, -1).
x(serotoninTOfiveHIAA, A, 1) :-
	x(serotonin, A, 1).
x(serotoninTOfiveHIAA, A, -1) :-
	x(serotonin, A, -1).
x(serotoninProduction, A, 1) :-
	x(brainGlucose, A, 1).
x(serotoninProduction, A, -1) :-
	x(brainGlucose, A, -1).
x(serotoninProduction, A, 1) :-
	x(insulin, A, 1).
x(serotoninProduction, A, -1) :-
	x(insulin, A, -1).
x(serotoninProduction, A, 1) :-
	x(pns, A, 1).
x(serotoninProduction, A, -1) :-
	x(pns, A, -1).
x(serotoninTOfiveHIAA, A, 1) :-
	x(pns, A, 1).
x(serotoninTOfiveHIAA, A, -1) :-
	x(pns, A, -1).
x(serotoninTOfiveHIAA, A, -1) :-
	x(parg, A, 1).
x(serotoninTOfiveHIAA, A, 1) :-
	x(parg, A, -1).
x(serotoninProduction, A, -1) :-
	x(msg, A, 1).
x(serotoninProduction, A, 1) :-
	x(msg, A, -1).
x(sns, A, -1) :-
	x(pns, A, 1).
x(sns, A, 1) :-
	x(pns, A, -1).
x(pHgh, A, -1) :-
	x(ghProduction, A, 1).
x(hgh, A, 1) :-
	x(dummy13, A, 1).
x(hgh, A, -1) :-
	x(dummy13, A, -1).
x(dummy13, A, 1) :-
	x(hypox_now, A, 1),
	x(ghProduction, A, 1).
x(hgh, A, 1) :-
	x(hypox, A, 1).
x(hgh, A, 1) :-
	x(hghInj, A, 1).
x(hgh, A, -1) :-
	x(hghInj, A, -1).
x(ghrh, A, 1) :-
	x(fiveHIAA, A, 1).
x(ghrh, A, -1) :-
	x(fiveHIAA, A, -1).
x(pHgh, A, -1) :-
	x(ghrh, A, 1).
x(pHgh, A, 1) :-
	x(ghrh, A, -1).
x(ghProduction, A, 1) :-
	x(ghrh, A, 1).
x(ghProduction, A, -1) :-
	x(ghrh, A, -1).
x(ghProduction, A, 1) :-
	x(glucose, A, 1).
x(ghProduction, A, -1) :-
	x(glucose, A, -1).
x(pHgh, A, 1) :-
	x(glucose, A, 1).
x(pHgh, A, -1) :-
	x(glucose, A, -1).
x(pHgh, A, -1) :-
	x(srif, A, 1).
x(pHgh, A, 1) :-
	x(srif, A, -1).
x(ghProduction, A, -1) :-
	x(srif, A, 1).
x(ghProduction, A, 1) :-
	x(srif, A, -1).
x(srif, A, 1) :-
	x(crf, A, 1).
x(srif, A, -1) :-
	x(crf, A, -1).
x(acthProduction, A, 0) :-
	x(crf, A, 1),
	x(hypox, A, 1).
x(acthProduction, A, 0) :-
	x(crf, A, 1),
	x(glucocorticoid, A, 1).
x(acthProduction, A, 0) :-
	x(hypox, A, -1),
	x(crf, A, -1).
x(acthProduction, A, 0) :-
	x(hypox, A, -1),
	x(glucocorticoid, A, 1).
x(cortisolProduction, A, 0) :-
	x(acth, A, 1),
	x(dummy1, A, -1).
x(cortisolProduction, A, 0) :-
	x(acth, A, 1),
	x(guan, A, 1).
x(cortisolProduction, A, 0) :-
	x(dummy1, A, 1),
	x(acth, A, -1).
x(cortisolProduction, A, 0) :-
	x(dummy1, A, 1),
	x(guan, A, 1).
x(cortisolProduction, A, 0) :-
	x(guan, A, -1),
	x(acth, A, -1).
x(cortisolProduction, A, 0) :-
	x(guan, A, -1),
	x(dummy1, A, -1).
x(cortisol, A, 0) :-
	x(dummy2, A, 1),
	x(corticoidProduction, A, 1).
x(cortisol, A, 0) :-
	x(adrx, A, -1),
	x(dummy2, A, -1).
x(cortisol, A, 0) :-
	x(adrx, A, -1),
	x(corticoidProduction, A, 1).
x(acthProduction, A, 0) :-
	x(glucocorticoid, A, -1),
	x(crf, A, -1).
x(acthProduction, A, 0) :-
	x(glucocorticoid, A, -1),
	x(hypox, A, 1).
x(glucocorticoid, A, 0) :-
	x(corticoidProduction, A, 1),
	x(dex, A, -1).
x(glucocorticoid, A, 0) :-
	x(corticoidProduction, A, 1),
	x(acutEdex, A, -1).
x(glucocorticoid, A, 0) :-
	x(corticoidProduction, A, 1),
	x(chroniCdex, A, -1).
x(glucocorticoid, A, 0) :-
	x(dex, A, 1),
	x(acutEdex, A, -1).
x(glucocorticoid, A, 0) :-
	x(dex, A, 1),
	x(chroniCdex, A, -1).
x(glucocorticoid, A, 0) :-
	x(acutEdex, A, 1),
	x(dex, A, -1).
x(glucocorticoid, A, 0) :-
	x(acutEdex, A, 1),
	x(chroniCdex, A, -1).
x(glucocorticoid, A, 0) :-
	x(chroniCdex, A, 1),
	x(dex, A, -1).
x(glucocorticoid, A, 0) :-
	x(chroniCdex, A, 1),
	x(acutEdex, A, -1).
x(catechole, A, 0) :-
	x(dummy3, A, 1),
	x(catecholeDisp, A, 1).
x(catechole, A, 0) :-
	x(adrx, A, -1),
	x(dummy3, A, -1).
x(catechole, A, 0) :-
	x(adrx, A, -1),
	x(catecholeDisp, A, 1).
x(catecholeProd, A, 0) :-
	x(dummy4, A, 1),
	x(guan, A, 1).
x(catecholeProd, A, 0) :-
	x(guan, A, -1),
	x(dummy4, A, -1).
x(da, A, 0) :-
	x(daProduction, A, 1),
	x(da2Hva, A, 1).
x(da, A, 0) :-
	x(daProduction, A, 1),
	x(prl, A, -1).
x(da, A, 0) :-
	x(daProduction, A, 1),
	x(neProduction, A, 1).
x(da, A, 0) :-
	x(prl, A, 1),
	x(da2Hva, A, 1).
x(da, A, 0) :-
	x(prl, A, 1),
	x(neProduction, A, 1).
x(hva, A, 0) :-
	x(msg, A, -1),
	x(dummy5, A, -1).
x(glucagon, A, 0) :-
	x(glucagonProd, A, 1),
	x(glucagonDis, A, 1).
x(glucagonProd, A, 0) :-
	x(dummy6, A, 1),
	x(guan, A, 1).
x(glucagonProd, A, 0) :-
	x(dummy6, A, 1),
	x(glucose, A, 1).
x(glucagonProd, A, 0) :-
	x(dummy6, A, 1),
	x(insulin, A, 1).
x(glucagonProd, A, 0) :-
	x(guan, A, -1),
	x(dummy6, A, -1).
x(glucagonProd, A, 0) :-
	x(guan, A, -1),
	x(glucose, A, 1).
x(glucagonProd, A, 0) :-
	x(guan, A, -1),
	x(insulin, A, 1).
x(glucagonProd, A, 0) :-
	x(glucose, A, -1),
	x(dummy6, A, -1).
x(glucagonProd, A, 0) :-
	x(glucose, A, -1),
	x(guan, A, 1).
x(glucagonProd, A, 0) :-
	x(glucose, A, -1),
	x(insulin, A, 1).
x(glucagonProd, A, 0) :-
	x(insulin, A, -1),
	x(dummy6, A, -1).
x(glucagonProd, A, 0) :-
	x(insulin, A, -1),
	x(guan, A, 1).
x(glucagonProd, A, 0) :-
	x(insulin, A, -1),
	x(glucose, A, 1).
x(glucose, A, 0) :-
	x(chroniCglucose, A, 1),
	x(brainGlucoseUptake, A, 1).
x(glucose, A, 0) :-
	x(chroniCglucose, A, 1),
	x(toTissue, A, 1).
x(glucose, A, 0) :-
	x(fromGut, A, 1),
	x(chroniCglucose, A, -1).
x(glucose, A, 0) :-
	x(fromGut, A, 1),
	x(brainGlucoseUptake, A, 1).
x(glucose, A, 0) :-
	x(fromGut, A, 1),
	x(toTissue, A, 1).
x(glucose, A, 0) :-
	x(fromLiver, A, 1),
	x(chroniCglucose, A, -1).
x(glucose, A, 0) :-
	x(fromLiver, A, 1),
	x(brainGlucoseUptake, A, 1).
x(glucose, A, 0) :-
	x(fromLiver, A, 1),
	x(toTissue, A, 1).
x(brainGlucoseUptake, A, 0) :-
	x(glucose, A, 1),
	x(twoDg, A, 1).
x(temp1, A, 0) :-
	x(glucose, A, 1),
	x(insulin, A, -1).
x(temp1, A, 0) :-
	x(insulin, A, 1),
	x(glucose, A, -1).
x(temp2, A, 0) :-
	x(insulin, A, -1),
	x(glucocorticoid, A, -1).
x(temp2, A, 0) :-
	x(insulin, A, -1),
	x(pns, A, 1).
x(temp2, A, 0) :-
	x(insulin, A, -1),
	x(catechole, A, -1).
x(temp2, A, 0) :-
	x(insulin, A, -1),
	x(dummy7, A, -1).
x(temp2, A, 0) :-
	x(insulin, A, -1),
	x(guan, A, -1).
x(temp2, A, 0) :-
	x(insulin, A, -1),
	x(glucagon, A, -1).
x(temp2, A, 0) :-
	x(glucocorticoid, A, 1),
	x(insulin, A, 1).
x(temp2, A, 0) :-
	x(glucocorticoid, A, 1),
	x(pns, A, 1).
x(temp2, A, 0) :-
	x(glucocorticoid, A, 1),
	x(catechole, A, -1).
x(temp2, A, 0) :-
	x(glucocorticoid, A, 1),
	x(dummy7, A, -1).
x(temp2, A, 0) :-
	x(glucocorticoid, A, 1),
	x(guan, A, -1).
x(temp2, A, 0) :-
	x(glucocorticoid, A, 1),
	x(glucagon, A, -1).
x(temp2, A, 0) :-
	x(pns, A, -1),
	x(insulin, A, 1).
x(temp2, A, 0) :-
	x(pns, A, -1),
	x(glucocorticoid, A, -1).
x(temp2, A, 0) :-
	x(pns, A, -1),
	x(catechole, A, -1).
x(temp2, A, 0) :-
	x(pns, A, -1),
	x(dummy7, A, -1).
x(temp2, A, 0) :-
	x(pns, A, -1),
	x(guan, A, -1).
x(temp2, A, 0) :-
	x(pns, A, -1),
	x(glucagon, A, -1).
x(temp2, A, 0) :-
	x(catechole, A, 1),
	x(insulin, A, 1).
x(temp2, A, 0) :-
	x(catechole, A, 1),
	x(glucocorticoid, A, -1).
x(temp2, A, 0) :-
	x(catechole, A, 1),
	x(pns, A, 1).
x(temp2, A, 0) :-
	x(catechole, A, 1),
	x(dummy7, A, -1).
x(temp2, A, 0) :-
	x(catechole, A, 1),
	x(guan, A, -1).
x(temp2, A, 0) :-
	x(catechole, A, 1),
	x(glucagon, A, -1).
x(temp2, A, 0) :-
	x(dummy7, A, 1),
	x(insulin, A, 1).
x(temp2, A, 0) :-
	x(dummy7, A, 1),
	x(glucocorticoid, A, -1).
x(temp2, A, 0) :-
	x(dummy7, A, 1),
	x(pns, A, 1).
x(temp2, A, 0) :-
	x(dummy7, A, 1),
	x(catechole, A, -1).
x(temp2, A, 0) :-
	x(dummy7, A, 1),
	x(guan, A, -1).
x(temp2, A, 0) :-
	x(dummy7, A, 1),
	x(glucagon, A, -1).
x(temp2, A, 0) :-
	x(guan, A, 1),
	x(insulin, A, 1).
x(temp2, A, 0) :-
	x(guan, A, 1),
	x(glucocorticoid, A, -1).
x(temp2, A, 0) :-
	x(guan, A, 1),
	x(pns, A, 1).
x(temp2, A, 0) :-
	x(guan, A, 1),
	x(catechole, A, -1).
x(temp2, A, 0) :-
	x(guan, A, 1),
	x(dummy7, A, -1).
x(temp2, A, 0) :-
	x(guan, A, 1),
	x(glucagon, A, -1).
x(temp2, A, 0) :-
	x(glucagon, A, 1),
	x(insulin, A, 1).
x(temp2, A, 0) :-
	x(glucagon, A, 1),
	x(glucocorticoid, A, -1).
x(temp2, A, 0) :-
	x(glucagon, A, 1),
	x(pns, A, 1).
x(temp2, A, 0) :-
	x(glucagon, A, 1),
	x(catechole, A, -1).
x(temp2, A, 0) :-
	x(glucagon, A, 1),
	x(dummy7, A, -1).
x(temp2, A, 0) :-
	x(glucagon, A, 1),
	x(guan, A, -1).
x(brainGlucoseUptake, A, 0) :-
	x(twoDg, A, -1),
	x(glucose, A, -1).
x(insulin, A, 0) :-
	x(fromPancreas, A, 1),
	x(toKidneys, A, 1).
x(insulin, A, 0) :-
	x(fromPancreas, A, 1),
	x(insulinBolis, A, -1).
x(insulin, A, 0) :-
	x(fromPancreas, A, 1),
	x(insulin10, A, -1).
x(insulin, A, 0) :-
	x(fromPancreas, A, 1),
	x(insulin30, A, -1).
x(insulin, A, 0) :-
	x(fromPancreas, A, 1),
	x(chroniCinsulin, A, -1).
x(temp3, A, 0) :-
	x(dummy8, A, 1),
	x(guan, A, 1).
x(temp3, A, 0) :-
	x(dummy8, A, 1),
	x(catechole, A, 1).
x(temp3, A, 0) :-
	x(dummy8, A, 1),
	x(glucagon, A, -1).
x(temp3, A, 0) :-
	x(dummy8, A, 1),
	x(glucose, A, -1).
x(temp3, A, 0) :-
	x(dummy8, A, 1),
	x(pns, A, -1).
x(temp3, A, 0) :-
	x(guan, A, -1),
	x(dummy8, A, -1).
x(temp3, A, 0) :-
	x(guan, A, -1),
	x(catechole, A, 1).
x(temp3, A, 0) :-
	x(guan, A, -1),
	x(glucagon, A, -1).
x(temp3, A, 0) :-
	x(guan, A, -1),
	x(glucose, A, -1).
x(temp3, A, 0) :-
	x(guan, A, -1),
	x(pns, A, -1).
x(temp3, A, 0) :-
	x(catechole, A, -1),
	x(dummy8, A, -1).
x(temp3, A, 0) :-
	x(catechole, A, -1),
	x(guan, A, 1).
x(temp3, A, 0) :-
	x(catechole, A, -1),
	x(glucagon, A, -1).
x(temp3, A, 0) :-
	x(catechole, A, -1),
	x(glucose, A, -1).
x(temp3, A, 0) :-
	x(catechole, A, -1),
	x(pns, A, -1).
x(temp3, A, 0) :-
	x(glucagon, A, 1),
	x(dummy8, A, -1).
x(temp3, A, 0) :-
	x(glucagon, A, 1),
	x(guan, A, 1).
x(temp3, A, 0) :-
	x(glucagon, A, 1),
	x(catechole, A, 1).
x(temp3, A, 0) :-
	x(glucagon, A, 1),
	x(glucose, A, -1).
x(temp3, A, 0) :-
	x(glucagon, A, 1),
	x(pns, A, -1).
x(temp3, A, 0) :-
	x(glucose, A, 1),
	x(dummy8, A, -1).
x(temp3, A, 0) :-
	x(glucose, A, 1),
	x(guan, A, 1).
x(temp3, A, 0) :-
	x(glucose, A, 1),
	x(catechole, A, 1).
x(temp3, A, 0) :-
	x(glucose, A, 1),
	x(glucagon, A, -1).
x(temp3, A, 0) :-
	x(glucose, A, 1),
	x(pns, A, -1).
x(temp3, A, 0) :-
	x(pns, A, 1),
	x(dummy8, A, -1).
x(temp3, A, 0) :-
	x(pns, A, 1),
	x(guan, A, 1).
x(temp3, A, 0) :-
	x(pns, A, 1),
	x(catechole, A, 1).
x(temp3, A, 0) :-
	x(pns, A, 1),
	x(glucagon, A, -1).
x(temp3, A, 0) :-
	x(pns, A, 1),
	x(glucose, A, -1).
x(fromPancreas, A, 0) :-
	x(temp3, A, 1),
	x(tolbut10, A, -1).
x(fromPancreas, A, 0) :-
	x(temp3, A, 1),
	x(tolbut20, A, -1).
x(fromPancreas, A, 0) :-
	x(temp3, A, 1),
	x(tolbut30, A, -1).
x(fromPancreas, A, 0) :-
	x(temp3, A, 1),
	x(chroniCtolbut, A, -1).
x(insulin, A, 0) :-
	x(insulinBolis, A, 1),
	x(toKidneys, A, 1).
x(insulin, A, 0) :-
	x(insulinBolis, A, 1),
	x(insulin10, A, -1).
x(insulin, A, 0) :-
	x(insulinBolis, A, 1),
	x(insulin30, A, -1).
x(insulin, A, 0) :-
	x(insulinBolis, A, 1),
	x(chroniCinsulin, A, -1).
x(insulin, A, 0) :-
	x(insulin10, A, 1),
	x(toKidneys, A, 1).
x(insulin, A, 0) :-
	x(insulin10, A, 1),
	x(insulinBolis, A, -1).
x(insulin, A, 0) :-
	x(insulin10, A, 1),
	x(insulin30, A, -1).
x(insulin, A, 0) :-
	x(insulin10, A, 1),
	x(chroniCinsulin, A, -1).
x(insulin, A, 0) :-
	x(insulin30, A, 1),
	x(toKidneys, A, 1).
x(insulin, A, 0) :-
	x(insulin30, A, 1),
	x(insulinBolis, A, -1).
x(insulin, A, 0) :-
	x(insulin30, A, 1),
	x(insulin10, A, -1).
x(insulin, A, 0) :-
	x(insulin30, A, 1),
	x(chroniCinsulin, A, -1).
x(insulin, A, 0) :-
	x(chroniCinsulin, A, 1),
	x(toKidneys, A, 1).
x(insulin, A, 0) :-
	x(chroniCinsulin, A, 1),
	x(insulinBolis, A, -1).
x(insulin, A, 0) :-
	x(chroniCinsulin, A, 1),
	x(insulin10, A, -1).
x(insulin, A, 0) :-
	x(chroniCinsulin, A, 1),
	x(insulin30, A, -1).
x(fromPancreas, A, 0) :-
	x(tolbut10, A, 1),
	x(temp3, A, -1).
x(fromPancreas, A, 0) :-
	x(tolbut10, A, 1),
	x(tolbut20, A, -1).
x(fromPancreas, A, 0) :-
	x(tolbut10, A, 1),
	x(tolbut30, A, -1).
x(fromPancreas, A, 0) :-
	x(tolbut10, A, 1),
	x(chroniCtolbut, A, -1).
x(fromPancreas, A, 0) :-
	x(tolbut20, A, 1),
	x(temp3, A, -1).
x(fromPancreas, A, 0) :-
	x(tolbut20, A, 1),
	x(tolbut10, A, -1).
x(fromPancreas, A, 0) :-
	x(tolbut20, A, 1),
	x(tolbut30, A, -1).
x(fromPancreas, A, 0) :-
	x(tolbut20, A, 1),
	x(chroniCtolbut, A, -1).
x(fromPancreas, A, 0) :-
	x(tolbut30, A, 1),
	x(temp3, A, -1).
x(fromPancreas, A, 0) :-
	x(tolbut30, A, 1),
	x(tolbut10, A, -1).
x(fromPancreas, A, 0) :-
	x(tolbut30, A, 1),
	x(tolbut20, A, -1).
x(fromPancreas, A, 0) :-
	x(tolbut30, A, 1),
	x(chroniCtolbut, A, -1).
x(fromPancreas, A, 0) :-
	x(chroniCtolbut, A, 1),
	x(temp3, A, -1).
x(fromPancreas, A, 0) :-
	x(chroniCtolbut, A, 1),
	x(tolbut10, A, -1).
x(fromPancreas, A, 0) :-
	x(chroniCtolbut, A, 1),
	x(tolbut20, A, -1).
x(fromPancreas, A, 0) :-
	x(chroniCtolbut, A, 1),
	x(tolbut30, A, -1).
x(ne, A, 0) :-
	x(dummy9, A, 1),
	x(ne2dhpg, A, 1).
x(ne, A, 0) :-
	x(dummy9, A, 1),
	x(ne2Epin, A, 1).
x(ne, A, 0) :-
	x(msg, A, -1),
	x(dummy9, A, -1).
x(ne, A, 0) :-
	x(msg, A, -1),
	x(ne2dhpg, A, 1).
x(ne, A, 0) :-
	x(msg, A, -1),
	x(ne2Epin, A, 1).
x(dhpg, A, 0) :-
	x(msg, A, -1),
	x(dummy10, A, -1).
x(sns, A, 0) :-
	x(dhpg, A, 1),
	x(pns, A, 1).
x(neControl, A, 0) :-
	x(stress, A, 1),
	x(glucocorticoid, A, 1).
x(neControl, A, 0) :-
	x(stress, A, 1),
	x(brainGlucose, A, 1).
x(neControl, A, 0) :-
	x(stress, A, 1),
	x(diaz, A, 1).
x(neControl, A, 0) :-
	x(stress, A, 1),
	x(chroniCdiaz, A, 1).
x(neControl, A, 0) :-
	x(glucocorticoid, A, -1),
	x(stress, A, -1).
x(neControl, A, 0) :-
	x(glucocorticoid, A, -1),
	x(brainGlucose, A, 1).
x(neControl, A, 0) :-
	x(glucocorticoid, A, -1),
	x(diaz, A, 1).
x(neControl, A, 0) :-
	x(glucocorticoid, A, -1),
	x(chroniCdiaz, A, 1).
x(neControl, A, 0) :-
	x(brainGlucose, A, -1),
	x(stress, A, -1).
x(neControl, A, 0) :-
	x(brainGlucose, A, -1),
	x(glucocorticoid, A, 1).
x(neControl, A, 0) :-
	x(brainGlucose, A, -1),
	x(diaz, A, 1).
x(neControl, A, 0) :-
	x(brainGlucose, A, -1),
	x(chroniCdiaz, A, 1).
x(neProduction, A, 0) :-
	x(neControl, A, 1),
	x(hgh, A, -1).
x(neProduction, A, 0) :-
	x(neControl, A, 1),
	x(insulin, A, 1).
x(neProduction, A, 0) :-
	x(neControl, A, 1),
	x(yoh, A, -1).
x(ne2dhpg, A, 0) :-
	x(neControl, A, 1),
	x(ne, A, -1).
x(ne2dhpg, A, 0) :-
	x(neControl, A, 1),
	x(aluminium, A, 1).
x(ne2dhpg, A, 0) :-
	x(neControl, A, 1),
	x(parg, A, 1).
x(ne2dhpg, A, 0) :-
	x(ne, A, 1),
	x(neControl, A, -1).
x(ne2dhpg, A, 0) :-
	x(ne, A, 1),
	x(aluminium, A, 1).
x(ne2dhpg, A, 0) :-
	x(ne, A, 1),
	x(parg, A, 1).
x(ne2dhpg, A, 0) :-
	x(aluminium, A, -1),
	x(neControl, A, -1).
x(ne2dhpg, A, 0) :-
	x(aluminium, A, -1),
	x(ne, A, -1).
x(ne2dhpg, A, 0) :-
	x(aluminium, A, -1),
	x(parg, A, 1).
x(neProduction, A, 0) :-
	x(hgh, A, 1),
	x(neControl, A, -1).
x(neProduction, A, 0) :-
	x(hgh, A, 1),
	x(insulin, A, 1).
x(neProduction, A, 0) :-
	x(hgh, A, 1),
	x(yoh, A, -1).
x(neProduction, A, 0) :-
	x(insulin, A, -1),
	x(neControl, A, -1).
x(neProduction, A, 0) :-
	x(insulin, A, -1),
	x(hgh, A, -1).
x(neProduction, A, 0) :-
	x(insulin, A, -1),
	x(yoh, A, -1).
x(stress, A, 0) :-
	x(swimstr, A, 1),
	x(etherstr, A, -1).
x(stress, A, 0) :-
	x(swimstr, A, 1),
	x(gentle, A, -1).
x(stress, A, 0) :-
	x(etherstr, A, 1),
	x(swimstr, A, -1).
x(stress, A, 0) :-
	x(etherstr, A, 1),
	x(gentle, A, -1).
x(neProduction, A, 0) :-
	x(yoh, A, 1),
	x(neControl, A, -1).
x(neProduction, A, 0) :-
	x(yoh, A, 1),
	x(hgh, A, -1).
x(neProduction, A, 0) :-
	x(yoh, A, 1),
	x(insulin, A, 1).
x(ne2dhpg, A, 0) :-
	x(parg, A, -1),
	x(neControl, A, -1).
x(ne2dhpg, A, 0) :-
	x(parg, A, -1),
	x(ne, A, -1).
x(ne2dhpg, A, 0) :-
	x(parg, A, -1),
	x(aluminium, A, 1).
x(stress, A, 0) :-
	x(gentle, A, 1),
	x(swimstr, A, -1).
x(stress, A, 0) :-
	x(gentle, A, 1),
	x(etherstr, A, -1).
x(neControl, A, 0) :-
	x(diaz, A, -1),
	x(stress, A, -1).
x(neControl, A, 0) :-
	x(diaz, A, -1),
	x(glucocorticoid, A, 1).
x(neControl, A, 0) :-
	x(diaz, A, -1),
	x(brainGlucose, A, 1).
x(neControl, A, 0) :-
	x(diaz, A, -1),
	x(chroniCdiaz, A, 1).
x(neControl, A, 0) :-
	x(chroniCdiaz, A, -1),
	x(stress, A, -1).
x(neControl, A, 0) :-
	x(chroniCdiaz, A, -1),
	x(glucocorticoid, A, 1).
x(neControl, A, 0) :-
	x(chroniCdiaz, A, -1),
	x(brainGlucose, A, 1).
x(neControl, A, 0) :-
	x(chroniCdiaz, A, -1),
	x(diaz, A, 1).
x(pns, A, 0) :-
	x(insulin, A, 1),
	x(fiveHIAA, A, -1).
x(pns, A, 0) :-
	x(insulin, A, 1),
	x(sns, A, 1).
x(pns, A, 0) :-
	x(fiveHIAA, A, 1),
	x(insulin, A, -1).
x(pns, A, 0) :-
	x(fiveHIAA, A, 1),
	x(sns, A, 1).
x(pns, A, 0) :-
	x(sns, A, -1),
	x(insulin, A, -1).
x(pns, A, 0) :-
	x(sns, A, -1),
	x(fiveHIAA, A, -1).
x(pPrl, A, 0) :-
	x(da, A, -1),
	x(prlRelease, A, 1).
x(prl, A, 0) :-
	x(hypox, A, -1),
	x(dummy11, A, -1).
x(sateity, A, 0) :-
	x(fiveHIAA, A, 1),
	x(brainGlucose, A, 1).
x(sateity, A, 0) :-
	x(brainGlucose, A, -1),
	x(fiveHIAA, A, -1).
x(serotonin, A, 0) :-
	x(dummy12, A, 1),
	x(serotoninTOfiveHIAA, A, 1).
x(serotonin, A, 0) :-
	x(msg, A, -1),
	x(dummy12, A, -1).
x(serotonin, A, 0) :-
	x(msg, A, -1),
	x(serotoninTOfiveHIAA, A, 1).
x(serotoninProduction, A, 0) :-
	x(hgh, A, -1),
	x(t4, A, 1).
x(serotoninProduction, A, 0) :-
	x(hgh, A, -1),
	x(brainGlucose, A, -1).
x(serotoninProduction, A, 0) :-
	x(hgh, A, -1),
	x(insulin, A, -1).
x(serotoninProduction, A, 0) :-
	x(hgh, A, -1),
	x(pns, A, -1).
x(serotoninProduction, A, 0) :-
	x(hgh, A, -1),
	x(msg, A, 1).
x(serotoninProduction, A, 0) :-
	x(t4, A, -1),
	x(hgh, A, 1).
x(serotoninProduction, A, 0) :-
	x(t4, A, -1),
	x(brainGlucose, A, -1).
x(serotoninProduction, A, 0) :-
	x(t4, A, -1),
	x(insulin, A, -1).
x(serotoninProduction, A, 0) :-
	x(t4, A, -1),
	x(pns, A, -1).
x(serotoninProduction, A, 0) :-
	x(t4, A, -1),
	x(msg, A, 1).
x(serotoninTOfiveHIAA, A, 0) :-
	x(t4, A, 1),
	x(serotonin, A, -1).
x(serotoninTOfiveHIAA, A, 0) :-
	x(t4, A, 1),
	x(pns, A, -1).
x(serotoninTOfiveHIAA, A, 0) :-
	x(t4, A, 1),
	x(parg, A, 1).
x(serotoninTOfiveHIAA, A, 0) :-
	x(serotonin, A, 1),
	x(t4, A, -1).
x(serotoninTOfiveHIAA, A, 0) :-
	x(serotonin, A, 1),
	x(pns, A, -1).
x(serotoninTOfiveHIAA, A, 0) :-
	x(serotonin, A, 1),
	x(parg, A, 1).
x(serotoninProduction, A, 0) :-
	x(brainGlucose, A, 1),
	x(hgh, A, 1).
x(serotoninProduction, A, 0) :-
	x(brainGlucose, A, 1),
	x(t4, A, 1).
x(serotoninProduction, A, 0) :-
	x(brainGlucose, A, 1),
	x(insulin, A, -1).
x(serotoninProduction, A, 0) :-
	x(brainGlucose, A, 1),
	x(pns, A, -1).
x(serotoninProduction, A, 0) :-
	x(brainGlucose, A, 1),
	x(msg, A, 1).
x(serotoninProduction, A, 0) :-
	x(insulin, A, 1),
	x(hgh, A, 1).
x(serotoninProduction, A, 0) :-
	x(insulin, A, 1),
	x(t4, A, 1).
x(serotoninProduction, A, 0) :-
	x(insulin, A, 1),
	x(brainGlucose, A, -1).
x(serotoninProduction, A, 0) :-
	x(insulin, A, 1),
	x(pns, A, -1).
x(serotoninProduction, A, 0) :-
	x(insulin, A, 1),
	x(msg, A, 1).
x(serotoninProduction, A, 0) :-
	x(pns, A, 1),
	x(hgh, A, 1).
x(serotoninProduction, A, 0) :-
	x(pns, A, 1),
	x(t4, A, 1).
x(serotoninProduction, A, 0) :-
	x(pns, A, 1),
	x(brainGlucose, A, -1).
x(serotoninProduction, A, 0) :-
	x(pns, A, 1),
	x(insulin, A, -1).
x(serotoninProduction, A, 0) :-
	x(pns, A, 1),
	x(msg, A, 1).
x(serotoninTOfiveHIAA, A, 0) :-
	x(pns, A, 1),
	x(t4, A, -1).
x(serotoninTOfiveHIAA, A, 0) :-
	x(pns, A, 1),
	x(serotonin, A, -1).
x(serotoninTOfiveHIAA, A, 0) :-
	x(pns, A, 1),
	x(parg, A, 1).
x(serotoninTOfiveHIAA, A, 0) :-
	x(parg, A, -1),
	x(t4, A, -1).
x(serotoninTOfiveHIAA, A, 0) :-
	x(parg, A, -1),
	x(serotonin, A, -1).
x(serotoninTOfiveHIAA, A, 0) :-
	x(parg, A, -1),
	x(pns, A, -1).
x(serotoninProduction, A, 0) :-
	x(msg, A, -1),
	x(hgh, A, 1).
x(serotoninProduction, A, 0) :-
	x(msg, A, -1),
	x(t4, A, 1).
x(serotoninProduction, A, 0) :-
	x(msg, A, -1),
	x(brainGlucose, A, -1).
x(serotoninProduction, A, 0) :-
	x(msg, A, -1),
	x(insulin, A, -1).
x(serotoninProduction, A, 0) :-
	x(msg, A, -1),
	x(pns, A, -1).
x(sns, A, 0) :-
	x(pns, A, -1),
	x(dhpg, A, -1).
x(hgh, A, 0) :-
	x(dummy13, A, 1),
	x(hghInj, A, -1).
x(hgh, A, 0) :-
	x(hypox, A, 1),
	x(dummy13, A, -1).
x(hgh, A, 0) :-
	x(hypox, A, 1),
	x(hghInj, A, -1).
x(hgh, A, 0) :-
	x(hghInj, A, 1),
	x(dummy13, A, -1).
x(pHgh, A, 0) :-
	x(ghrh, A, -1),
	x(ghProduction, A, 1).
x(pHgh, A, 0) :-
	x(ghrh, A, -1),
	x(glucose, A, -1).
x(pHgh, A, 0) :-
	x(ghrh, A, -1),
	x(srif, A, 1).
x(ghProduction, A, 0) :-
	x(ghrh, A, 1),
	x(glucose, A, -1).
x(ghProduction, A, 0) :-
	x(ghrh, A, 1),
	x(srif, A, 1).
x(ghProduction, A, 0) :-
	x(glucose, A, 1),
	x(ghrh, A, -1).
x(ghProduction, A, 0) :-
	x(glucose, A, 1),
	x(srif, A, 1).
x(pHgh, A, 0) :-
	x(glucose, A, 1),
	x(ghProduction, A, 1).
x(pHgh, A, 0) :-
	x(glucose, A, 1),
	x(ghrh, A, 1).
x(pHgh, A, 0) :-
	x(glucose, A, 1),
	x(srif, A, 1).
x(pHgh, A, 0) :-
	x(srif, A, -1),
	x(ghProduction, A, 1).
x(pHgh, A, 0) :-
	x(srif, A, -1),
	x(ghrh, A, 1).
x(pHgh, A, 0) :-
	x(srif, A, -1),
	x(glucose, A, -1).
x(ghProduction, A, 0) :-
	x(srif, A, -1),
	x(ghrh, A, -1).
x(ghProduction, A, 0) :-
	x(srif, A, -1),
	x(glucose, A, -1).
