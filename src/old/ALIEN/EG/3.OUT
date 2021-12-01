
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

oneOfP(boolean, [t, f]).
oneOfP(priors, [lots, some, none]).

personP(tim, 'tim@menzies.com').
personP(tom, 'tom@menzies.com').

groupP(prosecute).
groupP(defend).

personGroupP(prosecute, tim).
personGroupP(defend, tom).

numericP(age).

object(age).
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

statement(1, 1 if infant or moron then not legally_responsible).
statement(2, 2 if age>7 then infant).
statement(3, 3 if legally_responsible and guilty then jail).
statement(4, 4 if guilty then jail).
statement(5, 5 if motive and means and opportunity and witnesses then guilty).
statement(6, 6 if guilty and not legally_responsible then not jail).
statement(7, 7 if infant or moron then not legally_responsible).
statement(8, 8 if not convictions=lots then not guilty).
statement(9, 9 if infant or moron then not legally_responsible).

legally_responsible@t(1)=f :-
	{from(prosecute), id(1), cost(1)},
	infant@t(1)=t.
legally_responsible@t(1)=f :-
	{from(prosecute), id(1), cost(1)},
	moron@t(1)=t.
infant@t(1)=t :-
	{from(prosecute), id(2), cost(1)},
	age@t(1)>7.
jail@t(1)=t :-
	{from(prosecute), id(3), cost(1)},
	legally_responsible@t(1)=t,
	guilty@t(1)=t.
jail@t(1)=t :-
	{from(prosecute), id(4), cost(1)},
	guilty@t(1)=t.
guilty@t(1)=t :-
	{from(prosecute), id(5), cost(1)},
	motive@t(1)=t,
	means@t(1)=t,
	opportunity@t(1)=t,
	witnesses@t(1)=t.
jail@t(1)=f :-
	{from(defence), id(6), cost(1)},
	guilty@t(1)=t,
	legally_responsible@t(1)=f.
legally_responsible@t(1)=f :-
	{from(defence), id(7), cost(1)},
	infant@t(1)=t.
legally_responsible@t(1)=f :-
	{from(defence), id(7), cost(1)},
	moron@t(1)=t.
guilty@t(1)=f :-
	{from(defence), id(8), cost(1)},
	convictions@t(1)=some.
guilty@t(1)=f :-
	{from(defence), id(8), cost(1)},
	convictions@t(1)=none.
legally_responsible@t(1)=f :-
	{from(defence), id(9), cost(1)},
	infant@t(1)=t.
legally_responsible@t(1)=f :-
	{from(defence), id(9), cost(1)},
	moron@t(1)=t.
% time= 0.11 secs
