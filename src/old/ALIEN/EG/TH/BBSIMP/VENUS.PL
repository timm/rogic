:- [ops].

*boolean are oneOf=[t, f].
*authors are[groups=[1], persons=[tim='tim@menzies.com'], members=[1=[tim]]].
*boolean are[aa, bb, cc, dd].
*author=1.
*boolean are[check(1)].
*1 if aa then cc.
*mt(1)if not cc then not aa.
*boolean are[check(2)].
*2 if cc then dd.
*mt(2)if not dd then not cc.
*boolean are[check(3)].
*3 if dd then bb.
*mt(3)if not bb then not dd.
*boolean are[check(4)].
*4 if dd then bb.
*mt(4)if not bb then not dd.
*boolean are[check(5)].
*5 if dd then cc.
*mt(5)if not cc then not dd.

statement(1, 1 if aa then cc).
statement(2, 2 if cc then dd).
statement(3, 3 if dd then bb).
statement(4, 4 if dd then bb).
statement(5, 5 if dd then cc).
