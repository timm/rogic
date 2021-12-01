:- [ops].

obj(0, aa).
obj(1, ll).
obj(2, bb).
obj(3, mm).
obj(4, nn).
obj(5, ii).
obj(6, jj).
obj(7, kk).
obj(8, cc).
obj(9, dd).
obj(10, ee).
obj(11, ff).
obj(12, gg).
obj(13, hh).
obj(14, check(1)).
obj(15, check(2)).
obj(16, check(3)).
obj(17, check(4)).
obj(18, check(5)).

v(20, bb, =, t, t(1), or).
v(22, aa, =, t, t(1), or).
v(26, aa, =, f, t(1), or).
v(28, bb, =, f, t(1), or).
v(33, mm, =, t, t(1), or).
v(37, mm, =, f, t(1), or).
v(42, ee, =, t, t(1), or).
v(48, ee, =, f, t(1), or).
v(52, kk, =, t, t(1), or).
v(58, kk, =, f, t(1), or).
v(62, hh, =, f, t(1), or).
v(68, hh, =, t, t(1), or).

e(23, 22, 20, 1).
e(29, 28, 26, 1).
e(34, 33, 28, 1).
e(39, 20, 37, 1).
e(44, 20, 42, 1).
e(49, 48, 28, 1).
e(54, 20, 52, 1).
e(59, 58, 28, 1).
e(64, 28, 62, 1).
e(69, 68, 20, 1).

assertion(21, 1, 1).
assertion(27, mt(1), 1).
assertion(32, 2, 1).
assertion(38, mt(2), 1).
assertion(43, 3, 1).
assertion(47, mt(3), 1).
assertion(53, 4, 1).
assertion(57, mt(4), 1).
assertion(63, 5, 1).
assertion(67, mt(5), 1).

assertionEdge(24, 23, 21).
assertionEdge(30, 29, 27).
assertionEdge(35, 34, 32).
assertionEdge(40, 39, 38).
assertionEdge(45, 44, 43).
assertionEdge(50, 49, 47).
assertionEdge(55, 54, 53).
assertionEdge(60, 59, 57).
assertionEdge(65, 64, 63).
assertionEdge(70, 69, 67).
