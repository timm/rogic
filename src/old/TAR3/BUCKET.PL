buckets(Rel) :-
	write('% buckets'),
        retractall(bucket(Rel,_,_)),
	forall(buckets1(Rel,B),
	       assert(B)),
	nl.

buckets1(Rel,bucket(Rel,Id,Bucket)) :-
	targets(Rel,Dist),
	flag(Rel,Eg,Eg),
	`nway=N,
	any(Rel,[id=Id,`target=Class]),
	spit(Id,50,'.'),
	member(Class-Freq,Dist),
	buckets2(N,Freq/Eg,Bucket).

buckets2(N,Freq,Bucket) :-
	repeat,
	Bucket is round(rand(0.501,N+0.499)),
	rand(0,1) > Freq,
	!.

targets(Rel,Dist) :-
	bagof(C,any(Rel,`target=C),Cs),
	dist(Cs,Dist).

