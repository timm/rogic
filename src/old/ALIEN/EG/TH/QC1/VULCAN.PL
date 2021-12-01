:- [ops].

obj(0, true).
obj(1, accident(peter, londonRoad)).
obj(2, check(0)).
obj(3, medicalEmergency(londonRoad)).
obj(4, check(1)).
obj(5, check(2)).
obj(6, dispatchAmbulanceTo(londonRoad)).
obj(7, check(3)).
obj(8, check(4)).
obj(9, ambulanceAvailable).
obj(10, check(5)).
obj(11, check(6)).
obj(12, check(7)).

v(14, accident(peter, londonRoad), =, t, t(1), or).
v(16, true, =, t, t(1), or).
v(20, true, =, f, t(1), or).
v(22, accident(peter, londonRoad), =, f, t(1), or).
v(26, medicalEmergency(londonRoad), =, t, t(1), or).
v(32, medicalEmergency(londonRoad), =, f, t(1), or).
v(44, dispatchAmbulanceTo(londonRoad), =, t, t(1), or).
v(50, dispatchAmbulanceTo(londonRoad), =, f, t(1), or).
v(63, ambulanceAvailable, =, f, t(1), or).
v(67, ambulanceAvailable, =, t, t(1), or).

e(17, 16, 14, 1).
e(23, 22, 20, 1).
e(28, 14, 26, 1).
e(33, 32, 22, 1).
e(37, 32, 22, 1).
e(41, 14, 26, 1).
e(46, 26, 44, 1).
e(51, 50, 32, 1).
e(55, 50, 32, 1).
e(59, 26, 44, 1).
e(64, 63, 50, 1).
e(69, 44, 67, 1).
e(73, 44, 67, 1).
e(77, 63, 50, 1).
e(81, 16, 63, 1).
e(85, 67, 20, 1).

assertion(15, 0, 1).
assertion(21, mt(0), 1).
assertion(27, 1, 1).
assertion(31, mt(1), 1).
assertion(36, 2, 1).
assertion(40, mt(2), 1).
assertion(45, 3, 1).
assertion(49, mt(3), 1).
assertion(54, 4, 1).
assertion(58, mt(4), 1).
assertion(62, 5, 1).
assertion(68, mt(5), 1).
assertion(72, 6, 1).
assertion(76, mt(6), 1).
assertion(80, 7, 1).
assertion(84, mt(7), 1).

assertionEdge(18, 17, 15).
assertionEdge(24, 23, 21).
assertionEdge(29, 28, 27).
assertionEdge(34, 33, 31).
assertionEdge(38, 37, 36).
assertionEdge(42, 41, 40).
assertionEdge(47, 46, 45).
assertionEdge(52, 51, 49).
assertionEdge(56, 55, 54).
assertionEdge(60, 59, 58).
assertionEdge(65, 64, 62).
assertionEdge(70, 69, 68).
assertionEdge(74, 73, 72).
assertionEdge(78, 77, 76).
assertionEdge(82, 81, 80).
assertionEdge(86, 85, 84).
