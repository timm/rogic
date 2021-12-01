mine=[aa,bb,cc,dd,ee,ff,gg,hh,ii,zz].

?cc =X if ?aa = X ror ?bb \= X.
?dd =X if ?cc = X.
?ee =X if ?cc = X.
?ff =X if ?cc = X.
?gg =X if ?zz = X.
?hh =X if ?dd = X.
?ii =X if ?dd = X.
?zz =X if ?dd = X.

b/B :- 
	go([aa = 1,bb = 1],
	   [hh = 1, ii = -1, ee = 1,ff = -1, gg = 1],
	   B,_).