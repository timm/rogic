mybagof(A,B,C) :- bagof(A,B,C),!.
mybagof(_,_,[]).

sum([H|T],S) :- sum([H|T],0,S).

sum([],S,S).
sum([H|T],In,Out) :- Temp is H + In, sum(T,Temp,Out).

nSum(N,Goal, One,Sum,Av) :-
	flag(nSum,_,0), 
	nSum1(N,Goal,One),
	flag(nSum,Sum,Sum),
	Av is Sum/N.
nSum1(N,Goal,One) :-
	between(1,N,_), 
	Goal,
	flag(nSum,Old,Old+One),
	fail.
nSum1(_,_,_).

ndo(N,G) :- forall(between(1,N,_),G).

% histogram stuff
bins(L,B) :- 
	msort(L,L1), 
	bins(L1,[],B).

bins([],X,X).
bins([H|T],[H-N0|Rest],Out) :- !,
    N is N0 + 1,
    bins(T,[H-N|Rest],Out).
bins([H|T],In,Out) :-
    bins(T,[H-1|In],Out).

dist(L) :- dist(5,5,3,L).

dist(W1,W2,W3,L) :-
	sformat(S,'~~~wP  ~~~wP ~~~wS\n',[W1,W2,W3]),
	bins(L,Bins),
	nl,
	format(S,[item,frequency,0]),
	forall(member(What-N,Bins),format(S,[What,N,N])).

% misc print utilities (needed for the bistogram stuff)

:- format_predicate('P',padChars(_,_)).

padChars(default,A) :- padChars(5,A).
padChars(S,A) :-
	name(A,List),
	length(List,N), 
	Pad is S - N, 
        forall(between(1,Pad,_),put(32)),
        write(A).

:- format_predicate('S',twiddle(_,_)).

twiddle(default,A) :- twiddle(25,A).
twiddle(W,N) :-
	N1 is round(N/W), 
        forall(between(1,N1,_),put(126)).



runiv(Term, Out) :-
        Term =..L,
        once(maplist(runiv1, L, Out)).

runiv1(H,H)  :- var(H).
runiv1(H,H)  :- atomic(H).
runiv1(H0,H) :- runiv(H0,H).

rPrint(Term) :- runiv(Term,L),numbervars(L,0,_),lPrint(L).

lPrint(L) :- forall(lPrint(L,-1,'|    '),true). 



lPrint(L,Level,Before) :-
	is_list(L),!,
	member(X,L),
	lPrint(X,Level+1,Before).
lPrint(X,Level,Before) :-
	N is Level,
	forall(between(1,N,_), write(Before)),
	write(X),nl.
/*
prodof(X,Y,Z) :- bagof(X,Y,All),!,prod(All,1,Z).
prodof(_,_,1).

prod([],X,X).
prod([H|T],In,Out) :-
	Temp is In * H,
	prod(T,Temp,Out).

sumof(X,Y,Z) :- bagof(X,Y,All), !, sum(All,0,Z).
sumof(_,_,0).

sum([H|T],Out) :- sum(T,H,Out).

sum([],X,X).
sum([H|T],In,Out) :- Temp is H + In, sum(T,Temp,Out).

dot(X) :-write(X),flush_output.
dot :- dot('.').
bar :- dot('|').
x(X) :- nl,dot(x(X)).

t2l(T,L) :- runiv(T,L0), flatten(L0,L).

runiv(Term, Out) :-
        Term=..[H|T],
	(infixp(H,T,Arg1,Arg2)
        -> Todo =[Arg1,H,Arg2]
        ;  Todo=[H|T]),
        once(maplist(runiv1, Todo, Out)).

runiv1(H,H)  :- var(H).
runiv1(H,H)  :- atomic(H).
runiv1(H0,H) :- runiv(H0,H).

infixp(X,[A,B],A,B) :- current_op(_,xfx,X).
infixp(X,[A,B],A,B) :- current_op(_,xfy,X).
infixp(X,[A,B],A,B) :- current_op(_,yfx,X).

*/