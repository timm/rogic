shmain :-
	shmain(_,_,_,_,_,_,_,_,_,_).

shmain(ExpName,Exp1,In,Exp2,Out,Proofs,AB,A,Time2,W) :-
	shmain(slow,ExpName,Exp1,In,Exp2,Out,Proofs,AB,A,Time2,W).

shmain(Speed,ExpName,Exp1,In,Exp2,Out,Proofs,AB,A,Time2,W) :-
	
	b(ExpName,Exp1,Exp2,In,Out),
		tick_init(proofs),
		tick(proofs,data),
	wmeClear(datum),
	in_wrap(In,In1),
	ensures(In1),
	out_wrap(Out,Out1),
	ensures(Out1),
	Time1 is cputime,

	(Speed = slow 
        -> itOr(worlds(Proofs,AB,A,W),[],W)
        |  itOr(fastworlds(Proofs,AB,A,W),[],W)),
	
	Time2 is cputime - Time1,
	itOr(not(var(Proofs)),[],Proofs),
	itOr(not(var(AB)),[],AB),
	itOr(not(var(A)),[],A).

	
shmain_random(Speed,Repeats,In,Out,Proofs,AB,A,Time2,W) :-
	
	bRandom(4,10,Repeats,In,Out),

	tick_init(proofs),
	tick(proofs,data),
	wmeClear(datum),
	in_wrap(In,In1),
	ensures(In1),
	out_wrap(Out,Out1),
	ensures(Out1),
	Time1 is cputime,

	(Speed = slow 
        -> itOr(worlds(Proofs,AB,A,W),[],W)
        |  itOr(fastworlds(Proofs,AB,A,W),[],W)),
	
	Time2 is cputime - Time1,
	itOr(not(var(Proofs)),[],Proofs),
	itOr(not(var(AB)),[],AB),
	itOr(not(var(A)),[],A).

in_wrap([],[]).
in_wrap([Object=Value|T],[in(V)|Rest]) :- 
	valueFast(V,Object,Value),
	in_wrap(T,Rest).
	
out_wrap([],[]).
out_wrap([Object=Value|T],[out(V)|Rest]) :- 
	valueFast(V,Object,Value),
	out_wrap(T,Rest).

peekitrun(SlowOrFast) :-
	myflag(nthExp,_,1),
	myflag(expPercent,_,0),
	shmain(SlowOrFast,_ExpName,_Exp1,_In,_Exp2,_Out,Proofs,_AB,_A,_Time1,Worlds),
	validate(Worlds,Proofs,BestCover0,_BestWorlds),
	myflag(nthExp,NthExp,NthExp+1),
	myflag(expPercent,ExpPercent,ExpPercent+BestCover0),
	CurrentExplicableRate is ((ExpPercent + BestCover0)/NthExp)*100,
	print(NthExp/CurrentExplicableRate),nl.



watch_it_run(Exp1,Exp2) :-
	watch_it_run(slow,Exp1,Exp2,_).
watch_it_run(SlowOrFast,Exp1,Exp2,Proofs) :-
	myflag(nthExp,_,1),
	myflag(expPercent,_,0),
	myflag(abductionTime,_,0),
	data(ExpName,_,_),
	model_specs(NAnds,NOrs,Fanout),
	nl,
	write(':- style_check(-discontiguous).
:- discontiguous fSweepNumbers/5, result/10,ticks/1,about/4. '), nl,

	nl,write('%about(d,nands,nOrs,fanout).'),nl,
	print(about(ExpName,NAnds,NOrs,Fanout)),write('.'),nl,
	StartTime is cputime,
	shmain(SlowOrFast,ExpName,Exp1,In,Exp2,Out,Proofs,AB,A,Time1,Worlds),
	myflag(nthExp,NthExp,NthExp+1),
	Time2 is cputime,
	validate(Worlds,Proofs,BestCover0,BestWorlds),
	tick(proofs,done),
	Time3 is (cputime - Time2) + Time1,
	myflag(abductionTime,AbductionTime0,AbductionTime0 + Time3),
	AbductionTime is AbductionTime0 + Time3,
	myflag(expPercent,ExpPercent,ExpPercent+BestCover0),
	CurrentExplicableRate is ((ExpPercent + BestCover0)/NthExp)*100,
	sformat(OutTime,'~1f',Time3),
	BestCover1 is BestCover0 * 100,
	sformat(BestCover,'~1f',BestCover1),
	length(BestWorlds,NBestWorlds),
	length(Worlds,NWorlds),
	countTypes(Out,up,Ups),
	countTypes(Out,down,Downs),
	countTypes(Out,std,Steadies),
	Changes is Ups + Downs,
	countTypes(In,arrived,Arriveds),
	countTypes(In,left,Lefts),
	OldStyleCauses is Arriveds + Lefts,
	%clumps(Clumps),
	%nClumps(NClumps),
	Clumps = clumpOff/0,
	NClumps = 0,
	proofStats(Proofs,AboutProofs),
	format('~n%#~d~n',NthExp),

	sweepNumbers(AB,A,Worlds),
	write('
%% result(expName,comparisonNumber,slowOrFast,exp1,exp2,
'),
	write('result('),
	print(ExpName),                          write(', '),
	print(NthExp),                           write(', '),
	print(SlowOrFast),	                 write(', '),
	print(Exp1),	                         write(', '),
	print(Exp2),	                         write(', '),
	write('
 %causes > changes/steadies,
 '),
	print(OldStyleCauses > Changes/Steadies),write(', '),
	write('
 % clumping?/ inStarPercentClumpAble,nClumps
 '),

	print(Clumps),                               write(', '),
	print(NClumps),                               write(', '),
	write('
 %nProofs/averageProofSize/sd - [minSize,maxSize] - all,
 '),
	write(AboutProofs),                      write(', '),
	write('
 %nWorlds, nBestWorlds, bestPercentCovered, time_seconds).
 '),
	write(NWorlds),	                         write(', '),
	write(NBestWorlds),	                 write(', '),
	write(BestCover),	                 write(', '),
	write(OutTime), 	                 write(').'),nl,
	format('~n%mean explicable : ~1f %',CurrentExplicableRate),
	format('~n%abduction time  : ~2f secs',AbductionTime),
        TotalTime is cputime - StartTime,
	format('~n%total run time  : ~2f secs~n',TotalTime),
        tick_done(proofs).

minimum(Time1) :-
	shmain(slow,_ExpName,_Exp1,_In,_Exp2,_Out,Proofs,_AB,_A,Time1,Worlds),
	validate(Worlds,Proofs,_BestCover0,_BestWorlds).

model_specs(NAnds,NOrs,FanOut) :-
	itOr(bagof(A,andVertex(A),Ands),Ands,[]),
	itOr(bagof(O,orVertex(O),Ors),Ors,[]),
	itOr(bagof(E,From^To^Source^Cost^e(E,From,To,Source,Cost),Es),
	      Es,[]),
	length(Ands,NAnds),
	length(Ors,NOrs),
	length(Es,NE),
	FanOut is NE/(NAnds + NOrs).

sweepNumbers(AB,A,Worlds) :-
	length(AB,ABL),
	n(v(_,_,_),Vs),
	n(inStar(_),In),
	length(Worlds,NW),
	n(ac(_),AC),
	length(A,LA),
	Pin is (In * 100)/Vs,
	Pac is (AC * 100)/Vs,
	Pa  is (LA  * 100)/Vs,
	format('~n%~q.~n',[fSweepNumbers(a,ac,ab,pinStar,pa,pac,worlds)]),
	format('~q.~n',[fSweepNumbers(LA,AC,ABL,Pin,Pa ,Pac,NW)]).
% Code changed by Sam 20/5/97 to avoid compiler problems	
%	format('~n%~q.~n',[fSweepNumbers(a>ac>ab,pinStar,pa,pac,worlds)]),
%	format('~q.~n',[fSweepNumbers(LA>AC>ABL,Pin,Pa ,Pac,NW)]).	

watch_it_run_random1(SlowOrFast,Repeats,Proofs) :-
	myflag(nthExp,_,1),
	myflag(expPercent,_,0),
	myflag(abductionTime,_,0),
	%ExpName = random,
	model_specs(NAnds,NOrs,Fanout),
	nl,
 	write(':- style_check(-discontiguous).
:- discontiguous randomRun/7, ticks/1'), nl,

	
	StartTime is cputime,
	shmain_random(SlowOrFast,Repeats,Proofs,Time1,Worlds),
	myflag(nthExp,NthExp,NthExp+1),
	Time2 is cputime,
	validate(Worlds,Proofs,BestCover0,BestWorlds),
	tick(proofs,done),
	Time3 is (cputime - Time2) + Time1,
	myflag(abductionTime,AbductionTime0,AbductionTime0 + Time3),
	AbductionTime is AbductionTime0 + Time3,
	myflag(expPercent,ExpPercent,ExpPercent+BestCover0),
	CurrentExplicableRate is ((ExpPercent + BestCover0)/NthExp)*100,
	sformat(OutTime,'~1f',Time3),
	BestCover1 is BestCover0 * 100,
	sformat(BestCover,'~1f',BestCover1),
	length(BestWorlds,NBestWorlds),
	length(Worlds,NWorlds),


	format('~n%#~d~n',NthExp),
	write('
 %randomRun(nands,nOrs,fanout,nWorlds, nBestWorlds, bestPercentCovered, time_seconds).
  randomRun('),
	write(NAnds),                            write(', '),
	write(NOrs),                             write(', '),
	write(Fanout),                           write(', '),
	write(NWorlds),	                         write(', '),
	write(NBestWorlds),	                 write(', '),
	write(BestCover),	                 write(', '),
	write(OutTime), 	                 write(').'),nl,

	format('~n%abduction time         : ~2f secs',AbductionTime),
	format('~n%current explicable rate: ~2f %',CurrentExplicableRate),
        TotalTime is cputime - StartTime,
	format('~n%total run time  : ~2f secs~n',TotalTime),
        tick_done(proofs).

watch_it_run_random(SlowOrFast,Repeats,Proofs) :-
	myflag(nthExp,_,1),
	myflag(expPercent,_,0),
	myflag(abductionTime,_,0),
	ExpName=random,
	model_specs(NAnds,NOrs,Fanout),
	nl,
	write(':- style_check(-discontiguous).
:- discontiguous fSweepNumbers/5, result/10,ticks/1,about/4. '), nl,

	nl,write('%about(d,nands,nOrs,fanout).'),nl,
	print(about(ExpName,NAnds,NOrs,Fanout)),write('.'),nl,
	StartTime is cputime,
	shmain_random(SlowOrFast,Repeats,In,Out,Proofs,AB,A,Time1,Worlds),
	myflag(nthExp,NthExp,NthExp+1),
	Time2 is cputime,
	validate(Worlds,Proofs,BestCover0,BestWorlds),
	tick(proofs,done),
	Time3 is (cputime - Time2) + Time1,
	myflag(abductionTime,AbductionTime0,AbductionTime0 + Time3),
	AbductionTime is AbductionTime0 + Time3,
	myflag(expPercent,ExpPercent,ExpPercent+BestCover0),
	CurrentExplicableRate is ((ExpPercent + BestCover0)/NthExp)*100,
	sformat(OutTime,'~1f',Time3),
	BestCover1 is BestCover0 * 100,
	sformat(BestCover,'~1f',BestCover1),
	length(BestWorlds,NBestWorlds),
	length(Worlds,NWorlds),
	countTypes(Out,up,Ups),
	countTypes(Out,down,Downs),
	countTypes(Out,std,Steadies),
	Changes is Ups + Downs,
	countTypes(In,arrived,Arriveds),
	countTypes(In,left,Lefts),
	OldStyleCauses is Arriveds + Lefts,
	%clumps(Clumps),
	%nClumps(NClumps),
	Clumps = clumpOff/0,
	NClumps = 0,
	proofStats(Proofs,AboutProofs),
	format('~n%#~d~n',NthExp),

	sweepNumbers(AB,A,Worlds),
	write('
%% result(expName,comparisonNumber,slowOrFast,exp1,exp2,
'),
	write('result('),
	print(ExpName),                          write(', '),
	print(NthExp),                           write(', '),
	print(SlowOrFast),	                 write(', '),
	print(in),	                         write(', '),
	print(out),	                         write(', '),
	write('
 %causes > changes/steadies,
 '),
	print(OldStyleCauses > Changes/Steadies),write(', '),
	write('
 % clumping?/ inStarPercentClumpAble,nClumps
 '),

	print(Clumps),                               write(', '),
	print(NClumps),                               write(', '),
	write('
 %nProofs/averageProofSize/sd - [minSize,maxSize] - all,
 '),
	write(AboutProofs),                      write(', '),
	write('
 %nWorlds, nBestWorlds, bestPercentCovered, time_seconds).
 '),
	write(NWorlds),	                         write(', '),
	write(NBestWorlds),	                 write(', '),
	write(BestCover),	                 write(', '),
	write(OutTime), 	                 write(').'),nl,
	format('~n%mean explicable : ~1f %',CurrentExplicableRate),
	format('~n%abduction time  : ~2f secs',AbductionTime),
        TotalTime is cputime - StartTime,
	format('~n%total run time  : ~2f secs~n',TotalTime),
        tick_done(proofs).






