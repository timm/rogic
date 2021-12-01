% dcg repair
goal_expansion(>(A,B,C,C), A > B).
goal_expansion(format(A,B,C,C), format(A,B)).
goal_expansion(fail(X,X), fail).
