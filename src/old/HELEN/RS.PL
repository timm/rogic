% note, for lists of size 2 [First,Second]
% is nearly as likely as [Second,First]
rs(In,Out) :- length(In,L),rs(In,L,_,Out).
rs([H],_,1,[H]).
rs([H|Rest],L,N,Out) :-
    rs(Rest,L,N0,Temp),
    once(r0(N0,L,H,Temp,Out)),
    N is N0 + 1.

r0(N,L,X,[H|T],[X,H|T]) :- random(2147483647)/2147483647 < N/L.
%r0(N,L,X,[H|T],[X,H|T]) :- random(2147483647)/2147483647 < 0.5.
r0(_,_,X,[H|T],[H,X|T]) .


go :- 
    go((1,2),2); 
    go((1,2,3),3);   
    go((1,2,3,4),4); 
    go((1,2,3,4,5,6),6); 
    go((1,2,3,4,5,6,7,8),8); 
    go((1,2,3,4,5,6,7,8,9,10,11,12),12); 
    go((1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,
        21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40),40).
    
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
    total([First|Rest],T),
    Av is T/Size.

nth1s1(N,Lines,X) :- 
    member(Line,Lines),
    nth1(N,Line,X).

grab(N,Con,Lines) :- bagof(Line,N^Con^go1(N,Con,Line),Lines).

go1(N,Con,L) :-  between(1,N,_), r(Con,r(_,L0)),rs(L0,L).

/*

?- go,fail.
nth1s(1, 1, 2, 1.485)
nth1s(2, 1, 2, 1.515)

nth1s(1, 1, 3, 1.561)
nth1s(2, 1, 3, 2.099)
nth1s(3, 2, 3, 2.34)

nth1s(1, 1, 4, 1.496)
nth1s(2, 1, 4, 2.381)
nth1s(3, 2, 4, 2.881)
nth1s(4, 3, 4, 3.242)

nth1s(1, 1, 6, 1.29)
nth1s(2, 1, 6, 2.396)
nth1s(3, 2, 6, 3.435)
nth1s(4, 3, 6, 4.088)
nth1s(5, 4, 6, 4.631)
nth1s(6, 5, 6, 5.16)

nth1s(1, 1, 8, 1.198)
nth1s(2, 1, 8, 2.259)
nth1s(3, 2, 8, 3.341)
nth1s(4, 3, 8, 4.383)
nth1s(5, 4, 8, 5.252)
nth1s(6, 5, 8, 5.968)
nth1s(7, 6, 8, 6.467)
nth1s(8, 7, 8, 7.132)

nth1s(1, 1, 5, 1.118)
nth1s(2, 1, 8, 2.142)
nth1s(3, 2, 12, 3.191)
nth1s(4, 3, 12, 4.163)
nth1s(5, 4, 12, 5.359)
nth1s(6, 5, 12, 6.35)
nth1s(7, 6, 12, 7.336)
nth1s(8, 7, 12, 8.203)
nth1s(9, 8, 12, 9.082)
nth1s(10, 9, 12, 9.646)
nth1s(11, 10, 12, 10.343)
nth1s(12, 11, 12, 11.067)

nth1s(1, 1, 2, 1.033)
nth1s(2, 1, 4, 2.016)
nth1s(3, 2, 6, 3.019)
nth1s(4, 3, 7, 4.059)
nth1s(5, 4, 8, 5.036)
nth1s(6, 5, 11, 6.045)
nth1s(7, 6, 11, 7.026)
nth1s(8, 7, 14, 8.002)
nth1s(9, 8, 13, 9.089)
nth1s(10, 9, 15, 10.037)
nth1s(11, 10, 17, 11.038)
nth1s(12, 11, 19, 12.06)
nth1s(13, 12, 19, 13.058)
nth1s(14, 13, 23, 14.082)
nth1s(15, 14, 24, 15.068)
nth1s(16, 15, 22, 16.061)
nth1s(17, 16, 27, 17.129)
nth1s(18, 17, 27, 18.085)
nth1s(19, 18, 33, 19.041)
nth1s(20, 19, 40, 20.145)
nth1s(21, 20, 40, 21.202)
nth1s(22, 21, 35, 22.086)
nth1s(23, 22, 40, 23.176)
nth1s(24, 23, 40, 24.188)
nth1s(25, 24, 40, 25.314)
nth1s(26, 25, 40, 26.398)
nth1s(27, 26, 40, 27.28)
nth1s(28, 27, 40, 28.306)
nth1s(29, 28, 40, 29.246)
nth1s(30, 29, 40, 30.355)
nth1s(31, 30, 40, 31.2)
nth1s(32, 31, 40, 32.182)
nth1s(33, 32, 40, 33.168)
nth1s(34, 33, 40, 33.834)
nth1s(35, 34, 40, 34.669)
nth1s(36, 35, 40, 35.449)
nth1s(37, 36, 40, 36.453)
nth1s(38, 37, 40, 37.231)
nth1s(39, 38, 40, 38.113)
nth1s(40, 39, 40, 39.021)

*/
