db(emp(name,age,shoesize,weight)).

emp=hello:-
	!age is ?shoesize + ?weight + 1,
	!age is ?age  * ?age * 3,
	X   is 2 * ?age,
        X   is  ?weight,
	(l->  -a %freddo(_,23,k)
        ;   10 is ?shoesize + 2 ),%      -johno(X)),
	(l1->  -a1 %freddo(_,23,k)
        ;   -k1 ),%      -johno(X)),
	?age > ?weight,
	append([1,?shoesize,?age,age,?location],[?weight],Y),
	length(Y,_).


