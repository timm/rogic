% Shanghai 0.1 : a system that will always try to perform abductions
%
% Tim Menzies (timm@insect.sd.monash.edu.au)
% abductive inference engine supporting full worlds-level assessment
% also, all set manipulationsa re via a set of high-level predicates so
%       we can later experiment with the internal representation of the 
%       sets
%
% N.B. 'and' treated as a world assessment heuristic (no, no no no)

tooLong(X) :- X is cputime + 10 * 60. 
                           % fifteen881 minutes: 
                           % equals 40 minutes of HT4-smalltalk 
worlds(Worlds) :-
	worlds(_,Worlds).
worlds(Proofs,AB,A,Worlds) :-
	wmeClear(run),
	tooLong(StopTime),
	assert(stopTime(StopTime)),
	write('%fsweep'),nl,
	prep(A),
	write('%bsweep'),nl,
	proofs(AB,Objects,Proofs),
	write('%wsweep'),nl,
	bagof(World,A^AB^Objects^Proofs^
                    world(A,AB,Objects,Proofs,World),
	      Worlds).

prep(A) :-
	tick(proofs,prep),
	facts(F),
	factsSweep(F),
	tick(proofs,forwardSweep),
	forwardSweep, 
	find_a(F,A), 
	find_ac.

proofs(AB,Objects,Proofs) :-	
	tick(proofs,backwardsSweep),
	backwardSweep(Proofs), 
	find_ab(Proofs,AB, Objects).

world(A,AB_all,Objects,Proofs,World) :-
	tick(proofs,worldsSweep),
	world_base_assumptions(AB_all,A,Objects,WBA),
	edgesInWorld(Proofs,WBA,World).

details(V,I,O,F,M,Missables) :- 
	vertices(V), 
	ins(I), outs(O), facts(F), 
        maybes(M), missables(Missables).

goodExample(_,I,O,F,M,Missables) :-
	set_is_subset(O,F),
	set_is_subset(Missables,O),
	set_is_subset(F,M),
	set_is_subset(O,M),
	set_is_subset(I,M),
	set_is_subset(Missables,M),
	(set_member(X,O), \+ andVertex(X)),
	!.

 
%----------------------------------------------------------------------
% forwardSweep

forwardSweep :- in(I),	forwardSweep1(I), fail.
forwardSweep.

forwardSweep1(X) :- inStar(X), !.
forwardSweep1(X) :- culled(X), !.
forwardSweep1(X) :- andVertex(X), !, 
                    \+ unSatisfiedParent(X), forwardSweep2(X).
forwardSweep1(X) :- forwardSweep2(X).

forwardSweep2(X) :- assert(inStar(X)), kid(X,Kid), forwardSweep1(Kid).

unSatisfiedParent(X) :- parent(X,P), \+ inStar(P). 

%-----------------------------------------------------------------------
% facts sweep

factsSweep(Facts) :-
	set_member(F,Facts),
	contradicts(F,V), 
	ensure(culled(V)), 
	fail.
factsSweep(_).

find_a(F,A) :- find_a1(F),my_setof(X,a(X),A).

find_a1(F) :- inStar(V), \+ set_member_chk(V,F),ensure(a(V)), fail.
find_a1(_).

find_ac :- 
	a(V1), 
	i(V1,V2), % 2
	a(V2),    % 3  note that if 2 and 3 are reveresed,
	          %    system slows down by a factor of THREE!!!
	ensure(ac(V1)), 
	ensure(ac(V2)), 
	fail.
find_ac.

%------------------------------------------------------------------------
% backwards sweep

prin(X) :- print(X), flush_output(user).

backwardSweep(Proofs) :-
	bagof(Proof,X^(out(X),proof(X,Proof)),Proofs).

proof(X,_) :- culled(X),                !, fail.	
proof(X,P) :- \+ inStar(X), ok2Fail(X), !, proof0(X,isolated,P).
proof(X,_) :- \+ inStar(X),             !, fail.
proof(X,P) :- in(X), out(X),            !, proof0(X,easy,P).
proof(X,P) :- proof0(X,edges,P0), ascend(X,P0,P).
	
ascend(_,_,_) :- 
	Now is cputime, stopTime(Stop), Now > Stop,
	write('% *** HALTING PROOF GENERATION ***'),nl,
	halt.
ascend(	X,Out,Out) :- 
	in(X).
ascend(	X, In, Out) :- 
	orVertex(X),!, 
	step(X,Parent,In,Temp),
	ascend(Parent,  Temp, Out).
ascend(	X, In, Out) :-
	parents(X,Parents),
	proofsForParents(Parents,X,In,AllProofs),
	combos(AllProofs,Proofs),
	combineProofs(Proofs,Out).

% find all proofs of all parents	
proofsForParents([],_,_,[]).
proofsForParents([Parent|Parents],X,In,[Proofs|Rest]) :-
	bagof(Proof, 
	         Parent^In^X^proofForParent(Parent,X,In,Proof),
              Proofs), % note, if any parent has no prrof, 
	               % fail proofsForParents right here
	proofsForParents(Parents,X,In,Rest).

proofForParent(Parent,X,In,Out) :- 
	step(X,Parent,In,Temp), 
	ascend(Parent, Temp, Out).

% low-level proof details.

proof0(X,Type,p(Id,X,Cost,Edges,Vertices,Forbids,
                AB, Roots, Type)) :-
	sets_empty([Edges,AB,Roots]),
	noGoods(X,Forbids),
	set_with([X],Vertices),
	Cost = 0,
	newN(Id).

/*
jump(C_Root,C_Vertices,C_Edges,C_Cost,C_Forbids,C_AB,
     p(Id,Goal,Cost0, Edges0, Vertices0, Forbids0, AB0, _Roots0,edges),
     p(Id,Goal,Cost,  Edges,  Vertices,  Forbids,  AB,  Roots,  edges)) :-
	%1,2,3 UN-NECESSARY                  
	set_no_int(C_Vertices,Forbids0),              %4 parents not forbidden
	set_union_new(C_Vertices,Vertices0,Vertices), %5 no loops
	set_no_int(C_Forbids,Vertices),               %6,7
        set_union(C_Forbids,Forbids0,Forbids),        %8
	Cost is C_Cost + Cost0,                       %9
        set_union(Edges0,C_Edges,Edges),              %10
	(set_empty(C_AB) -> AB = AB0 | AB = C_AB),    %11
	set_with([C_Root],Roots).                     %12
*/
step(X,Parent,p(Id,Goal,Cost0,Edges0,Vertices0,Forbids0,AB0,_,    edges),
	      p(Id,Goal,Cost, Edges, Vertices, Forbids, AB, Roots,edges)) :-
	upEdge(X,Eid,Parent,Cost1),            %1
	inStar(Parent),                        %2 reachable from In
	\+ culled(Parent),                     %3 not culled
	\+ set_member_chk(Parent,Forbids0),    %4 parent not forbidden
	set_newel(Vertices0,Parent,Vertices),  %5 fails if already there
	                                       % i.e. loop detection
	(noGoods(Parent,Temp1) -> Forbids1 = Temp1| set_empty(Forbids1)),%6
	set_no_int(Forbids1,Vertices),         %7 current path ok with parent
	set_union(Forbids1,Forbids0,Forbids),  %8
	Cost is Cost0 + Cost1,                 %9
	set_addel(Edges0,Eid,Edges),           %10
	(ac(Parent) -> set_with([Parent],AB) | AB = AB0), %11
	set_with([Parent],Roots).              %12

combineProofs([P],P).
combineProofs([P1,P2|T],Out) :- 
	combine2Proofs(P1,P2,P3),
	combineProofs([P3|T],Out).

combine2Proofs(  
       p(_,X,Cost1,Edges1,Vertices1,Forbids1, 
	 AB1,Roots1,edges),
       p(_,X,Cost2,Edges2,Vertices2,Forbids2, 
	 AB2,Roots2,edges),
       p(Id,X,Cost,Edges,Vertices, 
	 Forbids, AB,Roots,edges)
   ) :-	
	set_union(Vertices1,Vertices2,Vertices),
	set_union(Forbids1,Forbids2,Forbids),
	set_no_int(Vertices,Forbids),   % check combo is valid
	newN(Id),
	max([Cost1,Cost2],Cost),
	set_union(Edges1,Edges2,Edges),
	set_union(AB1,AB2,AB),
	set_union(Roots1,Roots2,Roots).

find_ab(Proofs,AB,Objects) :- 
	sets_empty([AB0,Objects0]),
	find_ab1(Proofs,AB0,Objects0,Objects,AB).

find_ab1([],AB, Objects,AB, Objects).
find_ab1([H|T],Objects0,AB0, Objects, AB) :-
	p(ab,H,ABnew),
	find_ab2(ABnew,Objects0,AB0,Objects1,AB1),
	find_ab1(T,Objects1,AB1,Objects,AB).

find_ab2([],O,AB,O,AB).
find_ab2([Item|Items],Objects0,AB0,Objects,AB) :-
	v(Item,Literal,_),
	l(Literal,Value,_),
	o(Objectnew,Value,_),
	set_addel(AB0,Item,AB1),
	set_addel(Objects0,Objectnew,Objects1),
	find_ab2(Items,Objects1,AB1,Objects,AB).

world_base_assumptions(ABS_all,_,Objects,WBA) :-
	object_values(Objects,ABS_all,ObjectValues),
	removes1(ObjectValues,WBA).

object_values([],_,[]).
object_values([Object|Objects],Values,[ObjectValues|Rest]) :-
	set_new(ObjectValues0),
	object_values1(Values,Object,ObjectValues0,ObjectValues),
	object_values(Objects,Values,Rest).
	      
object_values1([],_,Out,Out).
object_values1([Value|Values],Object,Out0,Out) :-	
	v(Value,Literal,_),
	l(Literal,HasValue,_),
	o(Object,HasValue,_),
	!,
	set_addel(Out0,Value,Out1),
	object_values1(Values,Object,Out1,Out).
object_values1([_|Values],Object,Out0,Out) :-
	object_values1(Values,Object,Out0,Out).

removes1([],[]).
removes1([H|T],[H1|T1]) :- remove1(H,H1,_),removes1(T,T1).

edgesInWorld(Proofs,WBA,W) :-
	set_new(W0),
	edgesInWorld1(Proofs,WBA,W0,W).

edgesInWorld1(_ ,_,W,W) :- 
	Now is cputime, stopTime(Stop), Now > Stop, 
	write('% *** HALTING WORLD GENERATION ***'),nl,
	halt.

edgesInWorld1([],_,W,W).
edgesInWorld1([Proof|Proofs],WBA,W0,W) :-
	p(forbids,Proof,F),
	set_no_int(F,WBA),!,
	p(edges,Proof,Edges),
	set_union(Edges,W0,W1),
	edgesInWorld1(Proofs,WBA,W1,W).
edgesInWorld1([_|Proofs],WBA,W0,W) :-
	edgesInWorld1(Proofs,WBA,W0,W).


