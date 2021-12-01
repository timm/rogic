newBag(N,bag(N,0,[])).

add2bag(K=V,bag(N,0,[]),bag(N,1,[K=V])).
add2bag(K=V,bag(N,S,  [Lest=V|L ]), bag(N,S,[Lest=V|L])) :- K < Lest.
add2bag(K=V,bag(N,S0, [Lest=V|L0]), bag(N,S,L)) :- 
  K >= Lest, 
  S0 < N,
  S is S0 + 1,
  add2bag1([Lest=V|L0],K=V,L).
add2bag(K=V,bag(N,S0, [Lest=V|L0]), bag(N,S,L)) :- 
  K >= Lest, 
  S0 = N,
  S is S0,
  add2bag1(L0,K=V,L).


add2bag1([],X,[X]).
add2bag1([K0=V0|L0],K=V,[K0=V0|Rest]) :- K > K0, add2bag1(L0,K=V,Rest).
add2bag1([K0=V0|L0],K=V,[K=V,K0=V0|L0]):- K =< K0.

tests(N) :-
	newBag(20,B0),
	tests(N,B0,B),
	print(B),nl.

tests(0,B,B).
tests(N,B0,B) :-
	N > 0,
	N1 is N - 1,
	K is random(100),
	add2bag(K=aa,B0,B1),
	tests(N1,B1,B).

