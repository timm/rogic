term_expansion((macro(X) :- Y),All) :-
	findall(X,Y,All).

:- dynamic loud/0.

loud.

shout :- loud -> true ; assert(loud).

ssh :- ignore(retract(loud)).

t(nl) :- !, (loud -> nl ; true).
t(X)  :- loud -> write(X),write('.'),nl; true.

portray(- X) :- is_list(X), forall(member(Y,X),(print(Y),nl)).

twoMembers([One|T],One,Two) :-
	member(Two,T).
twoMembers([_|T],One,Two) :-
	twoMembers(T,One,Two).


memberA((X,Y),Z) :- !, (Z=X;memberA(Y,Z)).
memberA(X,X).

runtime(X) :- 
	runtime(X,1,_).

runtime(X,N,T) :-
	T1 is cputime,
	forall(between(1,N,_),X),
	T2 is cputime, T is  (T2-T1)/N, 
	t(nl), 
	t(runtime(T)).

inc(X,V) :-
	flag(X,V,V+1),
	(0 is V mod 10 -> write(X/V),nl ; true).

isOption(thrashes).
isOption(fiddles).
isOption(forgets).
isOption(watch).
isOption(trust).
isOption(even).
isOption(model).

option(X,Y) :- isOption(X), flag(X,Z,Z),!,Y=Z.
option(X,_) :- print(badOption(X)),nl,fail.
