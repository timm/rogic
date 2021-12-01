
%=head2 Start-up actions

%Assert the C<inf/1> fact.

 :- current_prolog_flag(max_integer,X), 
    X1 is X - 1, 
    retractall(inf(_)),
    assert(inf(X1)).

%Since we've also made C<inf/0> a maths function,
%we can now write things like

% X is 2/inf.
