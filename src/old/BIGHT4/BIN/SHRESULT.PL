result_times(Min,Max,Average) :-
	bagof(Time,result_time(Time),Times),
	stats(Times,_,Min,Max,_,Average).

result_time(Time) :-
	result(_,_,_,_,_,_,Time).

long_proof(LongTime, Exp1,Exp2,
	result(_,Exp1,Exp2,Details,Proofs,BestCover,Time)) :-
	R = result(_,Exp1,Exp2,Details,Proofs,BestCover,Time),
	R,
	Time > LongTime.

results(X) :-
	theory_file(qcm,X,'.out',In),
	see(In),
	read(Temp),
	results1(Temp,a([],     [],[]),
	              a(PinStar,PA,PAC),
                      proofs([]),proofs(Proofs),
		      worlds([],[],   []),
                      worlds(N, NBest,BestCovered),
		      time([]),time(Time),
		      details([], [],[],[],[],  []),
		      details(Val,WS,BS,FS,Prep,Data)),!,
	results2([pInStar - PinStar,
	       pa - PA,
	       pac - PAC,
	       proofs - Proofs,
	       nWorlds - N,
	       nBestWorlds - NBest,
	       bestCovered - BestCovered,
	       time - Time,
	       validataionTime - Val,
		worldsSweepTime - WS,
	      backSweepTime - BS,
              forwardsSweepTime - FS,
		prepTime - Prep,
		dataExtractionTime - Data]).

results1(X,A,A,P,P,W,W,T,T,D,D) :-
	pause(X), !,fail.

results1(end_of_file,A,A,P,P,W,W,T,T,D,D) :- !.

results1(fSweepNumbers(_, PInStar,PA,PAC,_), a(PInStar0,PA0,PAC0),A,
					     P0,P,W0,W,T0,T,D0,D) :- !,
	read(X),
	results1(X,a([PInStar|PInStar0], [PA|PA0],[PAC|PAC0]),A,
					     P0,P,W0,W,T0,T,D0,D).

results1(result(_,_,_,_,_,_,_,_,_/_/_ - _ - All,NW,NB,BC,TS),
	A0,A,
	proofs(Proofs0),P,
	worlds(NW0,NB0,BC0),W,
	time(TS0),T,
	D,D0) :- !,
	append(All,Proofs0,Proofs1),
	read(X),
	results1(X,A0,A,proofs(Proofs1),P,
	         worlds([NW|NW0],[NB|NB0],[BC|BC0]),W,time([TS|TS0]),T,D0,D).

results1(ticks([total          - _,
                validate       - _ / Val,
                worldsSweep    - _ / WS,
	        backwardsSweep - _ / BS,
                forwardSweep   - _ / FS,
                prep           - _ / Prep,
	        data           - _ / Data
               ]), A0,A,P0,P,W0,W,T0,T,
	details(Val0,WS0,BS0,FS0,Prep0,Data0),Details) :- !,
	read(X),
	results1(X,A0,A,P0,P,W0,W,T0,T,
	         details([Val|Val0],[WS|WS0],[BS|BS0],[FS|FS0],[Prep|Prep0],
                         [Data|Data0]),
	        Details).

results1(X,A0,A,P0,P,W0,W,T0,T,D0,D) :- 
	print(X),nl,
	read(Y),
	results1(Y,A0,A,P0,P,W0,W,T0,T,D0,D).

results2(Items) :-
	member(Item,Items),
	stats(Item,Stats),
	print(Item = Stats),nl,
	fail.
results2(_).
