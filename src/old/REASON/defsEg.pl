/*

=head1 Defs Examples */

 :- [defs].

 def(emp,[name,age,shoesize]).

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

 /* this example won't work- need ECGs
  eg2 -->
    in emp,
    the name=23,
    the age=0,
     the age+1,
     our fields=F,
     the age=Age,
     the name=Name,
     the shoesize=ShoeSize,
    {print(fields=F),nl,
    print(name=Name),nl,
    print(age=Age),nl,
    print(shoesize=ShoeSize),nl}.*/
