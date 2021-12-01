?cc =X --> ?aa = X ror ?bb \= X.
?dd =X --> ?cc = X.
?ee =X --> ?cc = X.
?ff =X --> ?cc = X.
?gg =X --> ?zz = X.
?hh =X --> ?dd = X.
?ii =X --> ?dd = X.
?zz =X --> ?dd = X.

b/B :- 
	go([aa = 1,bb = 1],[hh = 1, ii = -1, ee = 1,ff = -1, gg = 1],B).