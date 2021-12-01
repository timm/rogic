:- [ops].

*boolean are oneOf=[t, f].
*priors are oneOf=[lots, some, none].
*authors are[groups=[prosecute, defend], persons=[tim='tim@menzies.com', tom='tom@menzies.com'], members=[prosecute=[tim], defend=[tom]]].
*numeric are[age, wieght, shoeSize].
*priors are[convictions].
*boolean are[guilty, infant, jail, legally_responsible, means, moron, motive, opportunity, witnesses].
*author=prosecute.
*boolean are[check(1)].
*boolean are[check(mt(1))].
*1 if moron then weight is 23.
*1 if moron then not legally_responsible.
*1 if wieght>12 and infant then weight is 23.
*1 if wieght>12 and infant then not legally_responsible.
*mt(1)if legally_responsible then not infant.
*mt(1)if legally_responsible then not moron.
*mt(1)if legally_responsible then not wieght>12.
*mt(1)if not weight is 23 then not infant.
*mt(1)if not weight is 23 then not moron.
*mt(1)if not weight is 23 then not wieght>12.
*test(1)if moron and legally_responsible then check(1).
*test(1)if moron and not weight is 23 then check(1).
*test(1)if (wieght>12 and infant)and legally_responsible then check(1).
*test(1)if (wieght>12 and infant)and not weight is 23 then check(1).
*test(mt(1))if legally_responsible and moron then check(mt(1)).
*test(mt(1))if legally_responsible and wieght>12 and infant then check(mt(1)).
*test(mt(1))if not weight is 23 and moron then check(mt(1)).
*test(mt(1))if not weight is 23 and wieght>12 and infant then check(mt(1)).
*boolean are[check(2)].
*boolean are[check(mt(2))].
*2 if age<12 then infant.
*2 if age>7 then infant.
*mt(2)if not infant then not age<12.
*mt(2)if not infant then not age>7.
*test(mt(2))if not infant and age<12 then check(mt(2)).
*test(mt(2))if not infant and age>7 then check(mt(2)).
*boolean are[check(3)].
*boolean are[check(mt(3))].
*3 if shoeSize<100 then shoeSize is 20.
*3 if shoeSize>23 then shoeSize is 20.
*mt(3)if not shoeSize is 20 then not shoeSize<100.
*mt(3)if not shoeSize is 20 then not shoeSize>23.
*test(mt(3))if not shoeSize is 20 and shoeSize<100 then check(mt(3)).
*test(mt(3))if not shoeSize is 20 and shoeSize>23 then check(mt(3)).

statement(1, 1 if wieght>12 and infant or moron then weight is 23 and not legally_responsible).
statement(2, 2 if age>7 or age<12 then infant).
statement(3, 3 if shoeSize>23 or shoeSize<100 then shoeSize is 20).
