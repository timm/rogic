:- [ops].

obj(0, aa).
obj(1, bb).
obj(2, cc).
obj(3, dd).
obj(4, ff).
obj(5, check(1)).
obj(6, check(mt(1))).
obj(7, check(2)).
obj(8, check(mt(2))).
obj(9, check(3)).
obj(10, check(mt(3))).
obj(11, check(4)).
obj(12, check(mt(4))).
obj(13, check(5)).
obj(14, check(mt(5))).

v(16, cc, =, t, t(1), or).
v(18, aa, =, t, t(1), or).
v(22, aa, =, f, t(1), or).
v(24, cc, =, f, t(1), or).
v(28, check(mt(1)), =, t, t(1), or).
v(30, and, =, t, t(1), and).
v(38, dd, =, f, t(1), or).
v(44, dd, =, t, t(1), or).
v(48, check(mt(2)), =, t, t(1), or).
v(50, and, =, t, t(1), and).
v(59, ff, =, t, t(1), or).
v(63, ff, =, f, t(1), or).
v(68, check(mt(3)), =, t, t(1), or).
v(70, and, =, t, t(1), and).
v(78, bb, =, t, t(1), or).
v(84, bb, =, f, t(1), or).
v(88, check(mt(4)), =, t, t(1), or).
v(90, and, =, t, t(1), and).
v(106, check(mt(5)), =, t, t(1), or).
v(108, and, =, t, t(1), and).

e(19, 18, 16, 1).
e(25, 24, 22, 1).
e(31, 30, 28, 1).
e(33, 24, 30, 0).
e(35, 18, 30, 0).
e(40, 16, 38, 1).
e(45, 44, 24, 1).
e(51, 50, 48, 1).
e(53, 44, 50, 0).
e(55, 16, 50, 0).
e(60, 59, 44, 1).
e(65, 38, 63, 1).
e(71, 70, 68, 1).
e(73, 38, 70, 0).
e(75, 59, 70, 0).
e(80, 44, 78, 1).
e(85, 84, 38, 1).
e(91, 90, 88, 1).
e(93, 84, 90, 0).
e(95, 44, 90, 0).
e(99, 16, 78, 1).
e(103, 84, 24, 1).
e(109, 108, 106, 1).
e(111, 84, 108, 0).
e(113, 16, 108, 0).

assertion(17, 1, 1).
assertion(23, mt(1), 1).
assertion(29, test(mt(1)), 1).
assertion(39, 2, 1).
assertion(43, mt(2), 1).
assertion(49, test(mt(2)), 1).
assertion(58, 3, 1).
assertion(64, mt(3), 1).
assertion(69, test(mt(3)), 1).
assertion(79, 4, 1).
assertion(83, mt(4), 1).
assertion(89, test(mt(4)), 1).
assertion(98, 5, 1).
assertion(102, mt(5), 1).
assertion(107, test(mt(5)), 1).

assertionEdge(20, 19, 17).
assertionEdge(26, 25, 23).
assertionEdge(32, 31, 30).
assertionEdge(34, 33, 29).
assertionEdge(36, 35, 29).
assertionEdge(41, 40, 39).
assertionEdge(46, 45, 43).
assertionEdge(52, 51, 50).
assertionEdge(54, 53, 49).
assertionEdge(56, 55, 49).
assertionEdge(61, 60, 58).
assertionEdge(66, 65, 64).
assertionEdge(72, 71, 70).
assertionEdge(74, 73, 69).
assertionEdge(76, 75, 69).
assertionEdge(81, 80, 79).
assertionEdge(86, 85, 83).
assertionEdge(92, 91, 90).
assertionEdge(94, 93, 89).
assertionEdge(96, 95, 89).
assertionEdge(100, 99, 98).
assertionEdge(104, 103, 102).
assertionEdge(110, 109, 108).
assertionEdge(112, 111, 107).
assertionEdge(114, 113, 107).
