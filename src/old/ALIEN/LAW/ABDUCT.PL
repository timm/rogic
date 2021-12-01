% join(v,27,outOfEnv(comp(bb,=,f))).

% time
% layers of conflict resolution operators
% ripples
 
:- +[basic,records,lib/oset, types/e, types/v,types/obj].

:- dynamic in/1, out/1, fact/1, a/1, ac/1, culled/1, inStar/1.
 
spys :- forall(member(X,[factSweep,
	forwardSweep,
	backwardSweep,
	worldSweep]), spy(X)).

record(h(ins,outs,facts,proofs,worlds)).
record(xplain(ins=[],outs,cost=0,edges=[],env=[],type)).

portrasy(xplain(Id,Ins,Outs,Cost,Edges,Env,Type)) :-
    write('XPLAIN('),
    write((id=Id,ins=Ins,outs=Outs,cost=Cost,
                 edges=Edges,env=Env,type=Type)),
    write(')').
xplain0(show,    xplain(Id,Ins,Outs,Cost,Edges,Env,Type),
	         xplain(Id,Ins,Outs,Cost,Edges,Env,Type)) :-
	maplist(vName,Ins,Ins1),
	maplist(vName,Outs,Outs1),
	maplist(vName,Env,Env1),
	tprint(xplain(
		'id    '=Id,
                'ins   '=Ins1,
                'outs  '=Outs1,
                'cost  '=Cost,
                'edges '=Edges,
                'env   '=Env1,
                'type  '=Type)),nl.
xplain0(combine([]),X,X).
xplain0(combine([H|T])) --> xplain0(combine1(H)),xplain0(combine(T)).
xplain0(combine1(xplain(_,Ins0,Outs0,Cost0,Edges0,Env0,Type)),
  	         xplain(_,Ins1,Outs1,Cost1,Edges1,Env1,Type),
	         xplain(Id,Ins ,Outs ,Cost ,Edges ,Env ,Type)) :-
	addsIfNoConflict(Edges0,Edges1,Edges),
	set_union(Ins0,Ins1,Ins),
	set_union(Outs0,Outs1,Outs),
	Cost is max(Cost1,Cost0),
	set_union(Env0,Env1,Env),
	flag(id,Id,Id+1).

h0(worldsAre(W))   --> h0(worlds(_,W)).	
h0(fact(One))      --> h0(facts(All)), {member(One,All)}.
h0(in(One))        --> h0(ins(All)), {member(One,All)}.
h0(out(One))       --> h0(outs(All)), {member(One,All)}.

h0(envs(All),H,H)  :- h0(proofs(Proofs),H,H),
		      my_bagof(E, P^Proofs^ES^(member(P,Proofs)
                                           ,xplain0(env(ES),P,P)
                                           ,member(E,ES)
                                           ),
                                  All).
xplain0(edge(E))   --> xplain0(edges(Es)), {member(_@E0,Es),member(E,E0)}.
xplain0(vertex(V)) --> xplain0(edge(Id)),  {join(e,Id,vertex(V))}. 
xplain0(easy(V))   --> xplain0([outs(_,[V]),ins(_,[V]),type(_,easy)]).
xplain0(edgeType(V)) --> xplain0([outs(_,[V]),type(_,edges)]).
xplain0(initTime(V)) --> {join(v,V,time(T))}, xplain0(edges(_,[T@[]])).
xplain0(vertices(Vs),X,X) :- setof(V,X^xplain0(vertex(V),X,X),Vs).
xplain0(addEdge(E),xplain(Id,_,  Outs,Cost0,[When@Edges0|B4],Env0,Type),
		   xplain(Id,[V],Outs,Cost, Edges,           Env, Type)) :-
	join(e,E,[cost(C),from(V),timeType(TType)]),
	inStar(V),                     
        \+culled(V),
	(TType=inter(Last)
	-> Edges=[Last@[E]|[When@Edges0|B4]]
	;  addIfNoConflictOrLoops(Edges0,E,Edges1),
	   Edges=[When@Edges1|B4]),
	Cost is Cost0 + C,
	(ac(V) -> Env=[V] ; Env=Env0).
% XXX to do: breadth first search, ands
xplain0(ascend(X)) --> {in(X)}.
xplain0(ascend(Goal),X0,X) :-
	join(v,Goal,or),
        join(e,E,[to(Goal),from(Parent)]),
	xplain0(addEdge(E),X0,X1),
	xplain0(ascend(Parent),X1,X).
xplain0(ascend(Goal),X0,X) :-
	join(v,Goal,and),
	froms(Goal,InEdges),
	proofs4Parents(InEdges,X0,Xs),
	combos(Xs,[Proof|OtherProofs]),
	xplain0(combine(OtherProofs),Proof,X).

proofs4Parents([],_,[]).
proofs4Parent([Edge|Edges],X0,[Proofs|Rest]) :-
	join(e,Edge,from(Where)),
	bagof(Proof,
	        Where^X0^xplain0(ascend(Where),X0,Proof),
	      Proofs),
        proofs4Parents(Edges,X0,Rest). 
	    
addsIfNoConflict(X1,X2,X) :-
	append(X1,X2,X3),
	sort(X3,X3s),
	addsIfNoConflict1(X3s,X).

addsIfNoConflict1([T@Edges1],[T@Edges1]).
addsIfNoConflict1([T@Edges1,T@Edges2|Rest],Out) :- !,
	addsIfNoConflict2(Edges1,Edges2,Edges3),
	addsIfNoConflict1([T@Edges3|Rest],Out).
addsIfNoConflict1([T1@Edges1,T2@Edges2|Rest],
                  [T1@Edges1|Out]) :-
	addsIfNoConflict1([T2@Edges2|Rest],Out).

addsIfNoConflict2([],Out,Out).
addsIfNoConflict2([H|T],In,Out) :-
	addIfNoConflict(In,H,Temp),
	addsIfNoConflict2(T,Temp,Out).

addIfNoConflict([], El, [El]).  
addIfNoConflict([H|T], El, Add) :- 
	\+ conflict([H],El),	
	compare(Order, H, El), 
	aINC1(Order, H, T, El, Add).

aINC1(<, H, T,  El,  [H|Add]) :- 
	addIfNoConflict(T, El, Add).
aINC1(=, H, T,  _,  [H|T]).
aINC1(>, H, T,  El,  [El,H|T]) :- 
	\+ conflict([H|T],El).

% this predicate does three jobs: stops loops,
% inserts new vertices in their right order,                                                                       
% rejects conflicting vertices

addIfNoConflictOrLoops([], El, [El]).  
addIfNoConflictOrLoops([H|T], El, Add) :- 
	\+ conflict([H],El),	
	compare(Order, H, El), 
	aINCOR1(Order, H, T, El, Add).

conflict(Edges,E2) :-
	member(E1,Edges),
	join(e,E1,from(V1)), 
    	join(e,E2,from(V2)),
     	join(v,V1,contradicts(V2)).

aINCOR1(<, H, T,  El,  [H|Add]) :- 
	addIfNoConflictOrLoops(T, El, Add).
% "=" is the loop case... just fail
%aINC1(=,
% can add if no conflict in rest
aINCOR1(>, H, T,  El,  [El,H|T]) :- 
	\+ conflict([H|T],El).

ht5(In0,Out0,Facts0,Worlds) :-
	vids(In0,In), vids(Out0,Out), vids(Facts0,Facts),
	create(h,[ins(In),outs(Out),facts(Facts)],H0),
	sweeps(H0,H),
	h0(worlds(Worlds),H).

vids(In,Out) :- maplist(vid,In,Out).
vid(Attr@Details,Out) :-
	Details =.. [Op,T,V],
	join(v,Out,[attr(Attr),op(Op),value(V),time(T)]),!.
vid(_@_,X) :-
	flag(id,Id,Id+1),
	X is -1 * Id.

sweeps -->
	factSweep,
	forwardSweep,
	backwardSweep,
	worldSweep.
	
factSweep(H,H) :-
	h0(fact(F),H),
	join(v,F,contradicts(C)),
        ensure(culled(C)),
	fail.
factSweep(H,H).

forwardSweep(H,H) :- h0(out(I),H), ensure(out(I)),  forwardSweep1(I), fail.
forwardSweep(H,H) :- h0(in(I),H),  ensure(in(I)),   forwardSweep1(I), fail.
forwardSweep(H,H) :- h0(fact(F),H),ensure(fact(F)), fail.
forwardSweep(H,H) :- find_a, find_ac.

forwardSweep1(X) :- inStar(X), !.
forwardSweep1(X) :- culled(X), !.
forwardSweep1(X) :- join(v,X,and), !, 
                    \+ unSatisfiedParent(X), forwardSweep2(X).
forwardSweep1(X) :- forwardSweep2(X).

forwardSweep2(X) :- assert(inStar(X)), join(v,X,kid(Kid)), forwardSweep1(Kid).

unSatisfiedParent(X) :- join(v,X,parent(P)), \+ inStar(P). 

find_a :- inStar(V), \+ fact(V), ensure(a(V)), fail.
find_a.

find_ac :- 
	a(V1), 
	join(v,V1,contradicts(V2)), 
	a(V2),     
	ensure(ac(V1)), 
	ensure(ac(V2)), 
	fail.
find_ac.
   
backwardSweep(H0,H) :-
	my_bagof(Proof,  
		O^H^(h0(out(O),H0)
		    ,proof(O,Proof)
		    ),
		Proofs),
	h0(proofs(_,Proofs),H0,H).
	
proof(X,_)     :- culled(X),     !, fail.	 
proof(X,_)     :- \+ inStar(X),  !, fail.
proof(X,P)     :- in(X), out(X), !, create(xplain,[easy(X)],P).
proof(X,Proof) :- create(xplain,[initTime(X),edgeType(X),ascend(X)],Proof).
	
worldSweep(H0,H) :-
	my_bagof(World,H^world(H0,World),Worlds),
	h0(worlds(Worlds),H0,H).

world(H,World) :-
	environment(H,Env),
	h0(proofs(Proofs),H),
	inEnvironment(Proofs,Env,[Proof|OtherProofs]),
	xplain0(combine(OtherProofs),Proof,World).

environment(H,Env) :-
	h0(envs(All),H),
	envDetails(All,[],CompObjects),
	removes1(CompObjects,Env).

inEnvironment([],_,[]).
inEnvironment([Proof|Proofs],Env,[Proof|Rest]) :-
	\+ incompatiable(Proof,Env),!,
	inEnvironment(Proofs,Env,Rest).
inEnvironment([_|Proofs],Env,Rest) :-
	inEnvironment(Proofs,Env,Rest).

incompatiable(Proof,Env) :-
	xplain0(edge(E),Proof),
	join(e,E,v(V)),
	join(v,V,outOfEnv(Env)).
	
% how to handle maths operators... convert them to literals 
% (note: sounds like fun... subsumes hierarchy with unique literals
%  for each leaf)

arg2(X,Y) :- arg(2,X,Y).

envDetails([],Out0,Out) :- maplist(arg2,Out0,Out).
envDetails([V|Vs]) --> envDetail(V), envDetails(Vs).

envDetail(V,In,Out) :-
	join(v,V,[attr(A),op(O),value(Val)]),
	(oneLess(In,A-OV,Temp)
	-> 	(member(comp(A,O,Val),OV)
		-> Out=In
		;  Out=[A-[comp(A,O,Val)|OV]|Temp])
	; Out=[A-[comp(A,O,Val)]|In]).	

showWorlds(Worlds) :-
	length(Worlds,N),
	print(nWorlds=N),nl,
	nth1(Pos,Worlds,World),
	print(world(Pos)), 
	print(:),
        o(show,World),
        fail.
showWorlds(_).

inStars :- inStar(X), vName(X,Y), print(X),write(' -> '),print(Y),nl,fail.
inStars.









