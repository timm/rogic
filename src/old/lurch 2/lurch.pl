% Eliza- did not tell you about this bit.
% Lurch's memos are designed for arbitrary Prolog ground terms.
% Hence, we hash on each term for fast access

:- dynamic memo/3.
% memo(HashOfTerm, Term, ClauseRefThatProvedTerm)

go(X) :-  reset, run(X), !, report(X).

reset  :- retractall(memo(_,_,_)). 
run(X) :- lurch(X).
%report(X) :- quickReport.
report(X) :-  quickReport, write('\n===> '), scoreReport(X).

scoreReport(X) :-
	costs(C), 
	benefit(X,B),
	format('cost=~w benefit=~w\n',[C,B]). 

quickReport :- forall(memo(_,Y,0),format('assumption=~w\n',[Y])).

lurch(X) :- once(lurch0(X,Y)), lurch1(Y).

lurch0(X,        bad(var)) :- var(X). 
lurch0(call(X),   call(X)).
lurch0(true,         true).
lurch0((X->Y;Z), (X->Y;Z)).
lurch0(once(X),   once(X)).

% eliza- there are three different ways to handle "or"
%lurch0((X;Y),     rors(L)) :- c2l((X,Y),L).
lurch0((X;Y),      ror(L)) :- d2l((X;Y),L). 
%lurch0((X;Y),       or(L)) :- d2l((X;Y),L).

lurch0((X,Y),      and(L)) :- c2l((X,Y),L).
lurch0(X,    old(X,Index)) :- choices(X,Index), \+ \+ memo(Index,X,_).
lurch0(X, assume(X,Index)) :- choices(X,Index), \+ clause(X,_).
lurch0(X,    new(X,Index)) :- choices(X,Index). 
lurch0(X,         call(X)) :- knownBuiltIn(X).
lurch0(X,          sub(X)) :- clause(X,_).  
lurch0(X, bad(unknown(X))).

lurch1(rors([])).
lurch1(rors1([])).
lurch1(rand([])).
lurch1( and([])).
lurch1(true). 
lurch1(bad(X))       :- barph(X).
lurch1(call(X))      :- X.
lurch1((X->Y;Z))     :- lurch(X) -> lurch(Y) ; lurch(Z).
lurch1(sub(X))       :- clause(X,Y), lurch(Y).
lurch1(once(X))      :- once(lurch(X)). 
lurch1(old(X,Index)) :- memo(Index,X,_).
lurch1(and([H|T]))   :- lurch(H), lurch1(and(T)).
lurch1(rand(L))      :- rone(L,Y,Z), lurch(Y), lurch1(rand(Z)).

% eliza: or1: starting from left hand side, prove first one and only 1
lurch1(or(L))        :- member(X,L), lurch(X).

% eliza: or2: starting from any position, prove first one and only 1
lurch1(ror(L))       :- rone(L,Y,_), lurch(Y).

% eliza: or3: starting from any position, try to prove them all.
%             Step 1: At least one has to succeed
%             Step 2: After which try the others in any order 
%                     and if they don't succeed, don't sweat it

% rors step 1
lurch1(rors(L))  :- rone(L,Y,Z), lurch(Y), lurch1(rors1(Z)).
% rors step 2
lurch1(rors1(L)) :- rone(L,Y,Z), try(lurch(Y)), lurch1(rors1(Z)).

lurch1(assume(X,Index)) :- bassert(memo(Index,X,0)).
lurch1(new(X,Index)) :- 
	oneof(X/Y/R,clause(X,Y,R), X/Y/R),
	lurch(Y), 
	bassert(memo(Index,X,R)).	


 
