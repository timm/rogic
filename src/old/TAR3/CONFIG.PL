target   = errorRate.
skip     = [id,errorRate,defects,density].
nway     = 10.
relation = kc2.
verbose  = 1.

weight(X,Y) :- Y is X + 1.