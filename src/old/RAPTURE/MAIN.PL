:- op(900,xfx,if).
:- op(890,xfx,then).
:- op(880,xfy,or).
:- op(870,xfy,and).
:- op(860,fy,not).
%:- op(400,xfx,/).
%:- op(300,xfx,>)
%:- op(300,xfx,<)
%:- op(300,xfx,==)

% the first time you touch the rule. add in tediuos checks here.
% add in unique functors here.
% ?? add demorgan here

xpandRule(Who,X0,Y,rule(Who,X,Y)) :-
	ground(X0),
	xpandIf(X0,X).

%xpandIf(+X,-Y).

xpandIf(A or B,    Z)         :- (Z0=A; Z0=B), xpandIf(Z0,Z).
xpandIf(A0 and B0, A and B)   :- xpandIf(A0,A),xpandIf(B0,B).
%xpandIf(not (A and B),C or D) :- !, xpandIf(not A,C), 
%                                    xpandIf(not B,D).
xpandIf(not B0,not B)         :- xpandIf(B0,B).

%xpandIf(X>= N,sym(X)>=num(N)) :- number(N), atomic(X), not number(X).
xpandIf(X>= N,X>=N).
xpandIf(X> N,X>N).
xpandIf(X== N,X==N).
xpandIf(X=< N,X=<N).
xpandIf(X< N,X<N).


term_expansion((Who if X then Y), SideEffects) :-
	bagof(SideEffect,xpandRule(Who,X,Y,SideEffect),SideEffects).

:- dynamic r/6.

% swi indexing, limited to first 4 args
:- index(r(1,1,0,0,0,0)).

%r(201,a,<,7,8,=)
%r(143,b,=,4,10,<).
%r(671,dayOfWeek,=,tues,tues,=).

getRanges :-
	retractall(r(_,_,_,_,_,_)),
	setof(One,get1range(One),All),
	forall(member(r(A,B,C,D,E),All), 
               (flag(id,ID,ID+1),
                assert(r(ID,A,B,C,D,E)))).

get1range(One) :-
	rule(_,If,_),
	get1range(If,One).

get1range([H|T],Out) :- member(X,[H|T]), get1range(X,Out).
get1range(X and Y,Z) :- get1range([X,Y],Z).
get1range(X or Y,Z)  :- get1range([X,Y],Z).
get1range(not X,Z)   :- get1range(X,Z).
get1range(X >= N, r(X,=,N,   inf,<)).
get1range(X >  N, r(X,>,N,   inf,<)).
get1range(X == N, r(X,=,N,   N,  =)).
get1range(X =< N, r(X,>,ninf,N,  =)).
get1range(X <  N, r(X,>,ninf,N,  <)). 




:- flag(id,_,1).




