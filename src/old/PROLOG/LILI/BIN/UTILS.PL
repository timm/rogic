:-  op(1001,fx,  all).

all X :- X, fail.
all _.

:- multifile demo/2.
:- discontiguous demo/2.

demos :- 
	all 
	clause(demo(X,Y),_), 
	print(demo(X,Y)),
	write('.'),
	nl.

forget(X) :- all retract(X).


toFront(Item,List0,[Item|List]) :- oneLess(List0,Item,List).

oneLess([A|B], A, B).
oneLess([A|B], C, [A|D]) :- oneLess(B, C, D).
