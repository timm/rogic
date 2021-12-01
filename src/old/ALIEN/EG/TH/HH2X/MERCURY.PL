:- [ops].

rangeP(aa, t).
rangeP(aa, f).
rangeP(ll, t).
rangeP(ll, f).
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
rangeP(check(9), t).
rangeP(check(9), f).
rangeP(check(mt(9)), t).
rangeP(check(mt(9)), f).
rangeP(check(10), t).
rangeP(check(10), f).
rangeP(check(mt(10)), t).
rangeP(check(mt(10)), f).
rangeP(check(11), t).
rangeP(check(11), f).
rangeP(check(mt(11)), t).
rangeP(check(mt(11)), f).
rangeP(check(12), t).
rangeP(check(12), f).
rangeP(check(mt(12)), t).
rangeP(check(mt(12)), f).

oneOfP(boolean, [t, f]).

personP(tim, 'tim@menzies.com').

groupP(1).

personGroupP(1, tim).


object(aa).
object(ll).
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
object(check(9)).
object(check(mt(9))).
object(check(10)).
object(check(mt(10))).
object(check(11)).
object(check(mt(11))).
object(check(12)).
object(check(mt(12))).

statement(1, 1 if aa then cc).
statement(2, 2 if bb then not cc).
statement(3, 3 if not cc then not ee).
statement(4, 4 if not cc then not ff).
statement(5, 5 if cc then dd).
statement(6, 6 if dd then gg).
statement(7, 7 if dd then not ll).
statement(8, 8 if ii then not jj).
statement(9, 9 if hh then jj).
statement(10, 10 if jj then not kk).
statement(11, 11 if jj then gg).
statement(12, 12 if not jj then mm).

cc@t(1)=t :-
	{1, 1, 1},
	aa@t(1)=t.
aa@t(1)=f :-
	{1, mt(1), 1},
	cc@t(1)=f.
check(mt(1))@t(1)=t :-
	{1, test(mt(1)), 1},
	cc@t(1)=f,
	aa@t(1)=t.
cc@t(1)=f :-
	{1, 2, 1},
	bb@t(1)=t.
bb@t(1)=f :-
	{1, mt(2), 1},
	cc@t(1)=t.
check(mt(2))@t(1)=t :-
	{1, test(mt(2)), 1},
	cc@t(1)=t,
	bb@t(1)=t.
ee@t(1)=f :-
	{1, 3, 1},
	cc@t(1)=f.
cc@t(1)=t :-
	{1, mt(3), 1},
	ee@t(1)=t.
check(mt(3))@t(1)=t :-
	{1, test(mt(3)), 1},
	ee@t(1)=t,
	cc@t(1)=f.
ff@t(1)=f :-
	{1, 4, 1},
	cc@t(1)=f.
cc@t(1)=t :-
	{1, mt(4), 1},
	ff@t(1)=t.
check(mt(4))@t(1)=t :-
	{1, test(mt(4)), 1},
	ff@t(1)=t,
	cc@t(1)=f.
dd@t(1)=t :-
	{1, 5, 1},
	cc@t(1)=t.
cc@t(1)=f :-
	{1, mt(5), 1},
	dd@t(1)=f.
check(mt(5))@t(1)=t :-
	{1, test(mt(5)), 1},
	dd@t(1)=f,
	cc@t(1)=t.
gg@t(1)=t :-
	{1, 6, 1},
	dd@t(1)=t.
dd@t(1)=f :-
	{1, mt(6), 1},
	gg@t(1)=f.
check(mt(6))@t(1)=t :-
	{1, test(mt(6)), 1},
	gg@t(1)=f,
	dd@t(1)=t.
ll@t(1)=f :-
	{1, 7, 1},
	dd@t(1)=t.
dd@t(1)=f :-
	{1, mt(7), 1},
	ll@t(1)=t.
check(mt(7))@t(1)=t :-
	{1, test(mt(7)), 1},
	ll@t(1)=t,
	dd@t(1)=t.
jj@t(1)=f :-
	{1, 8, 1},
	ii@t(1)=t.
ii@t(1)=f :-
	{1, mt(8), 1},
	jj@t(1)=t.
check(mt(8))@t(1)=t :-
	{1, test(mt(8)), 1},
	jj@t(1)=t,
	ii@t(1)=t.
jj@t(1)=t :-
	{1, 9, 1},
	hh@t(1)=t.
hh@t(1)=f :-
	{1, mt(9), 1},
	jj@t(1)=f.
check(mt(9))@t(1)=t :-
	{1, test(mt(9)), 1},
	jj@t(1)=f,
	hh@t(1)=t.
kk@t(1)=f :-
	{1, 10, 1},
	jj@t(1)=t.
jj@t(1)=f :-
	{1, mt(10), 1},
	kk@t(1)=t.
check(mt(10))@t(1)=t :-
	{1, test(mt(10)), 1},
	kk@t(1)=t,
	jj@t(1)=t.
gg@t(1)=t :-
	{1, 11, 1},
	jj@t(1)=t.
jj@t(1)=f :-
	{1, mt(11), 1},
	gg@t(1)=f.
check(mt(11))@t(1)=t :-
	{1, test(mt(11)), 1},
	gg@t(1)=f,
	jj@t(1)=t.
mm@t(1)=t :-
	{1, 12, 1},
	jj@t(1)=f.
jj@t(1)=t :-
	{1, mt(12), 1},
	mm@t(1)=f.
check(mt(12))@t(1)=t :-
	{1, test(mt(12)), 1},
	mm@t(1)=f,
	jj@t(1)=f.
