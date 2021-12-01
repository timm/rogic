/*

=head1 Circuit 

for more info on this, see Bratko, chpt20. Qualitative Reasoning.
common sense, qualitative reasoning and naïve physics AND
http://menzies.us/pdf/01lesstalk.pdf */

 :- ensure_loaded([randoms,memo]).

 circuit(   switch=[XS1, Sw1,  VSw1, C1],
            bulb  =[XB1,   B1,   L1,   VB1, C1],
            switch=[XS2, Sw2,  VSw2, C2],
            bulb  =[XB2,   B2,   L2,   VB2, C2],
            switch=[XS3, Sw3,  VSw3, CSw3],
            bulb  =[XB3,   B3,   L3,   VB3, CB3],
        Shine) :-
    VSw3 = VB3,              %  2
    sum(VSw1, VB1, V1),      %  3
    sum(V1,VB3,+),           %  4
    sum(VSw2,VB2,VB3),       %  5
    switch(XS1,Sw1,VSw1,C1),     %  6
    bulb(XB1,B1,L1,VB1,C1),      %  7
    switch(XS2,Sw2,VSw2,C2),     %  8
    bulb(XB2,B2,L2,VB2,C2),      %  9
    switch(XS3,Sw3,VSw3,CSw3),   % 10
    bulb(XB3,B3,L3,VB3,CB3),     % 11
    sum(CSw3,CB3,C3),        % 12
    sum(C2,C3,C1),           % 13
    num(L1,N1),
    num(L2,N2),
    num(L3,N3),
    Shine is N1+N2+N3.

 sum(X,Y,Z) :- any(sum1(X,Y,Z)).

 sum1(+,+,+).
 sum1(+,0,+).
 sum1(+,-,_Any).
 sum1(0,+,+).
 sum1(0,0,0).
 sum1(0,-,-).
 sum1(-,+,_Any).
 sum1(-,0,-).
 sum1(-,-,-).

 bulb(X,A,B,C,D) :- memo(any(bulb1(A,B,C,D)), 
                        [X/state=A,X/light=B,X/volt=C,X/curr=D]).

 bulb1(blown,dark, _Any, 0).
 bulb1(ok,   light,+,  +).
 bulb1(ok,   light,-,  -).
 bulb1(ok,   dark, 0,  0).

 switch(X,A,B,C) :- memo(any(switch1(A,B,C)),
                        [X/sw=A,X/volt=B,X/curr=C]).

 switch1(on,    0,    _Any).
 switch1(off,   _Any,  0).

 num(light,1).
 num(dark,0).

 value(X,Sw,    switch, switch=[X,_,Sw,_,_]).
 value(X,Light, bulb,   bulb=[X,_,_,Light,_,_]).

 inf(Inf,bulb=[_,_,Shine,_,_],switch=[_,Pos,_,_]) :-
    inf1(Inf,Shine,Pos).

 inf1(Inf,Shine,Pos) :- any(inf2(Inf,Shine,Pos)).

 inf2(+,dark,off).
 inf2(+,light,on).
 inf2(-,dark,on).
 inf2(-,light,off). 

 def(bulb,[name,status,shine,volts,amps]).

 bulb0(Name,B) :- bulb0(Name,_,B).
 bulb0(Name) --> in bulb, the name=Name.

 def(switch,[name,state,volts,amps]).

 switch0(Name,S) :- switch0(Name,_,S).
 switch0(Name) --> in switch, the name=Name.

 run(Shine) :- reset, once(circuit(Shine)).

 circuit(Shine) :- 
    bulb0(bulb1a,B1a),    bulb0(bulb2a,B2a), bulb0(bulb3a,B3a),
    bulb0(bulb1b,B1b),    bulb0(bulb2b,B2b), bulb0(bulb3b,B3b),
    bulb0(bulb1c,B1c),    bulb0(bulb2c,B2c), bulb0(bulb3c,B3c),
    switch0(switch1a,Sw1a),switch0(switch2a,Sw2a),switch0(switch3a,Sw3a),
    switch0(switch1b,Sw1b),switch0(switch2b,Sw2b),switch0(switch3b,Sw3b),
    switch0(switch1c,Sw1c),switch0(switch2c,Sw2c),switch0(switch3c,Sw3c),

    at(in bulb with the shine := light,B1a,B1a),
%    value(bulb1a, light,bulb,B1a), % K1
    %value(switch3c,on,switch,Sw3c), % K2
    %value(switch1c,on,switch,Sw1c), % K3
    %value(switch2c,off,switch,Sw2c), % K4
    %B3c= bulb(bulb3c,ok,_,_,_),
    %value(bulb2a, dark,bulb,B2a),
    %value(switch3a, off,switch,Sw3a),

    circuit(Sw1a,B1a,Sw2a,B2a,Sw3a,B3a,Shine1),
    inf(+,B1a,Sw1b),
    inf(-,B2a,Sw3b),
    circuit(Sw1b,B1b,Sw2b,B2b,Sw3b,B3b,Shine2),
    inf(-,B3b,Sw2c),
    inf(+,B2b,Sw3c),
    circuit(Sw1c,B1c,Sw2c,B2c,Sw3c,B3c,Shine3),
    inf(-,B2c,Sw1d),
    inf(+,B3c,Sw3d),
    inf(+,B1a,Sw1d),
    inf(+,B1b,Sw2d),
    circuit(Sw1d,B1d,Sw2d,B2d,Sw3d,B3d,Shine4),   
    Shine is Shine1+Shine2+Shine3+Shine4.


%    sformat(_String,'~p,~p,~p,~p,~p,~p,~p,~p,~p,~p,~p,~p,~%,~%,~%,~%,~%,~%,~%,~%,~%,~%,~%,~%,~p\n',
  %           [Sw1a,Sw2a,Sw3a,Sw1b,Sw2b,Sw3b,Sw1c,Sw2c,Sw3c,  Sw1d,Sw2d,Sw3d,
 %         B1a,B2a,B3a,B1b,B2b,B3b,B1c,B2c,B3c,  B1d,B2d,B3d,
   %      Shine]).
%    true.


% datas(Max) :-
%	flag(n,_,0),
%	repeat,
%	circuit,
%	flag(n,N,N+1),
%	N > Max,
%	!.

 :- format_predicate('%',bulbIs(_,_)).

 bulbIs(_,bulb=[_,X,_,_,_]) :- var(X) -> write('?') | write(X).

 %portray(X) :- value(Z,Y,_,X), write(Z/Y).

 data :- tell('circ.data'),forall(datas(1000000),true), told.

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
               9:                                [     0 -  0%] */
