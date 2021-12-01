:- [ops].

obj(0, aa).
obj(1, bb).
obj(2, cc).
obj(3, dd).
obj(4, check(1)).
obj(5, check(mt(1))).

v(7, cc, =, t, t(1), or).
v(9, and, =, t, t(1), and).
v(12, aa, =, t, t(1), or).
v(15, bb, =, t, t(1), or).
v(19, dd, =, t, t(1), or).
v(20, and, =, t, t(1), and).
v(28, aa, =, f, t(1), or).
v(30, cc, =, f, t(1), or).
v(34, bb, =, f, t(1), or).
v(38, dd, =, f, t(1), or).
v(45, check(1), =, t, t(1), or).
v(47, and, =, t, t(1), and).
v(57, and, =, t, t(1), and).
v(67, check(mt(1)), =, t, t(1), or).
v(69, and, =, t, t(1), and).
v(79, and, =, t, t(1), and).

e(10, 9, 7, 1).
e(13, 12, 9, 0).
e(16, 15, 9, 0).
e(21, 20, 19, 1).
e(23, 12, 20, 0).
e(25, 15, 20, 0).
e(31, 30, 28, 1).
e(35, 30, 34, 1).
e(39, 38, 28, 1).
e(42, 38, 34, 1).
e(48, 47, 45, 1).
e(50, 12, 47, 0).
e(52, 15, 47, 0).
e(54, 30, 47, 0).
e(58, 57, 45, 1).
e(60, 12, 57, 0).
e(62, 15, 57, 0).
e(64, 38, 57, 0).
e(70, 69, 67, 1).
e(72, 30, 69, 0).
e(74, 12, 69, 0).
e(76, 15, 69, 0).
e(80, 79, 67, 1).
e(82, 38, 79, 0).
e(84, 12, 79, 0).
e(86, 15, 79, 0).

assertion(8, 1, 1).
assertion(29, mt(1), 1).
assertion(46, test(1), 1).
assertion(68, test(mt(1)), 1).

assertionEdge(11, 10, 9).
assertionEdge(14, 13, 8).
assertionEdge(17, 16, 8).
assertionEdge(22, 21, 20).
assertionEdge(24, 23, 8).
assertionEdge(26, 25, 8).
assertionEdge(32, 31, 29).
assertionEdge(36, 35, 29).
assertionEdge(40, 39, 29).
assertionEdge(43, 42, 29).
assertionEdge(49, 48, 47).
assertionEdge(51, 50, 46).
assertionEdge(53, 52, 46).
assertionEdge(55, 54, 46).
assertionEdge(59, 58, 57).
assertionEdge(61, 60, 46).
assertionEdge(63, 62, 46).
assertionEdge(65, 64, 46).
assertionEdge(71, 70, 69).
assertionEdge(73, 72, 68).
assertionEdge(75, 74, 68).
assertionEdge(77, 76, 68).
assertionEdge(81, 80, 79).
assertionEdge(83, 82, 68).
assertionEdge(85, 84, 68).
assertionEdge(87, 86, 68).
