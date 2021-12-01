:- [lurch0].

machine x=1.
machine y=1.
machine s=a.
machine cs=a.

machine a=1.
fun a(2), x(1)   :- a(1).
fun a(3), s(b)   :- a(2).
fun acs          :- y(0), a(3).
fun a(5), x(0)   :- acs.

machine b=1.
fun b(2),y(1)  :- b(1),y(1).
fun b(3),s(a)  :- b(2).
fun bcs        :- b(3).
fun bcs        :- b(3),s(b).
fun b(5) ,y(0) :- bcs.

machine all=ok.
fun all(bad) :- all(ok),acs,bcs.
