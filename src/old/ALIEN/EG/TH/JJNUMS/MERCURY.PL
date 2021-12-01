:- [ops].

rangeP(convictions, lots).
rangeP(convictions, some).
rangeP(convictions, none).
rangeP(guilty, t).
rangeP(guilty, f).
rangeP(infant, t).
rangeP(infant, f).
rangeP(jail, t).
rangeP(jail, f).
rangeP(legally_responsible, t).
rangeP(legally_responsible, f).
rangeP(means, t).
rangeP(means, f).
rangeP(moron, t).
rangeP(moron, f).
rangeP(motive, t).
rangeP(motive, f).
rangeP(opportunity, t).
rangeP(opportunity, f).
rangeP(witnesses, t).
rangeP(witnesses, f).
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

oneOfP(boolean, [t, f]).
oneOfP(priors, [lots, some, none]).

personP(tim, 'tim@menzies.com').
personP(tom, 'tom@menzies.com').

groupP(prosecute).
groupP(defend).

personGroupP(prosecute, tim).
personGroupP(defend, tom).

numericP(age).
numericP(wieght).
numericP(shoeSize).


object(age).
object(wieght).
object(shoeSize).
object(convictions).
object(guilty).
object(infant).
object(jail).
object(legally_responsible).
object(means).
object(moron).
object(motive).
object(opportunity).
object(witnesses).
object(check(1)).
object(check(mt(1))).
object(check(2)).
object(check(mt(2))).
object(check(3)).
object(check(mt(3))).

statement(1, 1 if wieght>12 and infant or moron then weight is 23 and not legally_responsible).
statement(2, 2 if age>7 or age<12 then infant).
statement(3, 3 if shoeSize>23 or shoeSize<100 then shoeSize is 20).

legally_responsible@t(1)=f :-
	{prosecute, 1, 1},
	moron@t(1)=t.
legally_responsible@t(1)=f :-
	{prosecute, 1, 1},
	wieght@t(1)>12,
	infant@t(1)=t.
infant@t(1)=f :-
	{prosecute, mt(1), 1},
	legally_responsible@t(1)=t.
moron@t(1)=f :-
	{prosecute, mt(1), 1},
	legally_responsible@t(1)=t.
check(1)@t(1)=t :-
	{prosecute, test(1), 1},
	moron@t(1)=t,
	legally_responsible@t(1)=t.
check(1)@t(1)=t :-
	{prosecute, test(1), 1},
	wieght@t(1)>12,
	infant@t(1)=t,
	legally_responsible@t(1)=t.
check(mt(1))@t(1)=t :-
	{prosecute, test(mt(1)), 1},
	legally_responsible@t(1)=t,
	moron@t(1)=t.
check(mt(1))@t(1)=t :-
	{prosecute, test(mt(1)), 1},
	legally_responsible@t(1)=t,
	wieght@t(1)>12,
	infant@t(1)=t.
infant@t(1)=t :-
	{prosecute, 2, 1},
	age@t(1)<12.
infant@t(1)=t :-
	{prosecute, 2, 1},
	age@t(1)>7.
check(mt(2))@t(1)=t :-
	{prosecute, test(mt(2)), 1},
	infant@t(1)=f,
	age@t(1)<12.
check(mt(2))@t(1)=t :-
	{prosecute, test(mt(2)), 1},
	infant@t(1)=f,
	age@t(1)>7.
check(mt(3))@t(1)=t :-
	{prosecute, test(mt(3)), 1},
	shoeSize@t(1)<20,
	shoeSize@t(1)<100.
check(mt(3))@t(1)=t :-
	{prosecute, test(mt(3)), 1},
	shoeSize@t(1)>20,
	shoeSize@t(1)<100.
check(mt(3))@t(1)=t :-
	{prosecute, test(mt(3)), 1},
	shoeSize@t(1)<20,
	shoeSize@t(1)>23.
check(mt(3))@t(1)=t :-
	{prosecute, test(mt(3)), 1},
	shoeSize@t(1)>20,
	shoeSize@t(1)>23.
