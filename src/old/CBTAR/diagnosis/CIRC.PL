circuit(    switch(Sw1,VSw1,C1), 
            bulb(B1,L1,VB1,C1),  
            switch(Sw2,VSw2,C2), 
            bulb(B2,L2,VB2,C2),  
            switch(Sw3,VSw3,CSw3),
            bulb(B3,L3,VB3,CB3),
	    Shine) :-
    VSw3 = VB3,              %  2
    sum(VSw1, VB1, V1),      %  3
    sum(V1,VB3,+),           %  4
    sum(VSw2,VB2,VB3),       %  5
    switch(Sw1,VSw1,C1),     %  6
    bulb(B1,L1,VB1,C1),      %  7
    switch(Sw2,VSw2,C2),     %  8
    bulb(B2,L2,VB2,C2),      %  9
    switch(Sw3,VSw3,CSw3),   % 10
    bulb(B3,L3,VB3,CB3),     % 11
    sum(CSw3,CB3,C3),        % 12
    sum(C2,C3,C1),           % 13
    num(L1,N1),
    num(L2,N2),
    num(L3,N3),
    Shine is N1+N2+N3.

sum(+,+,+).
sum(+,0,+).
sum(+,-,_Any).
sum(0,+,+).
sum(0,0,0).
sum(0,-,-).
sum(-,+,_Any).
sum(-,0,-).
sum(-,-,-).

bulb(blown,dark, _Any, 0).
bulb(ok,   light,+,  +).
bulb(ok,   light,-,  -).
bulb(ok,   dark, 0,  0).

num(light,1).
num(dark,0).

switch(on,    0,    _Any).
switch(off,   _Any,  0).

value(Sw,    switch, switch(Sw,_,_)).
value(Light, bulb,   bulb(_,Light,_,_)).

inf(Inf,bulb(_,Shine,_,_),switch(Pos,_,_)) :-
	inf1(Inf,Shine,Pos).
inf1(+,dark,off).
inf1(+,light,on).
inf1(-,dark,on).
inf1(-,light,off).

circuit :-
	value(light,bulb,B1a), % K1
%	value(on,switch,Sw3c), % K2
%	value(on,switch,Sw1c), % K3
%	value(off,switch,Sw2c), % K4
%	B3c= bulb(blown,_,_,_), % E1
%	B1b= bulb(ok,_,_,_), % E1
%	value(dark,bulb,B3b), % K1
%	value(light,bulb,B1c), % K1
	%value(dark,bulb,B2a),
	%value(off,switch,Sw3a),
	value(light,bulb,B2b),
	value(off,switch,Sw3a),
	value(on,switch,Sw1a),
	circuit(Sw1a,B1a,Sw2a,B2a,Sw3a,B3a,Shine1),
	inf(+,B1a,Sw1b),
	inf(-,B2a,Sw3b),
	circuit(Sw1b,B1b,Sw2b,B2b,Sw3b,B3b,Shine2),
	inf(-,B3b,Sw2c),
	inf(+,B2b,Sw3c),
	circuit(Sw1c,B1c,Sw2c,B2c,Sw3c,B3c,Shine3),
	Shine is Shine1+Shine2+Shine3,
	format('~p,~p,~p,~p,~p,~p,~p,~p,~p,~p,~p,~p,~p,~p,~p,~p,~p,~p,~%,~%,~%,~%,~%,~%,~%,~%,~%,~p\n',
	        [Sw1a,Sw2a,Sw3a,Sw1b,Sw2b,Sw3b,Sw1c,Sw2c,Sw3c,
		B1a,B2a,B3a,B1b,B2b,B3b,B1c,B2c,B3c,
		B1a,B2a,B3a,B1b,B2b,B3b,B1c,B2c,B3c,
		Shine]).

:- format_predicate('%',bulbIs(_,_)).

bulbIs(_,bulb(X,_,_,_)) :- var(X) -> write('?') | write(X).

portray(X) :- value(Y,_,X), write(Y).

data :- tell('circ.data'),flag(n,_,0), data1, told, flag(n,N,N),print(N),nl.

data1 :- circuit, flag(n,N,N+1), fail.
data1.
/*
K1 & E1


default: Changes=true
Read 25856 cases (27 attributes) from circ.data

        Worth=1.000000
        Granularity=2; Promising=-1000.000000; Useful=1.000000
        Treatment:[No Treatment]

   0:                                [     0 -  0%]
   1:~~~~~~~~~~~~~~~                 [  5904 - 23%]
   2:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  [ 11275 - 44%]
   3:~~~~~~~~~~~~~~                  [  5515 - 21%]
   4:~~~~                            [  1619 -  6%]
   5:~~~~                            [  1505 -  6%]
   6:                                [    34 -  0%]
   7:                                [     4 -  0%]
   8:                                [     0 -  0%]
   9:                                [     0 -  0%]



        Worth=6.544718
        Granularity=2; Promising=-1000.000000; Useful=1.000000
        Treatment:[
        switch3c=on]

   0:                                [     0 -  0%]
   1:                                [     0 -  0%]
   2:                                [     0 -  0%]
   3:                                [     0 -  0%]
   4:~~~~~~~~~                       [    14 - 15%]
   5:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  [    44 - 46%]
   6:~~~~~~~~~~~~~~~~~~~~~~~         [    34 - 35%]
   7:~~                              [     4 -  4%]
   8:                                [     0 -  0%]
   9:                                [     0 -  0%]


K1 & E1 & switch3c=off

Read 25760 cases (27 attributes) from circ.data

        Worth=1.000000
        Granularity=2; Promising=-1000.000000; Useful=1.000000
        Treatment:[No Treatment]

   0:                                [     0 -  0%]
   1:~~~~~~~~~~~~~~~                 [  5904 - 23%]
   2:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  [ 11275 - 44%]
   3:~~~~~~~~~~~~~~                  [  5515 - 21%]
   4:~~~~                            [  1605 -  6%]
   5:~~~                             [  1461 -  6%]
   6:                                [     0 -  0%]
   7:                                [     0 -  0%]
   8:                                [     0 -  0%]
   9:                                [     0 -  0%]

      Worth=3.564165
      Granularity=2; Promising=-1000.000000; Useful=1.000000
      Treatment:[
      bulb3b=light]

 0:                                [     0 -  0%]
 1:                                [     0 -  0%]
 2:                                [     0 -  0%]
 3:                                [     0 -  0%]
 4:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  [  1330 - 50%]
 5:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  [  1330 - 50%]
 6:                                [     0 -  0%]
 7:                                [     0 -  0%]
 8:                                [     0 -  0%]
 9:                                [     0 -  0%]

K1 & E1 & switch3c=off & bulb3b=dark

Read 23100 cases (27 attributes) from circ.data

        Worth=1.000000
        Granularity=2; Promising=-1000.000000; Useful=1.000000
        Treatment:[No Treatment]

   0:                                [     0 -  0%]
   1:~~~~~~~~~~~~~~~                 [  5904 - 26%]
   2:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  [ 11275 - 49%]
   3:~~~~~~~~~~~~~~                  [  5515 - 24%]
   4:                                [   275 -  1%]
   5:                                [   131 -  1%]
   6:                                [     0 -  0%]
   7:                                [     0 -  0%]
   8:                                [     0 -  0%]
   9:                                [     0 -  0%]


       Worth=3.733334
       Granularity=2; Promising=-2000.000000; Useful=1.000000
       Treatment:[
       bulb1c=light]

  0:                                [     0 -  0%]
  1:                                [     0 -  0%]
  2:                                [     0 -  0%]
  3:~~~~~~~~~~~~~~~                 [   144 - 26%]
  4:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  [   275 - 50%]
  5:~~~~~~~~~~~~~~                  [   131 - 24%]
  6:                                [     0 -  0%]
  7:                                [     0 -  0%]
  8:                                [     0 -  0%]
  9:                                [     0 -  0%]

K1 & E1 & switch3c=off & bulb3b=dark & buld1c=light
 
*/
