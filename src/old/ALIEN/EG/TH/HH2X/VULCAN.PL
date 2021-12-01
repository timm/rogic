:- [ops].

obj(0, aa).
obj(1, ll).
obj(2, bb).
obj(3, cc).
obj(4, dd).
obj(5, ee).
obj(6, ff).
obj(7, gg).
obj(8, hh).
obj(9, ii).
obj(10, jj).
obj(11, kk).
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
obj(29, check(9)).
obj(30, check(mt(9))).
obj(31, check(10)).
obj(32, check(mt(10))).
obj(33, check(11)).
obj(34, check(mt(11))).
obj(35, check(12)).
obj(36, check(mt(12))).

v(38, cc, =, t, t(1), or).
v(40, aa, =, t, t(1), or).
v(44, aa, =, f, t(1), or).
v(46, cc, =, f, t(1), or).
v(50, check(mt(1)), =, t, t(1), or).
v(52, and, =, t, t(1), and).
v(61, bb, =, t, t(1), or).
v(65, bb, =, f, t(1), or).
v(70, check(mt(2)), =, t, t(1), or).
v(72, and, =, t, t(1), and).
v(80, ee, =, f, t(1), or).
v(86, ee, =, t, t(1), or).
v(90, check(mt(3)), =, t, t(1), or).
v(92, and, =, t, t(1), and).
v(100, ff, =, f, t(1), or).
v(106, ff, =, t, t(1), or).
v(110, check(mt(4)), =, t, t(1), or).
v(112, and, =, t, t(1), and).
v(120, dd, =, t, t(1), or).
v(126, dd, =, f, t(1), or).
v(130, check(mt(5)), =, t, t(1), or).
v(132, and, =, t, t(1), and).
v(140, gg, =, t, t(1), or).
v(146, gg, =, f, t(1), or).
v(150, check(mt(6)), =, t, t(1), or).
v(152, and, =, t, t(1), and).
v(160, ll, =, f, t(1), or).
v(166, ll, =, t, t(1), or).
v(170, check(mt(7)), =, t, t(1), or).
v(172, and, =, t, t(1), and).
v(180, jj, =, f, t(1), or).
v(182, ii, =, t, t(1), or).
v(186, ii, =, f, t(1), or).
v(188, jj, =, t, t(1), or).
v(192, check(mt(8)), =, t, t(1), or).
v(194, and, =, t, t(1), and).
v(203, hh, =, t, t(1), or).
v(207, hh, =, f, t(1), or).
v(212, check(mt(9)), =, t, t(1), or).
v(214, and, =, t, t(1), and).
v(222, kk, =, f, t(1), or).
v(228, kk, =, t, t(1), or).
v(232, check(mt(10)), =, t, t(1), or).
v(234, and, =, t, t(1), and).
v(250, check(mt(11)), =, t, t(1), or).
v(252, and, =, t, t(1), and).
v(260, mm, =, t, t(1), or).
v(266, mm, =, f, t(1), or).
v(270, check(mt(12)), =, t, t(1), or).
v(272, and, =, t, t(1), and).

e(41, 40, 38, 1).
e(47, 46, 44, 1).
e(53, 52, 50, 1).
e(55, 46, 52, 0).
e(57, 40, 52, 0).
e(62, 61, 46, 1).
e(67, 38, 65, 1).
e(73, 72, 70, 1).
e(75, 38, 72, 0).
e(77, 61, 72, 0).
e(82, 46, 80, 1).
e(87, 86, 38, 1).
e(93, 92, 90, 1).
e(95, 86, 92, 0).
e(97, 46, 92, 0).
e(102, 46, 100, 1).
e(107, 106, 38, 1).
e(113, 112, 110, 1).
e(115, 106, 112, 0).
e(117, 46, 112, 0).
e(122, 38, 120, 1).
e(127, 126, 46, 1).
e(133, 132, 130, 1).
e(135, 126, 132, 0).
e(137, 38, 132, 0).
e(142, 120, 140, 1).
e(147, 146, 126, 1).
e(153, 152, 150, 1).
e(155, 146, 152, 0).
e(157, 120, 152, 0).
e(162, 120, 160, 1).
e(167, 166, 126, 1).
e(173, 172, 170, 1).
e(175, 166, 172, 0).
e(177, 120, 172, 0).
e(183, 182, 180, 1).
e(189, 188, 186, 1).
e(195, 194, 192, 1).
e(197, 188, 194, 0).
e(199, 182, 194, 0).
e(204, 203, 188, 1).
e(209, 180, 207, 1).
e(215, 214, 212, 1).
e(217, 180, 214, 0).
e(219, 203, 214, 0).
e(224, 188, 222, 1).
e(229, 228, 180, 1).
e(235, 234, 232, 1).
e(237, 228, 234, 0).
e(239, 188, 234, 0).
e(243, 188, 140, 1).
e(247, 146, 180, 1).
e(253, 252, 250, 1).
e(255, 146, 252, 0).
e(257, 188, 252, 0).
e(262, 180, 260, 1).
e(267, 266, 188, 1).
e(273, 272, 270, 1).
e(275, 266, 272, 0).
e(277, 180, 272, 0).

assertion(39, 1, 1).
assertion(45, mt(1), 1).
assertion(51, test(mt(1)), 1).
assertion(60, 2, 1).
assertion(66, mt(2), 1).
assertion(71, test(mt(2)), 1).
assertion(81, 3, 1).
assertion(85, mt(3), 1).
assertion(91, test(mt(3)), 1).
assertion(101, 4, 1).
assertion(105, mt(4), 1).
assertion(111, test(mt(4)), 1).
assertion(121, 5, 1).
assertion(125, mt(5), 1).
assertion(131, test(mt(5)), 1).
assertion(141, 6, 1).
assertion(145, mt(6), 1).
assertion(151, test(mt(6)), 1).
assertion(161, 7, 1).
assertion(165, mt(7), 1).
assertion(171, test(mt(7)), 1).
assertion(181, 8, 1).
assertion(187, mt(8), 1).
assertion(193, test(mt(8)), 1).
assertion(202, 9, 1).
assertion(208, mt(9), 1).
assertion(213, test(mt(9)), 1).
assertion(223, 10, 1).
assertion(227, mt(10), 1).
assertion(233, test(mt(10)), 1).
assertion(242, 11, 1).
assertion(246, mt(11), 1).
assertion(251, test(mt(11)), 1).
assertion(261, 12, 1).
assertion(265, mt(12), 1).
assertion(271, test(mt(12)), 1).

assertionEdge(42, 41, 39).
assertionEdge(48, 47, 45).
assertionEdge(54, 53, 52).
assertionEdge(56, 55, 51).
assertionEdge(58, 57, 51).
assertionEdge(63, 62, 60).
assertionEdge(68, 67, 66).
assertionEdge(74, 73, 72).
assertionEdge(76, 75, 71).
assertionEdge(78, 77, 71).
assertionEdge(83, 82, 81).
assertionEdge(88, 87, 85).
assertionEdge(94, 93, 92).
assertionEdge(96, 95, 91).
assertionEdge(98, 97, 91).
assertionEdge(103, 102, 101).
assertionEdge(108, 107, 105).
assertionEdge(114, 113, 112).
assertionEdge(116, 115, 111).
assertionEdge(118, 117, 111).
assertionEdge(123, 122, 121).
assertionEdge(128, 127, 125).
assertionEdge(134, 133, 132).
assertionEdge(136, 135, 131).
assertionEdge(138, 137, 131).
assertionEdge(143, 142, 141).
assertionEdge(148, 147, 145).
assertionEdge(154, 153, 152).
assertionEdge(156, 155, 151).
assertionEdge(158, 157, 151).
assertionEdge(163, 162, 161).
assertionEdge(168, 167, 165).
assertionEdge(174, 173, 172).
assertionEdge(176, 175, 171).
assertionEdge(178, 177, 171).
assertionEdge(184, 183, 181).
assertionEdge(190, 189, 187).
assertionEdge(196, 195, 194).
assertionEdge(198, 197, 193).
assertionEdge(200, 199, 193).
assertionEdge(205, 204, 202).
assertionEdge(210, 209, 208).
assertionEdge(216, 215, 214).
assertionEdge(218, 217, 213).
assertionEdge(220, 219, 213).
assertionEdge(225, 224, 223).
assertionEdge(230, 229, 227).
assertionEdge(236, 235, 234).
assertionEdge(238, 237, 233).
assertionEdge(240, 239, 233).
assertionEdge(244, 243, 242).
assertionEdge(248, 247, 246).
assertionEdge(254, 253, 252).
assertionEdge(256, 255, 251).
assertionEdge(258, 257, 251).
assertionEdge(263, 262, 261).
assertionEdge(268, 267, 265).
assertionEdge(274, 273, 272).
assertionEdge(276, 275, 271).
assertionEdge(278, 277, 271).
