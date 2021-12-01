% Computational Intelligence: a logical approach. 
% Prolog Code.
% BELIEF NETWORK for the leaving network
% Copyright (c) 1998, Poole, Mackworth, Goebel and Oxford University Press.

% list of all variables, ordered so the parents of a node 
% are before the node.

variables([problem_complexity, design_effort, testing_effort,operational_usage,
	   defects_introduced, defects_detected,
	   residual_defects,
	   operational_defects]).

/*ok(X) :- variables(L), member(X,L),!.
ok(X) :- print(notok(X)),nl.

ok0(X) :- functor(X,One,_),ok(One).
ok1(X) :- arg(1,X,One), ok(One).

okProb([X,Y]) :- 1 is X + Y,!.
okProb([X,Y]) :- print(notProb(X+Y)),nl.

term_expansion(+parents(A,L),parents(A,L)) :- ok(A), checklist(ok0,L).
term_expansion(+pr(A,L,[X1,X2]),pr(A,L,[X1,X2])) :-
	okProb([X1,X2]),
	ok(A),
	checklist(ok1,L).
*/
%term_expansion(+ X,X).


normalize(L0,L) :- 
	sum(L0,N),
	maplist(normalize1(N),L0,L).
	
normalize1(N,X,Y) :- Y is X/N.
	
sum([],0).
sum([H|T],N) :- sum(T,N1), N is H + N1.
 

term_expansion(r0(X,Y),r1(X,Z)) :-
	l(10,Y),
	normalize(Y,Z).

l(N,X) :- length(X,N),!.
l(_,X) :- print(wrongSize(X)),nl,fail.

r0(very_low, [512,256,128, 64,  32,16,  8,  4,2,1]).
r0(low,  [128,256,512,256,128,64,32,16,8,4]).
r0(average, [1,1,1, 1, 1,   1,   1,    1,   1,    1]).
r0(high, [4,8,16,32,64,128,256,512,256,128]).
r0(very_high,[1,2,4, 8,  16, 32, 64, 128,256,512]). 

r(X,Y) :- r1(X,Y),!.
r(X,_) :- print(badR(X)),nl,fail.

v(very_high,5).
v(high,4).
v(average,3).
v(low,2).
v(very_low,1).

v2(-,V1,V2,V,L) :- v(V1,N1), v(V2,N2), N is min(5,max(1,3 + N1-N2)), v(V,N),r(V,L).

% Structure of the graph
parents(defects_introduced, [problem_complexity, design_effort]).
parents(defects_detected,   [testing_effort, defects_introduced]).
parents(residual_defects,   [defects_introduced, defects_detected]).
parents(operational_defects,[operational_usage, residual_defects]).
parents(problem_complexity, []).
parents(design_effort,      []).
parents(testing_effort,     []).
parents(operational_usage,  []).

% values for variables
values(problem_complexity, [very_low,low,average,high,very_high]).
values(design_effort,      [very_low,low,average,high,very_high]).
values(testing_effort,     [very_low,low,average,high,very_high]).
values(operational_usage,  [very_low,low,average,high,very_high]).
values(defects_introduced, [ n0_10,n10_20,n20_30,n30_40,n40_50,
			    n50_60,n60_70,n70_80,n80_90,n90_100]).
values(defects_detected,   [n0_10,n10_20,n20_30,n30_40,n40_50,n50_inf]).
values(residual_defects,   [n0_10,n10_20,n20_30,n30_40,n40_50,n50_inf]).
values(operational_defects,[n0_10,n10_20,n20_30,n30_40,n40_50,n50_inf]).

% conditional probabilities
pr(problem_complexity,[],[3.45,10.63,20.83,29.9,35.2]).
pr(design_effort,           [],[27.12,23.66,20.02,16.37,12.83]).
pr(testing_effort,           [],[74.94,21.92,2.53,0.47,0.13]).
pr(operational_usage,   [],[0.0,0.0,5.18,35.05,59.77]).




pr(defects_introduced,[problem_complexity=V1,design_effort=V2],L) :- v2(-,V1,V2,_,L).

/*pr(defects_introduced,[problem_complexity=very_low,design_effort=low],L)          :- r(vvery_low,L). 
pr(defects_introduced,[problem_complexity=very_low,design_effort=average],L)   :- r(low,L).
pr(defects_introduced,[problem_complexity=very_low,design_effort=high], L)        :- r(average,L).
pr(defects_introduced,[problem_complexity=very_low,design_effort=very_high],L) :- r(very_high,L).

pr(defects_introduced,[problem_complexity=low,design_effort=very_low],L) :- r(very_low,L).
pr(defects_introduced,[problem_complexity=low,design_effort=low],L) :- r(low,L).
pr(defects_introduced,[problem_complexity=low,design_effort=average],L) :- r(average,L).
pr(defects_introduced,[problem_complexity=low,design_effort=high],L) :- r(high,L).
pr(defects_introduced,[problem_complexity=low,design_effort=very_high],L) :- r(very_high,L).

pr(defects_introduced,[problem_complexity=average,design_effort=very_low],L) :- r(average,L).
pr(defects_introduced,[problem_complexity=average,design_effort=low],L) :- r(average,L).
pr(defects_introduced,[problem_complexity=average,design_effort=average],L) :- r(high,L). 
pr(defects_introduced,[problem_complexity=average,design_effort=high],L) :- r(high,L).
pr(defects_introduced,[problem_complexity=average,design_effort=very_high],L) :- r(very_high,L).

pr(defects_introduced,[problem_complexity=high,design_effort=very_low],L) :- r(very_high,L).
pr(defects_introduced,[problem_complexity=high,design_effort=low],L) :- r(high,L).
pr(defects_introduced,[problem_complexity=high,design_effort=average],L) :- r(average,L).
pr(defects_introduced,[problem_complexity=high,design_effort=high],L)  :- r(average,L).
pr(defects_introduced,[problem_complexity=high,design_effort=very_high],[0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1]).

pr(defects_introduced,[problem_complexity=very_high,design_effort=very_low],[0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1]).
pr(defects_introduced,[problem_complexity=very_high,design_effort=low],[0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1]).
pr(defects_introduced,[problem_complexity=very_high,design_effort=average],[0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1]).
pr(defects_introduced,[problem_complexity=very_high,design_effort=high],[0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1]).
pr(defects_introduced,[problem_complexity=very_high,design_effort=very_high],[0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1]).
*/

pr(defects_detected,[testing_effort=very_low,defects_introduced=n0_10], [0.15,0.15,0.15,0.15,0.15,0.15]).
pr(defects_detected,[testing_effort=very_low,defects_introduced=n10_20], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=very_low,defects_introduced=n20_30], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=very_low,defects_introduced=n30_40], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=very_low,defects_introduced=n40_50], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=very_low,defects_introduced=n50_60], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=very_low,defects_introduced=n60_70], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=very_low,defects_introduced=n70_80], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=very_low,defects_introduced=n80_90], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=very_low,defects_introduced=n90_100], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=low,defects_introduced=n0_10], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=low,defects_introduced=n10_20], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=low,defects_introduced=n20_30], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=low,defects_introduced=n30_40], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=low,defects_introduced=n40_50], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=low,defects_introduced=n50_60], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=low,defects_introduced=n60_70], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=low,defects_introduced=n70_80], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=low,defects_introduced=n80_90], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=low,defects_introduced=n90_100], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=average,defects_introduced=n0_10], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=average,defects_introduced=n10_20], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=average,defects_introduced=n20_30], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=average,defects_introduced=n30_40], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=average,defects_introduced=n40_50], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=average,defects_introduced=n50_60], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=average,defects_introduced=n60_70], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=average,defects_introduced=n70_80], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=average,defects_introduced=n80_90], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=average,defects_introduced=n90_100], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=high,defects_introduced=n0_10], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=high,defects_introduced=n10_20], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=high,defects_introduced=n20_30], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=high,defects_introduced=n30_40], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=high,defects_introduced=n40_50], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=high,defects_introduced=n50_60], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=high,defects_introduced=n60_70], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=high,defects_introduced=n70_80], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=high,defects_introduced=n80_90], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=high,defects_introduced=n90_100], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=very_high,defects_introduced=n0_10], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=very_high,defects_introduced=n10_20], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=very_high,defects_introduced=n20_30], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=very_high,defects_introduced=n30_40], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=very_high,defects_introduced=n40_50], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=very_high,defects_introduced=n50_60], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=very_high,defects_introduced=n60_70], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=very_high,defects_introduced=n70_80], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=very_high,defects_introduced=n80_90], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(defects_detected,[testing_effort=very_high,defects_introduced=n90_100], [0.15,0.15,0.15,0.15,0.15,0.25]).

pr(residual_defects,[defects_introduced=n0_10,defects_detected=n0_10], [0.15,0.15,0.15,0.15,0.15,0.15]).
pr(residual_defects,[defects_introduced=n0_10,defects_detected=n10_20], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n0_10,defects_detected=n20_30], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n0_10,defects_detected=n30_40], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n0_10,defects_detected=n40_50], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n0_10,defects_detected=n50_inf  ], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n10_20,defects_detected=n0_10], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n10_20,defects_detected=n10_20], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n10_20,defects_detected=n20_30], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n10_20,defects_detected=n30_40], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n10_20,defects_detected=n40_50], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n10_20,defects_detected=n50_inf  ], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n20_30,defects_detected=n0_10], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n20_30,defects_detected=n10_20], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n20_30,defects_detected=n20_30], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n20_30,defects_detected=n30_40], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n20_30,defects_detected=n40_50], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n20_30,defects_detected=n50_inf  ], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n30_40,defects_detected=n0_10], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n30_40,defects_detected=n10_20], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n30_40,defects_detected=n20_30], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n30_40,defects_detected=n30_40], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n30_40,defects_detected=n40_50], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n30_40,defects_detected=n50_inf  ], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n40_50,defects_detected=n0_10], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n40_50,defects_detected=n10_20], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n40_50,defects_detected=n20_30], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n40_50,defects_detected=n30_40], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n40_50,defects_detected=n40_50], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n40_50,defects_detected=n50_inf  ], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n50_60,defects_detected=n0_10], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n50_60,defects_detected=n10_20], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n50_60,defects_detected=n20_30], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n50_60,defects_detected=n30_40], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n50_60,defects_detected=n40_50], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n50_60,defects_detected=n50_inf  ], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n60_70,defects_detected=n0_10], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n60_70,defects_detected=n10_20], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n60_70,defects_detected=n20_30], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n60_70,defects_detected=n30_40], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n60_70,defects_detected=n40_50], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n60_70,defects_detected=n50_inf  ], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n70_80,defects_detected=n0_10], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n70_80,defects_detected=n10_20], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n70_80,defects_detected=n20_30], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n70_80,defects_detected=n30_40], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n70_80,defects_detected=n40_50], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n70_80,defects_detected=n50_inf  ], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n80_90,defects_detected=n0_10], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n80_90,defects_detected=n10_20], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n80_90,defects_detected=n20_30], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n80_90,defects_detected=n30_40], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n80_90,defects_detected=n40_50], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n80_90,defects_detected=n50_inf  ], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n90_100,defects_detected=n0_10], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n90_100,defects_detected=n10_20], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n90_100,defects_detected=n20_30], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n90_100,defects_detected=n30_40], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n90_100,defects_detected=n40_50], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(residual_defects,[defects_introduced=n90_100,defects_detected=n50_inf  ], [0.15,0.15,0.15,0.15,0.15,0.25]).

pr(operational_defects,[operational_usage=very_low,residual_defects=n0_10], [0.10,0.10,0.10,0.10,0.10,0.10]).
pr(operational_defects,[operational_usage=very_low,residual_defects=n10_20], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(operational_defects,[operational_usage=very_low,residual_defects=n20_30], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(operational_defects,[operational_usage=very_low,residual_defects=n30_40], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(operational_defects,[operational_usage=very_low,residual_defects=n40_50], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(operational_defects,[operational_usage=very_low,residual_defects=n50_inf  ], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(operational_defects,[operational_usage=low,residual_defects=n0_10], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(operational_defects,[operational_usage=low,residual_defects=n10_20], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(operational_defects,[operational_usage=low,residual_defects=n20_30], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(operational_defects,[operational_usage=low,residual_defects=n30_40], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(operational_defects,[operational_usage=low,residual_defects=n40_50], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(operational_defects,[operational_usage=low,residual_defects=n50_inf  ], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(operational_defects,[operational_usage=average,residual_defects=n0_10], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(operational_defects,[operational_usage=average,residual_defects=n10_20], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(operational_defects,[operational_usage=average,residual_defects=n20_30], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(operational_defects,[operational_usage=average,residual_defects=n30_40], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(operational_defects,[operational_usage=average,residual_defects=n40_50], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(operational_defects,[operational_usage=average,residual_defects=n50_inf  ], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(operational_defects,[operational_usage=high,residual_defects=n0_10], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(operational_defects,[operational_usage=high,residual_defects=n10_20], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(operational_defects,[operational_usage=high,residual_defects=n20_30], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(operational_defects,[operational_usage=high,residual_defects=n30_40], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(operational_defects,[operational_usage=high,residual_defects=n40_50], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(operational_defects,[operational_usage=high,residual_defects=n50_inf  ], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(operational_defects,[operational_usage=very_high,residual_defects=n0_10], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(operational_defects,[operational_usage=very_high,residual_defects=n10_20], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(operational_defects,[operational_usage=very_high,residual_defects=n20_30], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(operational_defects,[operational_usage=very_high,residual_defects=n30_40], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(operational_defects,[operational_usage=very_high,residual_defects=n40_50], [0.15,0.15,0.15,0.15,0.15,0.25]).
pr(operational_defects,[operational_usage=very_high,residual_defects=n50_inf  ], [0.15,0.15,0.15,0.15,0.15,0.25]).


% EXAMPLE QUERIES:
% ? p(fire,[report=yes],P).
% ? p(fire,[report=yes,smoke=yes],P).
% ? p(fire,[report=yes,smoke=no],P).
% ? p(report,[],P).
% ? p(report,[smoke=yes],P).
% ? p(report,[smoke=yes,tampering=no],P).
