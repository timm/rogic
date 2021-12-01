%
/* \documentstyle[a4,cite,varioref,makeidx,fancyheadings,lastpage,epsf,epic,ecltree]{book}
\documentclass[a4paper,10pt]{book}
\usepackage{alltt,
cite,varioref,makeidx,fancyheadings,lastpage,epsf,epic,ecltree}

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

\newenvironment{prol}{\medskip\par\noindent
  \begin{equation}\footnotesize\begin{minipage}{.9\textwidth}}{%
  \end{minipage}\normalsize\end{equation}}

\newenvironment{prol1}{\medskip\par\noindent
  \begin{equation}\footnotesize\begin{minipage}{.9\textwidth}\begin{verbatim}}{%
  \end{verbatim}\end{minipage}\normalsize\end{equation}}

%\newcommand{\changequote}[1]{\let\origchn\chaptername
%\renewcommand{\chaptername}{\strut
%\rlap{\hbox to \linewidth{\hfill\vtop to 0pt{\hbox{#1}\vss}}}\origchn}}


%\newcommand{\max}{{\em max}}
\newcommand{\fig}[1]{Figure \vref{#1}}
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
\newcommand{\code}[1]{{\em #1}}
\newcommand{\prolog}{\code{Prolog}}
\newcommand{\ent}[1]{{\sffamily #1}}

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
\lfoot{}
\rhead[\fancyplain{}{\sl \leftmark}]{\fancyplain{}{\sl \rightmark}}
\rfoot{{\sl page~\thepage~of~\pageref{LastPage}}}
\chead{}
\cfoot{}
\footrulewidth 0.4pt


%%%%%% fancies

\makeindex

\title{
The TROJAN Toolkit:\\~\\
Unified Principles for\\
Software Engineering and\\
Knowledge Engineering}


\author{
Tim Menzies\\~\newline~\newline
Dept. of Artificial Intelligence,\\  
School of Computer Science and Engineering,\\
The University of New South Wales,\\
Sydney, Australia, 2052~\\~\\
{\tt
timm@cse.unsw.edu.au}\\
{\tt  http:// www.cse.unsw.edu.au/$\sim$timm}
~\\~\\~\\~\\~\\
{\bf CAUTION}: Despite what you might read in this text,
\code{TROJAN}~\\ 
{\bf does not exist yet}. This is a working document~\\
intended to state the goals, track the progress,~\\
and document the interim deliverables.
}

\date{\today}

\begin{document}

\maketitle

\section*{Dedications}

This book is dedicated to:
\bi
\item {\bf Erwin Schroedinger} who rightly says:
\begin{quote}
If you cannot- in the long run- tell everyone what you have been
doing, your doing has been worthless.
\end{quote}

and {\em  Antoine de Saint-Exupery} who said:

\begin{quote}
Perfection is reached, not
when there is no longer
anything to add, but when there
is no longer anything to take
away.
\end{quote}

\item {\bf Peter Norvig} whose {\em Paradigms of Artificial
Intelligence} is an inspiration to all educators.

\item {\bf Graham Mann} who always challenges me to reach further.

\item {\bf Roland Sammut} and {\bf Michael Wise} who originally taught
me \prolog\ and
{\bf Claude Sammut} who I believed when he said that
\prolog\ can be used for real world applications.

\item {\bf Guy L. Steele}, the man who wrote two of the greatest
technical documents in the world: {\em Common Lisp, the Language} and
{\tt The Hacker's Dictionary}.  Any man who writes a PhD thesis where
the font sizes change twenty times in a single sentence is my kind of
Guy!~\footnote{I've been waiting years to make that joke.}

\item All the students of \prolog\ who have helped me
worked through this
document: 
Fakir Mohideen Shahul,
Simon Goss.
This text benefited enormously through their input. Many thanks.

\ei

\tableofcontents

\pagestyle{fancy}

%\newsavebox\myquotation
%\sbox\myquotation{\parbox[t]{0.3\linewidth}{
% {\em Those of us who have been trained as architects have this desire
%perhaps at the very center of our lives: that one day, somewhere,
%somehow, we shall build one building which is wonderful, beautiful,
%breathtaking, a place where people can walk and dream for centuries.}
% Christopher Alexander\vspace{0.1cm}}}
% {\changequote{\copy\myquotation}

\chapter{Introduction}


\begin{quote} 
\raggedleft  
{\em Those of us who have been trained as\\
architects have this desire perhaps at the\\
very center of our lives: that one day,\\
somewhere, somehow, we shall build one\\
building which is wonderful, beautiful,\\
breathtaking, a place where people can\\
walk and dream for centuries.}\\ 
Christopher Alexander
\end{quote}

%  \chapter{Introduction}

\section{New Questions about Software}

In the late-1980s I went to an expert systems conference~\cite{men87a}
where the question was asked "Rule-based programming is a great
technique. Why doesn't everyone use rule-based programming?"  In the
very early-1990s, I went to a logic programming
conference~\cite{mebfd92} where the question was asked "logic
programming programming is a great technique. Why doesn't everyone use
logic programming?".  In the early 1990s, I went to object-oriented
conference~\cite{men93j} and we asked "Object-oriented programming is
a great technique. Why doesn't everyone use objects?". Recently, I
attended an artificial intelligence conference~\cite{me95j} and asked
"Abduction programming is a great technique. Why doesn't everyone use
the abduction?". I predict that, in the future, I will attend
conferences where it will be asked "{\em X} is a great technique. Why
doesn't everyone use {\em X}?"  (where {\em X} may be one of neural
nets, business process re-engineering, genetic algorithms, design
patterns, Bayesian reasoning,~\ldots).

Rather than squeezing all software
construction problems into a single
technique (objects, logic programming, rules, patterns,\ldots),
perhaps its time for a new question: \begin{quote} What are the {\em
range} of technique are useful for supporting software generation?".
\end{quote} Is is possible to look at our existing successful software
systems and reverse engineer a minimal list of techniques used to
build them? And if we are building such a list, we also want to ask:
\begin{quote} Which techniques can we do without?  \end{quote} That
is, which of these techniques really matter?

The goal of this book is the creation of a toolkit that lets us ask
and answer these questions.  We offer a description of the
\code{TROJAN} toolkit which contains a integrated set of customisable
SE/KE techniques.  This toolkit allows developers to work at a
specification level at several layers of abstraction back from their
problem. This specification will be directly executable, thus avoiding
the need for possible incorrect translation of the specification into
some other language. An essential
part of \code{TROJAN} is a metrics collection
suite. We hope to convince developers to develop applications using
\code{TROJAN}. An analysis of the collected metrics will let us decide
which techniques are useful/useless.

\section{Why \prolog?}

After years of experimentation, we find that our \code{Prolog} code is
shorter and simpler than our object-oriented \code{Smalltalk} code,
our functional \code{Lisp} code, or our procedural \code{C} code.
\code{TROJAN} needs to be customisable. Shorter things are easier to
change than longer things. Hence, \code{TROJAN} is written in \prolog.

\code{Prolog} is short for "Programming in Logic". However, logic
programming purists would balk at how \code{Prolog} is used here.
When using \code{Prolog}, we do not just write down theorems about the
domain under analysis, then let the \prolog\ theorem prover derive the
deductive consequences.  Rather, we use \prolog\ as a prototyping
language in which we can build virtual machines that can interpret
domain-specific specification languages.  These virtual machines have
properties that are very different from the horn clauses of logical
\prolog.

\section{How to Read This Book}

This book describes the \code{TROJAN} toolkit at increasing
levels of detail starting at \prolog\ {\em idioms},
then working up to {\em frameworks} and {\em patterns}.
Depending on your background and your goals, there are different ways
to read this book.

\bi
\item This book requires a basic
understanding of \prolog; data-modeling; object-oriented
modeling.
For introductory \prolog\ material, see
Brakto~\cite{bratko90} or Sterling~\cite{sterling94}. 
Intermediary and advanced \prolog\ material can be found in  
the O'Keefe text~\cite{ok90}.
Numerous database texts (e.g.~\cite{date95}) discuss data modeling.
Rumbaugh gives a simple introduction to object-oriented
modeling~\cite[chpt.~2,3,4,8.1,8.2,8.3,8.4]{rum91}.

\item 
Advanced \prolog\
users can skip the introductory material in the
{\em idioms} and {\em libraries} sections.

\item
SE and KE researchers
can skip the {\em idioms}, {\em libraries} and {\em mechanisms}
section. At the completion of these three sections, we will have
defined the \code{TROJAN} virtual machine. Subsequent material will
just treat this machinery as notational primitives.
\ei


\section{Idioms} 

Students can often complete a one semester introductory \prolog\
programming subject and still not be familiar with common \prolog\
programming idioms. Idioms reflect common usage of a language;
e.g. using recursion to remove local variables, returning a negative
number to denote an error in \code{C}~\cite{coplein92}, or
failure-driven loops in \prolog.  Sterling calls \prolog\ idioms
"skeletons"~\cite{sterling94}.  Robertson uses idioms to define
editors for standardising the creation of \prolog\ source
code~\cite{robertson96}.  Developers who know each other's idioms can
read code faster. Several lines of source code can be scanned at one
glance to infer (e.g.) "oh yes, Tim is using a head-append to collect
the results of an iterator".

\section{Libraries}

Most developers have a library of favorite sub-routines for common
processing. Our library has sub-routines for list and string
processing, and statistical report generation, as well as managing
different storage structures (e.g. 2-3-4 trees). Also, some of our
libraries tools simplify programming-by-idioms.

\section{Frameworks} 

Libraries are neutral to the process of coding.  They are merely
little sub-routines that handle common, low-level processing.
"Libraries" that have
a major effect on coding style are called frameworks.  Such frameworks
are parameterised sub-routines which handle a significant percentage of
the processing. With a good framework, the developer can build
executable systems by filling in the appropriate
parameters. Frameworks encourage the developer to tackle problems in
the same manner as the author of the framework. User-interface
libraries are often frameworks: the developer merely provides a few
subclasses that fill in the local detail. \code{TROJAN} uses frameworks
for extended data modeling (includes inheritance and methods),
rule-based programming, ripple-down-rules, and  abduction.

\section{Patterns}

Frameworks are necessarily large libraries of executable code which
support a certain style of coding.  Patterns are "frameworks" which
may or may not be executable and which encourage developers towards
certain styles of design.  Frameworks allow us to reuse old code.
Patterns allow us to reuse old design approaches, either for design
initialisation, project management, or throughout the design process.
Design patterns were first recorded in architecture~\cite{lea94} and
lately have achieved prominence in object-oriented design~\cite{gof95}
and knowledge-level modeling~\cite{weil92,me95e}.  One interesting
claim from the pattern's community is that what distinguishes good
designers is that they worry earlier about crucial
issues~\cite{kerth95}. 
Patterns
can document a succinct description of these crucial issues.

\code{TROJAN} is built around different patterns (which contain
sub-patterns):

\bi
\item
{\em
Symbol-level} vs {\em knowledge-level}.
\item
The {\em Fenton metrics triad}.
\item
Specification evolution.

\ei

\subsection{Symbol-Level vs Knowledge-Level}

In Newell's knowledge-level
(KL) approach~\cite{newell82}, intelligence is modeled as a
search for appropriate {\em operators} that convert some {\em current
state} to a {\em goal state}. Domain-specific knowledge as used to
select the operators according to {\em the principle of rationality};
i.e. an intelligent agent will select an operator which its knowledge
tells it will lead the achievement of some of its goals. If
implemented, this KL is built on top of a {\em symbol-level}
containing data structures, algorithms, etc. However, to a KL agent,
these sub-cognitive symbol-level constructs are the tools used
``sub-consciously'' as it performs its KL processing.
Conventional commercial software  rarely makes it above the
symbol-level. 

\subsubsection{Details of the Symbol-Level}

A common symbol-level pattern in conventional software
is the "three-tiered" combination of {\em data}, {\em model}, and
{\em dialogue}. The {\em model} layer contains the business logic
separate the persistent {\em data} storage layer and the {\em
dialogue} layer (i.e. the program's interface). 

The {\em data} layer is sub-divided into a {\em DBMS} and a {\em disc
data} layer.  Codd~\cite{codd:70} argued in 1970 for "data
independence"; i.e. it should be possible to re-organise the data
storage without having to change the model.  To do this, a database
management system (DBMS) acts as an intermediary between the model and
the database. Typically, SQL is used to communicate between the data
and the model layer.  \code{TROJAN} uses a simple model/data
connection.  All its internal facts are ground \prolog\ clauses with no
sub-goals (i.e. no rules). Such ground facts map simply to relational
databases.  \code{TROJAN} uses a simple file-out technique to store
its facts in text files. When multiple users access the same
specification, \code{TROJAN} locks its files at the directory level.
All users can browse any portion of the specification, but can only
modify the portions in the files in the directories which they "own".
For intra-file level locking, \code{TROJAN} needs to be interfaced to
a relational database (not done in this version). Given
\code{TROJAN}'s internal format conventions, this should be simple to
do.

Hartson \& Hicks~\cite{hart89} argue in 1989 for "dialogue
independence"; i.e. the separation of a program's computational
component (the {\em model} layer) from its interface (the {\em
dialogue} layer). Such a separation permits the separate modification
of the dialogue or the underlying system. To date, there does not
exist an SQL-like standard to handle communication between the model
and dialogue.  \code{TROJAN} proposes a {\em constraints
interface management system} (CIMS) for the model/dialogue 
communication.  Elements in the
model can report their values as being (e.g.) {\tt one2many} 
with another entity.
The CIMS can use this meta-knowledge
to drive a auto-layout package for the
interface; e.g. paint a screen with a scrolling list of manage the
connection to the {\tt many} side. 
\code{TROJAN} uses \code{HTML} 3.0 with frames as the basis
of its interface layer.

If  data/dialogue independence is maintained, then
the 
application generates a representation of the domain (the model layer)
that is not
confused by interface or data storage trivia. This has two significant
economic implications:
\be
\item
Haynes~\cite{hay96} reports experiments with a software size
estimation model for object-oriented systems. Accurate size estimates
could be determined by first defining the classes in the model, then
multiplying by 3.6.  If we can
automate the generation of the data and dialogue layer via an
intelligent (and automatic) analysis of the model layer (e.g. using
the
\code{TROJAN} CIMS layer), then we {\em
may} be able to reduce the cost of software development by up to
$\frac{1}{3.5}=29\%$.
\item
Luqi~\cite{luqi96a} reports that in
1995, The US government spent \$81 billion on software projects that
were never completed. Some 31\% of all their software projects were
canceled.  Given that the non-completion rate is so high,
organisations
should structure projects such that something useful can be extracted
from the wreckage of a project. The model layer represents hard-won
knowledge about the domain under studying, If we can at least recover
a partially built model from a failed software project, then we can
speed up future projects.

\ee

\subsubsection{Details of the Knowledge Level}

\code{TROJAN} uses Clancey's notion of a {\em situation-specific
model} (SSM) to explore the implementation details of the KL principle
of rationality.  Clancey argued that what distinguishes an expert
system from conventional software is that expert systems build and
reflect over some internal model which they create at
runtime~\cite{clancey89,clancey92}. Given a state space containing
legal transitions provided by some oracle, an expert system extracts
portions that are relevant and useful to the task at hand. In the case
where there is some choice of what to extract, a set of {\em conflict
resolution strategies} implement the principle of rationality by
advising portions to extract.

At its lowest level, \code{TROJAN} stores its specifications as a
directed graph containing links between concepts.  Conflict resolution
strategies are defined at various levels:

\bi
\item
{\em Node-level} e.g. "Which link should I use when I
leave this concept?" Node-level conflict resolution can implement
probabilistic reasoning.
\item
{\em Proof-level} e.g. "Hmmm, I'll stop working on
the current proof I am
considering since I notice that it  can be done much simpler using 
that another proof I worked out before." Proof-level conflict
resolution can implement a variety of search strategies such as beam search.
\item
{\em World-level} e.g. "Here are
two sets of consistent beliefs I can hold about this theory. That
first one is too complicated and gives me no more than this second
one. OK, I'll use the second one." World-level conflict resolution can
implement a variety of common knowledge-level tasks~\cite{me96a}. 
For example,
single
fault diagnosis is just return the belief sets with only one input and
all the outputs we are trying to explain. 
\ei

\subsection{The Fenton metrics triad}

One goal of \code{TROJAN} is an assessment of current techniques in SE
and KE. Assessment implies measurement.
Fenton~\cite[chpt.~3]{Fenton1991}
advises  that a complete software metrics program includes measures
of:

\bi
\item {\em Process metrics} which monitor the manner in which software
is constructed;
\item {\em Product metrics} which monitor the constructed entity;
\item {\em Resource metrics} which monitor what tools or human
resources
 were applied in
the process to produce the software product.
\ei

All representations in \code{TROJAN} are classified into one of the
above three groups.

\subsubsection{Products}

All products of a specification developed using \code{TROJAN} are
\prolog\ assertions. Frameworks are provided for using assertions to
replicate common information systems design notations (the {\em
Olle-20} and portions of the Rumboochary Unified object-oriented
Modelling language. The latter is a simply the addition of
inheritance, methods, and class features to the former.  Common
constructs in Rumboochary are shown in \fig{fig:notation}.

\begin{figure}[!htb]
\begin{center}
{\hfill
 \epsfbox{notation.eps}
\hfill}
\caption{Common Rumboochary constructs}
\label{fig:notation}
\end{center}
\end{figure} 

\subsubsection{Products}

A \code{TROJAN} specification comprises rules that specify connections
or constraints between entities. 
\subsubsection{Processes}
  

\begin{figure}
\begin{center}
{\hfill\epsfbox{activity.eps}\hfill}
\end{center}
\caption{A meta-model of softwre process. From~\cite{me96j}.}
\label{fig:metaprocess}
\end{figure}

Processes contain combinations of   \ent{sequenced},
\ent{support}, or \ent{review}  \ent{activities} (see \fig{fig:metaprocess}):
\bi
\item
\ent{Sequenced} \ent{activities} occur in some order according to the
methodology being used.  A \ent{sequenced} activity  
has a checkpoint where a 
\ent{review} of its \ent{products} is performed. 
\item
\ent{Review} task lets us model  checkpoints in
the process where the project may be halted if progress is not
satisfactory.
Such {\em commit partition} points
are essential part of risk-driven, iterative spiral
software process~\cite{boehm86}.
\item
\ent{Support} \ent{activities} tasks are those which
occur in parallel with any project such as
project monitoring \& control, 
quality management,
document development, training, 
and configuration management (including version control and backups).
These are shown as the  \ent{watch!} category in \fig{fig:sequence}.
\ei


\begin{figure}
\begin{center}
{\hfill\epsfbox{cycle.eps}\hfill}
\end{center}
\caption{\ent{Sequenced} \ent{categories} are one of \ent{what2Do?,
do!, done?, watch!}}
\label{fig:sequence}
\end{figure} 
  

After Hodgson~\cite{hod96}, we categorise \ent{sequenced activities} into
the three meta-groups shown in \fig{fig:sequence}:
\bi
\item
In the
\ent{what2Do?}  logical design \ent{activity category}, 
a brainstorming/elicitation
sub-activity is followed by an ordering/representation sub-activity.
\item
In the \ent{do!} physical design \ent{activity category}, the idealised logical
design is typically compromised as it is contorted to fit into some
lower-level representation. 
\item
In the \ent{done?} test \ent{activity category}, the
results of the physical design are assessed.  Testing can be divided
into {\em verification} (i.e. was the system built right?) and {\em
validation} (i.e. was the right system built?).  
Feedback from the
testing process can improve the physical and logical designs. 
\ei
Hodgson argues that the \ent{categories} of \fig{fig:sequence} are recursive;
i.e. the work involved within any of the \ent{sequenced activities} can
be sub-divided up into \ent{what2do?, do!, done?}. 
For example, in the verification \ent{sub-activity}, the tests have to be
planned (\ent{what2Do?}), implemented in some programming language
(\ent{do!}), then compiled, run and their results evaluated (\ent{done?}).

\subsubsection{Resources}

It is an open research issue how to collect resource metrics.
Theoretically, it can be argued~\cite{me96a} that a system that
supports knowledge-level tutoring can serve as a tool for 
automatically
assessing
the skill levels of different developers. However, this has yet to be
proven.  In the meantime, the \code{TROJAN} environment logs how long
developers spend on each \ent{activity}.

\subsection{Specification Evolution}

\code{TROJAN} assumes that experience with a domain will alter the
specification.  Several techniques are supplied to support
specification change:

\bi
\item
To run \code{TROAJN}, a new case is entered into a library of
cases that 
stores what outputs are expected for what inputs.
\item
A verification engine that reports structural anomalies in the
specification.
\item
A validation engine that reports:
\bi
\item
What percentage of the desired
outputs are currently achievable.
\item
What portions of the specification were used in reaching those desired
outputs.
\ei
\item
A model-patch facility. At its lowest level, a \code{TROJAN}
specification is a set of directed edges. Each edge is augmented with
the
cases that used it to achieve desired outputs. If a developer changes
an edge, they can re-run the cases that required that edge(s).
\item
A conflict-resolution maintenance  facility.
Ripple-down-rules are used to patch the definition of acceptable
SSMs.
\item Also, \code{TROJAN} can handle portions of the specification which are
{\em vague}; i.e. incomplete or under-specified. When processing such
vague specifications, assumptions need to be made and mutually
exclusive assumptions must be maintained separately.  Such vague
specifications are common during the start of a specification process
(e.g. when a group is negotiating the required specifications).
\item
Since \code{TROJAN} automatically
generates the data/dialogue link, these can be automatically
regenerated after the specification is changed.
There are two problems with this auto-regeneration process:
\bi
\item
Users
may lose the screens they are familiar with.
\item
Date entered into an old database schema must be mutated into the new
schema. This can be a non-trivial process in the case where the
new schema requires different information to that known to the old
schema.
\ei
Both these problems are ruled out-of-scope for this version of
\code{TROJAN}.
\ei

Note that such specification evolution tools are not required if
the specification can be made correctly in the first place.

\section{Why is it called \code{TROJAN}?}

Recall the story of the Trojan horse that
the fortress
city of Troy accepted
from their enemies.
Troy thought they were getting a gift so they let it into the city.
Late at night, the Greek   soldiers hiding
within the horse crept out and conquered the city.

\code{TROJAN} offers a range of useful tools. Specifications can be
executed, tested, and maintained at the symbol-level or
knowledge-level
throughout the specification lifecycle. 
Yet, under the hood, metrics will be collected that could
bring down certain methodological empires that sing the praises
of their techniques without ever testing them.

For example, 
the knowledge acquisition community can be divided into a majority and
a minority school of thought.  In the majority school (e.g. KADS), KBS
development is a {\em analysis intensive process} (AIP); i.e. before
{\em doing}, much time is spent in {\em thinking about
doing}. Further, previous {\em thinkings about doing} can be re-used
for new designs.  The minority situated cognition
school~\cite{compton90} argues that concepts elicited prior to direct
experience are {\em less} important than functional units developed
via direct experience with the current problem.  This situated
cognition school prefers a {\em maintenance intensive process} (MIP);
i.e. after a little {\em thinking about doing}, most of the system is
developed via {\em doing} then {\em fixing}.

A similar division between MIP and AIP can be seen in the software
engineering field; e.g. rapid application prototyping versus formal
methods.

Empirical evidence supported AIP or MIP is sketchy. The dominant
software development methodologies are AIP.  Anecdotally, we are aware
that programs need maintenance; i.e. AIP does not save us from needing
maintenance.  However, intuitively, we all believe that if we plan
before we execute, then we can execute better and reduce maintenance
costs.  But is this really the case? Isolated experiments in MIP and
the power of AIP have resulted in the following counter-intuitive
results:

\bi
\item
Large-scale patching
in the context of the last error can lead to competency in intricate
domains~\cite{preston93};
\item
Abstract inference
patterns reversed-engineered from previously successful expert systems
are not a productivity tool~\cite{cor95}.
\ei

These isolated MIP experiments must be explored. If they prove to be a
general result, then the implications are staggering.  Crudely
speaking, we would sack most of our analysts, rely more on MIP
techniques, and hire more maintenance programmers.  Given a
specification developed in the \code{TROJAN} environment, we would
declare MIP or AIP to be {\em satisfactory} if it can generate
competent systems from the same specification (e.g. one of the
Sisyphus projects~\cite{linster92a}).  We would declare either the MIP
or AIP approach {\em superior} if it produced more good edges sooner
than the other. Our money is on MIP, but time and metrics collection
will tell.

\section{Notes}

This document was written at great speed, partly in order to
support my students who need tutorial assistance in understanding 
by code.
Hence:
\bi
\item
Much of
the code shown here will be presented in a stream-of-consciousness manner.
\item
In order to simplify explaining this code to students:
I apply the 80-20 rule. If $N$ lines of code gives me 80\% of the
functionality that I want and the remaining 20\% of the functionality
needs $M>N$ more lines of code, then I stay with the $N$ system.
\ei

In order to assist with the navigation of our tangled stream-of-thought,
we provide the following structure:
\bi
\item
An index at the back for all our defined programs.
\item 
If a particular predicate is to be improved as the book progresses,
then version one of that predicate will be called {\tt fooA},
version two, {\tt fooB}, etc.
\item 
A set of {\tt demo} predicates that demonstrate the functionality.
For example, the demonstration
of predicate {\tt foo} would be {\tt demo(foo)}.

\ei


I have tried to make \code{TROJAN} compatible
with the \prolog\ ISO standard~\cite{der96}. However, some parts of
this
standard are just not practical; e.g. the lack of the {\tt portray/1}
predicate. Hence, in these matters,
\code{TROJAN} deviates from the official line.

Despite the speed with which this document was written, all 
the code described here really works as advertised.
We passed our \LaTeX source code, plus some extra comment characters, 
directly to our SWI-\prolog~\cite{swiprolog} interpreter. 
I am grateful David Poole for
showing us this ``latex-as-prolog'' trick since it
simplifies enormously the documentation
of our code.
This document is an example of literate programming in \prolog.
The literate programming FAQ defines literate programming as follows:

Literate programming is the combination of documentation and source
together in a fashion suited for reading by human beings.  In fact,
literate programs should be enjoyable reading, even inviting!  
In general, literate programs combine source
and documentation in a single file.  Literate programming tools then
parse the file to produce either readable documentation or compilable
source.  The WEB style of literate programming was created by D.E. Knuth
during the development of his TeX typesetting software.

All the original work revolves around a particular literate programming
tool called WEB.  Knuth says:
\bi
\item  
     The philosophy behind WEB is that an experienced system
     programmer, who wants to provide the best possible
     documentation of his or her software products, needs two
     things simultaneously: a language like TeX for formatting,
     and a language like C for programming.  Neither type of
     language can provide the best documentation by itself; but
     when both are appropriately combined, we obtain a system
     that is much more useful than either language separately.
   \item    
     The structure of a software program may be thought of as a
     web that is made up of many interconnected pieces.  To
     document such a program we want to explain each individual
     part of the web and how it relates to its neighbors. The
     typographic tools provided by TeX give us an opportunity to
     explain the local structure of each part by making that
     structure visible, and the programming tools provided by
     languages such as C or Fortran make it possible for us to
     specify the algorithms formally and unambiguously. By
     combining the two, we can develop a style of programming
     that maximizes our ability to perceive the structure of a
     complex piece of software, and at the same time the
     documented programs can be mechanically translated into a
     working software system that matches the documentation.
\ei

\part{Getting Started}

\chapter{Idioms}

\section{Textual}

Anonymous variables: naemd and unnamed

names in predicates: upepr case running. not
underscore (confuses latex when i mention them
in the text)

\section{Misc}

Tail recursion (good and bad max).

\section{Argument Numbering}

A0, to A1 to A

\section{The Update Argument}

\subsection{DCG Syntax}

\section{Predicate Calls}

Outputs at end

\section{Traversing nested Terms}

\section{Predicate Indexing}

Arity/Functor/term1

\section{Operator Notation}

\section{Macros}

A macro is some shorthand for common processing which the compiler
expands into the required longhand form. Marcos are.

\chapter{Libraries}

\section{Strings}

\section{Control}

%\begin{prol1}*/
%:- op(1001,fx,all).
%all X :- X, fail.
%all _.
%
%:- op(999,fx,do).
%do [X|Y] :- X, do Y.
%do [].
%/*\end{prol1}

\section{Assertion Control}

\begin{prol1}*/
% wmeShow
%wmezap (with catergories)
% wmeStore
%wme restore

ensure((X :- Y)) :- !, (clause(X,Y) -> true | assert((X :- Y))).

ensure(X) :- X,!.
ensure(X) :- assert(X).
/*\end{prol1}

\section{Simple Profiling}
\begin{prol1}*/
compareTimes(Goals,Times) :- timeThem(Goals,10,Times).

compareTimes([Goal|Goals],N,[100|Times]) :-
	timeIt(Goal,N,T),
	compareTimes(Goals,N,T,Times).

compareTimes([],_,_,[]).
compareTimes([Goal|Goals],N,T,[Time|Times]) :-
	timeIt(Goal,N,Time0),
	Time is integer(100*Time0/T),
	compareTimes(Goals,N,T,Times).

timeIt(G,T) :- timeIt(G,10,T).

timeIt(G,N,Time) :- 
        timeIt1(true,N,T1),timeIt1(G,N,T2),Time is T2 -T1.

timeIt1(Goal, N,T) :- 
        T1 is cputime, timeIt2(Goal,N), 
        T2 is cputime, T is (T2 - T1)/N.

timeIt2(Goal, Repeats) :- between(1,Repeats,_), Goal, fail.
timeIt2(_,_).
/*\end{prol1}\label{timeIt/2}\index{timeIt/2}\index{timeIt/3}

\section{Lists}

\begin{prol1} */
member1(X,Y) :- member(X,Y), !.
/*\end{prol1}
\section{Simple Tracing}

\begin{prol1}*/
f(X) :- functor(X,_,0),!,print(X), write('.').
f(X) :- portray_clause(X).

fnl(X) :- functor(X,_,0),!,print(X), write('.'),nl.
fnl(X) :- portray_clause(X).

fnll(X) :-
	all
	member(Y,X),
	fnl(Y).
:- dynamic tPrint/0.

tPrintOn  :- ensure(tPrint).
tPrintOff :- retractall(tPrint).

t(X)     :- tnl(0,X).
tnl(X,Y) :- tPrint,!,t(X,Y), nl.
tnl(_,_).
t(X,Y)   :- tPrint, !,tab(X),f(Y).
t(_,_).

t1  :- t(1).      t2  :- t(2).       t3  :- t(3).
t4  :- t(4).      t5  :- t(5).       t6  :- t(6).
t7  :- t(7).      t8  :- t(8).       t9  :- t(9).
t10 :- t(10).     t11 :- t(11).      t12 :- t(12).
t13 :- t(13).     t14 :- t(14).      t15 :- t(15).
t16 :- t(16).     t17 :- t(17).      t18 :- t(18).
t19 :- t(19).     t20 :- t(20).      t21 :- t(21).
t22 :- t(22).     t23 :- t(23).      t24 :- t(24).
t25 :- t(25).     t26 :- t(26).      t27 :- t(27).
t28 :- t(28).     t29 :- t(29).      t30 :- t(30).
/*\end{prol1}

\begin{prol1}*/
pauseHaltKey(x,120). 
pause :- pause('').
pause(String) :-
        write(String),nl,
	pauseHaltKey(Key,Value),
	write(''''),write(Key),write(''''),
        write('to abort; any other key to continue...'),
        get_single_char(C),
	(C=Value -> abort | true),
	nl.
/*\end{prol1}
\section{Meta Predicates}

\begin{prol1}*/
meta([Predicate|Predicates],Arguments) :- !,
	append([Predicate|Predicates],Arguments,List),
	Goal =.. List,
	Goal.
meta(Predicate,Arguments) :- 
	Goal =.. [Predicate|Arguments],
	Goal.
/*\end{prol1}\index{calln/2}\index{calln/3}

\section{Partial Evaluation}

\begin{prol1}*/
:- op(999,xfx,:).

	

/*\end{prol1}

\begin{prol1}*/
term_expansion(X = Parent + Slots0,[frame(X,Slots)|Rest]) :- !,
	slotsOf(Parent,PSlots),
	expandSlots(Slots0,Parent,PSlots,Slots),
	handleAssertions(X,Slots,Rest). 

term_expansion(X = Slots0,Out) :- 
	term_expansion(X = nothing + Slots0,Out).

expandSlots([],_,Out,Out).
expandSlots([Slot:Value|T],Parent,In,Out) :-
	expandValue(Value,Parent,[],Values),
	replaceSlot(In,Slot,Values,Temp),
	expandSlots(T,Parent,Temp,Out).

expandValue(X,_,In,[X|In]) :- \+ is_list(X), !.
expandValue([],_,In,In).
expandValue([other(Slot)|T],Parent,Values0,Values) :- 
	slotsOf(Parent,Slots),
	member1(Slot : Values1,Slots),!,
	append(Values0,Values1,Values2),
	expandValue(T,Parent,Values2,Values).
expandValue([H|T],Parent,In,Out) :- !,
	expandValue(T,Parent,[H|In],Out).

replaceSlot([],S,V,[S : V]).
replaceSlot([S:_|Slots],S,V,[S:V|Slots]) :- !.
replaceSlot([Slot|Slots],S,V,[Slot|Rest]) :- 
	replaceSlot(Slots,S,V,Rest).

handleAssertions(_,Slots,[]) :- \+ value0(assert,Slots,true).
handleAssertions(X,Slots,Assertions) :- 	
	value0(assert,Slots,true),
	value0(writer,Slots,Writer),
	meta(Writer,[X,Slots,Assertions]).	
/*\end{prol1} 

\begin{prol1}*/
slotsOf(nothing,[]) :- !.
slotsOf(F,Slots)    :- frame(F,Slots).

value(F,S,V)      :- slotsOf(F,Slots), value0(S,Slots,V).
value0(S,Slots,V) :- member(S:All,Slots), member(V,All).
/*\end{prol1} 
\section{Collections}

\subsection{Generic Collection Protocol}

OO people can smirk here: polymorphism.

\begin{prol1}*/
demo(collections) :-
	all
	member(Type,[ list
		    , lList
                    , dList
                    ]),
	nl, collDemo(Type).

collDemo(Type) :- 
	 clause(collDemo(Type,What),Body),
	 nl, write(Type - What),write(' '),
         (Body 
         -> write(' ** PASSED') 
         ;  write(' ** FAILED')).

collDemo(_,'Does the test engine work (should fail)?') :- fail.
collDemo(Type,'base types') :-
	empty(Type,X),
	type(X,Type).
collDemo(Type,(cPlusL/3, lPlusC/3)) :-
	cinit(Type,2,C0),   cPlusL(C0,[3,4],C1),
	lPlusC([4,5],C1,L), comment([2,3,4,4,5],L).
collDemo(2,Type,addsFirst/3) :-
        l2c(Type,[a,b,c],C1), l2c(Type,[d,e,f,g],C2),
	addsFirst(C1,C2,C3), c2l(C3,L3), comment([a,b,c,d,e,f,g],L3).
collDemo(Type,addsLast/3) :-
        l2c(Type,[a,b,c],C1), l2c(Type,[d,e,f,g],C2),
	addsLast(C1,C2,C3), c2l(C3,L3), comment([d,e,f,g,a,b,c],L3).
collDemo(Type,printing/portraying) :-
	l2c(Type,[1,2,3,4,5],C),nl,
	write(C), write(=), print(C), nl, % test portray
	cwrite(C),nl.
collDemo(Type,bite/3) :-
	l2c(Type,[1,2,3],C1), l2c(Type,[],C2),
	bite(C1,1,Tail), type(Tail,Type),
	not(bite(C2,_,_)).
collDemo(Type,sorting) :-
	l2c(Type,[1,6,4,5,2,3],C1), 
	ordered(C1,C2), c2l(C2,L), comment([1,2,3,4,5,6],L).
collDemo(Type,'sorting by key') :-
	l2c(Type,[1-a,6-f,4-d,5-e,2-b,3-c],C1), 
	orderedBy(C1,C2), c2l(C2,L), comment([1-a,2-b,3-c,4-d,5-e,6-f],L).
collDemo(Type, addLast/3) :-
	l2c(Type,[1,6,4,5,2,3],C1), 
	addLast(C1,7,C2), c2l(C2,L), comment([1,6,4,5,2,3,7],L).
collDemo(Type,addFirst/3) :-
	l2c(Type,[1,6,4,5,2,3],C1), 
	addFirst(C1,7,C2), c2l(C2,L), comment([7,1,6,4,5,2,3],L).
collDemo(Type,cPlusC/3) :-
        l2c(Type,[a,b,c],C1), l2c(Type,[d,e,f,g],C2),
	cPlusC(C1,C2,C3), c2l(C3,L3), comment([a,b,c,d,e,f,g],L3).
collDemo(Type,cardinality/2) :-
        l2c(Type,[a,b,c],C1), l2c(Type,[],C2),
	cardinality(C1,Card1), cardinality(C2,Card2), 
	comment(3,Card1), comment(0,Card2).
collDemo(Type,within/2) :-
        l2c(Type,[a-1,b,c],C1), 
	within(C1,a-X), 
	comment(1,X).

comment(Desired,Actual) :-
	comment(Desired,Actual,' + ',' - ').
comment(_,Actual,_,_) :- var(Actual),!, write(' ** UNBOUND OUTPUT').
comment(Desired,Actual,Hooray,_) :- 
	(\+ \+ Desired=Actual, write(Hooray)),!.
comment(_,_,_,Oops) :- write(Oops), fail.
/*\end{prol1}

\begin{prol1}*/
cwrite(X) :- seeing(Stream), cwrite(X,Stream).
portray(X)       :- type(X,T), \+ T = list, write('#c').

cAfterL(C0,L,C)  :- type(C0,T), l2c(T,L,C1), cPlusC(C1,C0,C).
cBeforeL(C0,L,C) :- cPlusL(C0,L,C).

cPlusL(C0,L,C)   :- type(C0,T), l2c(T,L,C1), cPlusC(C0,C1,C).
lPlusC(L0,C0,L)  :- c2l(C0,L1), append(L1,L0,L).

addsFirst(X,Y,Z) :- cPlusC(X,Y,Z).
addsLast(X,Y,Z)  :- cPlusC(Y,X,Z).
l2c(L,C)         :- defaultType(T), l2c(T,L,C).
cinit(X,C)       :- defaultType(T), cinit(T,X,C).
defaultType(list).
/*\end{prol1}

\begin{prol1}*/
type([],list).
type([_|_],list).
type(dList(_,_),dList).
type(lList(_,_),lList).
/*\end{prol1}

\begin{prol1}*/
cwrite([H|T],S)            :- print(S,[H|T]).
cwrite([],S)               :- print(S,[]).
cwrite(lList(_,L),S)       :- print(S,L).
cwrite(dList(S,X),Stream)  :- c2l(dList(S,X),L),print(Stream,L).
/*\end{prol1}

\begin{prol1}*/
empty([]).
empty(list,[]).

empty(lList(0,[])).
empty(lList,lList(0,[])).

empty(dList(0,empty)).
empty(dList,dList(0,_)).
/*\end{prol1}

\begin{prol1}*/
% fails for empty thing
bite(X,_,_) :- empty(X),!,fail.

bite([H|T],              H,T).
bite(lList(N0,[H|T]),    H,lList(N,T))     :- N is N0 - 1.
bite(dList(1,[H|_]-_),   H,Out)            :- !, empty(dList,Out).
bite(dList(N0,[H|T]-End),H,dList(N,T-End)) :- N is N0 - 1.  
/*\end{prol1}

\begin{prol1}*/
cinit(list, X,[X]).
cinit(lList,X,lList( 1,[X])).
cinit(dList,X,dList(1,[X|T]-T)).
/*\end{prol1}

\begin{prol1}*/
l2c(list,L,L).
l2c(lList,L,lList(N,L)) :- length(L,N).
l2c(dList,L,D)     :-  l2DList(L,D).

l2DList([],D)    :- empty(dList,D).
l2DList([H|T],D) :- cinit(dList,H,D0), add2DList(T, D0,D).

add2DList([], A, A).
add2DList([A|B], C, D) :-
        addLast(C, A, E),
        add2DList(B, E, D).

/*\end{prol1}

\begin{prol1}*/
c2l([H|T],[H|T]).
c2l([],[]).
c2l(lList(_,L),L).
c2l(dList(0,_),[])   :- !.
c2l(dList(_,In),Out) :- copyFromDList(In,Out).

copyFromDList([W|_]-_,[]) :- var(W),!.
copyFromDList([W,X|Y]-Z,[W|Rest]) :-
	copyFromDList([X|Y]-Z,Rest).
/*\end{prol1}

\begin{prol1}*/
ordered([],[]).
ordered([H|T],Out) :- sort([H|T],Out).
ordered(lList(S,L0),lList(S,L)) :- msort(L0,L).
ordered(dList(S,D0),D) :- 
	c2l(dList(S,D0),L0), msort(L0,L),l2c(dList,L,D).
/*\end{prol1}

\begin{prol1}*/
orderedBy([],[]).
orderedBy([H|T],Out) :- keysort([H|T],Out).
orderedBy(lList(S,L0),lList(S,L)) :- keysort(L0,L).
orderedBy(dList(S,D0),D) :- 
	c2l(dList(S,D0),L0), keysort(L0,L),l2c(dList,L,D).
/*\end{prol1}

\begin{prol1}*/
addLast([],Item,[Item]).
addLast([H|T],Item,[H|Rest]) :- 
	addLast(T,Item,Rest).
addLast(lList(N0,In),Item,lList(N,Out)) :- 
	addLast(In,Item,Out), 
	N is N0+1.
addLast(dList(0,_),Item, dList(1,[Item|T]-T)) :- !.
addLast(dList(N0,L-[Item|End]),Item, dList(N,L-End)) :- 
	N is N0 + 1.
/*\end{prol1}

\begin{prol1}*/
addFirst([],Item,[Item]).
addFirst([H|T],Item,[Item,H|T]).
addFirst(lList(N0,In),Item,lList(N,[Item|In])) :- 
	N is N0+1.
addFirst(dList(0,_),Item,dList(1,[Item|T]-T)) :- !.
addFirst(dList(N0,L-End),Item, dList(N,[Item|L]-End)) :- 
	N is N0 + 1.
/*\end{prol2}

\begin{prol1}*/

cPlusC([],L,L).
cPlusC([H|T],L0,L) :- append([H|T],L0,L).
cPlusC(lList(S0,L0),lList(S1,L1),lList(S,L)) :-	
	append(L0,L1,L),
	S is S0 + S1.
cPlusC(dList(S0,X0),dList(S1,X1),dList(S,X)) :-
	dListPlusDList(S0,S1,X0,X1,S,X).

dListPlusDList(0,S,_,Second,S,Second)      :- !.
dListPlusDList(S,0,First,_,S,First)        :- !. 
dListPlusDList(S1,S2,H1-L2,L2-E2,S3,H1-E2) :- S3 is S1 + S2.
/*\end{prol1}

\begin{prol1}*/

/*\end{prol1}

\begin{prol1}*/
cardinality([],0).
cardinality([H|T],X) :- length([H|T],X).
cardinality(lList(S,_),S).
cardinality(dList(S,_),S).
/*\end{prol1}

\begin{prol1}*/

/*\end{prol1}

\begin{prol1}*/
within([H|T],X)          :- member(X,[H|T]).
within(lList(_,L),X)     :- member(X,L).
within(dList(S,In),Item) :- S > 0,memberDList(Item,In).

memberDList(_,[Y|_]-_) :- var(Y),!,fail.
memberDList(Item,[Item|_]-_).
memberDList(Item,[_,X|Y]-Z) :- memberDList(Item,[X|Y]-Z).
/*\end{prol1}


\subsection{Lists}
\subsection{Linked Lists}

\subsection{Difference Lists}

quirk: can't have an empty one



\part{Frameworks}

\chapter{Search}

\begin{quote} 
\raggedleft  
{\em KING: Where is Polonius?\\
HAMLET: In heaven: send thither to see;\\
if your messenger find him not there, seek\\
him i'the other place yourself.}\\
Hamlet
\end{quote}

Given a directed graph representing the possible connections in a
domain, various search techniques can be employed to find connections
between two vertices.  After Norvig~\cite{Norvig92} and
Laird~\cite{laird83}, 
we will argue
that many of these are simple variations on a single generic graph
search algorithm with the following parameters:
\bi
\item
A list of {\ent states} we could explore;
\item
A test {\ent done} that succeeds when some state is a goal state;
\item
XXX
\ei

\begin{prol1}*/
skeletonWriter(X,Slots,Skeletons) :-
	bagof(Skeleton,
		Slots^X^skeletonWriter1(X,Slots,Skeleton),
	      Skeletons).

skeletonWriter1(X,Slots,Out) :-
	value0(source,Slots,F/A),
	functor(Source,F,A),
	member(swaps : Swaps0,Slots),
	makeSwaps([F/A:X/A|Swaps0],Swaps),
	clause(Source,Body),
	swap((Source :- Body),Out,Swaps,_).

makeSwaps([],[]).
makeSwaps([F1/A : F2/A|Tail],Swaps) :- !,   
	functor(T1,F1,A), functor(T2,F2,A),
	T1 =.. [F1|Args], T2 =.. [F2|Args],
	makeSwaps([T1:T2|Tail],Swaps).
makeSwaps([X0:Y0|T1],['#swap'(X1,X2,Y1,Y2)|T2]) :-
	copy_term(X0:Y0,X1:Y1),
	copy_term(X0:Y0,X2:Y2), 
	makeSwaps(T1,T2).

portray('#swap'(_,_,_,_))     :- print(swap).
portray([H|_]) :- \+ var(H), H = '#swap'(_,_,_,_),print(listOfSwaps).
/*\end{prol1}
\begin{prol1}*/
swap(In,Out,Swap0,Swap) :- swap1(In,Temp,Swap0,Swap),!,shrink(Temp,Out).

swap1(X,              X)              --> {var(X)}.
swap1([H0|T0],        [H|T])          --> swap(H0,H),swap(T0,T).
swap1((X0->Y0|Z0),    (X->Y|Z))       --> swap([X0,Y0,Z0],[X,Y,Z]).
swap1((X0->Y0;Z0),    (X->Y;Z))       --> swap([X0,Y0,Z0],[X,Y,Z]).
swap1((X0 :- Y0),     (X :- Y))       --> swap([X0,Y0],[X,Y]).
swap1((X0,Y0),        (X,Y))          --> swap([X0,Y0],[X,Y]).
swap1((X0;Y0),        (X;Y))          --> swap([X0,Y0],[X,Y]).
swap1((X0|Y0),        (X|Y))          --> swap([X0,Y0],[X,Y]).
swap1(X^Y0,           X^Y)            --> swap(Y0,Y).
swap1(bagof(X,  Y0,Z),bagof(X,  Y,Z)) --> swap(Y0,Y). 
swap1(setof(X,  Y0,Z),setof(X,  Y,Z)) --> swap(Y0,Y). 
swap1(findall(X,Y0,Z),findall(X,Y,Z)) --> swap(Y0,Y).
swap1(call(X0),       call(X))        --> swap(X0,X).
swap1(Old,            New,Swaps0,Swaps):- swap2(Swaps0,Old,New,Swaps).
swap1([],             [], Swaps, Swaps).  
swap1(X,              X,  Swaps, Swaps).
/*\end{prol1}
\begin{prol1}*/ 
shrink(X,Y) :- shrink1(X,Y),!.

shrink1(X,           X)     :- var(X).
shrink1({X},         true)  :- X.
shrink1((true,X0),   X)     :- shrink(X0,X).
shrink1((X0,true),   X)     :- shrink(X0,X).
shrink1((X0,Y0),     (X,Y)) :- shrink(X0,X), shrink(Y0,Y).
shrink1((X :- true), X).
shrink1(X,           X).
  
swap2(['#swap'(Old, Old1,New, New1)|Swaps],Old,New,
      ['#swap'(Old1,Old2,New1,New2)|Swaps]) :- !,
	copy_term(Old1,Old2),
	copy_term(New1,New2).
swap2([H|T0],Old,New,[H|T]) :- 
	swap2(T0,Old,New,T).
/*\end{prol1} 


specification accumulators
reserved syntax: 
\bi
\item slot X : Y
\item addtops X = Y + List. (and swap source for x is added to the swap)
\item other(X).
\ei

\begin{prol1} */
treeSearch(Start,Route) :-
	cinit(Start,States0),
	treeSearch1(States0,Route),!.

assertion  = [writer: skeletonWriter, assert: fail].
treeSearch = assertion   + [source: treeSearch/2].          
bfsL12     = treeSearch  + [assert: true,
                            swaps : [treeSearch1/2: bfsTwelveL1/2,
                                     cinit(X,Y)   : { cinit(list,X,Y) }]].
/* \end{prol1}
\begin{prol1}*/
treeSearch1(States,[First]) :-
  	bite(States,First,_),
	found(First),
	debug(found(First)),!.

treeSearch1(States0,[State|Rest]) :-
	debug(states(States0)),
	bite(States0,State,States1),
	(next(State,List)
	-> combine(List,States1,States2)
	;  States2 = States1),
	rank(States2,States3),
	prune(States3,States),
	treeSearch1(States,Rest).
/*\end{prol1}
\begin{prol1} */
treeSearch1 = assertion + [source: treeSearch1/2,
                           swaps : [rank(S1,S2) : {S1 = S2}, 
                                    prune(S2,S3): {S2 = S3},
                                    debug(X)     : {X=X}]].
bfs1       = treeSearch1 + [swaps: [combine/3     : cAfterL/3, 
                                    other(swaps)]].
bfsTwelveL1 = bfs1       + [assert: true,
                            swaps : [bite(C,Head,Tail): {C = [Head|Tail]},
                                     found(F)         : {F = 12},
				     debug/1          : identity/1,
                                     next(X,Y)        : finiteBinaryTree(15,X,Y),
                                     other(swaps)]].
/*\end{prol1}
\begin{prol1}*/
dfsL12     = treeSearch  + [assert: true,
                            swaps : [treeSearch1/2: dfsTwelveL1/2,
                                     cinit(X,Y)   : { cinit(list,X,Y) }]].
dfs1        = treeSearch1 + [swaps: [combine/3     : cAfterL/3, 
                                     other(swaps)]].
dfsTwelveL1 = bfs1        + [assert: true,
                             swaps : [bite(C,Head,Tail): {C = [Head|Tail]},
                                     found(F)         : {F = 12},
				     debug/1          : identity/1,
                                     next(In,Out)     : finiteBinaryTree(15,
                                                                    In,Out),
                                     other(swaps)]].
/*\end{prol1}

\begin{prol1}*/
binaryTree(X,[N1,N2])   :- N1 is 2 * X, N2 is 1 + N1.
finiteBinaryTree(N,X,B) :- X < N // 2, binaryTree(X,B).

demo(breadthFirstSearch(list(slow,Path))) :-
	treeSearchSlow(1,list,[=,12],identity,[finiteBinaryTree,15],
                       addsLast,identity,identity,Path).
demo(breadthFirstSearch(list(fast,Path))) :- 
	bfsL12(1,Path).

identity(X,X).
identity(_).
/*\end{prol1}


\begin{prol1} */
treeSearchSlow(Start,CType,Found,Debug,Next,Combine,Rank,Prune,Route) :-
	cinit(CType,Start,States0),
	treeSearchSlow1(States0,
			CType,Found,Debug,Next,Combine,Rank,Prune,
		        Route),
	!.

treeSearchSlow1(States,
		_CType,Found,Debug,_Next,_Combine,_Rank,_qPrune,
                [First]) :-
  	bite(States,First,_),
	meta(Found,[First]),
	meta(Debug,[found(First)]).

treeSearchSlow1(States0,
	        CType,Found,Debug,NextP,Combine,Rank,Prune,
                [State|Rest]) :-
	meta(Debug,[states(States0)]),
	bite(States0,State,States1),
	(meta(NextP,[State,Next])
	-> meta(Combine,[Next,States1,States2])
	;  States2 = States1),
	meta(Rank,[States2,States3]),
	meta(Prune,[States3,States]),
	treeSearchSlow1(States,
			CType,Found,Debug,NextP,Combine,Rank,Prune,
                        Rest).

/*\end{prol1}

\begin{prol1} */

demo(bfsSlowFast) :-
	demo(breadthFirstSearch(list(slow,Path1))),
	demo(breadthFirstSearch(list(fast,Path2))),
	Path1=Path2,
	compareTimes([demo(breadthFirstSearch(list(slow,_))), 
                     demo(breadthFirstSearch(list(fast,_)))],200,T),
	write_ln(T). 
/*\end{prol1}

\begin{prol1}*/	
dfs1 = treeSearch1 + 
[ swaps : [ combine/3              : cPlusC/3
          , other(swaps)
]        ]. 

dfsL12 = treeSearch +
[ assert : true
, swaps  : [ treeSearchL1/2 : dfsTwelveL1/2
           , cinit(X,Y)    : { Y = [X] }
]          ]. 

dfsTwelve1 = dfs1 +
[ swaps  : [ debug/1            : identity/1 
           , found(F)           : {F = 12}
           , other(swaps)
]           ].

/*
dfsTwelveG1 = dfsTwelve1 +
[ assert : true
, swaps : [ next(A,B)         : finiteBinaryTree(15,list,A,C)
% need a generic addList First
% need a generic addList Last
	   , combine/3         : append/3
           , other(swaps)
]         ].
*/

dfsTwelveL1 = dfsTwelve1 +
[ assert : true
, swaps : [  bite(C,Head,Tail) : {C = [Head|Tail]} 
           , next(A,B)         : finiteBinaryTree(15,list,A,B)
	   , combine/3         : append/3
           , other(swaps)
]         ].

/*dfsTwelveD1 = dfsTwelve1 +
[ assert : true1
, swaps : [ treeSearch1/2      : dfsTwelveD1/2
           , bite(C,Head,Tail) : {C = [H1,H2|T] - End, 
                                   Head = H1,
                                   Tail = (T-End)
                                  }
           , next(A,B)         :  (A < 15,
                                  {B= [X1,X2|End]-End},
                                   X1 is A * 2,
                                   X2 is X1 + 1)
	   , combine(           :  append/3
]         ].
*/
/*\end{prol1}

\begin{prol1}*/	
demo(firstSearchTest) :-
	depthFirstSearch(1,[=,12],[finiteBinaryTree,15],_Path).

demo(bestFirstSearch) :-
	bestFirstSearch(1,[=,12],[binaryTree,list],[close2n,12],_Path).
/*
\end{prol1}

\begin{prol1}*/
bestFirstSearch(c).

close2n(N,In,Out) :-
	type(In,T),
	c2l(In,L0),
	close2n1(L0,N,L1),
	msort(L1,L2),
	stripDash(L2,L3),
	l2c(T,L3,Out).

close2n1([],_,[]).
close2n1([H0|T0],N,[N-H0|T]) :-
	N is abs(N - H0),
	close2n1(T0,N,T).

stripDash([],[]).
stripDash([_-H|T],[H|Rest]) :- stripDash(T,Rest).
% also, for the data structures...
	
% i want an itenrator
diff(12,X,Y) :- Y is 12 - X.
/*\end{prol1}
\part{Patterns}

{\small
\printindex
}

{\small
\bibliographystyle{myplain}
\bibliography{../../refs/refs}
}

{\footnotesize
Some of the Menzies papers can be found at
{\em  http:// www.cse.unsw.edu.au/ $\sim$timm/pub/
docs/papersonly.html}}.


\end{document}*/
