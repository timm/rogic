:- [law/abduct,law/theory].

go1 :- 
	data(In,Out,Facts),
	ht5(In,Out,Facts,Worlds).
	
data(In,Out,Facts) :-
	eg(In0,Out0),
	map(sort,[In0,Out0,Facts0],[In,Out,Facts]),
	merge_set(In,Out,Facts).

facts2Time(F,Out) :- maplist(fact2Time,F,Out).
fact2Time(not X@T,X=f@T)    :- !.
fact2Time(not X  ,X=f@t(_)) :- !.
fact2Time(X@T    ,X=t@T)    :- !.
fact2Time(X@T    ,X=t@t(_)).
