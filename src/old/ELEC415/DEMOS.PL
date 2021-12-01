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

demo :-
	eg(_,Before),
        o(show(before),Before),
	buyWine(Before,After),
        o(show(after),After).

