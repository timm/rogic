%ticks([total - 0.07 / 100, validate - 0.01 / 14, worldsSweep - 0 / 0, backwardsSweep - 0.01 / 14, forwardSweep - 0.01 / 14, prep - 0.02 / 29, data - 0.02 / 29]).


study(X) :-
	see(X),
	read(Item),
	study1(Item,0,Out),
	seen,
	W is integer((Out*100)/870),
	print(worlds(Out,W)), nl.

study1(end_of_file,Out,Out) :- !.
study1(result(_A,_B,_C,_D,_E,_F,_G,_H,_I,J,_K,_L,_M),In0,Out) :-  !,
	In is In0 + J,
	read(Item),
	study1(Item,In,Out).
study1(_,In,Out) :- 
	read(Item),
	study1(Item,In,Out).

