:- [ops].

obj(0, aa).
obj(1, bb).
obj(2, cc).
obj(3, dd).
obj(4, ee).
obj(5, ff).
obj(6, gg).
obj(7, hh).
obj(8, ii).
obj(9, jj).
obj(10, kk).
obj(11, ll).
obj(12, mm).
obj(13, check(1)).
obj(14, check(mt(1))).
obj(15, check(2)).
obj(16, check(mt(2))).
obj(17, check(3)).
obj(18, check(mt(3))).
obj(19, check(4)).
obj(20, check(mt(4))).
obj(21, check(5)).
obj(22, check(mt(5))).
obj(23, check(6)).
obj(24, check(mt(6))).
obj(25, check(7)).
obj(26, check(mt(7))).
obj(27, check(8)).
obj(28, check(mt(8))).

v(30, cc, =, t, t(1), or).
v(32, and, =, t, t(1), and).
v(35, aa, =, t, t(1), or).
v(38, bb, =, t, t(1), or).
v(42, aa, =, f, t(1), or).
v(44, cc, =, f, t(1), or).
v(48, bb, =, f, t(1), or).
v(52, check(mt(1)), =, t, t(1), or).
v(54, and, =, t, t(1), and).
v(64, ff, =, t, t(1), or).
v(66, and, =, t, t(1), and).
v(69, dd, =, t, t(1), or).
v(72, ee, =, t, t(1), or).
v(76, dd, =, f, t(1), or).
v(78, ff, =, f, t(1), or).
v(82, ee, =, f, t(1), or).
v(86, check(mt(2)), =, t, t(1), or).
v(88, and, =, t, t(1), and).
v(98, gg, =, t, t(1), or).
v(100, and, =, t, t(1), and).
v(109, gg, =, f, t(1), or).
v(116, check(mt(3)), =, t, t(1), or).
v(118, and, =, t, t(1), and).
v(129, and, =, t, t(1), and).
v(144, check(mt(4)), =, t, t(1), or).
v(146, and, =, t, t(1), and).
v(156, kk, =, t, t(1), or).
v(162, kk, =, f, t(1), or).
v(166, check(mt(5)), =, t, t(1), or).
v(168, and, =, t, t(1), and).
v(176, hh, =, t, t(1), or).
v(182, hh, =, f, t(1), or).
v(186, check(mt(6)), =, t, t(1), or).
v(188, and, =, t, t(1), and).
v(196, ll, =, t, t(1), or).
v(198, and, =, t, t(1), and).
v(207, ll, =, f, t(1), or).
v(214, check(mt(7)), =, t, t(1), or).
v(216, and, =, t, t(1), and).
v(227, mm, =, t, t(1), or).
v(231, mm, =, f, t(1), or).
v(236, check(mt(8)), =, t, t(1), or).
v(238, and, =, t, t(1), and).

e(33, 32, 30, 1).
e(36, 35, 32, 0).
e(39, 38, 32, 0).
e(45, 44, 42, 1).
e(49, 44, 48, 1).
e(55, 54, 52, 1).
e(57, 44, 54, 0).
e(59, 35, 54, 0).
e(61, 38, 54, 0).
e(67, 66, 64, 1).
e(70, 69, 66, 0).
e(73, 72, 66, 0).
e(79, 78, 76, 1).
e(83, 78, 82, 1).
e(89, 88, 86, 1).
e(91, 78, 88, 0).
e(93, 69, 88, 0).
e(95, 72, 88, 0).
e(101, 100, 98, 1).
e(103, 30, 100, 0).
e(105, 64, 100, 0).
e(110, 109, 44, 1).
e(113, 109, 78, 1).
e(119, 118, 116, 1).
e(121, 109, 118, 0).
e(123, 30, 118, 0).
e(125, 64, 118, 0).
e(130, 129, 44, 1).
e(132, 35, 129, 0).
e(134, 38, 129, 0).
e(138, 30, 42, 1).
e(141, 30, 48, 1).
e(147, 146, 144, 1).
e(149, 30, 146, 0).
e(151, 35, 146, 0).
e(153, 38, 146, 0).
e(158, 64, 156, 1).
e(163, 162, 78, 1).
e(169, 168, 166, 1).
e(171, 162, 168, 0).
e(173, 64, 168, 0).
e(178, 44, 176, 1).
e(183, 182, 30, 1).
e(189, 188, 186, 1).
e(191, 182, 188, 0).
e(193, 44, 188, 0).
e(199, 198, 196, 1).
e(201, 98, 198, 0).
e(203, 156, 198, 0).
e(208, 207, 109, 1).
e(211, 207, 162, 1).
e(217, 216, 214, 1).
e(219, 207, 216, 0).
e(221, 98, 216, 0).
e(223, 156, 216, 0).
e(228, 227, 176, 1).
e(233, 182, 231, 1).
e(239, 238, 236, 1).
e(241, 182, 238, 0).
e(243, 227, 238, 0).

assertion(31, 1, 1).
assertion(43, mt(1), 1).
assertion(53, test(mt(1)), 1).
assertion(65, 2, 1).
assertion(77, mt(2), 1).
assertion(87, test(mt(2)), 1).
assertion(99, 3, 1).
assertion(108, mt(3), 1).
assertion(117, test(mt(3)), 1).
assertion(128, 4, 1).
assertion(137, mt(4), 1).
assertion(145, test(mt(4)), 1).
assertion(157, 5, 1).
assertion(161, mt(5), 1).
assertion(167, test(mt(5)), 1).
assertion(177, 6, 1).
assertion(181, mt(6), 1).
assertion(187, test(mt(6)), 1).
assertion(197, 7, 1).
assertion(206, mt(7), 1).
assertion(215, test(mt(7)), 1).
assertion(226, 8, 1).
assertion(232, mt(8), 1).
assertion(237, test(mt(8)), 1).

assertionEdge(34, 33, 32).
assertionEdge(37, 36, 31).
assertionEdge(40, 39, 31).
assertionEdge(46, 45, 43).
assertionEdge(50, 49, 43).
assertionEdge(56, 55, 54).
assertionEdge(58, 57, 53).
assertionEdge(60, 59, 53).
assertionEdge(62, 61, 53).
assertionEdge(68, 67, 66).
assertionEdge(71, 70, 65).
assertionEdge(74, 73, 65).
assertionEdge(80, 79, 77).
assertionEdge(84, 83, 77).
assertionEdge(90, 89, 88).
assertionEdge(92, 91, 87).
assertionEdge(94, 93, 87).
assertionEdge(96, 95, 87).
assertionEdge(102, 101, 100).
assertionEdge(104, 103, 99).
assertionEdge(106, 105, 99).
assertionEdge(111, 110, 108).
assertionEdge(114, 113, 108).
assertionEdge(120, 119, 118).
assertionEdge(122, 121, 117).
assertionEdge(124, 123, 117).
assertionEdge(126, 125, 117).
assertionEdge(131, 130, 129).
assertionEdge(133, 132, 128).
assertionEdge(135, 134, 128).
assertionEdge(139, 138, 137).
assertionEdge(142, 141, 137).
assertionEdge(148, 147, 146).
assertionEdge(150, 149, 145).
assertionEdge(152, 151, 145).
assertionEdge(154, 153, 145).
assertionEdge(159, 158, 157).
assertionEdge(164, 163, 161).
assertionEdge(170, 169, 168).
assertionEdge(172, 171, 167).
assertionEdge(174, 173, 167).
assertionEdge(179, 178, 177).
assertionEdge(184, 183, 181).
assertionEdge(190, 189, 188).
assertionEdge(192, 191, 187).
assertionEdge(194, 193, 187).
assertionEdge(200, 199, 198).
assertionEdge(202, 201, 197).
assertionEdge(204, 203, 197).
assertionEdge(209, 208, 206).
assertionEdge(212, 211, 206).
assertionEdge(218, 217, 216).
assertionEdge(220, 219, 215).
assertionEdge(222, 221, 215).
assertionEdge(224, 223, 215).
assertionEdge(229, 228, 226).
assertionEdge(234, 233, 232).
assertionEdge(240, 239, 238).
assertionEdge(242, 241, 237).
assertionEdge(244, 243, 237).
