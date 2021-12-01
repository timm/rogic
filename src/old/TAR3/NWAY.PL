targets(Dist) :-
	bagof(C,oneByOne(`target=C),Cs),
	dist(Cs,Dist0),
	flag(eg,Eg,Eg),
	maplist(targets1(Eg),Dist0,Dist).

targets1(Eg,What-N,What-P) :-
	P is N/Eg.

sortIntoBucket(bucket(Id,Bucket)) :-
	targets(Dist),
	`nway=N,
	oneByOne([id=Id,`target=Class]),
	spit(Id,50,=),
	member(Class-Freq,Dist),
	sortIntoBucket1(N,Freq,Bucket).

sortIntoBucket1(N,Freq,Bucket) :-
	repeat,
	Bucket is round(rand(0.501,N+0.499)),
	rand(0,1) > Freq,
	!.