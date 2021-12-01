/*

=head1 Defs Example

=head1 Header

=head2 Loads

 :- ensure_loaded(defs) */


 def(emp,[name,age,shoeSize]).

 eg(at3) :-
    at(in emp with 
       the name=tim with 
       the age=23 with 
       the shoeSize=20,_,X),
    print(X).

 eg(defs) --> 
    in emp,
    the name=tim,
    the age=23,
    the age+1,
    the shoeSize=20.
