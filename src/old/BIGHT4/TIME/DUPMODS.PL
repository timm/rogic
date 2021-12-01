% dupmods.pl
%
% Description: This contains clauses to duplicate a compiled graph for a
% number of time steps, linking nodes between the time steps appropriately.
% The time steps are presented in a sorted list, with an intermediate copy of
% the model generated in between non-adjacent time steps for implicit linking
% and all intermediate models generated for explicit linking.  Calls functions
% in linkdups.pl which perform the linking of the duplicate graphs.

% Duplicate the network in .net the number of times within the .run files,
% writing the results to a .ntt file, after adjusting the times required.
dupModel(Name, Dialect, LParams, Comp, Times) :-
	theory_file(Dialect, Name, '.net', NetName),
	reads(NetName, In),
	duplicateG(In, LParams, Comp-Times, Out),
	theory_file(Dialect, Name, '.ntt', DupName),
	writes(Dialect, Out, DupName).

%------------------------------------------------------------------------------
% Code for duplicating net given the time ticks required
%------------------------------------------------------------------------------
% Duplicate the net defined by the AllWmes WMEs for each time tick in Times.
duplicateG(AllWmes0, LParams, CTimes, AllWmes) :-
	% Remove and and steady vertices if required
	deleteIrrelevantWmes(AllWmes0, AllWmes1),

	% Separate WMEs to modify or not, and determine ids to modify (plus
	% maximum id -- note this assumes that the MaxId0 will be higher than
	% the id of WMEs not being changed).
	wmesToModify(AllWmes1, ChangeWmes, WmeIds0, RestWmes),
	members(WmeIds0, WmeIds),
	last(MaxId0, WmeIds),

	% Generate time stamps [t(Id, startTime, stopTime)] and calculate
	% how many duplicates are needed (along with the current MaxId).
	timeStamps(LParams, CTimes, MaxId0, Stamps, TimeStepTotal, MaxId1),

	% Generate the new id numbers for net duplication.
	duplicateIds(WmeIds, MaxId1, TimeStepTotal, NewWmeIds, MaxId),

	% Generate duplicate WMEs (pairing with time stamp information).
	generateDupWMEs(ChangeWmes, Stamps, NewWmeIds, DupWmes0),

	% Link duplicate models using e, ei, ebi and collate generated WMEs
	linkDups(LParams, Stamps, MaxId, NewWmeIds,
		 ChangeWmes, RestWmes, DupWmes0, DupWmes1),

	% Remove time stamp info, make whens [when(vid/eid, timestampId)] and
	% collate generated WMEs.
	strip(DupWmes1, DupWmes2),
	appends([DupWmes2,Stamps,RestWmes], AllWmes).


%------------------------------------------------------------------------------
% Code to remove steady and and vertices (not required for implicit linking)
%------------------------------------------------------------------------------
% Select the ids of irrelevant Wmes, sort and use to select the relevant Wmes.
%deleteIrrelevantWmes(explicit-_-_, Wmes,  Wmes).
%deleteIrrelevantWmes(implicit-_-_, Wmes0, Wmes) :-
deleteIrrelevantWmes(Wmes0, Wmes) :-
	selectIrrIds(Wmes0, IrrIds0),
	addIrrEdges(Wmes0, IrrIds0, IrrIds1),
	sort(IrrIds1, IrrIds),
	bagof(Wme, Wmes0^selectRelWme(Wmes0, IrrIds, Wme), Wmes), !.

% From a list of Wmes return the ids of irrelevant object, vertex and
% literal WMEs (note that the ids for vertices and literals are the same).
selectIrrIds([], []).
selectIrrIds([o(O,_,and)|Wmes], [O|Ids]) :-	!, selectIrrIds(Wmes, Ids).
selectIrrIds([v(V,V,and)|Wmes], [V|Ids]) :-	!, selectIrrIds(Wmes, Ids).
selectIrrIds([l(L,_,std)|Wmes], [L|Ids]) :-	!, selectIrrIds(Wmes, Ids).
selectIrrIds([_		|Wmes], Ids) :-		   selectIrrIds(Wmes, Ids).

% Ensure that all irrelevant edge ids (which link irrelevant vertices and
% literals) are included in items to be removed (to ensure ei and ebis go).
addIrrEdges([], Ids, Ids).
addIrrEdges([e(EId,F,T,_,_)|Wmes], Ids0, [EId|Ids]) :-
	(member(F,Ids0); member(T,Ids0)), !,
	addIrrEdges(Wmes, Ids0, Ids).
addIrrEdges([_|Wmes], Ids0, Ids) :-
	addIrrEdges(Wmes, Ids0, Ids).

% From a list a Wmes and a list of irrelevant ids, return a Wme which is
% not irrelevant and does not contain an empty reference list once the
% irrelevant ids have been removed (only for parents, kids, and NoGoods)
selectRelWme(Wmes, IrrIds, Wme) :-
	member(Wme0, Wmes),
	\+ irrelevantWme(Wme0, IrrIds),
	removeExtraRefs(Wme0, IrrIds, Wme),
	\+ listWmes(Wme, [], _, _).

% Returns true if Wme immediately irrelevant (ignoring lists of list Wmes)
irrelevantWme(W, DeleteIds) :-
	directIds(W, Ids),
	member(Id, Ids),
	member(Id, DeleteIds).

% Remove any references to irrelevant Wmes from Wmes with lists (others
% already handled -- assumes that the main id will be kept).
removeExtraRefs(Wme0, IrrIds, Wme) :-
	listWmes(Wme0, [VId|List0], Wme, [VId|List]),
	deletes(List0, IrrIds, List), !.
removeExtraRefs(Wme, _, Wme).

% Selects out direct id information (that not contained in a list)
% theory WMEs (plus object clause)
directIds(o(OId, _, _),		[OId]).
directIds(i(VIdA, VIdB),	[VIdA, VIdB]).
directIds(v(VId, LId, _),	[VId, LId]).
directIds(l(LId, _, _),		[LId]).
directIds(e(EId, Fr, To, _, _),	[EId,Fr,To]).

% theoryDetail WMEs
directIds(coi(_, OId),		[OId]).
directIds(ei(Par, EId),		[Par, EId]).
directIds(ebi(Child, EId),	[Child, EId]).
directIds(lvi(LId, VId),	[LId, VId]).
directIds(oli(OId, LId),	[OId, LId]).
directIds(kids(VId, _Kids),	[VId]).	% Check list later so ignore
directIds(parents(VId, _Pars),	[VId]).
directIds(noGoods(VId, _VIds),	[VId]).

% theoryDetail WMEs indicating those with list information
listWmes(kids(VId,Kids0),	[VId|Kids0], kids(VId,Kids),	[VId|Kids]).
listWmes(parents(VId,Pars0),	[VId|Pars0], parents(VId,Pars),	[VId|Pars]).
listWmes(noGoods(VId,VIds0),	[VId|VIds0], noGoods(VId,VIds),	[VId|VIds]).


%------------------------------------------------------------------------------
% Code to extract WMEs which require duplication and those which do not
%------------------------------------------------------------------------------
wmesToModify([], [], [], []).
wmesToModify([Head|Tail], [Head|Mods], [WmeIds|WmesIds], Rest) :-
	wmesModify(Head,WmeIds,_,_), !,
	wmesToModify(Tail, Mods, WmesIds, Rest).
wmesToModify([Head|Tail], Mods, WmesIds, [Head|Rest]) :-
	wmesToModify(Tail, Mods, WmesIds, Rest).

% Explicit details of WMEs requiring duplication in time modelling (conducted
% for WMEs in theory and theoryDetail classes)
% Form: wmesModify(Old,OldValues,New,NewValues).

% theory WMEs
wmesModify(i(IdA0,IdB0), [IdA0,IdB0], i(IdA,IdB), [IdA,IdB]).
wmesModify(v(Id0,Lit0,AndOr), [Id0,Lit0], v(Id,Lit,AndOr), [Id,Lit]).
wmesModify(l(Id0,Obj,Val), [Id0], l(Id,Obj,Val), [Id]).
wmesModify(e(Id0,Fr0,To0,Cost,Source), [Id0,Fr0,To0],
	   e(Id, Fr, To, Cost,Source), [Id, Fr, To]).

% theoryDetail WMEs
wmesModify(ei(Par0,Edge0), [Par0,Edge0], ei(Par,Edge), [Par,Edge]).
wmesModify(ebi(Child0,Edge0), [Child0,Edge0], ebi(Child,Edge), [Child,Edge]).
wmesModify(lvi(Lit0,Vert0), [Lit0,Vert0], lvi(Lit,Vert), [Lit,Vert]).
wmesModify(kids(VId0,Kids0), [VId0|Kids0], kids(VId,Kids), [VId|Kids]).
wmesModify(parents(VId0,Pars0), [VId0|Pars0], parents(VId,Pars), [VId|Pars]).
wmesModify(noGoods(IdA0,IdB0), [IdA0|IdB0], noGoods(IdA,IdB), [IdA|IdB]).
wmesModify(oli(Class, LId0), [LId0], oli(Class, LId), [LId]).


%------------------------------------------------------------------------------
% Code for creating time stamps and calculating the number of models required
%------------------------------------------------------------------------------
timeStamps(Link-Feat-_, Comp-[First|Rest], MaxId0, Stamps, TimeStepTotal,
	   MaxId1) :-
	(Link = implicit
	 -> Times0 = [First|Rest]
	  | last(Last, Rest),
	    generateTimes(First, Last, Times0)
	),
	(Comp = inter -> Times = Times0 | [_|Times] = Times0),
	timeStamps1(Times, Feat, MaxId0, Stamps, TimeStepTotal, MaxId1).

% Generates the numbers between First and Last inclusive.
generateTimes(N, N, [N]).
generateTimes(N1, N2, [N1|Rest]) :-
	N1 < N2,
	NewN1 is N1 + 1,
	generateTimes(NewN1, N2, Rest).

% Given a list of time steps and an max id, return a list of stamps, the
% number of models, and the id of the last WME created.  Three cases given:
% single time step, adjacent time steps and non-adjacent time steps
timeStamps1([T], _, Id, [t(Last,T,T)], 1, Last) :- Last is Id + 1.
timeStamps1([T1,T2|Times], Feat, Id0,
	    [t(Id1,T1,T1), t(Id2,T1,T2)|Rest], Copies, Last) :-
	(1 is T2 - T1; Feat = edge), !,
	Id1 is Id0 + 1, Id2 is Id0 + 2,
	timeStamps1([T2|Times], Feat, Id2, Rest, Copies0, Last),
	Copies is Copies0 + 1.
timeStamps1([T1,T2|Times], Feat, Id0,
	    [t(Id1,T1,T1), t(Id2,T1,TD), t(Id3,TD,TD), t(Id4,TD,T2)|Rest],
	    Copies, Last) :-
	TD = (T1+delta),
	Id1 is Id0 + 1, Id2 is Id0 + 2, Id3 is Id0 + 3, Id4 is Id0 + 4,
	timeStamps1([T2|Times], Feat, Id4, Rest, Copies0, Last),
	Copies is Copies0 + 2.


%------------------------------------------------------------------------------
% Generating new Id numbers
%------------------------------------------------------------------------------
% Generate N new Id numbers necessary for duplication for each original Id,
% copying them into a set of bins that look like this:
%	OldNumber - [OneNewNumberAtATimeStep|Rest]
duplicateIds([], MaxId, _, [], MaxId).
duplicateIds([Id|Ids], MaxId0, N, [Id-NewDups|NewIds], MaxId) :-
	generateNumbers(MaxId0, N, NewDups, MaxId1),
	duplicateIds(Ids, MaxId1, N, NewIds, MaxId).

% Generate a list of numbers starting from the first argument value, creating
% N values, returning the list of values and the maximum value.
generateNumbers(Max, 0, [], Max) :- !.
generateNumbers(Id0, N0, [Id|Rest], Max) :-
	Id is Id0 + 1,
	N is N0 - 1,
	generateNumbers(Id, N, Rest, Max).


%------------------------------------------------------------------------------
% Code to produce duplicate WMEs
%------------------------------------------------------------------------------
% Generate a list of new WMEs with time stamps combined 
generateDupWMEs(Wmes0, Stamps, Ids, Wmes) :-
	modelStamp(Stamps, Mods),
	bagof(Out, Wmes0^Mods^Ids^genDupWMEs1(Wmes0,Mods,Ids,Out), Wmes).

% Generate pairing of arbitrary time tick and the timeStamps of models
modelStamp([], []).
modelStamp([t(TSId,T,T)|Stamps0], [t(TSId,T,T)|Stamps]) :- !,
	modelStamp(Stamps0, Stamps).
modelStamp([_|Stamps0], Stamps) :-
	modelStamp(Stamps0, Stamps).

% for each time step do
%   select new ids for that time step
%   for each wme do
%     generate copies of that wme
genDupWMEs1(Wmes, Stamps, Ids0, StampedWme) :-
	nth(Stamps, Step/Stamp),
	selectIds(Ids0, Step, Ids),
	member(Wme0, Wmes),
	wmesModify(Wme0, Nums0, Wme, Nums),
	generateDupWMEIds(Nums0, Ids, Nums),
	stampVertEdge(Stamp, Wme, StampedWme).

% Select new id numbers corresponding to the appropriate time step.
selectIds([], _, []).
selectIds([Old-Dups|IdLists], Step, [Old-New|IdPairs]) :-
	nth(Dups, Step/New),
	selectIds(IdLists, Step, IdPairs).

% for each id in that wme do, pull out new id (given time and id list)
generateDupWMEIds([], _, []).
generateDupWMEIds([Old|T0], Ids, [New|T]) :-
	member(Old-New, Ids),
	generateDupWMEIds(T0, Ids, T).

% stamp vertex and edge WMEs, avoiding stamp for others.
stampVertEdge(Stamp, v(Id,L,AndOr),   Stamp-v(Id,L,AndOr)  ) :- !.
stampVertEdge(Stamp, l(Id,N,Val),     Stamp-l(Id,N,Val)    ) :- !.
stampVertEdge(Stamp, e(Id,Fr,To,C,S), Stamp-e(Id,Fr,To,C,S)) :- !.
stampVertEdge(_, Wme, Wme).


%------------------------------------------------------------------------------
% Code for generating when clauses and stripping time stamp from WMEs
%------------------------------------------------------------------------------
% Remove paired item from WMEs, adding whens and separating kids and parents.
strip([], []).
strip([t(T,_,_)-e(Id,Fr,To,C,S)|Wmes0], [e(Id,Fr,To,C,S),when(Id,T)|Wmes]) :-
	!, strip(Wmes0, Wmes).
strip([t(T,_,_)-v(Id,L,N)|Wmes0], [v(Id,L,N),when(Id,T)|Wmes]) :-
	!, strip(Wmes0, Wmes).
strip([_-Wme|Wmes0], [Wme|Wmes]) :- strip(Wmes0, Wmes).	% for literals
strip([Wme  |Wmes0], [Wme|Wmes]) :- strip(Wmes0, Wmes).
