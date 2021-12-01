mybagof(A,B,C) :- bagof(A,B,C),!.
mybagof(_,_,[]).

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
