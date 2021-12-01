:- [ops].

rangeP(aa, t).
rangeP(aa, f).
rangeP(ll, t).
rangeP(ll, f).
rangeP(bb, t).
rangeP(bb, f).
rangeP(mm, t).
rangeP(mm, f).
rangeP(nn, t).
rangeP(nn, f).
rangeP(ii, t).
rangeP(ii, f).
rangeP(jj, t).
rangeP(jj, f).
rangeP(kk, t).
rangeP(kk, f).
rangeP(cc, t).
rangeP(cc, f).
rangeP(dd, t).
rangeP(dd, f).
rangeP(ee, t).
rangeP(ee, f).
rangeP(ff, t).
rangeP(ff, f).
rangeP(gg, t).
rangeP(gg, f).
rangeP(hh, t).
rangeP(hh, f).
rangeP(check(1), t).
rangeP(check(1), f).
rangeP(check(2), t).
rangeP(check(2), f).
rangeP(check(3), t).
rangeP(check(3), f).
rangeP(check(4), t).
rangeP(check(4), f).
rangeP(check(5), t).
rangeP(check(5), f).

oneOfP(boolean, [t, f]).

personP(tim, 'tim@menzies.com').

groupP(1).

personGroupP(1, tim).


object(aa).
object(ll).
object(bb).
object(mm).
object(nn).
object(ii).
object(jj).
object(kk).
object(cc).
object(dd).
object(ee).
object(ff).
object(gg).
object(hh).
object(check(1)).
object(check(2)).
object(check(3)).
object(check(4)).
object(check(5)).

statement(1, 1 if aa then bb).
statement(2, 2 if mm then not bb).
statement(3, 3 if bb then ee).
statement(4, 4 if bb then kk).
statement(5, 5 if not bb then not hh).

bb@t(1)=t :-
	{1, 1, 1},
	aa@t(1)=t.
aa@t(1)=f :-
	{1, mt(1), 1},
	bb@t(1)=f.
bb@t(1)=f :-
	{1, 2, 1},
	mm@t(1)=t.
mm@t(1)=f :-
	{1, mt(2), 1},
	bb@t(1)=t.
ee@t(1)=t :-
	{1, 3, 1},
	bb@t(1)=t.
bb@t(1)=f :-
	{1, mt(3), 1},
	ee@t(1)=f.
kk@t(1)=t :-
	{1, 4, 1},
	bb@t(1)=t.
bb@t(1)=f :-
	{1, mt(4), 1},
	kk@t(1)=f.
hh@t(1)=f :-
	{1, 5, 1},
	bb@t(1)=f.
bb@t(1)=t :-
	{1, mt(5), 1},
	hh@t(1)=t.
