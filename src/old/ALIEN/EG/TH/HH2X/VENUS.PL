:- [ops].

*boolean are oneOf=[t, f].
*authors are[groups=[1], persons=[tim='tim@menzies.com'], members=[1=[tim]]].
*boolean are[aa, ll, bb, cc, dd, ee, ff, gg, hh, ii, jj, kk, ll, mm].
*author=1.
*boolean are[check(1)].
*boolean are[check(mt(1))].
*1 if aa then cc.
*mt(1)if not cc then not aa.
*test(mt(1))if not cc and aa then check(mt(1)).
*boolean are[check(2)].
*boolean are[check(mt(2))].
*2 if bb then not cc.
*mt(2)if cc then not bb.
*test(mt(2))if cc and bb then check(mt(2)).
*boolean are[check(3)].
*boolean are[check(mt(3))].
*3 if not cc then not ee.
*mt(3)if ee then cc.
*test(mt(3))if ee and not cc then check(mt(3)).
*boolean are[check(4)].
*boolean are[check(mt(4))].
*4 if not cc then not ff.
*mt(4)if ff then cc.
*test(mt(4))if ff and not cc then check(mt(4)).
*boolean are[check(5)].
*boolean are[check(mt(5))].
*5 if cc then dd.
*mt(5)if not dd then not cc.
*test(mt(5))if not dd and cc then check(mt(5)).
*boolean are[check(6)].
*boolean are[check(mt(6))].
*6 if dd then gg.
*mt(6)if not gg then not dd.
*test(mt(6))if not gg and dd then check(mt(6)).
*boolean are[check(7)].
*boolean are[check(mt(7))].
*7 if dd then not ll.
*mt(7)if ll then not dd.
*test(mt(7))if ll and dd then check(mt(7)).
*boolean are[check(8)].
*boolean are[check(mt(8))].
*8 if ii then not jj.
*mt(8)if jj then not ii.
*test(mt(8))if jj and ii then check(mt(8)).
*boolean are[check(9)].
*boolean are[check(mt(9))].
*9 if hh then jj.
*mt(9)if not jj then not hh.
*test(mt(9))if not jj and hh then check(mt(9)).
*boolean are[check(10)].
*boolean are[check(mt(10))].
*10 if jj then not kk.
*mt(10)if kk then not jj.
*test(mt(10))if kk and jj then check(mt(10)).
*boolean are[check(11)].
*boolean are[check(mt(11))].
*11 if jj then gg.
*mt(11)if not gg then not jj.
*test(mt(11))if not gg and jj then check(mt(11)).
*boolean are[check(12)].
*boolean are[check(mt(12))].
*12 if not jj then mm.
*mt(12)if not mm then jj.
*test(mt(12))if not mm and not jj then check(mt(12)).

statement(1, 1 if aa then cc).
statement(2, 2 if bb then not cc).
statement(3, 3 if not cc then not ee).
statement(4, 4 if not cc then not ff).
statement(5, 5 if cc then dd).
statement(6, 6 if dd then gg).
statement(7, 7 if dd then not ll).
statement(8, 8 if ii then not jj).
statement(9, 9 if hh then jj).
statement(10, 10 if jj then not kk).
statement(11, 11 if jj then gg).
statement(12, 12 if not jj then mm).
