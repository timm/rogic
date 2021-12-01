:- [ops].

*boolean are oneOf=[t, f].
*authors are[groups=[1], persons=[tim='tim@menzies.com'], members=[1=[tim]]].
*boolean are[a, b, l, k, m, n, o].
*author=1.
*boolean are[check(22)].
*boolean are[check(mt(22))].
*22 if not a then m.
*22 if not a then o.
*22 if not a then not n.
*22 if not b then m.
*22 if not b then o.
*22 if not b then not n.
*22 if not k then m.
*22 if not k then o.
*22 if not k then not n.
*22 if not l then m.
*22 if not l then o.
*22 if not l then not n.
*mt(22)if n then a.
*mt(22)if n then b.
*mt(22)if n then k.
*mt(22)if n then l.
*mt(22)if not m then a.
*mt(22)if not m then b.
*mt(22)if not m then k.
*mt(22)if not m then l.
*mt(22)if not o then a.
*mt(22)if not o then b.
*mt(22)if not o then k.
*mt(22)if not o then l.
*test(22)if not a and n then check(22).
*test(22)if not a and not m then check(22).
*test(22)if not b and n then check(22).
*test(22)if not b and not m then check(22).
*test(22)if not k and n then check(22).
*test(22)if not k and not m then check(22).
*test(22)if not l and n then check(22).
*test(22)if not l and not m then check(22).
*test(mt(22))if n and not a then check(mt(22)).
*test(mt(22))if n and not b then check(mt(22)).
*test(mt(22))if n and not k then check(mt(22)).
*test(mt(22))if n and not l then check(mt(22)).
*test(mt(22))if not m and not a then check(mt(22)).
*test(mt(22))if not m and not b then check(mt(22)).
*test(mt(22))if not m and not k then check(mt(22)).
*test(mt(22))if not m and not l then check(mt(22)).
*test(mt(22))if not o and not a then check(mt(22)).
*test(mt(22))if not o and not b then check(mt(22)).
*test(mt(22))if not o and not k then check(mt(22)).
*test(mt(22))if not o and not l then check(mt(22)).

statement(22, 22 if not (a and b)or not (l and k)then m and not n or o).
