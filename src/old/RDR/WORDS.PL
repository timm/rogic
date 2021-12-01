/* %\documentstyle[a4,cite,varioref,makeidx,fancyheadings,lastpage,epsf,epic,ecltree]{book}
\documentclass[a4paper]{book}
\usepackage{alltt,cite,varioref,makeidx,fancyheadings,lastpage,epsf,epic,ecltree}

\columnsep 0.25in
% \topmargin -1.1in
%\textwidth 15.95cm

%%%%%% begin standard timm latex macros

\newcommand{\home} {
	Department of Software Development, Monash University,
	Melbourne, VIC 3145, Australia\\
	+61-3-903-1033(ph)+61-3-903-2745(fax)
	{\bf Email: timm@insect.sd.monash.edu.au}
}

\newenvironment{prol}{\medskip\par\noindent
  \begin{equation}\footnotesize\begin{minipage}{.9\textwidth}}{%
  \end{minipage}\normalsize\end{equation}}


%\newcommand{\changequote}[1]{\let\origchn\chaptername
%\renewcommand{\chaptername}{\strut
%\rlap{\hbox to \linewidth{\hfill\vtop to 0pt{\hbox{#1}\vss}}}\origchn}}





%\newcommand{\max}{{\em max}}
\newcommand{\bc}{\begin{center}}
\newcommand{\ec}{\end{center}}

\newcommand{\be}{\begin{enumerate}}
\newcommand{\ee}{\end{enumerate}}
\newcommand{\bi}{\begin{itemize}}

\newcommand{\ei}{\end{itemize}}
\newcommand{\my}[1]{\mbox{\(\cal #1\)}}
\newcommand{\myy}[2]{\( {\cal {#1}}_{#2} \)}
\newcommand{\kla}{$\my{KL}_A$~}
\newcommand{\klb}{$\my{KL}_B$~}
\newcommand{\myset}[1]{{\tt\{#1\}}}
\newcommand{\src}[1]{Listing \vref{#1}}
\newcommand{\ilabel}[1]{\index{#1}\label{#1}}
\newcommand{\code}[1]{{\small\sf{\sc{#1}}}}

\newcommand{\myyy}[3]{\({{\cal #1}}_{{\em #2}}^{{\em #3}}\)} 

%\newsavebox{\fminibox}
%\newlength{\fminilength}
%\newenvironment{fminipage}[1][\linewidth]
% {\setlength{\fminilength}{#1}%
%\addtolength{\fminilength}{-2\fboxsep}%
%\addtolength{\fminilength}{-2\fboxrule}%
%\begin{lrbox}{\fminibox}\begin{minipage}{\fminilength}}
% {\end{minipage}\end{lrbox}\noindent\fbox{\usebox{\fminibox}}}

%%%%%% end standard timm latex macros

%%%%%% fancies


\lhead[\fancyplain{}{\sl\rightmark}]{\fancyplain{}{~}}
\rhead[\fancyplain{}{\sl \leftmark}]{\fancyplain{}{\sl \rightmark}}
\rhead[\fancyplain{}{\sl \leftmark}]{\fancyplain{}{~}}
\cfoot{}
\chead{}
\lhead{}
\rhead{}
\rfoot{}
\lfoot{}
\rhead[]{\sl page~\thepage~of~\pageref{LastPage}}
\lhead[{\sl page~\thepage~of~\pageref{LastPage}}]{}
\footrulewidth 0pt
\headrulewidth 0.4pt

%%%%%% fancies

\makeindex

\title{POO:\\
A Prolog Object-Oriented System}
\author{
Tim Menzies\\~\newline~\newline
Department of Artificial Intelligence,\\
School of Computer Science and Engineering\\
The University of New South Wales\\
Sydney, Australia\\~\newline
{\tt
timm@cse.unsw.edu.au}\\
{\tt  http://www.cse.unsw.edu.au/$\sim$timm}}

\date{\today}

\begin{document}

\maketitle

\section*{Dedications}

This book is dedicated to:

\tableofcontents

\pagestyle{fancy}


\chapter{Introduction}

%  \chapter{Introduction}

We build a simple object-based query system
for Prolog facts. Knowledge of the facts is expressed in
 oriented system in Prolog
that supports:

\bi
\item
A query 
\ei

\begin{prol}\begin{verbatim}}*/
a :- b.
*/\end{verbatim}\index{fred/1}\index{sam/2}\index{john/5}\end{prol}


{\small
\printindex
}

{\small
\bibliographystyle{myplain}
\bibliography{../../refs/refs}
}

{\footnotesize
Some of the Menzies papers can be found at
{\em  http:// www.sd.monash.edu.au/ $\sim$timm/pub/
docs/papersonly.html}}.


\end{document}*/
