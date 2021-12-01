ops(X) :- ops(X,999).

ops([]            ,_ ).
ops([A/O    |Rest],N0) :- atom(O),ops1([O],  A,N0,N), ops(Rest,N).
ops([A/[H|T]|Rest],N0) :-         ops1([H|T],A,N0,N), ops(Rest,N).

ops1([],_,N,N).
ops1([H|T],A,_, N) :-
	current_op(N0,A,H), !,
	format(':- ~w.\n',[op(N0,A,H)]),
	N1 is N0 - 1,
	ops1(T,A,N1,N).
ops1([H|T],A,N0,N) :-
	format(':- ~w.\n',[op(N0,A,H)]),
	op(N0,A,H), N1 is N0 - 1,
	ops1(T,A,N1,N).



