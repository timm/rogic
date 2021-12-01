/*

=head1 Circ1 Examples 

=head2 Loads */

 :- [demo,circ].

 eg(bulb) :-
    write('\nBEFORE\n'),listing(assumption),
    reset,
    write('\nRESET DONE\n'),listing(assumption),
    bulb(a,A,B,C,D),
    write(bulb(a,A,B,C,D)),nl,
    write('\nAFTER\n'),listing(assumption).

 eg(circ1) :-
    XS1= xs1, XB1= xb1, XS2= xs2, XB2=xb2, XS3=xs3,XB3= xb3,
    Goal=
        circuit(   switch(XS1, _Sw1,  _VSw1, _C1),
                   bulb(XB1,   _B1,   _L1,   _VB1, _C1),
                   switch(XS2, _Sw2,  _VSw2, _C2),
                   bulb(XB2,   _B2,   _L2,   _VB2, _C2),
                   switch(XS3, _Sw3,  _VSw3, _CSw3),
                   bulb(XB3,   _B3,   _L3,   _VB3, _CB3),
                   _Shine),
    reset, 
    Goal,
    write('\nAFTER\n'),listing(assumption).

 eg(sample) :-
    tell('circ.out'),forall(between(1,1000,I),(sample(I),once(circuit(_)))),told.


 sample(I) :- 0 is I mod 50,!, write(user,' '),write(user, I),flush_output(user).
 sample(_).
