ranges(Rel) :-
	write('% ranges'),
	flag(ranges,_,1),
 	retractall(range(Rel,_,_,_,_,_)),
	forall(ranges1(Rel,Range),
	       assert(Range)),
	nl.

ranges1(Rel,range(Rel,Name,N,Pair,Min,Max)) :-
	`skip=Bad,
	columns(Rel,Cols),	
	between(1,Cols,Col),
	h(Rel,Name,Col),
	not(member(Name,Bad)),
	spit('.'),
	ranges2(Rel,Col,Bins),
	pairs(Bins,Pair,Min,Max),
	flag(ranges,N,N+1).

ranges2(Rel,Col,Bins) :-
	`[maxNumber,steps]= [Max,Steps0],	
	cols(Rel,Col,All),
	msort([Max|All],Sort),
	length(Sort,L),
	Steps is min(Steps0,L),
	N is floor(L/Steps),
	bins(N,Sort,Bins0),
	append(Bins0,[Max],Bins).

cols(Rel,Pos,Ns) :-
	goodColumn(Rel,Name,Pos),
	bagof(N,Name^Rel^any(Rel,Name=N), Ns).



