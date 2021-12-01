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

w(Rel,AVs) :-
	sumof(Score,Rel^AVs^p(Rel,AVs,Score),W).

p(Rel,AVs, Score) :-
	ls(Rel,AVs,Ls),	
	maplist(arg(2),Ls,AllL),
	sum(AllL,Sum).
	member(Class=PC,Ls),
	weight(Class,W),
	Score is W*Pc/Sum.
	
ls(Rel,AVs,Ls) :-
	bagof(L,Rel^AVs^l1(Rel,AVs,L),Ls).

l1(Rel,AVs,Class=Freq/D*Prod) :-
	target(Rel,Dist),
	flag(Rel,D,D),
	member(Class-Freq,Dist),
	prodof(X,l2(AVs,Rel,Class,Freq,X),Prod).
	
l2(AVs,Rel,Class,Space,N/Space) :-
	member(Attr=Val,AVs),
	incData(Rel,Class,Attr,Val,N).

