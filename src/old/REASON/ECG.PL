/*

=head1 Extended clause grammers 

Speed up the manipulation of  named fields within DCGs.

=head1 Header

=head2 Loads */

 :- [defs]. /*

=head1 Body 

=head2 Standard Optimizations */

 goal_expansion(append(A,B,_),true) :- ground(A),ground(B).
 goal_expansion(append(A,_,C),true) :- ground(A),ground(C).
 goal_expansion(append(_,B,C),true) :- ground(B),ground(C). /*

=head2 Optimizing I<Solo> Calls

For certain clauses,
if there is only one clause that matches some sub-goal,
then we can eval it at load time with safety. */ 

 eval_if_solo(at(_,_,_,_,_)).
 eval_if_solo(at(_,_,_)).

 solo(X) :- Y='#solo', flag(Y,_,0), \+ solo1(Y,X), flag(Y,1,1).
 solo1(Sym,X) :- clause(X,_),flag(Sym,N,N+1),N > 1,!.   

 goal_expansion(X,true) :- eval_if_solo(X), solo(X), X.  /*

=head2  Maintaining Context

If we know what kind of C<def> we are currently expanding, we
can check for missing fields. */

 goal_expansion(in(T,X,Y),true)     :- in(T,X,Y). /*

This next one is tricky: SWI's DCG expansion does not unify
the output variable after a C<{X}> expansion so our meta-knowledge
that we are carrying round a certain C<def> is lost. So we
have to force that particular unification: */

 goal_expansion(A=(B=C),true) :- ground(B),def(B,_), A=(B=C). /*

Which means that we can't use 'C<X;Y>' or 'C<X -E<gt> Y ; Z>' in ECGs. 
So replace these with the usual expansions; i.e. 

 X :- Y,!,Z.
 X.

 X :- Y.
 X :- Z. */


