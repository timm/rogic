/*

=head1 Defs Example

Some examples 

=head1 Header

=head2 Loads */

 :- [ecg].

 def(emp,[name,age,shoes]).

 eg(at3) :-
    at(in emp with 
       the name=tim with 
       the age=23 with 
       the shoes=20,_,X),
    print(X).

 eg(defs) --> 
    in emp,
    the name=tim,
    the age=23,
    the age + 1,
    the shoes=20.

 eg(defs) --> 
    in emp1,
    the name=tim,
    the age=23,
    the shoes=20,
    the shoes > 13,
    the age1=1.

 eg(oops) --> in emp, the shoes > 13, the age1=1, the crap < 12. 

 :- listing(eg).
