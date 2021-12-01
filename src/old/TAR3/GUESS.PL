counts(Rel) :-
	write('% count'),
	`skip=Bad,
	incZero,
	forall(counts1(Rel, Bad),true),
        nl.

counts1(Rel,Bad) :-
	one(Rel,One),
	f([`target=Class,Attr=Val0],One),
	not(member(Attr,Bad)),
	rValue(Val0,Val),
	inc(Rel,Class,Attr,Val).

rValue(r(_,N),N) :- !.
rValue(N,N).

guess(Rel,All) :- setof(One,Rel^guess1(Rel,One),All).

guess1(Rel,Sum-((Attr/Val)=Range)) :-
	`skip=Bad,
	targets(Rel,Dist),
	range(Rel,Attr,Val,Range,_,_),
	not(member(Attr,Bad)),
        sumof(Score, Rel^Dist^Attr^Val^
		       guess2(Rel,Dist,Attr,Val,Score),
	      Sum).

guess2(Rel,Dist,Attr,Val,Score) :-		 
	 member(Class-Freq,Dist),
	 weight(Class,W),
	 incData(Rel,Class,Attr,Val,N),
	 Score is W*N/Freq
                  *N % add a support factor
	          .
