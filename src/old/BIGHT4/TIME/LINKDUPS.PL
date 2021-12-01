% linkdups.pl

% Contains routines to link duplicated models, called from dupmods.pl code.
% Two distinctions between linking: firstly implicit (no time information
% provided) and explicit (information on where links over time occur is
% provided); and secondly node linking (between same node in different time
% steps) and edge linking (edges added or redirected to join duplicate models).
% Note that correct linking depends on the correct ordering of the WmeIds.

% Depending on whether linking by nodes or edges and whether explicitly or
% implicitly linking, select vertex ids where links over time are to occur,
% then link through time by generating appropriate edge links.
linkDups(Link-Feat-For,Stamps,MaxId,WmeIds,OrigW,RestW,Wmes0,Wmes) :-
	(Feat = node
	 -> findall(Id, selectLinkNodes(Link, RestW, OrigW, Id), Ids0)
	  | findall(Id, selectLinkEdges(Link, RestW, OrigW, Id), Ids0)
	),
	sort(Ids0, Ids),
	doLinking(Ids, Stamps, For, WmeIds, MaxId, Wmes0, Wmes).


% Select the id a vertex where time node occurs.  Done by selecting a feature
% class, checking if time class for explicit linking, selecting feature name,
% and then select individual (non-steady) vertex id.  Assumes cost (1) and
% source (0).
selectLinkNodes(LinkStyle, RestWmes, OrigWmes, VId-1-0) :-
	member(source(_, objects(Class) = Names), RestWmes),
	(LinkStyle = implicit; timeClass(Class)),
	member(VertexLabel, Names),
	member(l(VId, VertexLabel, State), OrigWmes),
	\+ State = std.

% Select the ids of vertices where time edge occurs.  Done by selecting a
% theory edge, checking if time edge for explicit linking, and then selecting
% vertex ids, cost and source from specifc edge information.
selectLinkEdges(LinkStyle, RestWmes, OrigWmes, Fr/To-C-S) :-
	member(source(S,Src), RestWmes),
	defEdge(Link, Src, _, _),
	(LinkStyle = implicit; timeLink(Link)),
	member(e(_,Fr,To,C,S), OrigWmes).


% Given a list of vertex ids, select the duplicate ids and link these together.
% Select edges with the given source line and perform edge linking.
doLinking([], _, _, _, _, Wmes, Wmes).
doLinking([OId-C-S|Ids], Stamps, For, WmeIds, Id0, Wmes0, Wmes) :-
	(OId = Fr/To
	 -> member(Fr-Frs,      WmeIds),
	    member(To-[_|Tos],  WmeIds)
	  | member(OId-[F|Tos], WmeIds),
	    Frs = [F|Tos]
	),
	genLinks(Frs, Tos, Stamps, For, C-S, Id0, Id, Wmes0, Wmes1),
	doLinking(Ids, Stamps, For, WmeIds, Id, Wmes1, Wmes).


% Given two vertex id lists for vertices over time, add edge between vertices
% to graph.  Assumes "from" list has one more element than "to" list, and that
% time stamps are synchronised.  Returns new id and new WME list.
genLinks([_], [], [_], _, _, Id, Id, Wmes, Wmes) :- !.
genLinks([Fr|Frs], [To|Tos], [_,T2,_|St], For, C-S, Id0, MaxId, Wmes0, Wmes) :-
	(For = one -> addEdge(T2, Fr-To-C-S, Id0, Id, Wmes0, Wmes1)
		    | addEdges([To|Tos], T2-Fr-C-S, Id0, Id, Wmes0, Wmes1) ),
	genLinks(Frs, Tos, [_|St], For, C-S, Id, MaxId, Wmes1, Wmes).

% Given specific edge information, add all WMEs to form edge in graph.
addEdge(T2, Fr-To-C-S, Id0, Id, Wmes0,
	    [T2-e(Id,Fr,To,C,S), ei(Fr,Id), ebi(To,Id),
	     kids(Fr,[To|KIds]), parents(To,[Fr|PIds]) |Wmes]) :-
	Id is Id0 + 1,
	(select(Wmes0, kids(Fr, KIds),    Wmes1) -> true | KIds = []),
	(select(Wmes1, parents(To, PIds), Wmes)  -> true | PIds = []).

% Used for forward linking.
addEdges([], _, Id, Id, Wmes, Wmes).
addEdges([To|Tos], T2-Fr-C-S, Id0, MaxId) -->
	addEdge(T2, Fr-To-C-S, Id0, Id),
	addEdges(Tos, T2-Fr-C-S, Id, MaxId).
