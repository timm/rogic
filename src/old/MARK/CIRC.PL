circuit(    switch(Sw1,VSw1,C1),
            bulb(B1,L1,VB1,C1),
            switch(Sw2,VSw2,C2),
            bulb(B2,L2,VB2,C2),
            switch(Sw3,VSw3,CSw3),
            bulb(B3,L3,VB3,CB3),
        Shine) :-
    do([
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
    sum(C2,C3,C1)
    ]),           % 13
    num(L1,N1),
    num(L2,N2),
    num(L3,N3),
    Shine is N1+N2+N3.

do([]).
do(L) :- rone(L,One,Rest), One,do(Rest).

rone(L,One,Rest) :-
        length(L,N),
        Pos is random(N) + 1,
        less1(Pos,L,One,Rest).

less(_,[H],H,[]) :- !.
less1(1,[H|T],H,T) :- !.
less1(N0,[H|T],X,[H|Rest]) :- N is N0 - 1, less1(N,T,X,Rest).

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

/*
circuit :-
    value(light,bulb,B1a), % K1
    %value(on,switch,Sw3c), % K2
    %value(on,switch,Sw1c), % K3
    %value(off,switch,Sw2c), % K4
    %B3c= bulb(ok,_,_,_),
    %value(dark,bulb,B2a),
    %value(off,switch,Sw3a),

    circuit(Sw1a,B1a,Sw2a,B2a,Sw3a,B3a,Shine1),
    inf(+,B1a,Sw1b),
    inf(-,B2a,Sw3b),
    circuit(Sw1b,B1b,Sw2b,B2b,Sw3b,B3b,Shine2),
    inf(-,B3b,Sw2c),
    inf(+,B2b,Sw3c),
    circuit(Sw1c,B1c,Sw2c,B2c,Sw3c,B3c,Shine3),
    Shine is Shine1+Shine2+Shine3,
    format('~p,~p,~p,~p,~p,~p,~p,~p,~p,~%,~%,~%,~%,~%,~%,~%,~%,~%,~p\n',
            [Sw1a,Sw2a,Sw3a,Sw1b,Sw2b,Sw3b,Sw1c,Sw2c,Sw3c,
        B1a,B2a,B3a,B1b,B2b,B3b,B1c,B2c,B3c,
        Shine]).
*/

:- format_predicate('%',bulbIs(_,_)).

bulbIs(_,bulb(X,_,_,_)) :- var(X) -> write('?') | write(X).

portray(X) :- value(Y,_,X), write(Y).

data :- tell('circ.data'),forall(circuit,true), told.

/*K1:
35228 cases
initial conditions
   0:                                [     0 -  0%]
   1:~~~~~~~~~~~~~~~                 [  7920 - 22%]
   2:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  [ 15125 - 43%]
   3:~~~~~~~~~~~~~~                  [  7493 - 21%]
   4:~~~~                            [  2248 -  6%]
   5:~~~~                            [  2151 -  6%]
   6:                                [   241 -  1%]
   7:                                [    50 -  0%]
   8:                                [     0 -  0%]
   9:                                [     0 -  0%]
guessing: initial + some...


 Worth=3.621769
 Granularity=2 Promising=-1000.000000 Useful=1.000000 nChanges=1
 Treatment:[
        switch2c=off]

               0:                                [     0 -  0%]
               1:                                [     0 -  0%]
               2:                                [     0 -  0%]
               3:                                [     0 -  0%]
               4:~~~~~~~~~~~~~~~~~~~~~~~~~~~~    [  1526 - 47%]
               5:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  [  1582 - 48%]
               6:~~                              [   106 -  3%]
               7:                                [    50 -  2%]
               8:                                [     0 -  0%]
               9:                                [     0 -  0%]

 Worth=6.029714
 Granularity=2 Promising=-1000.000000 Useful=1.000000 nChanges=1
 Treatment:[
        switch3c=on]

               0:                                [     0 -  0%]
               1:                                [     0 -  0%]
               2:                                [     0 -  0%]
               3:                                [     0 -  0%]
               4:~~~~~~~~~                       [    28 - 15%]
               5:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  [    88 - 46%]
               6:~~~~~~~~~~~~~~~~~~~~~~~         [    68 - 35%]
               7:~~                              [     8 -  4%]
               8:                                [     0 -  0%]
               9:                                [     0 -  0%]

actual: initial +  swith2c=off


Worth=1.000000
Granularity=2 Promising=-1000.000000 Useful=1.000000 nChanges=1
Treatment:[No Treatment]

              0:                                [     0 -  0%]
              1:                                [     0 -  0%]
              2:                                [     0 -  0%]
              3:                                [     0 -  0%]
              4:~~~~~~~~~~~~~~~~~~~~~~~~~~~~    [  1526 - 47%]
              5:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  [  1582 - 48%]
              6:~~                              [   106 -  3%]
              7:                                [    50 -  2%]
              8:                                [     0 -  0%]
              9:                                [     0 -  0%]



Worth=1.000000
Granularity=2 Promising=-1000.000000 Useful=1.000000 nChanges=1
Treatment:[No Treatment]

              0:                                [     0 -  0%]
              1:                                [     0 -  0%]
              2:                                [     0 -  0%]
              3:                                [     0 -  0%]
              4:~~~~~~~~~~~~~~~~~~~~~~~~~~~~    [  1526 - 47%]
              5:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  [  1582 - 48%]
              6:~~                              [   106 -  3%]
              7:                                [    50 -  2%]
              8:                                [     0 -  0%]
              9:                                [     0 -  0%]

actual with K1 + switch2=off & switch1c=on

 Worth=1.320921
 Granularity=2 Promising=-1000.000000 Useful=1.000000 nChanges=1
 Treatment:[
        switch1c=on]

               0:                                [     0 -  0%]
               1:                                [     0 -  0%]
               2:                                [     0 -  0%]
               3:                                [     0 -  0%]
               4:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   [   266 - 41%]
               5:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  [   274 - 42%]
               6:~~~~~~                          [    58 -  9%]
               7:~~~~~                           [    50 -  8%]
               8:                                [     0 -  0%]
               9:                                [     0 -  0%]

 Worth=1.333333
 Granularity=2 Promising=-1000.000000 Useful=1.000000 nChanges=1
 Treatment:[
        bulb3a=ok]

               0:                                [     0 -  0%]
               1:                                [     0 -  0%]
               2:                                [     0 -  0%]
               3:                                [     0 -  0%]
               4:                                [     0 -  0%]
               5:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  [  1526 - 94%]
               6:~                               [    56 -  3%]
               7:                                [    50 -  3%]
               8:                                [     0 -  0%]
               9:                                [     0 -  0%]

 Worth=1.433829
 Granularity=2 Promising=-1000.000000 Useful=1.000000 nChanges=1
 Treatment:[
        bulb3c=ok]

               0:                                [     0 -  0%]
               1:                                [     0 -  0%]
               2:                                [     0 -  0%]
               3:                                [     0 -  0%]
               4:~~~~~~~~~~~~~~~~~~~~~~~~~~      [   196 - 36%]
               5:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  [   224 - 41%]
               6:~~~~~~~~~                       [    74 - 14%]
               7:~~~~~~                          [    46 -  9%]
               8:                                [     0 -  0%]
               9:                                [     0 -  0%]

 Worth=1.997824
 Granularity=2 Promising=-1000.000000 Useful=1.000000 nChanges=1
 Treatment:[
        switch3c=on]

               0:                                [     0 -  0%]
               1:                                [     0 -  0%]
               2:                                [     0 -  0%]
               3:                                [     0 -  0%]
               4:                                [     0 -  0%]
               5:~~~~~~~~~~~~~~~~~~~~~~~~~~      [    56 - 44%]
               6:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  [    64 - 50%]
               7:~~~                             [     8 -  6%]
               8:                                [     0 -  0%]
               9:                                [     0 -  0%]



*/
