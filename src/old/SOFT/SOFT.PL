/*

=head1 MOOSE

I<MOOSE> is a new 
M=model O=of S=software E=engineering. The premise of I<MOOSE>
is that we only build what we can test.

*/

/*

=head1 Header */

/*

=head2 Loads */

:- ensure_loaded([lib,randoms]).

/*

=head2 Operators */

 :- op(1199,fx,@).
 :- op(999,fx,&). /*

=head2 Flags */

/*

=head2  Hooks */

/*

=head2 Hacks */

/*

=head1 Body */

&X :- one(X).

/*


=head1 Footer */

/*

=head2 Start-up Commands */
