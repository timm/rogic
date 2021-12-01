
makeGraph(F) :- 
	reads(F,Statements),
	create(pre_g,G0),
	makeGraph1(Statements,G0,_).

makeGraph1([],G,G).
makeGraph1([H|T], G0,G) :-
	t2l(H,S,Used),
	makeGraph2(S,Used,G0,G1), 
	makeGraph1(T,G1,G).

makeGraph2(S,Used,G,G) :- print(s(S)),nl,print(used(Used)),nl.

t2l(X,Y,Uses) :- t2l1(X,Temp,[],Uses), t2lflat(Temp,Y).

%t2l1(X0 if Y0, [if,X,Y])      --> !, t2l1(X0,X), t2l1(Y0,Y).
%t2l1(X0 then Y0,[then,X,Y])   --> !, t2l1(X0,X), t2l1(Y0,Y).
%t2l1(X0 and Y0,[and,X,Y])     --> !, t2l1(X0,X), t2l1(Y0,Y).
t%2l1(X0 or Y0, [or,X,Y])      --> !, t2l1(X0,X), t2l1(Y0,Y).
%t2l1(not  X0,  [not,X])       --> !, t2l1(X0,X).
t2l1(r(N),     [rule,N],In,In) :- !.
t2l1(X,X,      In, [X|In]).

t2lflat([H|T0],[H|T]) :- !, t2lflat1(T0,H,T).
t2lflat(X,X).

t2lflat1([],_,[]).
t2lflat1([[Top|T0]|T1],Top, Out) :- !,
	append(T0,T1,T2), t2lflat1(T2,Top,Out).
t2lflat1([H0|T0],Top,[H|T]) :- 
	t2lflat(H0,H), t2lflat1(T0,Top,T).


:- dynamic xx/3,parents/2.
:- index(xx(1,1,1)).

setup :-
	retractall(xx(_,_,_)),
	Size=1000,
	N is Size*0.8,
	between(1,Size,_),
	X is random(N),
	Y is random(N),
	Z is random(N),
	assert(xx(X,Y,Z)),
	fail.
setup :- retractall(parents(_,_)),
	kids1(X-Y), assert(parents(X,Y)),fail.
setup.

kids(T,N) :- T0 is cputime, bagof(Kids,kids1(Kids),All), 
	length(All,N), T1 is cputime,
	T is T1-T0.

kids(T,N) :-
	T0 is cputime, bagof(X-Y,parents(X,Y),All), 
	length(All,N), T1 is cputime,
	T is T1-T0.	
kids1(From-Kids) :-
	xx(_,From,_),
	my_bagof(To,Id^From^xx(Id,From,To),Kids).

my_bagof(X,Y,Z) :- bagof(X,Y,Z),!.
my_bagof(_,_,[]).


