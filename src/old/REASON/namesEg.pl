/*

=head1 Names Examples */

 :- [names].

 names(emp,[name,age,shoesize]).

 eg(1) :-
    at(in emp with the name=23 
              with the age=0 
              with `the next age is the age+100
              with our fields=F
              with `append(the shoesize,[a,b],the next shoesize)
              with `append(the shoesize,[c,d],the next shoesize)
              with the age=Age
              with the name=Name
              with the shoesize=ShoeSize),
    print(fields=F),nl,
    print(name=Name),nl,
    print(age=Age),nl,
    print(shoesize=ShoeSize),nl.

 eg(2) :-
    at(in emp with our size1=F),
    print(size=F),nl.


 eg(n(N)) :- eg(N,_,_).


 eg(4) means
    in emp              and
    the name=23         and
    the age=0           and
    the age+1           and
    our fields=F        and
    the age=Age         and 
    the name=Name       and 
    the shoesize=[left] and 
    `append(the shoesize,[right], the next shoesize) and
    print(fields=F)      and nl and
    `print(ages=the age) and nl and
    print(name=Name)     and nl and
    print(age=Age)       and nl and
    `print(shoesize=the shoesize) and nl.
