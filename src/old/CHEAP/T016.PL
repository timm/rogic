?nna = X     --> ?coldSwim = X ror ?temp \= X.
?cortico = X --> ?acth = X.
?temp = X    --> ?cortico = X ror ?dex = X.
?acth = X    --> ?temp \= X   ror ?nna = X.

/*demo(W) :-
	go([coldSwim=1]
          ,[?nna=1,?cortico=1,?acth=1,?temp= -1]
          ,W).
*/	
demo(W) :-
	go([coldSwim= 1]
          ,[?nna=1,?cortico=1,?acth=1]
          ,W).

demo(W) :-
	go([coldSwim= 1]
          ,[?nna=1]
          ,W).
