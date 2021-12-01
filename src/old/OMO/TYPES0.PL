
%=head2 Operators

 :- op(999,xfx,(of)).
 :- op(999,fx,  (@)).
 :- op(1,fx,    (=)).

%=head2 Flags

 :- discontiguous @/2.
 :- multifile     @/2.

%=head2 Hooks

  term_expansion(X of Y,@X=Z:-@Y=Z)).
