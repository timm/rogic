% vim: filetype=prolog ts=2 sw=2 sts=2 et :
% depth first iterative deepening
prove(Goal,Dmax,How,D) :-
  between(1,Dmax, D),  prove1(Goal,D, [], How).

prove1(X,Y,How0,How) :- 
  once(prove2(X,Y,How0,How)). % look ma, no cuts

prove2(true,_,How,How).
prove2((Goal,Goals),D) -->   
  prove1(Goal,D), prove1(Goals,D).
prove2(Goal, D, How0,How) :- 
  D > 0,
  someSubGoal(Goal, How0, SubGoal, Id),  
  prove1(SubGoal, D-1, [Id|How0],How).

someSubGoal(X, How, Z, Zid) :- 
  setof(R/Y/Id,  (clause(X,Y,Id), randomlySelect1(Id,How,R)), L),
  member(_/Z/Zid,L).

% here where wou bias the choice of sub-goals.
% insert whole phd here. maybe just build a bayes classifier. collect clause ids
% (the "How"s) for each proof and sort them into best or rest. when you arrive here via some
% set of ids, select the subclause which, along with the path of ids coming in,
% maximizes likelihood of best
randomlySelect1(_,_,R) :- random(0.0, 1, R).

:- dynamic assumed/2.
assume(Key,V1) :- assumed(Key,V2) -> V1 \= V2 ;bassert(assumed(Key,V1)).

bassert(X) :- assert(X).
bassert(X) :- retract(X).

a:-b,c.
c:-d1.
c:-d2.
d1.
d2.
b.


