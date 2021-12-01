%%%% Show license 
%A cheery hellow.

hello :- 
	about(program,N),
	about(version,V),
	about(copyright,Y),
	about(motto,M),
	about(copywho,C),
	format('~w version ~w\n Copyright (C) ~w by ~w\n',
	       [N,V,Y,C]),
	format(' "~w"\n\n~w ~w ',[M,N,V]),
	chars('doc/nowarranty.txt'),nl.
%>
%Print the warranty (short).
%<
warranty :-
	about(program,P),
	about(copyright,Y),
	about(copywho,C),	
	format('~w by ~w\n Copyright (C) ~w\n\n',[P,C,Y]),
	chars('doc/warranty.txt'),nl. % see \tion{war}
%>
%Print the whole license (see back of this files
%<
conditions :-
	chars('doc/conditions.txt'),nl.
%>
