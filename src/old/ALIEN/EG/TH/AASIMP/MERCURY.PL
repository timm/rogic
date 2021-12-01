:- [ops].

rangeP(aa, t).
rangeP(aa, f).
rangeP(bb, t).
rangeP(bb, f).
rangeP(check(1), t).
rangeP(check(1), f).

oneOfP(boolean, [t, f]).

personP(tim, 'tim@menzies.com').

groupP(1).

personGroupP(1, tim).


object(aa).
object(bb).
object(check(1)).

statement(1, 1 if aa then bb).

bb@t(1)=t :-
	{1, 1, 1},
	aa@t(1)=t.
aa@t(1)=f :-
	{1, mt(1), 1},
	bb@t(1)=f.
