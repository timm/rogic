:- op(999,fx,&).
:- op(999,fx,@).
:- op(1002,xfy,ror).
:- op(1001,xfy,rand).

portray(A rand B) :- print(A), write(' rand '), print(B).
portray(A ror B) :- print(A), write(' ror '), print(B).

odd :- 0 is random(2).

X ror  Y :- odd -> (X;Y) ; (Y;X).
X rand Y :- odd -> (X,Y) ; (Y,X).

rstring(_,X)  :- nonvar(X),!.
rstring(A,X)  :- gensym(A,X).

rsym(_,X)  :- nonvar(X),!, atom(X).
rsym(A,X)  :- gensym(A,X).

rin(M,N,X) :- nonvar(X), !, integer(X), M =< X, X =< N.
rin(M,N,X) :-
	findall(Num,between(M,N,Num),L),
	rin(X,L).

rin(X,L) :- nonvar(X),!, member(X,L).
rin(X,L) :- 
	length(L,N),
	rmember1(L,N,X).

rmember1([H],_,H) :- !.
rmember1([H|T],N,X) :-
	Pos is random(N) + 1,
	oneLessN(Pos,[H|T],Y,L),
	(X=Y
	; N1 is N - 1,
	  rmember1(L,N1,X)).

oneLessN(1,[H|T],H,T) :- !.
oneLessN(N0,[H|T],X,[H|Rest]) :-
	N is N0 - 1,
	oneLessN(N,T,X,Rest).	

term_expansion((+X :- Y),(X :- Y)) :- 
	term_expansion(+X,X).

term_expansion(+X,X) :-
	(\+ \+ (@X)) -> true ; write(badRead(X)),nl.

&X :- @X,!.
&X :- numbervars(X,bad,0,_), print(failed(X)),nl.

oops(X)        :- \+ known(X),  print(unknown(X)),nl,fail.
known(X)       :- nonvar(X), clauses(Y,_,_,_), X=Y.

clauses(X,F,A,B) :- clause(-X,_), nonvar(X), functor(X,F,A),
		functor(B,F,A).

impact1(X,Y,I) :-
	impact(X,Y

impacts(+,X,I) :-
	sumof(Y,X^Who^impact(X,Y,Who),I).

impacts(*,X,I) :-
	prodof(Y,X^Who^impact(X,Y,Who),I).

prodof(X,Y,Z) :- bagof(X,Y,All),!,prod(All,1,Z).
prodof(_,_,1).

prod([],X,X).
prod([H|T],In,Out) :-
	Temp is In * H,
	prod(T,Temp,Out).

sumof(X,Y,Z) :- bagof(X,Y,All), !, sum(All,0,Z).
sumof(_,_,0).

sum([],X,X).
sum([H|T],In,Out) :- Temp is H + In, sum(T,Temp,Out).

