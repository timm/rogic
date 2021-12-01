
set_addel([], El, +,[El]). 
set_addel([H|T], El, Mode,Add) :- 
	compare(Order, H, El), 
        addel(Order, H, T, El, Mode,Add).

addel(<, H, T,  El, Mode,[H|Add]) :- set_addel(T, El, Mode,Add).
addel(=, H, T, _El, _,[H|T]). 
addel(>, H, T,  El, +, [El,H|T]).