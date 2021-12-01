/* file: impl_prolog_lib.pl 1.0.0 (USP LSI) Thu Mar 17 18:47:48 1994

    Copyright (c) 1994 Richard Victor Benjamins. All rights reserved.
    richard@lsi.usp.br

    Purpose: define reusable procedures that have nothing to do with
	     the actual problem solving
*/

write_list_to_screen([]).
write_list_to_screen([H| T]):-
  tab(2), write(H), nl,
  write_list_to_screen(T).


