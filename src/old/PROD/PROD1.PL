/*\documentclass[twocolumn,global]{svjour}
\usepackage{prod}\begin{document}

\theprogram{PROD1}
\thetocdepth{2}
\thepapers{refs}
\thewp{~menzies/src/pl/prod/prod0.tex}
\thetitle{An example of the {\PROD}\newline Prolog delivery and documentation system}
\theauthor{Tim Menzies\inst{1}, Sant A. Clause\inst{2}}
\theinstitute{Lane Department of Computer Science,
             West Virginia University,
             PO Box 6109, Morgantown,
             WV, 26506-6109, USA;\\
             \url{http://tim.menzies.us};
             \url{tim@menzies.us} 
             \and
            Artic Software Solutions: 
              no ice cube too small, no iceberg too big;\\
             \url{http://north.pole/~santac};
             \url{santa@north.pole}
}
\thereference{memo1@ai.wvu.2003. 
            Available from 
            \url{http://tim.menzies.com/pdf/03prod1.pdf}
}
\theacknowledgement{This research was conducted at West Virginia
  University under NASA contract NCC2-0979. The work was sponsored by
  the NASA Office of Safety and Mission Assurance under the Software
  Assurance Research Program led by the NASA IV\&V Facility.  Reference
  herein to any specific commercial product, process, or service by
  trade name, trademark, manufacturer, or otherwise, does not constitute
  or imply its endorsement by the United States Government.
}
\theabstract{This document is a minimal example of
            using the {\PROD} Prolog documentation and
            delivery  system.
}
*/
%%%% Introduction 
/* Here is some explanation text of a Prolog program. 
This document describes a little
SWI-Prolog~\cite{swiprolog} utility for summing numbers 
(Prolog is a useful language for rapdily building
systems~\cite{der96,me89zb,bratko01,ok90,sterling94}).
This utility is so small that this level of documentation is clearly
ridiculous. However, for larger Prolog programs, this kind
of documentation can be very useful.
*/
%%%% {\tt Sum/2} 
/* {\tt Sum/2} sums a list using tail recursion. 
*/
%%% About Tail Recursion
/* In tail recursion, the recursive
call is the last sub-goal in the body. Tail recursive calls can be optimized
as follows. On the stack of current goals, the head goal can be replaced 
by the tail recursive call (since they both have the same functor and
arity). Hence, tail recursive calls don't use the same amount of stack
memory as non-tail-recursive calls.

The trick to tail recursion is a {\em carry variable} that holds the
result seen too date.  
*/
%%%% Implementation
/* First, we need to handle the special case of an empty list. 
*/
%<
sum([],0).
%>
/* In the case of {\tt sum/2}, we initialize this 
carry variable to the head of the list being summed. 
*/
%<
sum([H|T],S) :- sum(T,H,S).
%>
/* The rest of the implementation just adds the head of the
current list to the carry variable, then passes the result to
the recursive call. 
*/
%<
sum([],S,S).
sum([H|T],In,Out) :- Temp is H + In, sum(T,Temp,Out).
%>
%%%% Demonstrations
/* To demo the code, we need to:
\bi
\item Write a demo predicate that shows off our code in action.
 This is accomplished using
the {\tt egsum/0} predicate shown below. 
\item Trap the output to a file. This is accomplished using
the {\tt Demos/1} predicate.
\item Include that file in this document. This is accomplished using
the following latex magic:
\begin{verbatim}
\SRC{egsum.spy}{{\tt Sum/2} in action}
\end{verbatim}
After that include, we can show the output in \fig{egsum.spy}
and reference that figure using
\begin{verbatim}
 \fig{egsum.spy}
\end{verbatim}
\ei

*/
%%% {\tt Egsum/0} 
%\SRC{egsum.spy}{{\tt Sum/2} in action}
%<
egsum :- % see \fig{egsum.spy}
    Numbers = 
          [[2,5,8,1,3,4]
          ,[]
          ,[2,10,7]
          ,[3]
          ],
    forall(member(Nums,Numbers),
              (sum(Nums,Sum),
           format('The sum of ~w is ~w.\n',[Nums,Sum]))).
%>
%%% {\tt Demos/1}
/*
{\tt Demos/1} runs a goal {\tt G} and catches the output to the file
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
{\tt Demos/1} needs a helper predicate. {\tt FreshFile/1} 
makes sure that no one
else has scribbled, or is currently scribbling, on our output file.
*/
%<
freshFile(X) :- 
    (current_stream(X,_,S) -> close(S)       ; true),
    (exists_file(X)        -> delete_file(X) ; true).
%>
%%% Using {\tt Demos/1}.
/* Next, we need to run the demo code as follows: 
\begin{LISTING}
?- demos(egsum).
\end{LISTING}
Once that is done, then when this document will include the
output.
*/
%%%% Conclusion
/* That's all folks! 
\theend
\end{document}
*/
