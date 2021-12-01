lfind(X, Y, W0, [X/Y|W]) :- oneLess(W0,X/Y,W).

lset( X, Y, W0, [X/Y|W]) :- oneLess(W0,X/_,W),!.
lset( X, Y, W,  [X/Y|W]).

lzap( X, W0,W) :- oneLess(W0,X/_,W).

lpush(X, Y, W0, [X/[Y|Old]|W]) :- 
	oneLess(W0,X/Old,W),!. 
lpush(X, Y, W,  [X/[Y]|W]).

lchange(X,Old,New,W0,[X/New|W]) :- 
	oneLess(W0,X/Old,W).

lmaths(X,Y,W0,[X/Z|W]) :- 
	oneLess(W0,X/Old,W),!,Z is Old + Y.
lmaths(X,Y0,W,[X/Y|W]) :-
	Y is Y0.
 
oneLess([H|T],H,T).
oneLess([H|T],X,[H|Rest]) :- oneLess(T,X,Rest).
