/*\documentclass[twocolumn,global]{svjour}
\usepackage{prod}\begin{document}
 
\theprogram{NAME}
\thetocdepth{2} 
\thewp{PATHNAME}
\thepapers{refs}
\thetitle{TITLE}
\theauthor{AUTHOR1\inst{1},AUTHOR2\inst{2}}
\theinstitute{WHERE AUTHOR1 WORKS;\\
          \url{author1@email1.com},
          \url{http://where.to.find.author1}
             \and
             WHERE AUTHOR2 WORKS}
\thereference{memo3@ai.wvu.2003. Available from
        \url{http://tim.menzies.com.pdf/03prod0.pdf}}
\theacknowledgement{ACKNOWLEDGEMENTS}
\theabstract{ONE PARAGRAPH SUMMARY}
*/

%%%% SECTION1 heading
/*
BODY OF DOCUMENT WITH A REFERNCE~\cite{swiprolog}.
*/
%\input{prod0a}
We can include text like that shown in \fig{prod0a.tex}.
\SRC{prod0a.tex}{A sample include file.}

/* Some text to be typeset
*/
%%% SECTION2 heading
/* Some text to be typeset
*/
%% SECTION3 heading
/* Some text to be typeset
*/
%%%% SECTION1 heading %<
somePrologCode :-
    subGoal1,
    subGoal2.
%>
/* Some text between code.
*/
%<
someMorePrologCode :-
    subGoal1,
    subGoal2.
%>
/*
\theend
\end{document}
*/
