%%%% Pre-load actions  
%%% Operators 
%Define an operator to handle numberic ranges
%\call{Min to Max}.
%<
:- op(1,xfx, to).
%>
%%% Flags 
%Define an \call{inf}inity function. 
%<
:- arithmetic_function(inf/0).
%>
%Define a \call{rand}om function.
%<
:- arithmetic_function(rand/0).
%>
%Define a \call{rand(Min,Max)} function.
%<
:- arithmetic_function(rand/2).
%>
%Define a \call{rand(Min,Max,Mean)} function.
%<
:- arithmetic_function(rand/3).
%>
%Define a \call{normal} function.
%<
:- arithmetic_function(normal/2).
%>
%Define a \call{beta} function.
%<
:- arithmetic_function(beta/1).
%>
%Define a \call{gamma} function.
%<
:- arithmetic_function(gamma/2).
%>
%Add a ``left-justify'' command to \call{format}.
%<
:- format_predicate('>',padChars(_,_)).
%>
%Add a ``right-justify'' command to \call{format}.
%<
:- format_predicate('<',charsPad(_,_)).
%>
%Add a ``print squiggles'' command to \call{format}.
%<
:- format_predicate('S',squiggle(_,_)).
%>
%Define a predicate for the lookup tables.
%<
:- discontiguous lookUp1/4.
:- multifile lookUp1/4.
:- index(lookUp1(1,1,1,0)).
%>
%%% Hooks 
%A hook for lookup tables.
%<
term_expansion(Table = ColsRows , Out) :- 
    nonvar(ColsRows),
    ColsRows = (Cols+Rows),
    lookUpTable(Table=Cols+Rows,Out). 
%>
