	
impacts(+,X,I) :-
	sumof(Y,X^Who^impact(X,Y,Who),I).

impacts(*,X,I) :-
	prodof(Y,X^Who^impact(X,Y,Who),I).
