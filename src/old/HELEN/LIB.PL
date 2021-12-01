bad(X,Y) :-
	format('% BAD ~w: ~w\n',[X,Y]),
        abort.

n(X,N) :-
	flag(n,_,0),
	forall(X,flag(n,Y,Y+1)),
	flag(n,N,N).

lprint(L) :-
	numbervars(L,0,_),
	member(X,L),
	format('~w\n',[X]),
	fail.
lprint(_).

l2c([A],A).
l2c([A,B|C],(A,Rest)) :- l2c([B|C],Rest).

total([H|T],Out) :- total(T,H,Out).

total([],X,X).
total([H|T],In,Out) :- Temp is H + In, total(T,Temp,Out).

members([],_).
members([H|T],L) :-
	member(H,L),
	members(T,L).
