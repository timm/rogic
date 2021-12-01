:- [dcgplus].
:- [accessor].
:- [demos].

% define the v record
wine = [brand,cost,maturity,bought].

% shell tricks
o(X=Y)       --> wine(X,Y,Y).
o(X is Y)    --> wine(X,_,Y).
o(init)      --> o(bought is n).
o(mature)    --> o(maturity=Y), Y > 100.
o(expensive) --> o(cost=Y),     Y > 10000.
o(buy)       --> o(bought is y).

eg --> 
	o(init), 
	o(brand=ozzie),   
	o(maturity=111),   
	o(cost=500).
eg --> 
	o(init),
	o(brand=canadian),
	o(maturity=1000), 
	o(cost=50000).

buyWine -->  
	o(mature), 
	\+ o(expensive),
	o(buy).

