 egThe :- listing(things).
 egOne :- listing(thing).

 egFresh :- listing(fresh).

 :- employees.

 eg1 ?--
	C=employee,
	touch(my one=C with a name=N with an age=A),
	print(C=N/A),nl.
 eg2 :-
	C=employee,
	touch(my one=C with a name=Name with an age=Age),
	Name \= Age.
 eg3 ?-
	C=employee,
	touch(my one=C with a name=Name with an age=Age),
	Name \= Age.
 eg4 ?--
	C=employee,
	touch(my one=C with a name=Name with an age=Age),
	Name \= Age.
 eg5 :-
	employees,
	R=100000,
	runtime(R,eg2,T1),
	runtime(R,eg3,T2),
	runtime(R,eg4,T3),
	Com1 is T2/T1*100,
	Com2 is T3/T1*100,
        format('t1=~p (=100%)\nt2=~p (=~1f%)\nt3=~p (=~1f%)\n',
	        [T1,T2,Com1,T3,Com2]).

 eg6 ?-
	touch(my one=employee with a  names=Name
                              with an ages=Age),
	Name \= Age.

 eg7 ?- touch(my one=employee with a F=V),
	print(F=V),nl,fail.
 eg7.
 
 