/*

=head1 Ecg2 Examples */

 :- [ecg2].

 names(emp,[name,age,shoesize]).

 eg(n(N)) :- eg(N,_,_).

 eg(1)  -->
    in emp              and
    the name=23         and
    the age=0           and
    the age+1           and
    our fields=F        and
    the age=Age         and
    the name=Name       and
    the shoesize=[left] and
    append(the shoesize,[right], the next shoesize) and
    print(fields=F)      and nl and
    print(ages=the age)  and nl and
    print(name=Name)     and nl and
    print(age=Age)       and nl and
    print(shoesize=the shoesize) and nl.
