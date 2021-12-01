% ordered set processing
% lists contain terms whose first arg is there id

has(In,E,Out) :- arg(1,E,Id), has(In,E,Id,Out).

has([], El,_, [El]). 
has([H|T], El,_,  Add) :-
	arg(1,H,HId),
	compare(Order, HId, Id), 
        has(Order, H, T, El, Id,Add).

has(<, H, T,  El, Id, [H|Add]) :- has(T, El, Id,Add).
has(=, H, T,  _,  _,  [H|T]). 
has(>, H, T,  El, Id, [El,H|T]).

hasnot(In,E,Out) :- arg(1,E,Id), hasnot(In,E,Id, Out).

hasnot([], _,_,[]).
hasnot([H|T], El, Id, Del) :-
	arg(1,H,HId),
	compare(Order, HId, Id), 
	hasnot(Order, H, T, El, Del).

hasnot(<,  H, T,  El, Id,[H|Del]) :- hasnot(T, El, Id, Del).
hasnot(=, _H, T, _El, _, T).
hasnot(>,  H, T, _El, _, [H|T]).
