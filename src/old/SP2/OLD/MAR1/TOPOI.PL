% known = [flexibility, usability, performance, maintainability].
%
% flexibility if not usability.
% flexibility if not performance.
% maintainability if flexibility.

% known = [ age_lessThen_7
%         , infant
% 	, legally_responsible
%	, moron
%	, motives
%	, means
%	, opportunity
%	, witness
%	, guilty
%	, jail].
%
%if infant or moron                               then not legally_responsible.
%if guilty                                        then jail.
%if age_lessThen_7                                then infant.
%if motives and means and opportunity and witness then guilty.
%if guilty and not legally_responsible            then not jail.
%
% ***** if legally_responsible and guilty                then jail.

known = [a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z].
%if a or b      then c.
%if not b and d then e.
if c           then not e.
%if not (i and j) and not k then x and y.
%if h and i and j then z.

if a and b then d.
if a and b then e.
%if a and b then d.
%if a and b then e.
