%=head2 Uses

  :- ensure_loaded([io,maths]).

%=head2 Operators

 :- op(750,xfx,in).
 :- op(750,xfx,from).
 :- op(749,xfx,by).
 :- op(748,xfx,to).


%=head2 Flags

%Define a C<rand>om function.

 :- arithmetic_function(rand/0).

%Define a C<rand(Min,Max)> function.

 :- arithmetic_function(rand/2).

%Define a C<rand(Min,Max,Mean)> function.

 :- arithmetic_function(rand/3).

%Define a C<normal> function.

 :- arithmetic_function(normal/2).

%Define a C<beta> function.

 :- arithmetic_function(beta/1).

%Define a C<gamma> function.

 :- arithmetic_function(gamma/2).
