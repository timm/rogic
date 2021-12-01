demo(1) :-
	R=kc2,
	profile((relation(R),
	         discretize(R)),plain,20).

demo(2) :-
	R=kc2,
        time((relation(R),
	         discretize(R))).


demo(3) :-
	R=kc20000,
	profile((relation(R),
	         discretize(R)),plain,20).

demo(4) :-
	length(L,20),
	time(l(kc2,All)),
	append(_,L,All),
	l(L).

demo(5) :-
    (go((1,2),2); 
    go((1,2,3),3);   
    go((1,2,3,4),4); 
    go((1,2,3,4,5,6),6); 
    go((1,2,3,4,5,6,7,8),8)),
    fail.
    %go((1,2,3,4,5,6,7,8,9,10,11,12),12); 
    %go((1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,
    %    21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40),40).

demo(5).    
go(Con,PosMax) :-
     N=1000,
     Size=1000,
     grab(N,Con,Lines),
     nl,between(1,PosMax,Pos),
     nth1s(Size,Pos,Lines,First,Max,Av),
     print(nth1s(Pos,First,Max,Av)),nl.
     
nth1s(Size,N,Lines,First,Max,Av) :- 
    bagof(X,N^Lines^nth1s1(N,Lines,X),Ns0),
    msort(Ns0,[First|Rest]),
    last(Max,Rest),
    sum([First|Rest],T),
    Av is T/Size.

nth1s1(N,Lines,X) :- 
    member(Line,Lines),
    nth1(N,Line,X).

grab(N,Con,Lines) :- bagof(Line,N^Con^go1(N,Con,Line),Lines).

go1(N,Con,L) :-  between(1,N,_), r(Con,r(_,L0)),rs(L0,L).

r(X,Y) :- once(r1(X,Y)).
r1((X0,Y0,Z0),r(*,[X|L])) :- r(X0,X),r((Y0,Z0),r(*,L)).
r1((X0;Y0;Z0),r(+,[X|L])) :- r(X0,X),r((Y0;Z0),r(+,L)).
r1((X0,Y0),   r(*,[X,Y])) :- r(X0,X),r(Y0,Y).
r1((X0;Y0),   r(+,[X,Y])) :- r(X0,X),r(Y0,Y).
r1(X,X).