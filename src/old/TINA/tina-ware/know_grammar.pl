/* file: grammar.pl 1.0.0 (USP LSI) Wed Mar 16 11:16:28 1994

    Copyright (c) 1994 Richard Victor Benjamins. All rights reserved.
    richard@lsi.usp.br

    Purpose: grammar for testing usability of PSMs to construct
	     diagnostic strategies
*/

/* The grammar, polluted with code to verify criteria
   and to built up the tree */


% methods for diagnosis
diagnosis(Fail, [prime_diagnostic_method, [SD, HG, HD]]) --> 
  {criteria(prime_diagnostic_method, F)}, 
		 		symptom_detection(SF, SD), 
				hypothesis_generation(HGF, HG), 
				hypothesis_discrimination(HDF, HD),
  {List = [F, SF, HGF, HDF],
  flatten(List, Fail)}.

% methods for symptom detection

symptom_detection(F, [ask_user_method, [user_judgement]]) --> 
 {criteria(ask_user_method, F)}, 
		        [user_judgement].
symptom_detection(F, [classify_method, [classify]]) --> 
  {criteria(classify_method, F)}, 
		                [classify].
symptom_detection(F, [compare_symptom_detection_method, 
		     [GE, C]]) -->
  {criteria(compare_symptom_detection_method, Fa)},
				generate_expectation(GEF, GE),
				compare(CF, C),
  {List = [Fa, GEF, CF],
  flatten(List, F)}.

% methods for the generate expectation task
generate_expectation(F, [lookup_method, [lookup]]) -->
  {criteria(lookup_method, F)},
			   	[lookup].
generate_expectation(F, [simulate_method, [simulate]]) -->
  {criteria(simulate_method, F)},
			       [simulate].

compare(F, [exact_compare_method, [equal_check]]) -->
  {criteria(exact_compare_method, F)},
				[equal_check].
compare(F, [threshold_compare_method, [determine_ratio, 
				      check_against_threshold]]) -->
  {criteria(threshold_compare_method, F)},
				[determine_ratio],
				[check_against_threshold].
% to make it a little faster 
% compare(F, [order_of_magnitude_compare_method, 
% 	    [determine_order_of_magnitude, compare]]) -->
%   {criteria(order_of_magnitude_compare_method, F)},
% 				[determine_order_of_magnitude],
% 				[compare].
% compare(F, [teleological_compare_method, [teleological_abstract,
% 					  compare]]) -->
%   {criteria(teleological_compare_method, F)},
% 				[teleological_abstract],
% 				[compare].
% compare(F, [statistical_compare_method, [statistical_compare]]) -->
%   {criteria(statistical_compare_method, F)},
% 				[statistical_compare].
% compare(F, [historical_compare_method, [historical_compare]]) -->
%   {criteria(historical_compare_method, F)},
% 				[historical_compare].
% 


% methods for hypothesis generation
hypothesis_generation(F, [compiled_hypothesis_generation_method,
			 [abstract, associate, probability_filter]]) -->
  {criteria(compiled_hypothesis_generation_method, F)},
	                        [abstract],
				[associate],
				[probability_filter].
hypothesis_generation(F, [model_based_hypothesis_generation_method,
			 [FC, TtH, PbF]]) --> 
  {criteria(model_based_hypothesis_generation_method, Fa)},
		  		find_contributors(FFC, FC),
				transform_to_hypothesis_set(THF, TtH),
				prediction_based_filtering(PFF, PbF),
  {List = [Fa, FFC, THF, PFF],
   flatten(List, F)}.

% methods for the find_contributors task
find_contributors(F, [trace_back_method, [find_upstream]]) --> 
  {criteria(trace_back_method, F)}, 
				[find_upstream].
find_contributors(F, [causal_covering_method, [causal_covering]]) --> 
  {criteria(causal_covering_method, F)},
				[causal_covering].
find_contributors(F, [prediction_based_method, [simulate]]) -->
  {criteria(prediction_based_method, F)},
				[simulate].

% Methods for the transform to hypothesis task
transform_to_hypothesis_set(F, [set_cover_transform_method,
			       [set_cover]]) -->
  {criteria(set_cover_transform_method, F)},
			       [set_cover].
transform_to_hypothesis_set(F, [intersection_method, [intersect]]) --> 
  {criteria(intersection_method, F)}, 
			        [intersect].
transform_to_hypothesis_set(F, [subset_minimality_transform_method,
		       [subset_minimality_cover]]) -->
 {criteria(subset_minimality_transform_method, F)},
		       [subset_minimality_cover].
transform_to_hypothesis_set(F, [cardinality_minimality_transform_method,
			       [cardinality_minimality_cover]]) -->
 {criteria(cardinality_minimality_transform_method, F)},
		       [cardinality_minimality_cover].

% methods for the prediction based filtering task
prediction_based_filtering(F, [constraint_suspension_method, 
			      [suspend_constraint, simulate_network,
			       check_consistency, keep]]) -->
  {criteria(constraint_suspension_method, F)},
			      [suspend_constraint],
			      [simulate_network], 
			      [check_consistency],
			      [keep].
prediction_based_filtering(F, [corroboration_method,
			      [dependency_analysis, compare, delete]]) -->
  {criteria(corroboration_method, F)},
			      [dependency_analysis],
			      [compare],
			      [delete].
prediction_based_filtering(F, [fault_simulation_method,
			      [select_fault_model, simulate_hypothesis,
			      compare, keep]]) -->
  {criteria(fault_simulation_method, F)},
			      [select_fault_model], 
			      [simulate_hypothesis],
			      [compare],
			      [keep].

% methods for the hypothesis discrimination task
hypothesis_discrimination(F, [hypothesis_discrimination_method, 
			     [SH, CD, symptom_detection, UH]]) -->
  {criteria(hypothesis_discrimination_method, Fa)}, 
			     select_hypothesis(FSH, SH),	
			     collect_data(FCD, CD),
			     [symptom_detection],
%			     symptom_detection(FSD, SD),
			     update_hypothesis_set(FUH, UH),
  {List = [Fa, FSH, FCD, FUH],
%   {List = [Fa, FSH, FCD, FSD, FUH],
   flatten(List, F)}.

% methods for the select hypothesis task
select_hypothesis(F, [random_select_hypothesis_method, [select_random]]) -->
  {criteria(random_select_hypothesis_method, F)},
			    [select_random].
select_hypothesis(F, [smart_select_hypothesis_method, [EC, 
		     order_hypothesis_set, select_first]]) -->
  {criteria(smart_select_hypothesis_method, Fa)},
			    estimate_cost_hypothesis_set(FEC, EC),
			    [order_hypothesis_set],
			    [select_first],
  {List = [FEC, Fa],
   flatten(List, F)}.

% methods for estimation of the cost of the hypothesis set
estimate_cost_hypothesis_set(F, [estimation_based_on_local_cost_method,
				[estimate_local_cost]]) -->
  {criteria(estimation_based_on_local_cost_method, F)},
				[estimate_local_cost].
estimate_cost_hypothesis_set(F, [estimation_based_on_number_method,
 				[estimate_number_of_tests]]) -->
   {criteria(estimation_based_on_number_method, F)},
 				[estimate_number_of_tests].
estimate_cost_hypothesis_set(F, [estimation_based_on_overall_cost_method,
				[estimate_overall_cost]]) -->
  {criteria(estimation_based_on_overall_cost_method, F)},
				[estimate_overall_cost].
% methods for collect_data
collect_data(F, [compiled_test_method, [compiled_test]]) -->
  {criteria(compiled_test_method, F)},
 			    [compiled_test].
collect_data(F, [probing_method, [measure, obtain]]) -->
  {criteria(probing_method, F)},
	                    [measure],
			    [obtain].
collect_data(F, [manipulating_method, [compute_input_vector,
 				       apply_input_vector, obtain]]) -->
  {criteria(manipulating_method, F)},
 			    [compute_input_vector],
 			    [apply_input_vector],
			    [obtain].
 
collect_data(F, [replace_method, [replace_hypothesis, obtain]]) -->
  {criteria(replace_method, F)},
			    [replace_hypothesis],
			    [obtain].

collect_data(F, [indicator_method, [compute_indicator, obtain]]) -->
  {criteria(replace_method, F)},
			    [compute_indicator],
			    [obtain].

% methods for the update_hypothesis_set_task
update_hypothesis_set(F, [interpret_in_isolation_method, [delete]]) -->
  {criteria(interpret_in_isolation_method, F)},
			    [delete].
update_hypothesis_set(F, [spilt_half_interpret_method, 
                         [spilt_hypothesis_set]]) -->
  {criteria(spilt_half_interpret_method, F)},
			    [spilt_hypothesis_set].
update_hypothesis_set(F, [model_based_hypothesis_generation_method,
		  [model_based_hypothesis_generation]]) -->
 {criteria(model_based_hypothesis_generation_method, F)},
	    [model_based_hypothesis_generation].



