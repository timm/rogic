:- [ops].

*boolean are oneOf=[t, f].
*authors are[groups=[1], persons=[tim='tim@menzies.com'], members=[1=[tim]]].
*boolean are[aa, bb, cc, dd, ee, ff, gg, hh, ii, jj, kk, ll, mm].
*author=1.
*boolean are[check(1)].
*boolean are[check(mt(1))].
*1 if aa and bb then cc.
*mt(1)if not cc then not aa.
*mt(1)if not cc then not bb.
*test(mt(1))if not cc and aa and bb then check(mt(1)).
*boolean are[check(2)].
*boolean are[check(mt(2))].
*2 if dd and ee then ff.
*mt(2)if not ff then not dd.
*mt(2)if not ff then not ee.
*test(mt(2))if not ff and dd and ee then check(mt(2)).
*boolean are[check(3)].
*boolean are[check(mt(3))].
*3 if cc and ff then gg.
*mt(3)if not gg then not cc.
*mt(3)if not gg then not ff.
*test(mt(3))if not gg and cc and ff then check(mt(3)).
*boolean are[check(4)].
*boolean are[check(mt(4))].
*4 if aa and bb then not cc.
*mt(4)if cc then not aa.
*mt(4)if cc then not bb.
*test(mt(4))if cc and aa and bb then check(mt(4)).
*boolean are[check(5)].
*boolean are[check(mt(5))].
*5 if ff then kk.
*mt(5)if not kk then not ff.
*test(mt(5))if not kk and ff then check(mt(5)).
*boolean are[check(6)].
*boolean are[check(mt(6))].
*6 if not cc then hh.
*mt(6)if not hh then cc.
*test(mt(6))if not hh and not cc then check(mt(6)).
*boolean are[check(7)].
*boolean are[check(mt(7))].
*7 if gg and kk then ll.
*mt(7)if not ll then not gg.
*mt(7)if not ll then not kk.
*test(mt(7))if not ll and gg and kk then check(mt(7)).
*boolean are[check(8)].
*boolean are[check(mt(8))].
*8 if mm then hh.
*mt(8)if not hh then not mm.
*test(mt(8))if not hh and mm then check(mt(8)).

statement(1, 1 if aa and bb then cc).
statement(2, 2 if dd and ee then ff).
statement(3, 3 if cc and ff then gg).
statement(4, 4 if aa and bb then not cc).
statement(5, 5 if ff then kk).
statement(6, 6 if not cc then hh).
statement(7, 7 if gg and kk then ll).
statement(8, 8 if mm then hh).
