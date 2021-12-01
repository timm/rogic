:- 	op(990,xfx,if),
	op(985,xfx,then),
	op(960,xfy,or),
	op(940,xfx,not).

term_expansion(X if Y,Items) :-
	xpandRule(X if Y,Items).
	
xpandRule(_,[]).

