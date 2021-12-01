:- [ops].

obj(0, aa).
obj(1, bb).
obj(2, check(1)).

v(4, bb, =, t, t(1), or).
v(6, aa, =, t, t(1), or).
v(10, aa, =, f, t(1), or).
v(12, bb, =, f, t(1), or).

e(7, 6, 4, 1).
e(13, 12, 10, 1).

assertion(5, 1, 1).
assertion(11, mt(1), 1).

assertionEdge(8, 7, 5).
assertionEdge(14, 13, 11).
