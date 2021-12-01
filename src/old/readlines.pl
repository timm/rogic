/*
Timm's very simple line reader.
Does not handle punctuation or compound
terms (exercise for reader).
Not one cut in the whole thing
*/

line2atoms(Atoms) :-
	%read line to list of chars
	line(Line),  
	%lists of non-blank items
	once(blacks(Letters,Line,_)), 
	% convert sub-lists to atoms
	maplist(name,Atoms,Letters). 

line(X) :- get0(C), line1(C,X).
line1(X,L) :- once(line0(X,Y)), line2(Y,L).

line0(-1,eof). line0(10,eof). line0(X,char(X)).

line2(eof, [-1]).
line2(char(X),[X|Rest]) :- get0(C), line1(C,Rest).

blacks([B|Bs]) --> black(B), blacks(Bs).
blacks([B]) --> black(B).

black(B) --> whites, black1(B), white.

whites --> white, whites.
whites --> [].

black1([H|T]) --> \+white, [H], black1(T).
black1([H]) --> \+white, [H].

% definition of white space
white --> [-1]. % end of input
white --> [10]. % new lines
white --> [9].  % tabe
white --> [32]. % space