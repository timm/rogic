 :- reset.
 :- stats has [sum=0,sumSquared=0,n=0].

 stats(L,S) :- fresh0(stats,S0), stats(L,S0,S).
 stats([],S,S).
 stats([H|T]) ?-->
	touch(a n+1 with a sum+H with a sumSquared+H*H),
	stats(T).

 egStats :- stats([1,2,3],S),write(S),nl.