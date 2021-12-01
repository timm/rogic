term_expansion(X if Y,Out) :-
	jim(X if Y,Out).


jim(X if Y,Out) :-
	source_location(_, Line),
	sformat(S,'[~w@~w]',[X,Line]),
	string_to_atom(S,Id),
	jim1(Y,Id,Y1,Rest,[]),
	expand_term(Id if Y1 then X,Head0),
	asList(Head0,Head),
	append(Head,Rest,Out).

+ (jim1(T1,C,T2) --> !, jim1(X0,C,X),jim1(Y0,C,Y)),
	comb(What),
	T1 =.. [What,X0,Y0],
	T2 =.. [What,X, Y].

jim1(X @  Chances,C,X1,[One|Rest],Rest) :-
	flag(X,N,N+1),
	X1 =.. [X,N],
	sformat(Id0,'~w in ~w',[X,C]),
	string_to_atom(Id0,Id),
	ruleHeadBody1(X1,t,X,Id,0,Chances,One).

jim1(X,_,X,L,L).