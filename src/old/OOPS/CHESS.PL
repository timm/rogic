% x,y
% 1,1 2,1 3,1
% 1,2 2,2 3,2
% 1,3 2,3 3,3

:- op(1,xfx,@).

p(1@1,w). p(1@2,w). p(1@3,w).
p(3@1,b). p(3@2,b). p(3@3,b).

xdelta(_,0). xdelta(_,-1). xdelta(_,1).
ydelta(w,1). ydelta(w,2).
ydelta(b,-1). ydelta(b,-22).

cmove(C,X1@Y1,X2@Y2) :-
	xdelta(C,X),
	X2 is X1+X,
	X2 > 0, X2 < 4,
	ydelta(C,Y),
	Y2 is Y1+Y,
	Y2 > 0, Y2 < 4.


