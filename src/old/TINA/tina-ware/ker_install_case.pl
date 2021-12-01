/* file: ker_install_case.pl 1.0.0 (USP LSI) Sun Mar 20 17:58:56 1994

    Copyright (c) 1994 Richard Victor Benjamins. All rights reserved.
    richard@lsi.usp.br

    Purpose: user interactive definition of case situation,
	     or alternatively, install *all* criteria
*/

install_case_situation:-
  writeln(['A situation is defined by characteristics of the case domain.',
	    nl]),
  ask_question(['There are some pre-specified situation from which you',
                'have to choose.'], [technical_domain_simple, 
				    technical_domain_complex,
				    camcorder,
				    almost_camcorder,
				    medical_domain,
				    empirical_domain],
		[Situation]),
  fetch_situation(Situation),
  writeln(['The situation is the following:', nl]),
  get_and_show_situation, nl.

get_and_show_situation:-
  findall(Sit, situation(Sit), List),
  write_list_to_screen(List), 
  get_single_char(_).

fetch_situation(technical_domain_simple):-
  technical_domain_simple(TechnicalCriteria),
  install_each(TechnicalCriteria).
fetch_situation(technical_domain_complex):-
  technical_domain_complex(TechnicalCriteria),
  install_each(TechnicalCriteria).
fetch_situation(medical_domain):-
  medical_domain(MedicalCriteria),
  install_each(MedicalCriteria).
fetch_situation(empirical_domain):-
  empirical_domain(MedicalCriteria),
  install_each(MedicalCriteria).
fetch_situation(camcorder):-
  camcorder(CamcorderCriteria),
  install_each(CamcorderCriteria).
fetch_situation(almost_camcorder):-
  almost_camcorder(CamcorderCriteria),
  install_each(CamcorderCriteria).

install_each([]).
install_each([H| T]):-
  assert(situation(H)),
  install_each(T).

technical_domain_simple([
	% epistemological 
	component_hypotheses,
	correct_device_model,
	dependencies_in_model,
	device_model,
	fault_behavior_constrained,
%	hypothesis_set_dependent,
	inference_rules,
	simulation_rules,
	% environmental 
	additional_observations,
	components_replaceable,
	device_accessible,
	failure_rates_equal,
	measuring_points_reachable,
	measuring_tools,
	precise_values,
	reachability_equal,
	% assumptions
	hypotheses_can_be_generated,
	independence_of_hypotheses,
	no_fault_masking,
	non_intermittency_assumption,
	single_fault_assumption
			        ]).

technical_domain_complex([
	% EPISTEMOLOGICAL 
	component_hypotheses,
	correct_device_model,
	cost_info,
	dependencies_in_model,
	device_model,
	fault_behavior_constrained,
	fault_simulation_rules,
%	hypothesis_set_dependent,
	inference_rules,
	local_cost_info,
	simulation_rules,
	threshold_info,
	no_net_fanout_structure,
	% ENVIRONMENTAL 
	additional_observations,
	imprecise_values,
	% ASSUMPTIONS
	hypotheses_can_be_generated,
	independence_of_hypotheses,
	non_intermittency_assumption
		         ]).

medical_domain([
	% EPISTEMOLOGICAL
	causal_model,
	cost_info,
	dependencies_in_model,
	empirical_associations,
	expected_value_database,
	expected_values_obtainable,
	fault_behavior_constrained,
	fault_simulation_rules,
%	hypothesis_set_dependent,
	tests_associated_to_hypotheses,
	% ENVIRONMENTAL
	additional_observations,
	imprecise_values,
	user_knowledgeable_symptoms,
	% ASSUMPTIONS
	complete_association_set,
	complete_expected_value_database,
	complete_fault_model,
	exhaustivity_assumption,
	single_fault_assumption,
	hypotheses_can_be_generated,
	non_intermittency_assumption
		       ]).

empirical_domain([
	% epistemological .
	probability_information,
	hypothesis_set_independent,
	tests_associated_to_hypotheses,
	% environmental 
	additional_observations,
	user_knowledgeable_symptoms,
	% assumptions
	complete_association_set,
	non_intermittency_assumption,
	single_fault_assumption
		         ]).

camcorder([
	% epistemological 
	component_hypotheses,
	cost_info,
	dependencies_in_model,
	device_model,
%	expected_value_database,   % implicit in the assumption complete.
%	hypothesis_set_dependent,
	local_cost_info,
	threshold_info,
	% environmental 
	additional_observations,
	components_replaceable,
	device_accessible,
	imprecise_values,
	measuring_points_reachable,
	measuring_tools,
	% assumptions
	complete_expected_value_database,
	hypotheses_can_be_generated,
	no_fault_masking,
	non_intermittency_assumption,
	single_fault_assumption
		         ]).
almost_camcorder([
	% epistemological 
	component_hypotheses,
	cost_info,
	dependencies_in_model,
	device_model,
%	hypothesis_set_dependent,
	local_cost_info,
%	threshold_info,
	% environmental 
	additional_observations,
	components_replaceable,
	device_accessible,
	imprecise_values,
	measuring_points_reachable,
	measuring_tools,
	% assumptions
%	complete_expected_value_database,
	hypotheses_can_be_generated,
	no_fault_masking,
	non_intermittency_assumption,
	single_fault_assumption
		         ]).

