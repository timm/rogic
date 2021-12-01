% requires superis

db(emp(name,age,shoesize,weight)).

% X-Y creates Y(Z) where Z is of type X
emp-show :-
	write(emp/?name).
% X=Y creates Y(Zin,Zout) where the Zs are of
%                         type X
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
	append([1,?shoesize,?age,age,location],[?weight],Y),
	length(Y,_).

/* internally becomes

hello(emp(A, B, C, D), emp(E, F, G, H)) :-
        I is C+D+1,
        J is I*I*3,
        K is 2*J,
        K is D,
        freddo(M, 23, k, emp(A, J, C, D), emp(E, F, G, H)),
        append([1, G, F, location], [H], N),
        length(N, O).

*/

:- listing(hello).
