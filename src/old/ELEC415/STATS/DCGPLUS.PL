% dcgplus- stuff to fix over-zealous dcg expansions

goal_expansion(=(A,B,C,C),      A = B).
goal_expansion(>(A,B,C,C),      A > B).
goal_expansion(<(A,B,C,C),      A < B).
goal_expansion(is(A,B,C,C),     A is B).
goal_expansion(fail(X,X),       fail).
goal_expansion(format(A,B,C,C), format(A,B)).
