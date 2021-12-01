/* file: criteria.pl 1.0.0 (USP LSI) Thu Mar 17 11:44:54 1994

    Copyright (c) 1994 Richard Victor Benjamins. All rights reserved.
    richard@lsi.usp.br

    Purpose: define the suitability criteria of the PSMs
*/

/*:- module(criteria, [
	  assumption/3,
	  epistemological/3,
	  environmental/3
		    ]
	 ).
*/
:- discontiguous
	epistemological/3,
	environmental/3,
	assumption/3.

% CRITERIA FOR THE PRIME DIAGNOSTIC METHOD

assumption(prime_diagnostic_method, hypotheses_can_be_generated, necessary).
environmental(prime_diagnostic_method, additional_observations,
              necessary).

%---------------------------------------------------
% Criteria method ask_user_method for symptom detection
%---------------------------------------------------
environmental(ask_user_method, user_knowledgeable_symptoms, necessary).

% CLASSIFY_METHOD
epistemological(classify_method, knowledge_for_classifying_symptoms, 
                necessary).

% COMPARE SYMPTOM DETECTION METHOD
epistemological(compare_symptom_detection_method, expected_values_obtainable,
                necessary).

% LOOKUP METHOD FOR GENERATE EXPECTATION
epistemological(lookup_method, expected_value_database, necessary).
assumption(lookup_method, complete_expected_value_database, necessary).

% SIMULATE METHOD FOR GENERATE EXPECTATION
epistemological(simulate_method, simulation_rules, necessary).

% EXACT COMPARE METHOD FOR COMPARE
environmental(exact_compare_method, precise_values, necessary).

% ORDER OF MAGNITUDE COMPARE
environmental(order_of_magnitude_compare_method, imprecise_values, necessary).

% THRESHOLD COMPARE
epistemological(threshold_compare_method, threshold_info, necessary).
environmental(threshold_compare_method, imprecise_values, necessary).

% TELEOLOGICAL COMPARE METHOD
epistemological(teleological_compare_method, knowledge_about_teleology,
                necessary).

% STATISTICAL COMPARE METHOD
epistemological(statistical_compare_method, statistical_info, necessary).

% HISTORICAL COMPARE METHOD
epistemological(historical_compare_method, historical_info, necessary).
environmental(historical_compare_method, device_stable_in_time, necessary).

% CRITERIA FOR THE COMPILED HYPOTHESIS GENERATION METHOD
epistemological(compiled_hypothesis_generation_method,	empirical_associations,
                necessary).
epistemological(compiled_hypothesis_generation_method, 
                probability_information, necessary).
assumption(compiled_hypothesis_generation_method, complete_association_set,
           necessary).

%---------------------------------------------------
% Criteria method model_based_hypothesis_generation_method for 
% hypothesis generation
%---------------------------------------------------
epistemological(model_based_hypothesis_generation_method, device_model, 
	        necessary).
assumption(model_based_hypothesis_generation_method, 
           non_intermittency_assumption, necessary).

% TRACE_BACK_METHOD FOR FIND CONTRBUTORS
epistemological(trace_back_method, dependencies_in_model, necessary).
% epistemological(trace_back_method, correct_device_model, necessary).

% CAUSAL COVERING METHOD FOR FIND CONTRIBUTORS
epistemological(causal_covering_method, causal_model, necessary).
assumption(causal_covering_method, exhaustivity_assumption, necessary).

% PREDICTION BASED METHOD FOR FIND CONTRIBUTORS
epistemological(prediction_based_method, simulation_rules, necessary).
epistemological(prediction_based_method, inference_rules, useful).

% CRITERIA FOR SET COVER TRANSFORM TO HYPOTHSIS SET METHOD
assumption(set_cover_transform_method, independence_of_hypotheses,
           necessary).

% CRITERIA FOR SUBSET MINIMALITY COVER
epistemological(subset_minimality_transform_method, fault_behavior_not_constrained,
                necessary).
assumption(subset_minimality_transform_method, independence_of_hypotheses,
           necessary).

assumption(cardinality_minimality_transform_method, independence_of_hypotheses,
           necessary).
environmental(cardinality_minimality_transform_method, failure_rates_equal,
              necessary).

% INTERSECTION_METHOD
assumption(intersection_method, single_fault_assumption, necessary).

% CRITERIA FOR THE CONSTRAINT SUSPENSION METHOD
epistemological(constraint_suspension_method, simulation_rules, necessary).
epistemological(constraint_suspension_method, inference_rules, necessary).
environmental(constraint_suspension_method, 
              many_initial_observations, useful).
assumption(constraint_suspension_method, single_fault_assumption, useful).

% CRITERIA FOR THE CORROBORATION METHOD
% epistemological(corroboration_method, simulation_rules, necessary).
epistemological(corroboration_method, dependencies_in_model, necessary).
assumption(corroboration_method, no_fault_masking, necessary).
environmental(corroboration_method, many_initial_observations, useful).

%-----------------------------------------------------------------
% Criteria for fault_simulation_method prediction based filtering
%-----------------------------------------------------------------
assumption(fault_simulation_method, complete_fault_model, necessary).
epistemological(fault_simulation_method, fault_simulation_rules, necessary).
environmental(fault_simulation_method, many_initial_observations, useful).

% DISCRIMINATION_METHOD
assumption(hypothesis_discrimination_method, non_intermittency_assumption, 
           necessary).

% SELECT RANDOM HYPOTHESIS SET
epistemological(random_select_hypothesis_method, hypothesis_set_independent,
                necessary).

% SMART HYPOTHESIS SELECTION
epistemological(smart_select_hypothesis_method, cost_info, necessary).

% CRITERIA FOR ESTIMATION BASED ON LOCAL COST
epistemological(estimation_based_on_local_cost_method, local_cost_info, 
                necessary).
epistemological(estimation_based_on_local_cost_method, 
                hypothesis_set_independent, necessary).

% CRITERIA FOR ESTIMATION BASED ON NUMBER OF TESTS
% epistemological(estimation_based_on_number_method, hypothesis_set_dependent,
%                 necessary). DYNAMIC
environmental(estimation_based_on_number_method, reachability_equal,
              necessary).
environmental(estimation_based_on_number_method, failure_rates_equal,
              necessary).

% CRITERIA FOR ESTIMATION BASED ON OVERALL COST
% epistemological(estimation_based_on_overall_cost_method,
%                 hypothesis_set_dependent, necessary). DYNAMIC
epistemological(estimation_based_on_overall_cost_method, cost_info,
                necessary).

% CRITERIA FOR THE COMPILED TEST METHOD
epistemological(compiled_test_method, tests_associated_to_hypotheses,
                necessary).

%-----------------------------------------------------------------
% Criteria for the probing_method
%-----------------------------------------------------------------
environmental(probing_method, device_accessible, necessary).
environmental(probing_method, measuring_tools, necessary).

%---------------------------------------------
% Criteria for the manipulating_method
%---------------------------------------------
epistemological(manipulating_method, simulation_rules, necessary).
epistemological(manipulating_method, inference_rules, necessary).
epistemological(manipulating_method, no_net_fanout_structure, necessary).

% CRITERIA FOR THE REPLACE METHOD
%---------------------------------------------
epistemological(replace_method, component_hypotheses, necessary).
environmental(replace_method, components_replaceable, necessary).
environmental(replace_method, components_easy_replaceable, useful).

% CRITERIA FOR THE INDICATOR METHOD
%---------------------------------------------
epistemological(indicator_method, simulation_rules, necessary).


% CRITERIA FOR THE INTERPRET IN ISOLATION METOHD
epistemological(interpret_in_isolation_method, hypothesis_set_independent,
                necessary).

% CRITERIA FOR THE SPILT HALF INTERPRET METHOD
% epistemological(spilt_half_interpret_method, hypothesis_set_dependent,
%                 necessary). DYNAMIC
% epistemological(spilt_half_interpret_method, hypothesis_set_dependent,
%                 useful). DYNAMIC
assumption(spilt_half_interpret_method, single_fault_assumption, necessary).
