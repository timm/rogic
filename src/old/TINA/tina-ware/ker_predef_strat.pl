/* file: ker_predef_strat.pl 1.0.0 (USP LSI) Wed Mar 23 17:22:14 1994

    Copyright (c) 1994 Richard Victor Benjamins. All rights reserved.
    richard@lsi.usp.br

    Purpose: define some known strategies in terms of inferences
*/

strat('GDE-GDE+', [
		simulate,
		equal_check,
		simulate,
		subset_minimality_cover,
		select_fault_model, 
		simulate_hypothesis,
		compare,
		keep,
		estimate_overall_cost,
		order_hypothesis_set,
		select_first,
		measure,
		obtain,
		symptom_detection,
		model_based_hypothesis_generation
		]).
strat('DART', [
	        simulate,
		equal_check,
		simulate,
		intersect,
		select_fault_model, 
		simulate_hypothesis,
		compare,
		keep,
		estimate_number_of_tests,
		order_hypothesis_set,
		select_first,
		compute_input_vector,
		apply_input_vector,
		obtain,
		symptom_detection,
		spilt_hypothesis_set
		]).
strat('FAULTY', [
	        lookup,
		equal_check,
		find_upstream,
		intersect,
		dependency_analysis,
		compare,
		delete,
		estimate_overall_cost,
		order_hypothesis_set,
		select_first,
		measure,
		obtain,
		symptom_detection,
		spilt_hypothesis_set
		]).

strat(empirical, 
      [user_judgement,abstract,associate,probability_filter,select_random,
       compiled_test, symptom_detection, delete]).

strat(simple, [
	      user_judgement, abstract, associate, probability_filter, 
	      select_random, compiled_test, symptom_detection, delete
	      ]).

strat(medical,
	[user_judgement,abstract,associate,probability_filter,
         estimate_number_of_tests, order_hypothesis_set,
	 select_first,compiled_test,symptom_detection,delete]).

strat('CHECK',
	        [user_judgement, 
		causal_covering, 
		intersect, 
		select_fault_model, 
		simulate_hypothesis,
		compare,
		keep,
		estimate_number_of_tests, 
		order_hypothesis_set,
		select_first,
		measure,
		obtain,
		symptom_detection,
		spilt_hypothesis_set
		]).

strat(partial_strategy1, 
      [user_judgement, _Z, _X , _Y, select_random,
       compiled_test,symptom_detection,delete]).

strat(partial_strategy2, [
	        simulate,
		equal_check,
		simulate,
		_F,
		_A,		
		_B,
		_C,
		_D,
		estimate_number_of_tests,
		order_hypothesis_set,
		select_first,
		compute_input_vector,
		apply_input_vector,
		obtain,
		symptom_detection,
		spilt_hypothesis_set
		]).

strat(for_camcorder,
[lookup, determine_ratio, check_against_threshold, find_upstream,
intersect, dependency_analysis, compare, delete,
estimate_overall_cost, order_hypothesis_set, select_first, measure,
obtain, symptom_detection, spilt_hypothesis_set]).
