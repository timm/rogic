% meta-interpreter: solve
% Interpreter solve can
% 1. modify the Possibility_true/Possibility_false value of places
% 2. 
% notes: 
% 1. putting not(Goal) in front of (Goal) so that all the not(A) will unify with solve(not(Goal)) first. 

% and is used for randomly firing premise places
:- 	op(925,xfy,and),
	op(1,fx,not).
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

% Case 1: place is known
% stop solving if it is absolutely true/false. (aka grounding)

% solve(?X,-X)
solve(A,B) :- solve1(A,B),!.

solve1(Goal, _Rule) :-
	place(_Id, Goal, _Type, _Possibility_true, _Possibility_false, y).

solve1(not(Goal), _Rule) :- 
	place(Id, Goal, Type, Possibility_true, Possibility_false, Stable),
	untruly(place(Id, Goal, Type, Possibility_true, Possibility_false, Stable)),
	ground_place(not(Goal)).
 
solve1(Goal, _Rule) :-
	Goal \= not(_),
	place(Id, Goal, Type, Possibility_true, Possibility_false, Stable),
	truly(place(Id, Goal, Type, Possibility_true, Possibility_false, Stable)),
	ground_place(Goal).
	
	
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

% The following cases of solve/1 will run until the places are stable. 

% Case 2: goal place does not exist and premises can be unified
% Generate goal place iff the premises (places + conditions) are satisfied and
% that the min(possibility value of all premise places) exceeds the threshold.
% The possibility_true/false value of the goal place is the 
% min(CF_rule, min(possibility value of all premise places)), aka FTT of a 
% particular rule/transition.

% Note that Premises contains both conditions and places
% first we apply solve() to all the premises that are places, 
% then we find if it passes the threshold
% afterwards we call the premises and see if it unifies, 
% if it can be unified, then we generate the new goal place with
% FBM = min(CF_rule, min(possibility value of all premise places))

solve(not(Goal), _Rule) :-
	\+ place(_,Goal,_,_,_,_),
	rule((not(Goal) :- (Premises)), CF, TH), 
	forall(member(Premise, Premises), solve(Premise, Intermediate_value, _Rule)),
	above_threshold(Intermediate_value, TH), 
	call(Premises),
	get_FTT(New_FBM, CF, Intermediate_value), 
	generate_place(Goal, dependent, 0, New_FBM, n), !.
	
solve(Goal, _Rule) :-
	\+ place(_,Goal,_,_,_,_),
	rule((Goal :- (Premises)), CF, TH), 
	forall(member(Premise, Premises), solve(Premise, Intermediate_value, _Rule)),
	above_threshold(Intermediate_value, TH), 
	call(Premises),
	get_FTT(New_FBM, CF, Intermediate_value), 
	generate_place(Goal, dependent, New_FBM, 0, n), !.

% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
	
% The deMorgan process for expanding the FPN will not generate new places, 
% yet it will modify the possibility_true/false values of the places.	
% Case 3: goal place exists and premises can be unified
% Since more then one transition affects the possibility_true/false value of 
% this value will be the max(FTT of each rule that lead to the goal place).
% no place is generated, yet the possibility_true/false value is modified. 

% forward expansion and backward expansion should both be handled..... tough. 
% algorithm: 
% 1. check if a goal place exists
% 2. find the premises of the goal
%	note: not necessary to check for the conditions
% 	note: (for forward expansion, concern with the premises places only)
% 	note: (for forward expansion, should not do not(Goal)!!!??? as it is stated on pg 83 of the thesis)
% 3. if all the premise places exists and the premise place is more than 1
%     , and the rule involved is not not(Goal), then
%	a. solve(not(Goal), I1)
%	b. find all the premise places with find_premise_that_are_places/2
%	c. for each of the premise places, expand

% forward expansion: 
solve(Goal, _Rule) :-
	% since we concern about the consequence if not(Goal), the Possibility_false
	% of goal is taken to compare with threshold
	% @ Question: TRUE??????
	place(_,Goal,_,_,Possibility_false,_),
	rule((Goal :- (Premises)), CF, TH), 
	above_threshold(Possibility_false, TH), 
	find_premise_that_are_places(Premises, Premise_places), 
	expand(Goal, Premise_places, CF, TH),!.
	
% backward expansion: if goal exists but not the premise
% @Questions: does backward expansion deals with deMorgan? 
% or expanding normally (i.e. no deMorgan)
% @NOTE: not done with this part!!!

% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% Case 4: goal exists, execute goal_driven rules
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

% Case 5: multiple places as premises to a particular goal rule
% adding randomness to which one is to be first proven
% @NOTE: question.... is this REALLY necessary...? 
% note: the minimum intermediate value is taken from all the premises

solve((Premise and Premises), Intermediate_value, _Rule) :-
	N is random(10000), 
	((N > 5000)-> 
		(	solve(Premises, I2, _Rule), 
			solve(Premise, I1, _Rule), 
			Intermediate_value = min(I1,I2)); 
		(	solve(Premise, I1, _Rule),
			solve(Premises, I2, _Rule),
			Intermediate_value = min(I1,I2))
		),!. 

% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

% Case 6: premise place exists, yet goal is not totally ture/untrue. 
% The intermediate value is for the calculation of FTT
% Can add some print graph instructions

solve(not(Premise), Intermediate_value, _Rule) :-
	place(_id, Premise, _type, _possibility_true, Intermediate_value, _stable),
	% @NOTE: as not(Premises) is needed for Goals requiring negation for certain premises
	assert_once(not(Premise)),!. 

solve(Premise, Intermediate_value, _Rule) :-
	place(_id, Premise, _type, Intermediate_value, _possibility_false, _stable),
	assert_once(Premise),!.
	
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

% case 7: shall all fails, call it. 
%solve(not(Goal)) :-
%	call(not(Goal)).
%solve(Goal) :-
%	call(Goal).
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

% get_FTT/3
% 	argument 1 is the new FTT
% 	argument 2 is the confident factor
% 	argument 3 is the intermediate value
% min(CF_rule, min(possibility value of all premise places))
get_FTT(New_FTT, CF, I) :-
	New_FTT is min(CF, I).

% get_FBM/3
% 	argument 1 is the new FBM
% 	argument 2 is the old FBM
% 	argument 3 is the incoming FTT
% find the FBM of a place; it is the max(all FTT to the place)
get_FBM(New_FBM, Old_FBM, Incoming_FTT):-
	New_FBM is max(Old_FBM, Incoming_FTT).

% generate_place/5
% 	argument 1 is the new Goal
% 	argument 2 is the type of the place
% 	argument 3 is the Possibility_true value
% 	argument 4 is the Possibility_false value
% 	argument 5 is the stablility

generate_place(Goal, Type, Possibility_true, Possibility_false, Stability) :-
	id_count(Id), 
	assert(place(Id, Goal, Type, Possibility_true, Possibility_false, Stability)), 
	New_Id is (Id + 1), 
	retract(id_count(Id)), assert(id_count(New_Id)). 

% change_place/2
% 	argument 1 is the old place
% 	argument 2 is the new place
% all it is gonna do is to retract the old and assert the new
change_place(Old, New) :-
	retract(Old), assert(New).

% assert_once/1
% 	argument 1 is a fact
assert_once(Fact) :-
	\+ Fact, 
	assert(Fact).

% truly/1
% 	argument 1 is a place(assumption/bubbles at the FPN graph)
% place is true when Possibility_true=100
% note: cannot use positive value and negative value to distinguish
% Possibility_true and Possibility_false because of the calculation of
% the intermediate value.
truly(place(_Id, _Goal, _Type, Possibility_true, _Possibility_false, _Stable)):-
	Possibility_true = 100.

% untruly/1
% 	argument 1 is a place(assumption/bubbles at the FPN graph)
% place is untrue when Possibility_false = -100
untruly(place(_Id, _Goal, _Type, _Possibility_true, Possibility_false, _Stable)):-
	Possibility_false = 100.
	
%above_threshold/2
%	argument 1 is a value to be compared to the threshold
%	argument 2 is a threshold for pruning
above_threshold(Intermediate_value, Threshold):-
	Intermediate_value >= Threshold. 
	
% find_premises
find_premise_that_are_places([],_):-fail.
find_premise_that_are_places([H|_Premises], Premise_places):-
	H=(_P1 and _P2), !, Premise_places is H. 
find_premise_that_are_places([_H|Premises], Premise_places):-
	find_premise_that_are_places(Premises, Premise_places).

%num_ands/2
%calculate the number of premises at a P and P and P statement
num_ands((P1 and P2), Count):-
	num_ands((P1 and P2), 0, Count). 
num_ands((_P1 and P2), Old_Count, Count):-
	New_Count is (Old_Count+1),
	num_ands(P2, New_Count, Count).
num_ands(_,Count , New_Count):-
	New_Count is (Count+1).

% is_stable/3
%	argument 1 is the New Stablility, either y or n
%	argument 2 is the Old_value
%	argument 3 is the New_value
is_stable(Stability, Old, New) :-
	stability(Diff),  % set at config file
	D is (Old - New), 
	DD is abs(D), 
	(DD =< Diff -> 
		Stability is y; 
		Stability is n). 

% expand/4
%	argument 1 is the Goal
%	argument 2 is the Premises
%	argument 3 is the confident factor
%	argument 4 is the threshold
% expand/2 is used for the deMorgan expansion of Goal and Premise places
% each time the expand/2 executes, the Premises(P and P') are seperated into
% head_premise and rest_premise.  Then solve(not(Goal)) and solve(P') is
% performed, and the FBM of the head_premise will be changed. 
% Since the Premises have to be more than one (i.e. always P1 and P2 and P3 and ..., never P)
% no need to worry about solving single Premise

expand(Goal, Premises, CF, TH) :-
	num_ands(Premises, Count),
	expand(Goal, Premises, CF, TH, Count). 
expand(_,_,_,_,1) :-!.
expand(Goal, Premises, CF, TH, Count):-
	New_Count is (Count-1), 
	Premises = P1 and P2, 
	New_Premises = P2 and P1, %circular list
	N is random(10000), 
	((N > 5000)-> 
		(	expand(Goal, New_Premises, CF, TH, New_Count), 
			process_expansion(Goal, P1, P2, CF, TH)); 
		(	process_expansion(Goal, P1, P2, CF, TH), 
			expand(Goal, New_Premises, CF, TH, New_Count))
		). 	

%process_expansion 

% backward expansion,when dealing with not(Goal)
process_expansion(not(Goal), Head_Premise, Rest_Premises, CF, TH) :-
	solve(Goal, I1, _Rule), 
	solve(Rest_Premises, I2, _Rule), 
	Intermediate_value = min(I1,I2), 
	above_threshold(Intermediate_value, TH), 
	get_FTT(New_FTT, CF, Intermediate_value), 
	place(Id, Head_Premise, Type, Old_FBM, Possibility_false, Stable), 
	get_FBM(New_FBM, Old_FBM, New_FTT), 
	is_stable(New_stability, Old_FBM, New_FBM),
	change_place( 	place(Id, Head_Premise, Type, Old_FBM, Possibility_false, Stable), 
			place(Id, Head_Premise, Type, New_FBM, Possibility_false, New_stability)).

%forward_expansion, when dealing with Goal
process_expansion(Goal, Head_Premise, Rest_Premises, CF, TH) :-
	solve(not(Goal), I1, _Rule), 
	solve(Rest_Premises, I2, _Rule), 
	Intermediate_value = min(I1,I2), 
	above_threshold(Intermediate_value, TH), 
	get_FTT(New_FTT, CF, Intermediate_value), 
	place(Id, Head_Premise, Type, Possibility_true, Old_FBM, Stable), 
	get_FBM(New_FBM, Old_FBM, New_FTT), 
	is_stable(New_stability, Old_FBM, New_FBM),
	change_place( 	place(Id, Head_Premise, Type, Possibility_true, Old_FBM, Stable), 
			place(Id, Head_Premise, Type, Possibility_true, New_FBM, New_stability)).
	