/* file: know_isa_crit.pl 1.0.0 (USP LSI) Sun Mar 20 16:46:48 1994

    Copyright (c) 1994 Richard Victor Benjamins. All rights reserved.
    richard@lsi.usp.br

    Purpose: Some more_specific relations between the criteria. To be 
	     used when a criterion is verified.
*/

/*    more_specific(x, y) means
      if x -> y
      if not(y) -> not(x)
*/


more_specific(expected_value_database, expected_values_obtainable).
more_specific(simulation_rules, expected_values_obtainable).
more_specific(complete_expected_value_database, expected_value_database).
more_specific(complete_fault_model, fault_behavior_constrained).
more_specific(fault_behavior_constrained, fault_simulation_rules).
more_specific(fault_simulation_rules, dependencies_in_model).
more_specific(dependencies_in_model, device_model).
more_specific(causal_model, dependencies_in_model).
more_specific(inference_rules, dependencies_in_model).
more_specific(simulation_rules, dependencies_in_model).
more_specific(correct_device_model, device_model).
more_specific(local_cost_info, cost_info).
more_specific(device_accessible, cost_info).
more_specific(components_easy_reachable, device_accessible).
more_specific(reachability_equal, device_accessible).
more_specific(measuring_point_reachable, device_accessible).
more_specific(components_replaceable, device_accessible).
more_specific(component_hypotheses, hypotheses_can_be_generated).
more_specific(hypothesis_set_dependent, hypotheses_can_be_generated).
more_specific(hypothesis_set_independent, hypotheses_can_be_generated).
more_specific(independence_of_hypotheses, hypotheses_can_be_generated).
more_specific(exhaustivity_assumption, hypotheses_can_be_generated).
more_specific(empirical_associations, hypotheses_can_be_generated).
more_specific(complete_association_set, empirical_associations).
