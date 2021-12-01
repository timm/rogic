 known = [ a, b, c, d, e, f, g, h,
           i, j, k, l, m, n, o, p,
           q, r, s, t, u, v, w, x, y, z
         ].


if a and b or h then c.
if not c or d   then e.
if not (e or f) then g.
if g            then e.
if i and not j  then not f or not k.
if not k        then g.
if g            then n.
if n            then f.
if m            then p.
if p            then not j.
if l            then j or k.


always([ a
       , b
       , h
       , i
       , l
       , m
       ], [g]).