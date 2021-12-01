% 80 or 40
mine=[aa,bb,cc,dd,ee,ff,gg,hh,ii,jj,ll].

?cc= X if ?aa= X ror ?bb \= X.
?ee= X if ?cc= X.
?ff= X if ?cc= X.
?dd= X if ?cc= X.
?gg= X if ?dd= X.
?ll= X if ?dd= X.
?jj= X if ?hh= X.
?jj= X if ?ii \= X.
?gg= X if ?jj= X.
?kk= X if ?jj= X.

b/B :- go([aa=1,bb=1,hh=1,ii=1], 
	  [ee= -1, kk= -1, ff= -1, gg= 1, ll= -1],
	  B,_).