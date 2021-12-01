%%%% Show license 
%A cheery hellow.
%<
hello :- 
	[program,version,copyright,motto,copywho]:=[N,V,Y,M,C],
	format('~s version ~s\n Copyright (C) ~s by ~s\n',
	       [N,V,Y,C]),
	format(' "~s"\n\n~s ~s ',[M,N,V]),
	chars('nowarranty.txt'). 
%>
%Print the warranty (short).
%<
warranty :-
	[program,copyright,copywho]:=[P, Y,C],
	format('~s by ~s\n Copyright (C) ~s\n\n',[P,C,Y]),
	chars('warranty.txt'),nl. % see \tion{war}
%>
%Print the whole license (see back of this files
%<
conditions :-
	chars('conditions.txt'),nl.
%>