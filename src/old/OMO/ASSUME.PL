

%=head1 Handling assumptions

 :- ensure_loaded([assume0,assume1]). /*

We seperate out I<type rules> from I<what-if ranges>:

=over 8

=item Type rules

Type rules define legal ranges for a variable of  a certain
type. They can also check that a bound variable for a certain
type is legal.

For example, the OMO type rules are shown in L<Data dictionary for COCOMO>.

=item What-if ranges

What-if ranges represent domain knowledge that a variable is to be restructed
to a certain range.

For example, the OMO type rules are shown in L<An example what-if range for COCOMO>.


=back

#=include omotypes.pl



#=include omowhatif1.pl

#=include assume0.pl

#=head1 Assumption control

#=include assume1.pl
