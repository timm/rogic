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
object(bb).
object(cc).
object(dd).
object(check(1)).
object(check(2)).
object(check(3)).
object(check(4)).
object(check(5)).

statement(1, 1 if aa then cc).
statement(2, 2 if cc then dd).
statement(3, 3 if dd then bb).
statement(4, 4 if dd then bb).
statement(5, 5 if dd then cc).

cc@t(1)=t :-
	{1, 1, 1},
	aa@t(1)=t.
aa@t(1)=f :-
	{1, mt(1), 1},
	cc@t(1)=f.
dd@t(1)=t :-
	{1, 2, 1},
	cc@t(1)=t.
cc@t(1)=f :-
	{1, mt(2), 1},
	dd@t(1)=f.
bb@t(1)=t :-
	{1, 3, 1},
	dd@t(1)=t.
dd@t(1)=f :-
	{1, mt(3), 1},
	bb@t(1)=f.
bb@t(1)=t :-
	{1, 4, 1},
	dd@t(1)=t.
dd@t(1)=f :-
	{1, mt(4), 1},
	bb@t(1)=f.
cc@t(1)=t :-
	{1, 5, 1},
	dd@t(1)=t.
dd@t(1)=f :-
	{1, mt(5), 1},
	cc@t(1)=f.
