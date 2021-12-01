t=fact   + tables(aa,employee).
w=array  + wme(32).

w(init,W0,W) :-
	w(fresh,_,W0),
	W0 =.. [H|T0],
	maplist(empty,T0,T),
	W  =.. [H|T].

empty(_,[]).

yours=fact + your(cost,chances).

yours(zero) --> yours(cost <- 0), yours(chances <- 1).