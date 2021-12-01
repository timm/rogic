% ordered set processing
% lists contain terms whose first arg is there id


% if not id there, add
% else, try to match whole term. if can't match,  
% replace with new term
% node: changes only enables if Mode="+"
has(In,E,Mode,Out) :- arg(1,E,Id),  nonvar(Id), has(In,E,Id,Mode,Out).

has(In,E) :- has(In,E,-,_).

has([], El,_, +,[El]). 
has([H|T], El,Id,  Mode,Add) :-
	arg(1,H,HId),
	compare(Order, HId, Id), 
	has(Order, H, T, El, Id,Add,Mode).

has(<, H, T,  El, Id, [H|Add],Mode) :- has(T, El, Id,Mode,Add).
has(=, H, T,  H,  _,  [H|T],_) :- !.
has(=, _, T,  El, _,  [El|T],+).
has(>, H, T,  El, _,  [El,H|T],+).


% if there, try to match whole term. delete if match or not.
% if not there, fail.
hasnot(In,E,Out) :- arg(1,E,Id), nonvar(Id), hasnot(In,E,Id, Out).

hasnot([], _,_,[]).
hasnot([H|T], El, Id, Del) :-
	arg(1,H,HId),
	compare(Order, HId, Id), 
	hasnot(Order, H, T, El, Id,Del).

hasnot(<,  H, T,  El, Id,[H|Del]) :- hasnot(T, El, Id, Del).
hasnot(=,  H, T,  El, _, T) :-  H=El,!.
hasnot(=, _,  T,  _,  _, T).
%hasnot(>,  _, _, _, _, _). fail

