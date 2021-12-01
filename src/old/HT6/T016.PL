?nna = X     --> ?coldSwim = X ror ?temp \= X.
?cortico = X --> ?acth = X.
?temp = X    --> ?cortico = X ror ?dex = X.
?acth = X    --> ?temp \= X   ror ?nna = X.

b/B :- go([coldSwim= 1],[nna=1,acth= 1, cortico= 1],B).

