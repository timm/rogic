/* file: construct.pl 1.0.0 (USP LSI) Wed Mar 16 13:04:01 1994

    Copyright (c) 1994 Richard Victor Benjamins. All rights reserved.
    richard@lsi.usp.br

    Purpose: enables varies ways of constructing diagnostic strategies,
	     using a grammar.
*/

:- dynamic
   	situation/1,
	mode/1.

go:-
  welcome,
  repeat,
  ask_question(['What do you want to know?'],
       [
%       all_strategies, 
        applicable_strategies, 
%        give_all_strategies_and_why_not_applicable, 
	give_some_strategies_and_why_not_applicable_due_to_user_constraints,
	supply_strategy_and_get_criteria_and_method_tree
%	supply_method_tree_and_get_strategy_and_criteria,
%	order_applicable_strategies
	       ],
		[Option]),
  Option,
  ask_question(['What next?'], [exit, continue], [Answer]),
  (Answer == exit -> true ; fail).

all_strategies:-
  install(weak),
  findall([Strat, Tree], diagnosis(_F, Tree, Strat, []), List),
  length(List, N), writeln(['There are', N, 'possible strategies.', nl]),
  statistics.
%  present_strat_tree(List, 1).

applicable_strategies:-
  install(strong),
  findall([Strat, Tree], diagnosis(_F, Tree, Strat, []), List),
  ( List == [] -> writeln(['No applicable strategies in this situation.', nl])
  ; 
    (length(List, N), N > 150 ->
     writeln(['There are', N, 'possible strategies.', nl])
    ; length(List, N),
      writeln(['There are', N, 'possible strategies.', nl]),
      writeln(['Hit any key to see them.']),
      get_single_char(_),
      present_strat_tree(List, 1)
    )
  ).

give_all_strategies_and_why_not_applicable:-
  install(weak),
%  assert(situation(bulshit)),
  findall([Strat, Tree, Fail], diagnosis(Fail, Tree, Strat, []), List),
  present_s_t_failreason(List, 1).

/* as above, but now present only strategies specify some criteria
   such as only those whose epist. requirements are not satisfied,
   and only X criteria may be failed of these. */

give_some_strategies_and_why_not_applicable_due_to_user_constraints:-
  install(weak),
  get_user_info(MethodNumber, CritType, CritNumber),
  findall([Strat, Tree, Fail], diagnosis(Fail, Tree, Strat, []), List),
  remove_empty_stuff(List, AlmCleanList),
  del_empty_list(AlmCleanList, CleanList), % CleanList bevat ook S en T
  apply_user_restriction(MethodNumber, CritType, CritNumber, 
		         CleanList, Final),
  any_strategies(Final, MethodNumber, CritType, CritNumber).

any_strategies([], MethodNumber, CritType, CritNumber):-
  !,
  writeln(['No strategies satisfying the user constraints:',
		           nl, 'Allowed methods with problems:',
			   MethodNumber, nl, 'Relaxed criteria type:',
			   CritType, nl, 
			   'Allowed number of unfulfilled criteria for',
			   CritType, ':',
			   CritNumber, nl]).

any_strategies(Final, _, _, _):-
  length(Final, N),
  (N > 150 -> writeln(['There are', N, 'possibly strategies.'])
  ; present_s_t_failreason(Final, 1)).

order_applicable_strategies:-
  write('Not yet implemented'), nl.
%  install(strong),
%  findall([Strat, Tree, Fail], diagnosis(Fail, Tree, Strat, []), List),
%  assign_priority(List, PriorList), % should manipulate criteria
%  present_strat_tree(PriorList, 1).

supply_strategy_and_get_criteria_and_method_tree:-
  ask_question(['Supply strategie. You can choose predefined ones.'],
	       [empirical, simple, medical, 'GDE-GDE+', 'DART', 
	        'FAULTY', 'CHECK', for_camcorder, partial_strategy1, 
		partial_strategy2], 
		[Strategy]),
  strat(Strategy, Strat),
  clean_db, assert(situation(bulshit)),
  assert(mode(weak)),
  findall([Strat, Tree, Fail], diagnosis(Fail, Tree, Strat, []), List),
  !,
  present_s_t_failreason(List, 1).
%  diagnosis(Required, Tree, Strat, []), !,
%  present_s_t_failreason([[Strat, Tree, Required]], 1).
supply_strategy_and_get_criteria_and_method_tree:- !,
  writeln(['Presented strategy is not according to grammar']).

supply_method_tree_and_get_strategy_and_criteria:-
  writeln(['Supply method tree. It must be a nested list!', nl]),
  read(Tree),
  clean_db, assert(situation(bulshit)),
  assert(mode(weak)),
  diagnosis(Required, Tree, Strat, []),
  present_s_t_failreason([[Strat, [], Required]], 1).

install(Mode):-
  clean_db,
  install_mode(Mode),
  install_case_situation.

clean_db:-
  abolish(mode, 1),
  abolish(suitable, 1),
  abolish(situation, 1).

install_mode(weak):-
  assert(mode(weak)).
install_mode(strong):-
  assert(mode(strong)).
install_mode(bulshit):-
  assert(mode(bulshit)).

% install_case_situation:-
%  assert_situation([bulshit]),
%  assert_situation([user_knowledgeable_symptoms,
%  		    dependencies_in_model,
%		    knowledge_for_classifying_symptoms,
%		    device_model,
%		    non_intermittency_assumption,
%		    correct_device_model,
%		    single_fault_assumption,
%		    complete_fault_model,
%		    fault_simulation_rules
%		   ]).

assert_situation([]).
assert_situation([H| T]):-
  assert(situation(H)),
  assert_situation(T).

/* Retrieve criteria: use a findall on the criteria KB to find
   whatever criteria needed, reason with that ones */

% criteria(PSM, required(PSM, Failed)):-
%   applicability(PSM, Required),
%   verify(Required, Failed).
criteria(PSM, required(PSM, [epist(EpistFail), assum(AssumFail), 
                           envir(EnvirFail)])):-
  get_all_criteria(PSM, EpistList, AssumList, EnvirList),
  verify(EpistList, EpistFail),
  verify(AssumList, AssumFail),
  verify(EnvirList, EnvirFail).

get_all_criteria(PSM, EpistList, AssumList, EnvirList):-
  findall(EC, epistemological(PSM, EC, necessary), EpistList),
  findall(AC, assumption(PSM, AC, necessary), AssumList),
  findall(ENC, environmental(PSM, ENC, necessary), EnvirList).
  
/* check the truth of a criterion.
   In "weak" mode, collects failed criteria, but continues.
   In "strong" mode fails if one criteria is nto true.
   Needs elaboration concerning useful critera.
*/

verify([], []).
verify([H| T], NT):-
%  situation(H), !,
  verify_or_deduce(H), !,
  verify(T, NT).
verify([H| T], [H|NT]):-
  mode(weak),
  verify(T, NT).

verify_or_deduce(Crit):-
  situation(Crit), !.
verify_or_deduce(Crit):-
  more_specific(Specific, Crit),
  verify_or_deduce(Specific).

/* peal(List): [required(pdm, [epist([]), assum([]), envir([])])], 
	        required(ask_user, [epist([user_knows, who_knows]), ...]))]
   Deletes from such a list the elements containing [] */

present_problem_criteria([], []).
present_problem_criteria([required(Method, ProblemList)| RestMetProblems],
                         [required(Method, ReducedProL)| NewRest]):-
  filter_prob_list(ProblemList, ReducedProL),
  present_problem_criteria(RestMetProblems, NewRest).

filter_prob_list(List, NiceList):-
  delete(List, epist([]), L1),
  delete(L1, assum([]), L2),
  delete(L2, envir([]), NiceList).  

del_empty_prob([], []).
del_empty_prob([required(_, [])| T], NT):-
  !,
  del_empty_prob(T, NT).
del_empty_prob([H| T], [H| NT]):-
  del_empty_prob(T, NT).

/* write each strategy (tree) on a separate line */

present_strat_tree([], _).
present_strat_tree([[S, Tree]| T], N):-
  write('Strategy number: '), write(N), nl,
  write_list_to_screen(S), nl,
  (strat(S, Known) -> writeln(['This is a known strategy:', Known]);true),
  write('Tree: '), nl, show_tree(Tree),
  NN is N + 1,  get_single_char(_),
  present_strat_tree(T, NN).

remove_empty_stuff([], []).
remove_empty_stuff([[S, T, Fail]| RestFail], [[S, T, CleanL]| RestC]):-
  present_problem_criteria(Fail, DirtyF),
  del_empty_prob(DirtyF, CleanL),
  remove_empty_stuff(RestFail, RestC).

present_s_t_failreason([], _).
present_s_t_failreason([[Strat, Tree, F]| Rest], N):-
  write('Strategy number: '), write(N), nl,
  write_list_to_screen(Strat), get_single_char(_),
  write('Required criteria: '), nl,
  present_problem_criteria(F, DirtyF),
  del_empty_prob(DirtyF,PF), 
  write_list_to_screen(PF), get_single_char(_),
  write('Tree: '), nl, show_tree(Tree),
  NN is N + 1, get_single_char(_),
  present_s_t_failreason(Rest, NN).

/* pretty print the parse tree
   Works almost ok.
*/

del_empty_list([] , []).
del_empty_list([_, _, []| R], NR):-
  del_empty_list(R, NR).
del_empty_list( [H| T], [H| NT]):-
  del_empty_list(T, NT).

show_tree(Tree):-
%  write(Tree), nl,nl.
  asci_show_tree(Tree), nl.
%  graph_show_tree(Tree).

t:-
  graph_show_tree([pdm, [[a, [1], [b, [q, [[2,3], 2]], [c, [3], d, [3,3]]], 
		      [e, [2], [f, [3], g, [3,3]]]]]]).
%  graph_show_tree([a1, a2, [b1, [c1, c2], b2], a3]).

asci_show_tree(Tree):-
  draw_tree(Tree, 0).
draw_tree([], _).
draw_tree([H| T], Indent):-
  is_list(H), !,
  NewIndent is Indent + 2,
  draw_tree(H, NewIndent),
  draw_tree(T, Indent).
draw_tree([Term| T], Indent):-
  tab(Indent),
  write(Term), nl,
  draw_tree(T, Indent).
/*
graph_show_tree([TopMet| TreeList]):-
  new(P, picture),
  send(P, open),
  new(Root, node(text(TopMet, center))),
  new(Tree, tree(Root)),
  send(Tree, direction, vertical),
  send(Tree, level_gap, 0),
  send(Tree, link_gap, 0),
  send(Tree, recogniser, new(move_gesture)),
  graph_tree(Root, TreeList, 0),
  send(P, display, Tree).

graph_tree(_R, [], _).
graph_tree(R, [H| T], _Indent):-
  is_list(H), !,
  H = [NR|_NT],
  new(Son, node(text(NR))),
%  NewIndent is Indent + 2,
  graph_tree(Son, H, _NewIndent),
  graph_tree(R, T, _Indent).
graph_tree(R, [Term| T], _Indent):-
%  tab(Indent),
  new(Son, node(text(Term, center))),   
  send(R, son, Son),
%  write(Term), nl,
  graph_tree(R, T, _Indent).
*/
/*
new(@p, picture).
send(@p, open).
new(@rnode, node(text(root, center))).
new(@t, tree(@rnode)).
send(@t, recogniser, new(move_gesture)).
send(@p, display, @t).

new(@sn1, node(text(son1))).
new(@sn2, node(text(son2))).
new(@sn3, node(text(son3))).

send(@rnode, son, @sn1).
send(@rnode, son, @sn2).
send(@sn1, son, @sn3).

*/
