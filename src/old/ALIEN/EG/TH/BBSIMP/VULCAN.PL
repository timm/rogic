:- [ops].

obj(0, aa).
obj(1, bb).
obj(2, cc).
obj(3, dd).
obj(4, check(1)).
obj(5, check(2)).
obj(6, check(3)).
obj(7, check(4)).
obj(8, check(5)).

v(10, cc, =, t, t(1), or).
v(12, aa, =, t, t(1), or).
v(16, aa, =, f, t(1), or).
v(18, cc, =, f, t(1), or).
v(22, dd, =, t, t(1), or).
v(28, dd, =, f, t(1), or).
v(32, bb, =, t, t(1), or).
v(38, bb, =, f, t(1), or).

e(13, 12, 10, 1).
e(19, 18, 16, 1).
e(24, 10, 22, 1).
e(29, 28, 18, 1).
e(34, 22, 32, 1).
e(39, 38, 28, 1).
e(43, 22, 32, 1).
e(47, 38, 28, 1).
e(51, 22, 10, 1).
e(55, 18, 28, 1).

assertion(11, 1, 1).
assertion(17, mt(1), 1).
assertion(23, 2, 1).
assertion(27, mt(2), 1).
assertion(33, 3, 1).
assertion(37, mt(3), 1).
assertion(42, 4, 1).
assertion(46, mt(4), 1).
assertion(50, 5, 1).
assertion(54, mt(5), 1).

assertionEdge(14, 13, 11).
assertionEdge(20, 19, 17).
assertionEdge(25, 24, 23).
assertionEdge(30, 29, 27).
assertionEdge(35, 34, 33).
assertionEdge(40, 39, 37).
assertionEdge(44, 43, 42).
assertionEdge(48, 47, 46).
assertionEdge(52, 51, 50).
assertionEdge(56, 55, 54).
