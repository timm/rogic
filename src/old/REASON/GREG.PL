/*

=head1 Greg's stuff

=head2

How to write psuedo random numbers in Prolog?

=head2 other stuff */

 sumDCG([H|T],Out) :- sumDCG(H,Out,T,[]).

 sumDCG(Out,Out) --> [].
 sumDCG(Temp,Out) -->  [H], {New is Temp + H}, sumDCG(New,Out).
