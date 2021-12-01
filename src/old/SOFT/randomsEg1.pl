/*

=head1 Demo of C<Randoms> 

=head1 Header

=head2 Loads */

 :- ensure_loaded([randoms,demo]). /*

=head1 Body */
 
  eg(any1) :-
    forall(any(member(X,[every,good,boy,deserves,fruit])),
           format('~w\n',[X])).

  eg(rand0) :-
    Rand1 is rand, 
    format('~w is a random number between 0 and 1.\n', [Rand1]).

  eg(rand2) :-
    Rand2 is rand(10,20),
    format('~w is a random number between 10 and 20.\n', [Rand2]).

  eg(rand3) :- 
    R1 is rand(10,20,0.9),    R2 is rand(10,20,0.9),
    R3 is rand(10,20,0.9),    R4 is rand(10,20,0.9),
    R5 is rand(10,20,0.9),    R6 is rand(10,20,0.9),
    R7 is rand(10,20,0.9),    R8 is rand(10,20,0.9),
    R9 is rand(10,20,0.9),    R10 is rand(10,20,0.9),
    Nums=[R1,R2,R3,R4,R5,R6,R7,R8,R9,R10],
    format('~w\nare random numbers 90\% between 10 and 20.\n', [Nums]).

  eg(normal2) :- 
    R1 is normal(10,2),    R2 is normal(10,2),
    R3 is normal(10,2),    R4 is normal(10,2),
    R5 is normal(10,2),    R6 is normal(10,2),
    R7 is normal(10,2),    R8 is normal(10,2),
    R9 is normal(10,2),    R10 is normal(10,2),
    Nums=[R1,R2,R3,R4,R5,R6,R7,R8,R9,R10],
    format('~w\nare random numbers from normal(10,2).\n', [Nums]).

 eg(gamma2) :- 
    R1 is gamma(10,2),    R2 is gamma(10,2),
    R3 is gamma(10,2),    R4 is gamma(10,2),
    R5 is gamma(10,2),    R6 is gamma(10,2),
    R7 is gamma(10,2),    R8 is gamma(10,2),
    R9 is gamma(10,2),    R10 is gamma(10,2),
    Nums=[R1,R2,R3,R4,R5,R6,R7,R8,R9,R10],
    format('~w\nare random numbers from gamma(10,2).\n', [Nums]). /*

=head1 Footer

=head2 Start-ups */

 %:- egs.

