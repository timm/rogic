count(0).
count(N0) :-
	N0 > 0,
	print(N0),nl,
	N is N0 - 1,
	count(N).

emp(tim,21,80).
emp(stan,30,80).

hi(X) :- print(X),nl.

healthy(Who) :-
	hi(1),
	emp(Who,Age,Weight),
	hi(2),
	AgeFactor is Age*3,
	AgeFactor > Weight.


female(amy).
                        female(johnette).
female(jill).
male(sam).                                                   
                        male(anthony).
                        male(bruce).
                        male(ogden).

                        parentof(amy,johnette).
                        parentof(amy,anthony).
                        parentof(amy,bruce).
                        parentof(ogden,johnette).
                        parentof(ogden,anthony).
                        parentof(ogden,bruce).
parentof(amy,tim).
parentof(tim,tony).
parentof(tony,sam).

parentof(sam,amy).
parentof(sam,ogden).
parentof(jill,sam).

anscestor(X,Y) :- parentof(X,Y).
anscestor(X,Y) :-
	parentof(A,X),
	anscestor(Y,A).


anc(X,[X,Y],Y) :- parentof(X,Y).
anc(X,[X|Rest],Y) :-
	parentof(X,Z),
	anc(Z,Rest,Y).

grandparent(X,Y) :-
	anc(X,[_,_,_],Y).



related(X,Path0,Path,Y) :-
	parentof(X,Z),
	\+ member(Z,Path0),
	related(Z,[X|Path0],Path,Y).
related(X,Path,[X,Y|Path],Y) :- parentof(X,Y).
