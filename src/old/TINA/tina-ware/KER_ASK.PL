/* file: ker_ask.pl 1.0.0 (USP LSI) Sun Mar 20 13:30:59 1994

    Copyright (c) 1994 Richard Victor Benjamins. All rights reserved.
    richard@lsi.usp.br

    Purpose: ask user for constraints concerning strategies to 
	     present.
*/

get_user_info(MethodNumber, CritType, CritNumber):-
  writeln(['How many methods of each strategy can have unfulfilled criteria?',
	   nl, '(any number or "dontcare".)']),
  read(MethodNumber), nl,
  ask_question(['What criteria type might be relaxed?'],
               [epistemological, assumption, environmental, dontcare],
 	       [CritAnswer]), 
  shrink(CritAnswer, CritType),
  check_dontcare(CritType, CritNumber).

check_dontcare(dontcare, dontcare):- !.
check_dontcare(CritType, CritNumber):-
  shrink(Type, CritType),
  writeln(['How many failed', Type, 'criteria do you allow for each',
		'method?', nl, 'Note that the other types should be without',
		'problems to pass!', nl, '(any number or "dontcare".)']),
  read(CritNumber), nl.

shrink(epistemological, epist).
shrink(assumption, assum).
shrink(environmental, envir).
shrink(dontcare, dontcare).
