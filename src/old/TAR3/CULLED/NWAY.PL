buckets(Rel) :-
	retractall(bucket(Rel,_,_)),
	forall(sortIntoBucket(Rel,B),assert(B)).

sortIntoBucket(Rel,bucket(Rel,Id,Bucket)) :-
	targets(Rel,Dist),
	flag(n(Rel),Eg,Eg),
	`nway=N,
	any(Rel,[id=Id,`target=Class]),
	spit(Id,50,=),
	member(Class-Freq,Dist),
	sortIntoBucket1(N,Freq/Eg,Bucket).

sortIntoBucket1(N,Freq,Bucket) :-
	repeat,
	Bucket is round(rand(0.501,N+0.499)),
	rand(0,1) > Freq,
	!.

targets(Rel,Dist) :-
	bagof(C,any(Rel,`target=C),Cs),
	dist(Cs,Dist).

threseholds(Rel,Avoid) :-
	flag(n(range),_,1),
	retractall(range(Rel,_,_,_,_)),
	forall(threseholdRun1(Rel,Avoid,Range),
	       assert(Range)).

threseholdRun1(Rel,Avoid,range(Rel,Name,N,Pair,Min,Max)) :-
	`skip=Bad,
	columns(Rel,Cols),	
	between(1,Cols,Col),
	h(Rel,Name,Col),
	not(member(Name,Bad)),
	spit(-),
	thresehold(Rel,Avoid,Col,Bins),
	pairs(Bins,Pair,Min,Max),
	flag(n(range),N,N+1).

thresehold(Rel,Avoid,Col,Bins) :-
	`[maxNumber,steps]= [Max,Steps0],	
	cols(Rel,Avoid,Col,All),
	msort([Max|All],Sort),
	length(Sort,L),
	Steps is min(Steps0,L),
	N is floor(L/Steps),
	bins(N,Sort,Bins0),
	append(Bins0,[Max],Bins).

cols(Rel,Avoid,Pos,Ns) :-
	goodColumn(Rel,Name,Pos),
	bagof(N,Name^Rel^Avoid^
                   col(Rel,Avoid,Pos,N),
	      Ns).

col(Rel,Avoid,Pos,N) :-	
	one(Rel,One),
	f(id=Id,One),
	bucket(Rel,Id,Bucket),
	not(Bucket=Avoid),
	arg(Pos,One,N).

