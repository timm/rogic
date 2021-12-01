:- [ops].

obj(0, age).
obj(1, wieght).
obj(2, shoeSize).
obj(3, convictions).
obj(4, guilty).
obj(5, infant).
obj(6, jail).
obj(7, legally_responsible).
obj(8, means).
obj(9, moron).
obj(10, motive).
obj(11, opportunity).
obj(12, witnesses).
obj(13, check(1)).
obj(14, check(mt(1))).
obj(15, check(2)).
obj(16, check(mt(2))).
obj(17, check(3)).
obj(18, check(mt(3))).

v(20, legally_responsible, =, f, t(1), or).
v(22, moron, =, t, t(1), or).
v(26, and, =, t, t(1), and).
v(29, wieght, >, 12, t(1), or).
v(32, infant, =, t, t(1), or).
v(36, infant, =, f, t(1), or).
v(38, legally_responsible, =, t, t(1), or).
v(42, moron, =, f, t(1), or).
v(46, check(1), =, t, t(1), or).
v(48, and, =, t, t(1), and).
v(56, and, =, t, t(1), and).
v(66, check(mt(1)), =, t, t(1), or).
v(68, and, =, t, t(1), and).
v(76, and, =, t, t(1), and).
v(87, age, <, 12, t(1), or).
v(91, age, >, 7, t(1), or).
v(95, check(mt(2)), =, t, t(1), or).
v(97, and, =, t, t(1), and).
v(105, and, =, t, t(1), and).
v(113, check(mt(3)), =, t, t(1), or).
v(115, and, =, t, t(1), and).
v(118, shoeSize, <, 20, t(1), or).
v(121, shoeSize, <, 100, t(1), or).
v(125, and, =, t, t(1), and).
v(128, shoeSize, >, 20, t(1), or).
v(134, and, =, t, t(1), and).
v(139, shoeSize, >, 23, t(1), or).
v(143, and, =, t, t(1), and).

e(23, 22, 20, 1).
e(27, 26, 20, 1).
e(30, 29, 26, 0).
e(33, 32, 26, 0).
e(39, 38, 36, 1).
e(43, 38, 42, 1).
e(49, 48, 46, 1).
e(51, 22, 48, 0).
e(53, 38, 48, 0).
e(57, 56, 46, 1).
e(59, 29, 56, 0).
e(61, 32, 56, 0).
e(63, 38, 56, 0).
e(69, 68, 66, 1).
e(71, 38, 68, 0).
e(73, 22, 68, 0).
e(77, 76, 66, 1).
e(79, 38, 76, 0).
e(81, 29, 76, 0).
e(83, 32, 76, 0).
e(88, 87, 32, 1).
e(92, 91, 32, 1).
e(98, 97, 95, 1).
e(100, 36, 97, 0).
e(102, 87, 97, 0).
e(106, 105, 95, 1).
e(108, 36, 105, 0).
e(110, 91, 105, 0).
e(116, 115, 113, 1).
e(119, 118, 115, 0).
e(122, 121, 115, 0).
e(126, 125, 113, 1).
e(129, 128, 125, 0).
e(131, 121, 125, 0).
e(135, 134, 113, 1).
e(137, 118, 134, 0).
e(140, 139, 134, 0).
e(144, 143, 113, 1).
e(146, 128, 143, 0).
e(148, 139, 143, 0).

assertion(21, 1, prosecute).
assertion(37, mt(1), prosecute).
assertion(47, test(1), prosecute).
assertion(67, test(mt(1)), prosecute).
assertion(86, 2, prosecute).
assertion(96, test(mt(2)), prosecute).
assertion(114, test(mt(3)), prosecute).

assertionEdge(24, 23, 21).
assertionEdge(28, 27, 26).
assertionEdge(31, 30, 21).
assertionEdge(34, 33, 21).
assertionEdge(40, 39, 37).
assertionEdge(44, 43, 37).
assertionEdge(50, 49, 48).
assertionEdge(52, 51, 47).
assertionEdge(54, 53, 47).
assertionEdge(58, 57, 56).
assertionEdge(60, 59, 47).
assertionEdge(62, 61, 47).
assertionEdge(64, 63, 47).
assertionEdge(70, 69, 68).
assertionEdge(72, 71, 67).
assertionEdge(74, 73, 67).
assertionEdge(78, 77, 76).
assertionEdge(80, 79, 67).
assertionEdge(82, 81, 67).
assertionEdge(84, 83, 67).
assertionEdge(89, 88, 86).
assertionEdge(93, 92, 86).
assertionEdge(99, 98, 97).
assertionEdge(101, 100, 96).
assertionEdge(103, 102, 96).
assertionEdge(107, 106, 105).
assertionEdge(109, 108, 96).
assertionEdge(111, 110, 96).
assertionEdge(117, 116, 115).
assertionEdge(120, 119, 114).
assertionEdge(123, 122, 114).
assertionEdge(127, 126, 125).
assertionEdge(130, 129, 114).
assertionEdge(132, 131, 114).
assertionEdge(136, 135, 134).
assertionEdge(138, 137, 114).
assertionEdge(141, 140, 114).
assertionEdge(145, 144, 143).
assertionEdge(147, 146, 114).
assertionEdge(149, 148, 114).
