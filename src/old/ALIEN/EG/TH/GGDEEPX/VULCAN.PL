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
obj(15, check(mt(1))).
obj(16, check(2)).
obj(17, check(mt(2))).
obj(18, check(3)).
obj(19, check(mt(3))).
obj(20, check(4)).
obj(21, check(mt(4))).
obj(22, check(5)).
obj(23, check(mt(5))).
obj(24, check(6)).
obj(25, check(mt(6))).
obj(26, check(7)).
obj(27, check(mt(7))).
obj(28, check(8)).
obj(29, check(mt(8))).

v(31, cc, =, t, t(1), or).
v(33, aa, =, t, t(1), or).
v(37, aa, =, f, t(1), or).
v(39, cc, =, f, t(1), or).
v(43, check(mt(1)), =, t, t(1), or).
v(45, and, =, t, t(1), and).
v(53, dd, =, t, t(1), or).
v(59, dd, =, f, t(1), or).
v(63, check(mt(2)), =, t, t(1), or).
v(65, and, =, t, t(1), and).
v(73, gg, =, f, t(1), or).
v(79, gg, =, t, t(1), or).
v(83, check(mt(3)), =, t, t(1), or).
v(85, and, =, t, t(1), and).
v(93, hh, =, f, t(1), or).
v(99, hh, =, t, t(1), or).
v(103, check(mt(4)), =, t, t(1), or).
v(105, and, =, t, t(1), and).
v(113, ii, =, t, t(1), or).
v(119, ii, =, f, t(1), or).
v(123, check(mt(5)), =, t, t(1), or).
v(125, and, =, t, t(1), and).
v(134, bb, =, t, t(1), or).
v(138, bb, =, f, t(1), or).
v(143, check(mt(6)), =, t, t(1), or).
v(145, and, =, t, t(1), and).
v(153, ee, =, t, t(1), or).
v(159, ee, =, f, t(1), or).
v(163, check(mt(7)), =, t, t(1), or).
v(165, and, =, t, t(1), and).
v(173, ff, =, t, t(1), or).
v(179, ff, =, f, t(1), or).
v(183, check(mt(8)), =, t, t(1), or).
v(185, and, =, t, t(1), and).

e(34, 33, 31, 1).
e(40, 39, 37, 1).
e(46, 45, 43, 1).
e(48, 39, 45, 0).
e(50, 33, 45, 0).
e(55, 31, 53, 1).
e(60, 59, 39, 1).
e(66, 65, 63, 1).
e(68, 59, 65, 0).
e(70, 31, 65, 0).
e(75, 53, 73, 1).
e(80, 79, 59, 1).
e(86, 85, 83, 1).
e(88, 79, 85, 0).
e(90, 53, 85, 0).
e(95, 53, 93, 1).
e(100, 99, 59, 1).
e(106, 105, 103, 1).
e(108, 99, 105, 0).
e(110, 53, 105, 0).
e(115, 53, 113, 1).
e(120, 119, 59, 1).
e(126, 125, 123, 1).
e(128, 119, 125, 0).
e(130, 53, 125, 0).
e(135, 134, 39, 1).
e(140, 31, 138, 1).
e(146, 145, 143, 1).
e(148, 31, 145, 0).
e(150, 134, 145, 0).
e(155, 39, 153, 1).
e(160, 159, 31, 1).
e(166, 165, 163, 1).
e(168, 159, 165, 0).
e(170, 39, 165, 0).
e(175, 39, 173, 1).
e(180, 179, 31, 1).
e(186, 185, 183, 1).
e(188, 179, 185, 0).
e(190, 39, 185, 0).

assertion(32, 1, 1).
assertion(38, mt(1), 1).
assertion(44, test(mt(1)), 1).
assertion(54, 2, 1).
assertion(58, mt(2), 1).
assertion(64, test(mt(2)), 1).
assertion(74, 3, 1).
assertion(78, mt(3), 1).
assertion(84, test(mt(3)), 1).
assertion(94, 4, 1).
assertion(98, mt(4), 1).
assertion(104, test(mt(4)), 1).
assertion(114, 5, 1).
assertion(118, mt(5), 1).
assertion(124, test(mt(5)), 1).
assertion(133, 6, 1).
assertion(139, mt(6), 1).
assertion(144, test(mt(6)), 1).
assertion(154, 7, 1).
assertion(158, mt(7), 1).
assertion(164, test(mt(7)), 1).
assertion(174, 8, 1).
assertion(178, mt(8), 1).
assertion(184, test(mt(8)), 1).

assertionEdge(35, 34, 32).
assertionEdge(41, 40, 38).
assertionEdge(47, 46, 45).
assertionEdge(49, 48, 44).
assertionEdge(51, 50, 44).
assertionEdge(56, 55, 54).
assertionEdge(61, 60, 58).
assertionEdge(67, 66, 65).
assertionEdge(69, 68, 64).
assertionEdge(71, 70, 64).
assertionEdge(76, 75, 74).
assertionEdge(81, 80, 78).
assertionEdge(87, 86, 85).
assertionEdge(89, 88, 84).
assertionEdge(91, 90, 84).
assertionEdge(96, 95, 94).
assertionEdge(101, 100, 98).
assertionEdge(107, 106, 105).
assertionEdge(109, 108, 104).
assertionEdge(111, 110, 104).
assertionEdge(116, 115, 114).
assertionEdge(121, 120, 118).
assertionEdge(127, 126, 125).
assertionEdge(129, 128, 124).
assertionEdge(131, 130, 124).
assertionEdge(136, 135, 133).
assertionEdge(141, 140, 139).
assertionEdge(147, 146, 145).
assertionEdge(149, 148, 144).
assertionEdge(151, 150, 144).
assertionEdge(156, 155, 154).
assertionEdge(161, 160, 158).
assertionEdge(167, 166, 165).
assertionEdge(169, 168, 164).
assertionEdge(171, 170, 164).
assertionEdge(176, 175, 174).
assertionEdge(181, 180, 178).
assertionEdge(187, 186, 185).
assertionEdge(189, 188, 184).
assertionEdge(191, 190, 184).
