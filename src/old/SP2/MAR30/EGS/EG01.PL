 known = [ a, b, c, d, e, f, g, h,
           i, j, k, l, m, n, o, p,
           q, r, s, t, u, v, w, x, y, z
         ].


if a then b.
if b then c.

io=
[ always([a], [b])
, always([b], [c])
, always([a], [c])
, always([-a], [-c])
, always([a, -b], [c])
].