% clumping is just a bad idea.
% this code has bugs: 40/870 different runs on the Smythe '89 code
% even with that: 2248 secs for 870 without clumping
%                 3259 secs for 870 with clumping
%                 909 seconds to do the clumping
%                 adds 102 seconds to the process (4.5% slower). (102/2248)
                                      


/*
:- dynamic culledDown/1.
cullDown(_) :-
	flag(culling,_,0),
	culled(X),
	cullDown1(X),
	fail.
cullDown(N) :-
	flag(culling,N,N).

cullDown1(X) :- 
	orVertex(X), 
	kid(X,K), 
	\+ inParent1(K,_), 
	\+ culled(K),
	assert(culled(K)),
	flag(culling,Killed,Killed+1),
	cullDown1(K).

cullDown1(X) :- 
	andVertex(X), 
	kid(X,K), 
	\+ culled(K),
	assert(culled(K)),
	flag(culling,Killed,Killed+1),
	cullDown1(K).

cullDownTest2(X,Culled0,Culled) :- 
	orVertex(X), 
	kid(X,K), 
	\+ inParent1(K,_,Culled0), 
	\+ member(K,Culled0),
	!,
	set_addel(Culled0,K,Culled1),
	cullDownTest2(K,Culled1,Culled).

cullDownTest2(X,Culled0,Culled) :- 
	andVertex(X), 
	kid(X,K), 
	\+ member(K,Culled0),
	!,
	set_addel(Culled0,K,Culled1),
	cullDownTest2(K,Culled1,Culled).
cullDownTest2(_,C,C).

cullDownTest(X,C) :-
	culleds(All),
	culled(X),
	set_new(C0),
	cullDownTest1(X,C0,C),
	set_size(C,L),
	L > 1.

culleds(All) :- setof(X,culled(X),All0), set_adds(All0,All).
inParent1(X,P,_C) :- parent(X,P), inStar(P), \+ culled(P).
*/
%----------------------------------------------------

nClumps(N) :-
	n(clumps1(_),N).

clumps(clumpOn/ N) :-
	option(jump), !,
	n(inStar(_),N1),
	bagof(C,clumps1(C),All),
	length(All,AllN),
	set_new(S0), set_unions(All,S0,S),	
	set_size(S,N2),
	N is ((N2 + AllN) * 100) /N1 .
clumps(clumpOff/0).

clumps1(C) :-
	clump_data(_,_,C,_,_,_,_).

set_unions([],S,S).
set_unions([Clump|Clumps],S0,S) :-
	set_union(Clump,S0,S1),
	set_unions(Clumps,S1,S).

testKludge :- retractall(clumpAble(_,_,_,_)),
              retractall(clump_data(_,_,_,_,_,_,_)).
find_clump_data :-
	clumpAblePrimitives,
	clump(C_members,E_members,Root,Leaf,Cost,Forbids,AB),
	assert(clump_data(Leaf,Root,C_members,E_members,Cost,Forbids,AB)),
	fail.
find_clump_data.

% delete clump root and head.
clump(C) :-	clump(C,_,_,_,_,_,_).

% not: clumps do not carry details about the clump root.
clump(Vertices,Edges,Root,Leaf,Cost,Forbids,AB) :-
	clumpLeaves(Leaves),
	member(Leaf,Leaves),
	sets_empty([Vertices0,AB0,Edges0,Forbids0]),
	Cost0 = 0,
	clump1(Leaf, Vertices0,Forbids0,AB0,Cost0,Edges0,
               Root, Vertices, Forbids, AB, Cost, Edges),
	\+ set_empty(Edges).

clump1(Root,Vertices,Forbids,AB,Cost,Edges,
       Root,Vertices,Forbids,AB,Cost,Edges) :-
	\+ clumpAble(Root,_,_,_), !.
clump1(V,    Vertices0,Forbids0,AB0,Cost0,Edges0,
       Root, Vertices, Forbids, AB, Cost, Edges) :-
	clumpAble(V,P,Eid,Cost1),
	set_newel(Vertices0,P,Vertices1), % loop detection
	\+ set_member_chk(P,Forbids0), 
	(noGoods(P,Forbids1) 
        ->  set_union(Forbids0,Forbids1,Forbids2)
        |   Forbids2 = Forbids0),
	(ac(P) -> set_adds([P],AB1) | AB1 = AB0),
	set_addel(Edges0,Eid,Edges1),
	Cost2 is Cost0 + Cost1,
	clump1(P,    Vertices1,Forbids2,AB1,Cost2,Edges1,
               Root, Vertices, Forbids, AB, Cost, Edges).

clumpLeaves(All) :- setof(K,clumpLeaf(K), All).
clumpLeaf(X)     :- clumpAble(X,_,_,_), \+ (kid(X,K), clumpAble(K,_,_,_)).
	
clumpAbles(All)  :- setof(X,P^E^C^clumpAble(X,P,E,C),All).

clumpAblePrimitives :-

	clumpAblePrimitive(X,P,Eid,Cost),
	assert(clumpAble(X,P,Eid,Cost)),
	fail.
clumpAblePrimitives.

clumpAblePrimitive(X,P,Eid,Cost)  :- 
	inStar(X), orVertex(X), 
	\+ in(X), \+ culled(X), 
	inParents(X,[details(P,Eid,Cost)]).

inParents(X,Out) :- 
	bagof(Details,X^inParent(X,Details),Out).
inParent(X,details(P,Eid,Cost)) :- 
	ebi(X,Eid),
	e(Eid,P,X,Cost,_),
	inStar(P), \+ i(X,P), \+ in(P), \+ culled(P).










