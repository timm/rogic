:- [ops].

% the check(N)s could be run afterwards deductively
% or run before to restrict the space for the subsequent
%    abductive run
% hmm... ignore ands during abduction.
%        compile rules into ground horn clause triples
%        then convert up via QCM to get the houle
%        optimisation (i.e. continous range of beliefs
%        0 to 1).
% adds check rules for all ands
% repair actions for different ands/ors (spec/gen)
% compile rules down via QCM

:- discontiguous statement/2.

term_expansion(* N if X then Y,[statement(N,N if X then Y),
                                * boolean are [check(N)]
                               |Out]) :-
	xpands(N if X then Y,Out).

output(*).
output(statement).

xpands(In,All) :-
	setof(One,In^xpand(In,One),All).
xpand(Id if X then Y,Out) :- 
	xpand(Id if X then Y,1,Out).

xpand(Id if X then Y,N,Out) :- 
	flatter(X,X1),
	flatter(Y,Y1),
	xpand1(Id if X1 then Y1,N,Out).

xpand1(Id if X then Y, 1,Out) :-
	\+Y=check(_), % not interested in check on LHS
	\+Y=(not check(_)),
	xpand(mt(Id) if not Y then not X,2,Out)
        % the constraints from the following are actually
	% the same as those without md
	%;flatter(X and not Y ,LHS),
	% xpand1(test(Id) if LHS then check(Id),2,Out)
	.
xpand1(Id if X then Y,_,* Id if X then A) :-
	memberAnd(A,Y).
xpand1(Id if X then Y and Z,_,Out) :- 
	xpand(  test(Id)
		if X and not (Y and Z) 
                then check(Id)
              ,Out).
xpand1(Id if X then Y and Z,_,Out) :- 
        xpand(  test(Id)
    		if not( X and not (Y and Z)) 
                then not check(Id)
              ,Out).

flatter(X and Y      ,X1 and Y1) :- !,
	flatter(X,X1),flatter(Y,Y1).
flatter(X or Y       , Z1)       :- !,
	(flatter(X,Z1); flatter(Y,Z1)).
flatter(not not X    , X1)       :- !,
	flatter(X,X1).
flatter(not (X and Y), Out)      :- !,
	flatter(not X or  not Y,Out).
flatter(not (X or  Y), Out)      :- !,
	flatter(not X and not Y,Out).
flatter(X,X).

memberAnd(X, X and _).
memberAnd(X, _ and Y) :- !, memberAnd(X,Y).
memberAnd(X, X).
