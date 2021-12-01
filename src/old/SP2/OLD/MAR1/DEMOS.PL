pqdemo :-
%	randomList(3655, 85, Sample),
	randomList(10, 5, Sample),
	print(Sample),
	insertPQs(Sample, Out),
	showPQs(Out),
	removePQs(Out, List),
	print(List),
	nl.

pqtest([K1-D1,K2-D2,K3-D3,K4-D4]) :-
	insertPQs([ 3-first
	          , 2-second
		  , 3-third
		  , 2-fourth], PQ0),
        removePQ(PQ0,K1,D1,PQ1),
	removePQ(PQ1,K2,D2,PQ2),
	removePQ(PQ2,K3,D3,PQ3),
	removePQ(PQ3,K4,D4,_).

pqtest1(Q) :-
	insertPQs([3=one
	          ,2=two
	          ,3=three
	          ,2=four
	          ,1=five
                  ,5=six
                  ,6=seven
                  ,2=eight
                  ],Q).


listdemo :-
	enqueue(a,_,A),
	enqueue(b,A,B),
	enqueue(c,B,C),
	dequeue(C, _AThing,D),
	dequeue(D, _BThing,E),
	enqueue(f,E,SemiFinal),
	enqueue(g,SemiFinal,Final),
	dequeue(Final, CThing, Final0),
	dequeue(Final0, DThing, Final1),
	dequeue(Final1, EThing, Final2),
	format('~w, ~w, ~w.\n', [CThing, DThing, EThing]),
	dequeue(Final2, Thing, FinalFinal),
	format('~w\t~w, ~w.\n', [Final2, Thing, FinalFinal]).

