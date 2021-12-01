/* file: ker_user_restr.pl 1.0.0 (USP LSI) Fri Mar 18 16:09:37 1994

    Copyright (c) 1994 Richard Victor Benjamins. All rights reserved.
    richard@lsi.usp.br

    Purpose: filter the strategies with problems according to
	     type and number of failed criteria.
*/

/* All looks like: 
   [ [Strat, Tree, Failed] | Rest]
   Failed looks like:
   [required(Method, ProblemList) | Rest]
   ProblemList looks like:
   [epist(FailList), assum(FailList), envir(FailList)] */

% if passes keep the strategy, else don't
% N is method number, Crit is crit type, M is crit number
apply_user_restriction(_, _, _, [], []).
apply_user_restriction(N, Crit, M, [[St, T, ProblemL]| RestSt],
		       [[St, T, Passed]| NewRestSt]):-
  apply_on_strategy(N, Crit, M, ProblemL, Passed),
  !,
  apply_user_restriction(N, Crit, M, RestSt, NewRestSt).
apply_user_restriction(N, Crit, M, [_| RestSt], NewRestSt):-
  apply_user_restriction(N, Crit, M, RestSt, NewRestSt).
  
apply_on_strategy(N, Crit, M, ProblemL, Passed):-
  how_many_methods_with_problems(N, ProblemL, PassList),
  !,
  apply_on_one_strategy(N, Crit, M, PassList, Passed).

apply_on_one_strategy(_, _, _, [], []).
apply_on_one_strategy(N, Crit, M, [required(Method, ProbL)| RestMethods],
                      [required(Method, Applied)| NewRestMethods]):-
  apply_on_one_method(N, Crit, M, ProbL, Applied),
  apply_on_one_strategy(N, Crit, M, RestMethods, NewRestMethods).

how_many_methods_with_problems(dontcare, List, List):- !.
how_many_methods_with_problems(N, List, List):-
  length(List, X),
  (X =< N -> true ; fail).

/*
% only the chosen criterion type is filtered, the others pass.
apply_on_one_method(_, dontcare, _, L, L):- !.
apply_on_one_method(_N, epist, M, ProbList, EAE):-
  ( memberchk(epist(EpL), ProbList) -> true ; true),
  length(EpL, L),
  (L > M -> delete(ProbList, epist(EpL), EAE)
         ;  ProbList = EAE).
apply_on_one_method(_N, assum, M, ProbList, EAE):-
  ( memberchk(assum(AsL), ProbList) -> true ; true),
  length(AsL, L),
  (L > M -> delete(ProbList, assum(AsL), EAE)
         ;  ProbList = EAE).
apply_on_one_method(_N, envir, M, ProbList, EAE):-
  ( memberchk(envir(EL), ProbList) -> true ; true),
  length(EL, L),
  (L > M -> delete(ProbList, envir(EL), EAE)
         ;  ProbList = EAE).
*/

% an other view is to ask which criteria can be relaxed, thus the strategy
% is ok if it falls within the relaxation, while the others can
% NOT be relaxed. So if one of the other criteria types have problems
% fail on this strategy completely!

apply_on_one_method(_, dontcare, _, L, L):- !.
apply_on_one_method(_N, epist, M, ProbList, EAE):-
  delete(ProbList, epist(EpL), []),
  !,
  ( memberchk(epist(EpL), ProbList) -> true ; true),
  length(EpL, L),
  (L > M -> fail % this strategy fails, take next.
         ;  ProbList = EAE).
apply_on_one_method(_N, assum, M, ProbList, EAE):-
  delete(ProbList, assum(AsL), []),
  !,
  ( memberchk(assum(AsL), ProbList) -> true ; true),
  length(AsL, L),
  (L > M -> fail
         ;  ProbList = EAE).
apply_on_one_method(_N, envir, M, ProbList, EAE):-
  delete(ProbList, envir(EL), []),
  !,
  ( memberchk(envir(EL), ProbList) -> true ; true),
  length(EL, L),
  (L > M -> fail
         ;  ProbList = EAE).
  
