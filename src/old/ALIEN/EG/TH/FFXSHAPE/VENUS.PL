:- [ops].

*boolean are oneOf=[t, f].
*authors are[groups=[1], persons=[tim='tim@menzies.com'], members=[1=[tim]]].
*boolean are[aa, ll, bb, mm, nn, ii, jj, kk, cc, dd, ee, ff, gg, hh].
*author=1.
*boolean are[check(1)].
*1 if aa then bb.
*mt(1)if not bb then not aa.
*boolean are[check(2)].
*2 if mm then not bb.
*mt(2)if bb then not mm.
*boolean are[check(3)].
*3 if bb then ee.
*mt(3)if not ee then not bb.
*boolean are[check(4)].
*4 if bb then kk.
*mt(4)if not kk then not bb.
*boolean are[check(5)].
*5 if not bb then not hh.
*mt(5)if hh then bb.

statement(1, 1 if aa then bb).
statement(2, 2 if mm then not bb).
statement(3, 3 if bb then ee).
statement(4, 4 if bb then kk).
statement(5, 5 if not bb then not hh).
