:- [ops].

rangeP(a, t).
rangeP(a, f).
rangeP(b, t).
rangeP(b, f).
rangeP(l, t).
rangeP(l, f).
rangeP(k, t).
rangeP(k, f).
rangeP(m, t).
rangeP(m, f).
rangeP(n, t).
rangeP(n, f).
rangeP(o, t).
rangeP(o, f).
rangeP(check(22), t).
rangeP(check(22), f).
rangeP(check(mt(22)), t).
rangeP(check(mt(22)), f).

oneOfP(boolean, [t, f]).

personP(tim, 'tim@menzies.com').

groupP(1).

personGroupP(1, tim).


object(a).
object(b).
object(l).
object(k).
object(m).
object(n).
object(o).
object(check(22)).
object(check(mt(22))).

statement(22, 22 if not (a and b)or not (l and k)then m and not n or o).

m@t(1)=t :-
	{1, 22, 1},
	a@t(1)=f.
o@t(1)=t :-
	{1, 22, 1},
	a@t(1)=f.
n@t(1)=f :-
	{1, 22, 1},
	a@t(1)=f.
m@t(1)=t :-
	{1, 22, 1},
	b@t(1)=f.
o@t(1)=t :-
	{1, 22, 1},
	b@t(1)=f.
n@t(1)=f :-
	{1, 22, 1},
	b@t(1)=f.
m@t(1)=t :-
	{1, 22, 1},
	k@t(1)=f.
o@t(1)=t :-
	{1, 22, 1},
	k@t(1)=f.
n@t(1)=f :-
	{1, 22, 1},
	k@t(1)=f.
m@t(1)=t :-
	{1, 22, 1},
	l@t(1)=f.
o@t(1)=t :-
	{1, 22, 1},
	l@t(1)=f.
n@t(1)=f :-
	{1, 22, 1},
	l@t(1)=f.
a@t(1)=t :-
	{1, mt(22), 1},
	n@t(1)=t.
b@t(1)=t :-
	{1, mt(22), 1},
	n@t(1)=t.
k@t(1)=t :-
	{1, mt(22), 1},
	n@t(1)=t.
l@t(1)=t :-
	{1, mt(22), 1},
	n@t(1)=t.
a@t(1)=t :-
	{1, mt(22), 1},
	m@t(1)=f.
b@t(1)=t :-
	{1, mt(22), 1},
	m@t(1)=f.
k@t(1)=t :-
	{1, mt(22), 1},
	m@t(1)=f.
l@t(1)=t :-
	{1, mt(22), 1},
	m@t(1)=f.
a@t(1)=t :-
	{1, mt(22), 1},
	o@t(1)=f.
b@t(1)=t :-
	{1, mt(22), 1},
	o@t(1)=f.
k@t(1)=t :-
	{1, mt(22), 1},
	o@t(1)=f.
l@t(1)=t :-
	{1, mt(22), 1},
	o@t(1)=f.
check(22)@t(1)=t :-
	{1, test(22), 1},
	a@t(1)=f,
	n@t(1)=t.
check(22)@t(1)=t :-
	{1, test(22), 1},
	a@t(1)=f,
	m@t(1)=f.
check(22)@t(1)=t :-
	{1, test(22), 1},
	b@t(1)=f,
	n@t(1)=t.
check(22)@t(1)=t :-
	{1, test(22), 1},
	b@t(1)=f,
	m@t(1)=f.
check(22)@t(1)=t :-
	{1, test(22), 1},
	k@t(1)=f,
	n@t(1)=t.
check(22)@t(1)=t :-
	{1, test(22), 1},
	k@t(1)=f,
	m@t(1)=f.
check(22)@t(1)=t :-
	{1, test(22), 1},
	l@t(1)=f,
	n@t(1)=t.
check(22)@t(1)=t :-
	{1, test(22), 1},
	l@t(1)=f,
	m@t(1)=f.
check(mt(22))@t(1)=t :-
	{1, test(mt(22)), 1},
	n@t(1)=t,
	a@t(1)=f.
check(mt(22))@t(1)=t :-
	{1, test(mt(22)), 1},
	n@t(1)=t,
	b@t(1)=f.
check(mt(22))@t(1)=t :-
	{1, test(mt(22)), 1},
	n@t(1)=t,
	k@t(1)=f.
check(mt(22))@t(1)=t :-
	{1, test(mt(22)), 1},
	n@t(1)=t,
	l@t(1)=f.
check(mt(22))@t(1)=t :-
	{1, test(mt(22)), 1},
	m@t(1)=f,
	a@t(1)=f.
check(mt(22))@t(1)=t :-
	{1, test(mt(22)), 1},
	m@t(1)=f,
	b@t(1)=f.
check(mt(22))@t(1)=t :-
	{1, test(mt(22)), 1},
	m@t(1)=f,
	k@t(1)=f.
check(mt(22))@t(1)=t :-
	{1, test(mt(22)), 1},
	m@t(1)=f,
	l@t(1)=f.
check(mt(22))@t(1)=t :-
	{1, test(mt(22)), 1},
	o@t(1)=f,
	a@t(1)=f.
check(mt(22))@t(1)=t :-
	{1, test(mt(22)), 1},
	o@t(1)=f,
	b@t(1)=f.
check(mt(22))@t(1)=t :-
	{1, test(mt(22)), 1},
	o@t(1)=f,
	k@t(1)=f.
check(mt(22))@t(1)=t :-
	{1, test(mt(22)), 1},
	o@t(1)=f,
	l@t(1)=f.
