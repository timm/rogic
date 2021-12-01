/*\documentclass[twocolumn,global]{svjour}
\usepackage{prod}\begin{document}

\theprogram{FAMILY} 
\thetocdepth{2} % e.g. 2
\thepapers{refs}
\thewp{~menzies/src/pl/prod/family.pl}
\thetitle{A family database}
\theauthor{Tim Menzies}
\theinstitute{Lane Department of Computer Science,
             West Virginia University,
             PO Box 6109, Morgantown,
             WV, 26506-6109, USA;\\
             \url{http://tim.menzies.us};
             \url{tim@menzies.us} 
             }
\thereference{memo5@.ai.wvu.2003. 
            Available from 
            \url{http://tim.menzies.com/pdf/03family.pdf}}
\theacknowledgement{This research was conducted at West Virginia
  University under NASA contract NCC2-0979. The work was sponsored by
  the NASA Office of Safety and Mission Assurance under the Software
  Assurance Research Program led by the NASA IV\&V Facility.  Reference
  herein to any specific commercial product, process, or service by
  trade name, trademark, manufacturer, or otherwise, does not constitute
  or imply its endorsement by the United States Government.}
\theabstract{A simple family database written in Prolog is described.
}
*/
%%%% Introduction
%The standard introductory Prolog example. Not sure where it came 
%from originally but I think it was Bratko~\cite{bratko01}.
%%%% The facts 
%%% The boys %<
male(alan).
male(david).
male(donald).
male(eric).
male(james).
male(john).
male(scott).
%>
%%% The girls %<
female(elizabeth).
female(emily).
female(florence).
female(jess).
female(katherine).
female(louise).
female(rebecca).
%>
%%% The parents  
%Definition of the \call{parent(Parent, Child)} relationship: 
%<
parent(james, david).
parent(james, louise).
parent(james, john).
parent(james, alan).
parent(florence, david).
parent(florence, louise).
parent(florence, john).
parent(florence, alan).
parent(david, scott).
parent(louise, rebecca).
parent(louise, eric).
parent(louise, katherine).
parent(alan, elizabeth).
parent(alan, emily).
parent(david,jessie).
parent(louise,donald).
%>
%%%% The rules  
%A mother is a female parent. 
%<
mother(Mother, Child):-
    parent(Mother, Child),
    female(Mother).        
%:A father is a male parent.
father(Father, Child):-
    parent(Father, Child),
    male(Father).      
%:A son is a male that has a parent. 
son(Parent, Son):-
    parent(Parent, Son),
    male(Son).
%:A daughter is a female that has a parent.
daughter(Parent, Daughter):-
    parent(Parent, Daughter),
    female(Daughter).
%:A grandparent is the parent of a parent. 
grandparent(GrandParent, GrandChild):-
    parent(GrandParent, Parent),
    parent(Parent, GrandChild).
%:An ancestor is a parent. 
ancestor(X,Y) :- parent(X,Y).
%:Also, an ancestor is also the parent of someone who is an ancestor. 
ancestor(X,Y) :- parent(X,Z), ancestor(Z,Y).
%>
%%%% Demonstrations
/* To demo the code, we need to:
\bi
\item Write a demo predicate that shows off our code in action.
 This is accomplished using
the \call{egfamily/0} predicate shown below. 
\item Trap the output to a file. This is accomplished using
the \call{Demos/1} predicate.
\item Include that file in this document. This is accomplished using
the following latex magic:
\begin{verbatim}
\SRC{egfamily.spy}{The family 
        database in action.}
\end{verbatim}
After that include, we can show the output in \fig{egfamily.spy}
and reference that figure using
\begin{verbatim}
 \fig{egfamily.spy}
\end{verbatim}
\ei

*/
%%% \call{Egfamily/0} 
%\SRC{egfamily.spy}{The family database in action.}
%<
egfamily:- % see \fig{egfamily.spy}
    forall(egfamily0(N,Goal,String,Results),
           egfamily1(N,Goal,String,Results)).

egfamily1(N,Goal,String,Results) :-
        format('\n::[~w]:::::::::::::::::::::::::\n',[N]),
        forall(Goal,
            format(String,Results)).
%>
%%% The test suite for \call{Egfamily/0} %<           
egfamily0(1,parent(X,david),
            'The parent of david is ~w.\n',[X]).
egfamily0(2,father(Dad,david),
            'The father of david is ~w.\n',[Dad]).
egfamily0(3,mother(Mom,david),
            'The mother of david is ~w.\n',[Mom]).
egfamily0(4,son(james,Son),
            'A son of james is ~w.\n',[Son]).
egfamily0(5,daughter(florence,Daugh),
            'A daughter of florence is ~w.\n',[Daugh]).
egfamily0(6,grandparent(florence,GP),
            'A grandparent of ~w is florence.\n',[GP]).            
egfamily0(7,ancestor(florence,Anc),
            'An ancestor of ~w is florence.\n',[Anc]).
%>
%%% \call{Demos/1}
/*
\call{Demos/1} runs a goal {\tt G} and catches the output to the file
{\tt G.spy}. Also, just so you know what is going on,
it runs the goal {\tt G} a second time and sends the output to the screen. 
*/
%<
demos(G) :-
    sformat(Out,'~w.spy',G),
    freshFile(Out),
    tell(Out),
    format('% output from '':- demos(~w).''\n\n',G),
        T1 is cputime,
    ignore(forall(G,true)),
    T2 is (cputime - T1),
    format('\n% runtime = ~w sec(s)\n',[T2]),
        told,
    format('% output from '':- demos(~w).''\n',G),  
        ignore(forall(G,true)),
    format('\n% runtime = ~w sec(s)',[T2]).
%>
/*
\call{Demos/1} needs a helper predicate. \call{FreshFile/1} 
makes sure that no one
else has scribbled, or is currently scribbling, on our output file.
*/
%<
freshFile(X) :- 
    (current_stream(X,_,S) -> close(S)       ; true),
    (exists_file(X)        -> delete_file(X) ; true).
%>
%%% Using \call{Demos/1}.
/* Next, we need to run the demo code as follows: 
\begin{LISTING}
?- demos(egfamily).
\end{LISTING}
Once that is done, then when this document will include the
output in \fig{egfamily.spy}.
*/
%%%% Bugs 
/* None known. */
/*
\theend
\end{document}
*/
