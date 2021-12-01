asList(X,Y) :-
	once(asList1(X,Y)).

asList1([],[]).
asList1([H0|T0],[H|T]) :-
	asList(H0,H),
	asList(T0,T).
asList1((X0;Y;Z),or([X|Rest],N)) :- 
	asList([X0,(Y;Z)],[X,or(Rest,N0)]),
	N is N0 + 1.
asList1((X0;Y0),or([X,Y],2)) :-
	asList([X0,Y0],[X,Y]).
asList1((X0,Y,Z),and([X|Rest],N)) :- 
	asList([X0,(Y,Z)],[X,and(Rest,N0)]),
	N is N0 + 1.
asList1((X0,Y0),and([X,Y],2)) :-
	asList([X0,Y0],[X,Y]).
asList1(X,X).

any(L,X) :-
	length(L,N),
	rone(L,N,X,_,_).
any(and(L0,N0),X,and(L,N)) :-
	rone(L0,N0,X,L,N).
any(or(L0,N0),X,or(L,N)) :-
	rone(L0,N0,X,L,N).
any([H|T],N0,X,L,N) :-
	rone([H|T],N0,X,L,N).
	

rone([H],_,H,[],0) :- !.
rone([H|T],N0,X,Out,N) :-
	N is N0 - 1,
	Pos is random(N0) + 1,
	oneLessN(Pos,[H|T],One,Rest),
	(X=One, Out=Rest
	; Out=[One|Tail],
	  N1 is N0 - 1,
	  rone(Rest,N1,X,Tail,_)).

oneLessN(1,[H|T],H,T) :- !.
oneLessN(N0,[H|T],X,[H|Rest]) :-
	N is N0 - 1,
	oneLessN(N,T,X,Rest).	
