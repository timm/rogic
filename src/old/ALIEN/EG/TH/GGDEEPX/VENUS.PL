:- [ops].

*boolean are oneOf=[t, f].
*authors are[groups=[1], persons=[tim='tim@menzies.com'], members=[1=[tim]]].
*boolean are[aa, ll, bb, mm, nn, ii, jj, kk, cc, dd, ee, ff, gg, hh].
*author=1.
*boolean are[check(1)].
*boolean are[check(mt(1))].
*1 if aa then cc.
*mt(1)if not cc then not aa.
*test(mt(1))if not cc and aa then check(mt(1)).
*boolean are[check(2)].
*boolean are[check(mt(2))].
*2 if cc then dd.
*mt(2)if not dd then not cc.
*test(mt(2))if not dd and cc then check(mt(2)).
*boolean are[check(3)].
*boolean are[check(mt(3))].
*3 if dd then not gg.
*mt(3)if gg then not dd.
*test(mt(3))if gg and dd then check(mt(3)).
*boolean are[check(4)].
*boolean are[check(mt(4))].
*4 if dd then not hh.
*mt(4)if hh then not dd.
*test(mt(4))if hh and dd then check(mt(4)).
*boolean are[check(5)].
*boolean are[check(mt(5))].
*5 if dd then ii.
*mt(5)if not ii then not dd.
*test(mt(5))if not ii and dd then check(mt(5)).
*boolean are[check(6)].
*boolean are[check(mt(6))].
*6 if bb then not cc.
*mt(6)if cc then not bb.
*test(mt(6))if cc and bb then check(mt(6)).
*boolean are[check(7)].
*boolean are[check(mt(7))].
*7 if not cc then ee.
*mt(7)if not ee then cc.
*test(mt(7))if not ee and not cc then check(mt(7)).
*boolean are[check(8)].
*boolean are[check(mt(8))].
*8 if not cc then ff.
*mt(8)if not ff then cc.
*test(mt(8))if not ff and not cc then check(mt(8)).

statement(1, 1 if aa then cc).
statement(2, 2 if cc then dd).
statement(3, 3 if dd then not gg).
statement(4, 4 if dd then not hh).
statement(5, 5 if dd then ii).
statement(6, 6 if bb then not cc).
statement(7, 7 if not cc then ee).
statement(8, 8 if not cc then ff).
