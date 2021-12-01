:- op(1002,xfy,ror).
:- op(1001,xfy,rand).
:- op(701,fy,?).
:- discontiguous def/4.
:- [sets,utils,pansion,do].

go(Before0,Try,W) :-
	nl,
	sort(Before0,Before),
	wme([],Before,W0),
	do(Try,W0,W).

prepGoals(G0,G,Before0,Before) :-
	sort(Before0,Before),
	maplist(prepGoal,G0,G),
	ht0(G,Before).

prepGoal(G,N-G) :- N is 1 + aPinch.
	
% there is a wme ehre for Nsolved, goals0,BestWmeSinceToData

ht0(0,Goals,_,Before).
ht0(Tries,Goals0,BestN,Best0,Best,Before) :-
	Tries > 0,
	ht0Prim(Goals1,_,W,0,Done,Goals),
	Tries1 is Tries - 1,
		
	keysort(Goals0,Goals1),

	
	Done > BestN
        -> ht0(Tries1,Goals,Done,,Before)
        ;  ht0(Tries1,Goals,Done,Before)
	
ht0Prim([],W,W,Done,Done,[]).
ht0Prim([N-Goal|Goals],W0,W,Done0,Done,[N1-Goal|Rest]) :-
	do(Goal,W0,W1),
	->    recall(W1,W2),
              N1   is N + aPinch,
	      Done is Done0 + 1,
	      ht0(Goals,W2,W,Before,Done,Rest)
	;     N1 is N - aPinch.
              ht0Prim(Goals,W0,W,Before,Done0,Rest).

aPinch(X) :- X is 1 + random(1000)/100000.

:- arithmetic_function(aPinch).
