:- [ops].

rangeP(aa, t).
rangeP(aa, f).
rangeP(bb, t).
rangeP(bb, f).
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
rangeP(ii, t).
rangeP(ii, f).
rangeP(jj, t).
rangeP(jj, f).
rangeP(kk, t).
rangeP(kk, f).
rangeP(ll, t).
rangeP(ll, f).
rangeP(mm, t).
rangeP(mm, f).
rangeP(check(1), t).
rangeP(check(1), f).
rangeP(check(mt(1)), t).
rangeP(check(mt(1)), f).
rangeP(check(2), t).
rangeP(check(2), f).
rangeP(check(mt(2)), t).
rangeP(check(mt(2)), f).
rangeP(check(3), t).
rangeP(check(3), f).
rangeP(check(mt(3)), t).
rangeP(check(mt(3)), f).
rangeP(check(4), t).
rangeP(check(4), f).
rangeP(check(mt(4)), t).
rangeP(check(mt(4)), f).
rangeP(check(5), t).
rangeP(check(5), f).
rangeP(check(mt(5)), t).
rangeP(check(mt(5)), f).
rangeP(check(6), t).
rangeP(check(6), f).
rangeP(check(mt(6)), t).
rangeP(check(mt(6)), f).
rangeP(check(7), t).
rangeP(check(7), f).
rangeP(check(mt(7)), t).
rangeP(check(mt(7)), f).
rangeP(check(8), t).
rangeP(check(8), f).
rangeP(check(mt(8)), t).
rangeP(check(mt(8)), f).

oneOfP(boolean, [t, f]).

personP(tim, 'tim@menzies.com').

groupP(1).

personGroupP(1, tim).


object(aa).
object(bb).
object(cc).
object(dd).
object(ee).
object(ff).
object(gg).
object(hh).
object(ii).
object(jj).
object(kk).
object(ll).
object(mm).
object(check(1)).
object(check(mt(1))).
object(check(2)).
object(check(mt(2))).
object(check(3)).
object(check(mt(3))).
object(check(4)).
object(check(mt(4))).
object(check(5)).
object(check(mt(5))).
object(check(6)).
object(check(mt(6))).
object(check(7)).
object(check(mt(7))).
object(check(8)).
object(check(mt(8))).

statement(1, 1 if aa and bb then cc).
statement(2, 2 if dd and ee then ff).
statement(3, 3 if cc and ff then gg).
statement(4, 4 if aa and bb then not cc).
statement(5, 5 if ff then kk).
statement(6, 6 if not cc then hh).
statement(7, 7 if gg and kk then ll).
statement(8, 8 if mm then hh).

cc@t(1)=t :-
	{1, 1, 1},
	aa@t(1)=t,
	bb@t(1)=t.
aa@t(1)=f :-
	{1, mt(1), 1},
	cc@t(1)=f.
bb@t(1)=f :-
	{1, mt(1), 1},
	cc@t(1)=f.
check(mt(1))@t(1)=t :-
	{1, test(mt(1)), 1},
	cc@t(1)=f,
	aa@t(1)=t,
	bb@t(1)=t.
ff@t(1)=t :-
	{1, 2, 1},
	dd@t(1)=t,
	ee@t(1)=t.
dd@t(1)=f :-
	{1, mt(2), 1},
	ff@t(1)=f.
ee@t(1)=f :-
	{1, mt(2), 1},
	ff@t(1)=f.
check(mt(2))@t(1)=t :-
	{1, test(mt(2)), 1},
	ff@t(1)=f,
	dd@t(1)=t,
	ee@t(1)=t.
gg@t(1)=t :-
	{1, 3, 1},
	cc@t(1)=t,
	ff@t(1)=t.
cc@t(1)=f :-
	{1, mt(3), 1},
	gg@t(1)=f.
ff@t(1)=f :-
	{1, mt(3), 1},
	gg@t(1)=f.
check(mt(3))@t(1)=t :-
	{1, test(mt(3)), 1},
	gg@t(1)=f,
	cc@t(1)=t,
	ff@t(1)=t.
cc@t(1)=f :-
	{1, 4, 1},
	aa@t(1)=t,
	bb@t(1)=t.
aa@t(1)=f :-
	{1, mt(4), 1},
	cc@t(1)=t.
bb@t(1)=f :-
	{1, mt(4), 1},
	cc@t(1)=t.
check(mt(4))@t(1)=t :-
	{1, test(mt(4)), 1},
	cc@t(1)=t,
	aa@t(1)=t,
	bb@t(1)=t.
kk@t(1)=t :-
	{1, 5, 1},
	ff@t(1)=t.
ff@t(1)=f :-
	{1, mt(5), 1},
	kk@t(1)=f.
check(mt(5))@t(1)=t :-
	{1, test(mt(5)), 1},
	kk@t(1)=f,
	ff@t(1)=t.
hh@t(1)=t :-
	{1, 6, 1},
	cc@t(1)=f.
cc@t(1)=t :-
	{1, mt(6), 1},
	hh@t(1)=f.
check(mt(6))@t(1)=t :-
	{1, test(mt(6)), 1},
	hh@t(1)=f,
	cc@t(1)=f.
ll@t(1)=t :-
	{1, 7, 1},
	gg@t(1)=t,
	kk@t(1)=t.
gg@t(1)=f :-
	{1, mt(7), 1},
	ll@t(1)=f.
kk@t(1)=f :-
	{1, mt(7), 1},
	ll@t(1)=f.
check(mt(7))@t(1)=t :-
	{1, test(mt(7)), 1},
	ll@t(1)=f,
	gg@t(1)=t,
	kk@t(1)=t.
hh@t(1)=t :-
	{1, 8, 1},
	mm@t(1)=t.
mm@t(1)=f :-
	{1, mt(8), 1},
	hh@t(1)=f.
check(mt(8))@t(1)=t :-
	{1, test(mt(8)), 1},
	hh@t(1)=f,
	mm@t(1)=t.
