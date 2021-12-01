w(Rel,AVs,W) :-
	sumof(Score,Rel^AVs^p(Rel,AVs,Score),W).

p(Rel,AVs, Score) :-
	ls(Rel,AVs,Ls),	
	maplist(arg(2),Ls,AllL),
	sum(AllL,Lsum),
	member(Class=Lc,Ls),
	weight(Class,W),
	Score is W*Lc/Lsum.
	
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

