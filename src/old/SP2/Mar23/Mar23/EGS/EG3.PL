 known = [ a, b, c, d, e, f, g, h,
           i, j, k, l, m, n, o, p,
           q, r, s, t, u, v, w, x, y, z
         ].


if not b   then d.
if c       then b.
%if f       then g.
%if g       then a.
if a and b then e.

always([ bar_b
       , a
       , c
       ], [e]).