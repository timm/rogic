%%%% fifo queue 
%%%% implemented as difference lists
:- module(fifo,[fifo/1,fifo/2,fifo/3]).

%fifo/2
fifo(empty, -).
fifo(full,  _-X) :- var(X).
fifo(new,   X)   :- fifo(empty,X).
fifo(show,  X)   :- dlprint(X).
fifo(asList(X), X-[]) :- !.
fifo(asList([]), -).

%fifo/3
fifo(poke(X),New,[X|End]-End) :- 
	fifo(empty,New).
fifo(poke(X),L-[X|End],L-End).
fifo(pokes([]),X,Y) :- 
	(var(X) -> fifo(empty,Y) ; X=Y).
fifo(pokes([H|T])) -->
	fifo(poke(H)), 
	fifo(pokes(T)).
fifo(pull(X),[X|T]-End,Out) :- 
	nonvar(X), 
	(var(T) 
	-> fifo(empty,Out) 
	;  Out=(T-End)).

%fifo/1 
fifo(demo1) :-
	fifo(pokes([a,b,c,d,e]),_,DL),
	fifo(show,DL).

dlprint(X) :- 
	fifo(empty,X), 
	write('{}').
dlprint(X) :-
	fifo(full,X),
	copy_term(X,Y-[]), 
	write('{'),
	(Y=[] 
	-> 	true 
	; 	Y=[H|T],
		write(H),
		forall(member(Z,T),
                       (write(', '),write(Z))
        )             ),
        write('}').

