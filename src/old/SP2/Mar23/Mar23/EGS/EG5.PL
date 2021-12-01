 known = [ a, b, c, d, e, f, g, h,
           i, j, k, l, m, n, o, p,
           q, r, s, t, u, v, w, x, y, z
         ].


if a and b then c.
if c and d then e.
if f       then g.
if g       then d.
if not d   then not b.
if not d   then not a.
if not b   then i.
if i       then j.

always([ a
       , b
       , f
       , bar_d
       ], [d]).