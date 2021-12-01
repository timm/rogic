(c)/climb =   [sets,lastScore,size,growIf,candidates,oracle].


c step --> c jump.

c go -->  c size is 1, c step.


climb(In,Out) :- 
	sort(In,Temp),
	climb1(Temp,1,[],Out).

canGrow(0,X) :- !, X > 0.
canGrow(Old,New) :- (New/Old) > 1.1.

snatch(In,Out,Score) :- snatch(In,[],0,Out,Score).

snatch(Todo0,Done0,Score0,Out,Best) :-
	snatch1(Todo0,New,Todo),
	append(Done0,New,Done),
        score(Done,Score),
	canGrow(Score0,Score),
	print((done=Done,todo=Todo)),nl,
        snatch(Todo,Done,Score,Out,Best).
snatch(_,D,S,D,S).

snatch(Todo0,N, Done0/Score0,Out/Best) :-
	

snatch1(In,Out,Rest) :-
	on
	length(In,L),
	between(1,L,N),
	snatch2(In,N,Out,Rest).

snatch2(In,N,Out,Rest) :-
	length(Out,N),
	append(Out,Rest,In).
snatch2([H|T],N,Out,[H|Rest]) :-
	snatch2(T,N,Out,Rest).

score(X,S) :- sum1(X,S).

sum1(X,S) :- member(a,X), member(b,X), S=1000,!.

sum1(X,S) :- 
	list_to_set(X,X1),
	subtract(X1,[a,b,c],X2), 
	(X2=[] -> S=0 ; sum(X2,S)).

oneLess([H|T],H,T) :- lt(H,T).
oneLess([H|T],Out,[H|Rest]) :- lt(H,T), oneLess(T,Out,Rest).

lt(_,[]) :- !.
lt(H,[H1|_]) :- H @< H1.

nLess(In,1,[Some],Rest) :- oneLess(In,Some,Rest).
nLess(In,N,[One|Some],Rest) :- 
	dec(N,N1),
	oneLess(In,One,Rest0),
	nLess(Rest0,N1,Some,Rest).

dec(N,N1) :- N > 1, N1 is N - 1.

xx(M,N) :-
	member(M,[2,4,8,16,32,64]),
	length(L1,M),
	member(N,[1,2,3,4,5]),
	N < M,
	print(M/N),nl,
	length(L2,N),
	forall(sub(L1,L2),true),
	fail.
xx(_,_).
