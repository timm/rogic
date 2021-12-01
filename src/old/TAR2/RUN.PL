wme(bands(_,_)).

go :- d(nChanges(N)), format('\n\n---| ~w |------------------\n',[N]),go(N).

go(M) :- 
	d(granularity(N)),
	go(M,N).

go(M,N) :-
	reset(N), 	
	run(X),
	report(M,X).

reset(N) :- 
        nOf(d(fetch),Egs),
	format('% found: ~w examples\n',[Egs]),
 	write('% building ranges: '), 
        zap, 
	ranges(N).

zap :- wme(X), retractall(X),fail.
zap :- r zap.

ranges(N) :- 
	d(referencedFields(Fields)),
	member(F,Fields),
	ranges1(F,N),
	fail.
ranges(_).

interestingRanges(N,L) :-
	setof(F,interestingRange(F),L),
	length(L,N).

interestingRange(F) :-
	d(field(F)), F\= class, F\= true,
	d(range(F,Range)),
	sort(Range,All),
	All \= [_].

ranges1(F,N) :-
        d(range(F,Range)),
	groups(Range,N,Gs), 
	format('\t~w\n',[F]), flush, 
        assert(bands(F,Gs)).
	
fastrun :- r zap, time(run).

run(X) :-
	makeRules,
	r searches(X).

makeRules :-
        bagof(Y,d([fetch,want,relevant(Y)]),All0),
	length(All0,NRules0),
        format('\n% found: ~w relevant entries; ',[NRules0]),
	msort(All0,All1),
	bins(All1,All2),
	maplist(makeRules1,All2,_),
	length(All2,NRules),format('~w unique entries\n',[NRules]).
	
makeRules1(Data0-N,_) :- 
	r(repeats is N,Data0,Data),
	assert(Data).

report(M,X) :- 
	reportBands,
	nl,
	reportRules(M,X),
	true.

reportRules(M,Changes) :-
	write(user,'+'),flush_output(user),
	retractall(xx(_)),
	assert(xx(Changes)),
	baseLineCounts(Current,Score0),
	reportChange('no change',Current,1),
	d(significant2(Sigs2)),
	d changes(Want),
	format('\n% Can any of ~w\n% improve this score over [~w]? Hmmm...\n',[Want,Sigs2]),
	scoredCounts(M,Changes,Score0,[One|Rest]),
	print(topScore(One)),nl,
	member(Score-(Change/Items),[One|Rest]),
	reportChange(Change,Items,Score),
	fail.
reportRules(_).
	        
reportChange(Change,Items,Score) :-
	nl, 
	d(format(F)),
	format(F,['score',Score,'',0]),
	theBand(Change,Band),
	format(F,['what if',Band,'?',0]),
	forall(member(Class/N,Items),
	       format(F,[Class,N,'%',N])).
	
reportBands :-
	bands(X,L),
	nl,
	format('\n~10<: ',[X]),
	member(group(_,A,B0),L),
	(infinity(B0) -> B = inf ; B = B0),
	format(' [~w .. ~w) ',[A,B]),
	fail.
reportBands.

baseLineCounts(All,Total) :-
	classCounts('no change',All,Total).

scoredCounts(M,Changes,Score,All) :-
%	length(Changes,L),
%	between(1,L,N),
%	length(Change,N),
%	sub(Changes,Change),
	setof(One,Changes^Score^M^scoredCounts1(M,Changes,Score,One),All0),!,
	reverse(All0,All).

scoredCounts(_,_,[]).

collectCommons(L,Out) :-
	maplist(arg(1),L,Names0),
	unique(Names0,Names),
	bagof(Name=NamedValues,
	       Names^(member(Name,Names),
	              bagof(Value,Name^L^member(Name=Value,L),
                            NamedValues)),
	      Out).
settings(M,L,Settings) :-
	collectCommons(L,Commons),
	sub(Commons,Smaller),
	length(Smaller,M),
	Smaller \= [],
	maplist(oneOf,Smaller,Settings).

oneOf(F=Vs,F=V) :- member(V,Vs).


scoredCounts1(M,Changes,Score0,Score-(Changes1/Items)) :-
	d(significant2(S)),
	settings(M,Changes,Changes1),
%	member(Changes11,Changes),
%	Changes1=[Changes11],
%	print(Changes1),nl,
	classCounts(Changes1,Items,Score1),
	Score is Score1/Score0,
	Score >= S.

classCounts(Change,Normals,Total) :-
	bagof(One,Change^classCount(Change,One),All0),
	maplist(arg(2),All0,Ns1),
	sum(Ns1,Members),
	maplist(normalizedMembers(Members),All0,Normals),
	maplist(classCounts1(Members),All0,All),
	maplist(arg(2),All,Ns2),
	sum(Ns2,Total).

classCounts1(N,Class/M,Class/O) :- 
	r(score(Class,Score)),
	(N =:= 0
        -> O = 0
         ;  O is (Score*M/N)).

normalizedMembers(Members,Class/N0,Class/N) :-
	Members =:= 0
        -> N = 0
       ;  N is round(N0*100/Members).

% looks like the paper is wrong- the counts seem to be over the
% baseline activity

classCount(Change,C/N) :-
	r class(C),
	asList(Change,Changes),
	nOf(d([class=C,selects(Changes)]),N).

asList([H|T],[H|T]) :- !.
asList(X,[X]).	


reportaa :-
	reportRules(2, [
                      '[iv&v@76]Cost'=1,
	              '[goodIntegration@147]Cost'=1]).
