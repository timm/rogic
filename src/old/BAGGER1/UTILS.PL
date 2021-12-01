%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sum a list of numbers

sum([H|T],X) :- sum(T,H,X).
sum([],   X,  X).
sum([H|T],X,Out) :- Temp is H + X, sum(T,Temp,Out).

%%%%%%%%%%%%%%%%%%%%%%%%%%
% member for lists of lists
ins([],_).
ins([X|Y],L) :- member(X,L),ins(Y,L).  

%%%%%%%%%%%%%%%%%%%%%%%%%
% pull one member out of a list
oneLess([H|T],H,T).
oneLess([H|T],Out,[H|Rest]) :- oneLess(T,Out,Rest).

%%%%%%%%%%%%%%%%%%%%%%%%%%
% pretty print extension to format
:- format_predicate('P',padChars(_,_)).

padChars(default,A) :- padChars(5,A).
padChars(S,A) :-
	name(A,List),
	length(List,N), 
	Pad is S - N, 
        forall(between(1,Pad,_),put(32)),
        write(A).

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% use of bagof to do summing

sumof(X,Y,Z) :- bagof(X,Y,Temp), !,sum(Temp,Z).
sumof(_,_,0).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% recursively descend a term, swapping atoms.

runiv(Term0, Swaps,Term) :-
        Term0 =..L0,
        once(maplist(runiv1(Swaps), L0, L)),
	Term =.. L.

runiv1(_,H,H)  :- var(H).
runiv1(Swaps,Old,New)  :- atomic(Old), member(Old/New,Swaps),!.
runiv1(_,H,H) :- atomic(H).
runiv1(Swaps,H0,H) :- runiv(H0,Swaps,H).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% find all the variables in a term
vars(X,T) :- 
  vars1(X,All,[]),
  sort(All,T).

vars(X,In,Out) :-
  vars1(X,All,In),
  sort(All,Out).

vars1(X,L,L) :- atomic(X),!.
vars1(X,[X|L],L) :- var(X),!.
vars1([],X,X)    :- !.
vars1([H|T],In,Out) :- !,
        vars1(H,In,Temp),
        vars1(T,Temp,Out).
vars1(Term,In,Out) :-
        Term =.. L,
        vars1(L,In,Out).

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% intersection defined for list of variables

intersectV([],_,[]).
intersectV([H|T],L,[H|Rest]) :-
	   memberV(H,L),!,
	   intersectV(T,L,Rest).
intersectV([_|T],L,Rest) :-
	   intersectV(T,L,Rest).

memberV(X,[Y|_]) :- X == Y.
memberV(X,[_|T]) :- memberV(X,T).

