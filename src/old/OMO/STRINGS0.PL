%=head2 Flags

%Define some new commands for C<format>.

%"Left-justify" is handled by C<padChars>.

 :- format_predicate('>',padChars(_,_)).

%"Right-justify" is handled by C<charsPad>

 :- format_predicate('<',charsPad(_,_)).

%"Squiggles" mean is handled by C<squiggle>.

 :- format_predicate('S',squiggle(_,_)).
