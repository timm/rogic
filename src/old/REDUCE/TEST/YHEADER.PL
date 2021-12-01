stats([],Out,Out).
stats([H|T]) --> stats1(H,1), stats(T).

stats1([],_,X,X).
stats1([H|T],N) --> inc([H,N]), {N1 is N +1}, stats1(T,N1).

inc(X,W,[X-New|Rest]) :- oneLess(W,X-Old,Rest),!, New is Old + 1.
inc(X,W,[X-1|W]).

oneLess([H|T],H,T).
oneLess([H|T],X,[H|Rest]) :- oneLess(T,X,Rest).

go :- go(_).

go(rmember1) :-
	bagof(One,one(a,1000,One),All),
        stats(All,[],S0),
	keysort(S0,S),
	member(X,[a,b,c,d,e]),
	nl,
	forall(member([X,Pos]-N,S),format('~w ~w ~w~n',[X,Pos,N])),
	fail.
go(rmember1).

one(a,N,L) :-	between(1,N,_), bagof(X,Rest^rone(l([a,b,a,c,d,e],6),X,Rest),L).