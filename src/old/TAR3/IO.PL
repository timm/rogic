
spit(N1,N2,X) :-
	(1 is N1 mod N2 -> spit(X) ; true).

spit(X) :- `verbose,!,write(user,X),flush_output(user).
spit(_).

chars(F) :- see(F), get_byte(X), ignore(chars1(X)), seen.
    
chars1(-1) :- !.
chars1(X)  :- put(X), get_byte(Y), chars1(Y).
