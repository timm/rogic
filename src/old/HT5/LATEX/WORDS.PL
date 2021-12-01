/* %\documentstyle[a4,cite,varioref,makeidx,fancyheadings,lastpage,epsf,epic,ecltree]{book}
\documentclass[a4paper]{book}
\usepackage{cite,varioref,makeidx,fancyheadings,lastpage,epsf,epic,ecltree}

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

\newenvironment{tip}{\medskip\par\noindent
  \begin{equation}\footnotesize\begin{minipage}{.9\textwidth}}{%
  \end{minipage}\normalsize\end{equation}}


\newenvironment{prol1}{\medskip\par\noindent
  \begin{equation}\footnotesize\begin{minipage}{.9\textwidth}\begin{verbatim}}{%
  \end{verbatim}\end{minipage}\normalsize\end{equation}}


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

\lhead[\fancyplain{}{\sl\rightmark}]{\fancyplain{}{\sl\leftmark}}
\rhead[\fancyplain{}{\sl \leftmark}]{\fancyplain{}{\sl \rightmark}}
\cfoot{{\sl page~\thepage~of~\pageref{LastPage}}}
\chead{}
\lfoot{}
\rfoot{}
%\footrulewidth 0.4pt


%%%%%% fancies

\makeindex

\title{HT5\\
\& Support Code}

\author{
Tim Menzies\\~\newline~\newline
Department of Artificial Intelligence,\\ 
School of Computer Science and Engineering,\\
The University of New South Wales,\\
Sydney, Australia, 2052.\\~\newline
{\tt
timm@cse.unsw.edu.au}\\
{\tt  http://cse.unsw.edu.au/$\sim$timm}}

\date{\today}

\begin{document}

\maketitle

\section*{Dedications}

This book is dedicated to:
\bi

\item Two authors whose texts I found 
to be inspirational:
{\bf Peter Norvig}~\cite{norvig92} 
and {\em Peter Coad}~\cite{coad97}.

\item  {\bf Roland Sammut} and {\bf Michael Wise} who originally taught
me Prolog and {\bf Claude Sammut} who I believed when he said that
Prolog can be used for real world applications.

\item {\bf Graham Mann} who always challenges me to reach further.

\item All the students of Prolog who have helped me
worked through this
document: 
Dylan Jay,
Fakir Mohideen Shahul,
Tracy Truong,
Sam Waugh.
This text benefited enormously through their input. Many thanks.

\ei

\tableofcontents

\pagestyle{fancy}


\chapter{Introduction}

\begin{raggedleft}
{\em
If you cannot- in the long run- tell\\
everyone what you have been doing, your\\
doing has been worthless.\\
Edwin Schrodinger
}
\end{raggedleft}

We describe {\tt HT5}:
\bi
\item
A graph-theoretic
relevant envisionment abductive inference engine
which supports temporal abductive inference, memoing,
and customisable multi-level inference assessment operators
\item
Plus 
the Prolog code that supports it:
\bi
\item 
Frameworks (which change the design thinking):
\bi
\item
{\tt OH}: a query language for
Prolog facts;
\item {\tt RDR}: a Prolog-based ripple-down rules system
\item {\tt RDF}: an extension to {\tt RDR} for handling evolving functions
called ripple-down functions.
\ei
\item Libraries (which are neutral to the design):
\bi
\item Processing for lists, strings, maths, sets, working memory,
input/output, and other miscallenous functionality.
\ei
\ei
\ei
 
\part{Frameworks}

\chapter{OH}\label{chp:records}

{\tt OH} 

\chapter{Ripple-Down Rules}\label{chp:rdr}

\chapter{Ripple-Down Functions}\label{sec:rdf}

\part{HT5}

\chapter{Here it is}

\part{Libraries}

\chapter{List Processing}\label{chp:lists}

\chapter{Set Processing}\label{chp:sets}

\chapter{String Processing}\label{chp:strings}

\chapter{Maths}\label{chp:maths}

\chapter{Working Memory}\label{chp:maths}

\chapter{Input/Output Routines}\label{chp:io}

\chapter{Miscallaneous Routines}\label{chp:io}

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
