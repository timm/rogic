 known = [ a, b, c, d, e, f, g, h,
           i, j, k, l, m, n, o, p,
           q, r, s, t, u, v, w, x, y, z
         ].


if a and b then c.
if d       then b.
if c       then not d.


io=
[ always([a, b], [-d])
, always([-a, -b], [-d])
, always([a, d], [-d])
].

