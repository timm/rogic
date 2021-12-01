mine=[nna,coldSwim,cortico,temp,dex,acth].

?nna = X     if ?coldSwim = X ror ?temp \= X.
?cortico = X if ?acth = X.
?temp = X    if ?cortico = X ror ?dex = X.
?acth = X    if ?temp \= X   ror ?nna = X.


b/B :- go([coldSwim= 1],[nna=1,acth= 1, cortico= 1],B,_).

