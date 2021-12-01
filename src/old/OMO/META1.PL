
#=head2 Backtractable state updates

  bassert(X) :- assert(X).
  bassert(X) :- retract(X),fail.

  reretract(X) :retract(X), (true; assert(X), fail).
