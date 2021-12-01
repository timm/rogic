:- [ops].

*boolean are oneOf=[t, f].
*authors are[groups=[1], persons=[tim='tim@menzies.com'], members=[1=[tim]]].
*boolean are[aa, bb, cc, dd].
*author=1.
*boolean are[check(1)].
*boolean are[check(mt(1))].
*1 if aa and bb then cc.
*1 if aa and bb then dd.
*mt(1)if not cc then not aa.
*mt(1)if not cc then not bb.
*mt(1)if not dd then not aa.
*mt(1)if not dd then not bb.
*test(1)if (aa and bb)and not cc then check(1).
*test(1)if (aa and bb)and not dd then check(1).
*test(mt(1))if not cc and aa and bb then check(mt(1)).
*test(mt(1))if not dd and aa and bb then check(mt(1)).

statement(1, 1 if aa and bb then cc and dd).
