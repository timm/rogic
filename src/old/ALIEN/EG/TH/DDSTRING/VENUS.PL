:- [ops].

*boolean are oneOf=[t, f].
*authors are[groups=[1], persons=[tim='tim@menzies.com'], members=[1=[tim]]].
*boolean are[aa, bb, cc, dd, ff].
*author=1.
*boolean are[check(1)].
*boolean are[check(mt(1))].
*1 if aa then cc.
*mt(1)if not cc then not aa.
*test(mt(1))if not cc and aa then check(mt(1)).
*boolean are[check(2)].
*boolean are[check(mt(2))].
*2 if cc then not dd.
*mt(2)if dd then not cc.
*test(mt(2))if dd and cc then check(mt(2)).
*boolean are[check(3)].
*boolean are[check(mt(3))].
*3 if ff then dd.
*mt(3)if not dd then not ff.
*test(mt(3))if not dd and ff then check(mt(3)).
*boolean are[check(4)].
*boolean are[check(mt(4))].
*4 if dd then bb.
*mt(4)if not bb then not dd.
*test(mt(4))if not bb and dd then check(mt(4)).
*boolean are[check(5)].
*boolean are[check(mt(5))].
*5 if cc then bb.
*mt(5)if not bb then not cc.
*test(mt(5))if not bb and cc then check(mt(5)).

statement(1, 1 if aa then cc).
statement(2, 2 if cc then not dd).
statement(3, 3 if ff then dd).
statement(4, 4 if dd then bb).
statement(5, 5 if cc then bb).
