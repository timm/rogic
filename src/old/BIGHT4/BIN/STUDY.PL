%ticks([total - 0.07 / 100, validate - 0.01 / 14, worldsSweep - 0 / 0, backwardsSweep - 0.01 / 14, forwardSweep - 0.01 / 14, prep - 0.02 / 29, data - 0.02 / 29]).


study(X) :-
	see(X),
	read(Item),
	study1(Item,[],Out),
	process(Out,[	total -  0, 
			validate -  0,
			worldsSweep -  0, 
			backwardsSweep -  0, 
			forwardSweep -  0, 
			prep -  0, 
			data -  0
			]),
	seen.

study1(end_of_file,Out,Out) :- !.
study1(ticks(X),In,Out) :- !,
	read(Item),
	study1(Item,[X|In],Out).
study1(_,In,Out) :- 
	read(Item),
	study1(Item,In,Out).

process([],Report) :- finalReport(Report,Final),print(Final).
process([H|T],Report0) :-
	process1(H,Report0,Report1),
	process(T,Report1).

process1([],R,R).
process1([Item-N/_|Rest],R0,R) :-
	delete(R0,Item-N0,R1),
	N1 is N + N0,
	process1(Rest,[Item-N1|R1],R).

finalReport(In,[total-T/100|Out]) :-
	delete(In,total-T,In0),
	finalReport1(In0,T,Out).

finalReport1([],_,[]).
finalReport1([Item-N|Tail],T,[Item-N/P|Rest]) :-
	P is integer(N*100/T),
	finalReport1(Tail,T,Rest).

