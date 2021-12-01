:- dynamic       option/2, bucket/3, blank/2,
	         fields/2, range/4,  h/3, incData/5.
:- multifile     option/2, blank/2,  fields/2, h/3.
:- discontiguous option/2, blank/2,  fields/2, h/3.

:- index(incData(1,1,1,1,0)).
:- index(h(1,1,1)).
:- index(bucket(1,1,1)).
:- index(range(1,1,1,1,0,0)).

:- arithmetic_function(o1/0).
:- arithmetic_function(rand/2).
