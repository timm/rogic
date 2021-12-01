:- [ops].

rangeP(aa, t).
rangeP(aa, f).
rangeP(bb, t).
rangeP(bb, f).
rangeP(cc, t).
rangeP(cc, f).
rangeP(dd, t).
rangeP(dd, f).
rangeP(check(1), t).
rangeP(check(1), f).
rangeP(check(mt(1)), t).
rangeP(check(mt(1)), f).

oneOfP(boolean, [t, f]).

personP(tim, 'tim@menzies.com').

groupP(1).

personGroupP(1, tim).


object(aa).
object(bb).
object(cc).
object(dd).
object(check(1)).
object(check(mt(1))).

statement(1, 1 if aa and bb then cc and dd).

cc@t(1)=t :-
	{1, 1, 1},
	aa@t(1)=t,
	bb@t(1)=t.
dd@t(1)=t :-
	{1, 1, 1},
	aa@t(1)=t,
	bb@t(1)=t.
aa@t(1)=f :-
	{1, mt(1), 1},
	cc@t(1)=f.
bb@t(1)=f :-
	{1, mt(1), 1},
	cc@t(1)=f.
aa@t(1)=f :-
	{1, mt(1), 1},
	dd@t(1)=f.
bb@t(1)=f :-
	{1, mt(1), 1},
	dd@t(1)=f.
check(1)@t(1)=t :-
	{1, test(1), 1},
	aa@t(1)=t,
	bb@t(1)=t,
	cc@t(1)=f.
check(1)@t(1)=t :-
	{1, test(1), 1},
	aa@t(1)=t,
	bb@t(1)=t,
	dd@t(1)=f.
check(mt(1))@t(1)=t :-
	{1, test(mt(1)), 1},
	cc@t(1)=f,
	aa@t(1)=t,
	bb@t(1)=t.
check(mt(1))@t(1)=t :-
	{1, test(mt(1)), 1},
	dd@t(1)=f,
	aa@t(1)=t,
	bb@t(1)=t.
