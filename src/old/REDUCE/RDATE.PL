rstring(_,X)  :- nonvar(X),!.
rstring(A,X)  :- gensym(A,X).

rsym(_,X)  :- nonvar(X), !,atom(X).
rsym(A,X)  :- var(X),  gensym(A,X).

rnum(M,N,X) :- rnum(M,N,1,X).

rnum(M,N,_,X) :- nonvar(X), !,number(X),M =< X, X =< N.
rnum(M,N,O,X) :- rnum1(M,N,O,X).

rnum1(M,N,_,_) :- M > N, !, fail.
rnum1(M,N,O, X) :-
	D is floor((N - M)/2/O), 
	rone(l([1,2,3],3),Control,_),
	rnum1(Control,M,N,D,O,X).

rnum1(1, M,_,D,O,X) :- 
	X is M+D*O.
rnum1(2, M,_,D,O,X) :- 
	Upper is M+((D-1)*O),
	rnum1(M,Upper,O,X).
rnum1(3, M,N,D,O,X) :- 
	Lower is M+((D+1)*O),
	rnum1(Lower,N,O,X).
	
rin(X,L) :- number(X),!, member(Y,L), X =:= Y. 
rin(X,L) :- nonvar(X),!, member(X,L). 
rin(X,L) :- 
	length(L,N),
	rone(l(L,N),X,_).

rone(l([H]  ,_),H,l([],  0)) :- !.
rone(l([H|T],N),X,l(Out,N1)) :-
	N1 is N - 1,
	Pos is random(N) + 1,
	oneLessN(Pos,[H|T],Y,L),
	(X=Y, Out=L
	; Out=[Y|Rest],
	  rone(l(L,N1),X,l(Rest,_))).

oneLessN(1,[H|T],H,T) :- !.
oneLessN(N0,[H|T],X,[H|Rest]) :-
	N is N0 - 1,
	oneLessN(N,T,X,Rest).	
