report(F) :-
	see(F),
	read(Item),
	report1(Item,out),
	seen.

report1(end_of_file,_) :- !.
report1(Item0,Old) :-
	report2(Item0,Old,New),
	!,
	read(Item),
	report1(Item,New).
report1(_,Old) :-
	read(Item),
	report1(Item,Old).

% an opss case, an about found when lookign for a report
% delcare the old reprot deaded
report2(about(_,Ors,Ands, _),in,in) :-
	print(0), tab(2),
	print(0), tab(2),
	print(inf),nl,
	All is Ors + Ands,
	print(All), tab(1).

report2(about(_,Ors,Ands, _),out,in) :-
	All is Ors + Ands,
	print(All), tab(1).

report2(
 % result(expName,comparisonNumber,slowOrFast,exp1,exp2,
   result(_,      _,                 _ ,      _ ,   _,
 %causes > changes/steadies,
 _, 
 % clumping?/ inStarPercentClumpAble,nClumps
 _,                                  _, 
 %nProofs/averageProofSize/sd - [minSize,maxSize] - all,
 _, 
 %nWorlds, nBestWorlds, bestPercentCovered, time_seconds).
 NWorlds, _,            BestCovered,        Time),
   in,out) :-
	print(NWorlds), tab(2),
	print(BestCovered), tab(2),
	print(Time),nl.

report2(
 % result(expName,comparisonNumber,slowOrFast,exp1,exp2,
   result(_,      _,                 _ ,      _ ,   _,
 %causes > changes/steadies,
 _, 
 % clumping?/ inStarPercentClumpAble,nClumps
 _,                                  _, 
 %nProofs/averageProofSize/sd - [minSize,maxSize] - all,
 _, 
 %nWorlds, nBestWorlds, bestPercentCovered, time_seconds).
 _NWorlds, _,            _BestCovered,        _Time),
   out,out).


/*

	


report :-
	report_cleanup,
	['../dialects/qcm/theories/28sym.out'],
	report_details(Reports),
	member(total=Total0,Reports),
	member(sum-Total,Total0),
	!,
	member(What=X,Reports),
	member(sum-Sum0,X),
	Sum is integer((Sum0*100)/Total),
	print(What=Sum),nl,	
	fail.
report.

report_cleanup :-
	member(F/A,[result/13,ticks/1, about/4,
		   fSweepNumbers/5]),
	(dynamic F/A),
	functor(Term,F,A),
	retract(Term),
	fail.
report_cleanup.

report_details(Report) :-
	Fields= [total,
		 validate,
                 worldsSweep,
                 backwardsSweep,
                 forwardSweep,
                 prep,
                 data
                ],
	make_report0(Fields,Report0),
	bagof(T,ticks(T),Data),
	report_details1(Data,Fields,Report0,Report1),
	summarise_report(Report1,Report).

make_report0(In,Out) :-	bagof(X=[],In^member(X,In),Out).

report_details1([],_,Out,Out).
report_details1([H|T],Fields,In0,Out) :-
	report_details2(Fields,H,In0,In1),
	report_details1(T,Fields,In1,Out).

report_details2([],_,Out,Out).
report_details2([Field|Fields],T,In0,Out) :-
	memberOr(Field - Time/_PTime,Time,0,T), !,
	report_details3(In0,Field,Time,In1),
	report_details2(Fields,T,In1,Out).

report_details3([Field=Old|Rest],Field,Data,[Field=[Data|Old]|Rest]) :-!.
report_details3([H|T],Field,Data,[H|Tail]) :-
	report_details3(T,Field,Data,Tail).

memberOr(X,_Y,_Or,L) :- member(X,L),!.
memberOr(_X,Or,Or,_L).

summarise_report([],[]).
summarise_report([Field=Numbers|T1],[Field=Report|T2]) :-
	stats(Numbers,Report),
	summarise_report(T1,T2).

*/	