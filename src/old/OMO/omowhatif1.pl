
%=head1 An example what-if range for COCOMO

/*In practice, users offer one I<what-if> file that defines certain restrictions
to the simulation. */

 cocomo ?2000.
 prec   ?X :- X in [vl,vh].

%So, once these what-of ranges are loaded, then all subsequent
%random simulations can pull randomly from the ranges of every other variable,
%However, for the variables listed above,  simulations are
%certain restrictions.