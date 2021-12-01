
 a1(X) ?- true;true,b,true,v,true; X=1;X=2.
 a2    ?- true;b;true.
 a3(X) ?-- a,b,c,X=1,true.

 employees :-
	reset,
	employee has [+name,age=0,shoeSize],
	new employee with a name:=tim  with an age:=23
                     with a shoeSize:=12,
        new employee with a name:=jane with an age:=24
                     with a shoeSize:=13.

 :- employees.
