% new: ordered insert, with no repeats
% of any literal New


% ok: union of two ordered lists, with
% repeats of literal H1, but only one
% assignment to that literal

ok([],X,X).
ok([H1|T1],L2,Out) :-
	ok1(L2,H1,T1,Out).

ok1([],H,T,[H|T]).
ok1([H2=This|T2],H1=That,T1,Out) :-
	compare(Order,H1,H2),
	ok2(Order,H1=That,T1,H2=This,T2,Out).

ok2(<,H1,T1,H2,T2,[H1|Out])   :-ok1(T1,H2,T2,Out).
ok2(>,H1,T1,H2,T2,[H2|Out])   :-ok1(T1,H1,T2,Out).
ok2(=,H=X,T1,H=X,T2,[H=X|Out]):-ok(T1,T2,Out).
%ok2(=,H=X1,T1,H=X2,T2,[H=X|Out]):-\+X1=X2,fail




