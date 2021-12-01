/*\documentstyle[a4,11pt,makeidx,fancyheadings,lastpage,epsf]{article}
\columnsep 0.25in
% \topmargin -1.1in
\textwidth 15.95cm
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

%\newcommand{\max}{{\em max}}
\newcommand{\bc}{\begin{center}}
\newcommand{\ec}{\end{center}}
\newcommand{\bver}{\begin{verbatim}}
\newcommand{\ever}{\end{verbatim}}
\newcommand{\beq}{\begin{equation}}
\newcommand{\eeq}{\end{equation}}

\newcommand{\be}{\begin{enumerate}}
\newcommand{\ee}{\end{enumerate}}
\newcommand{\bi}{\begin{itemize}}

\newcommand{\ei}{\end{itemize}}
\newcommand{\my}[1]{\mbox{\(\cal #1\)}}
\newcommand{\myy}[2]{\( {\cal {#1}}_{#2} \)}
\newcommand{\kla}{$\my{KL}_A$~}
\newcommand{\klb}{$\my{KL}_B$~}
\newcommand{\myset}[1]{{\tt\{#1\}}}
\newcommand{\src}[1]{Listing~\ref{#1}}
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
\rhead[\fancyplain{}{\sl \leftmark}]{\fancyplain{}{\sl 
        page \thepage~of~\pageref{LastPage}}}
\cfoot{}
\chead{}
\lfoot{}
\rfoot{}
%\footrulewidth 0.4pt


%%%%%% fancies

\makeindex

\title{{\em G}: Practical Prolog;\\
Defining Records}
\author{
Tim Menzies\\~\newline
Dept. of Software Development, Monash University,\\
Caulfield East, Melbourne,
Melbourne, Australia, 3185.\\
{\tt
timm@insect.sd.monash.edu.au}}

\date{\today}

\begin{document}

\maketitle

\begin{abstract}
We describe a simple record manipulation system for Prolog. The
system allows the programmer to abstract away from the arity
and position of parameters in Prolog terms. In order to
motivate the need for records in Prolog, the code is presented
in tutorial form using the example of building a forward
chainer in Prolog. Benchmarks are presented of using the 
forward chainer, with and without the record system.
\end{abstract}  

\tableofcontents
\pagebreak
\pagestyle{fancy}

\section{Introduction}

Prolog is a poorly understood language:
\bi
\item
It is misleading to
characterise the language as a backward chaining depth-first search
theorem prover. Prolog is better characterised as a language
that performs resolution
over Horn clauses.
This process can be used to
implement any number of search strategies.
\item
When using Prolog, we do not just write down theorems about the domain
under analysis, then let the Prolog theorem prover derive the
deductive consequences.  Rather, Prolog should be used to build
domain-specific specification languages. These languages can both
record a specification and execute it. The ability to execute a
developing specification is an important aid in maturing knowledge
about that specification. These application languages can be
represented in numerous ways such as (e.g.) 
forward-chaining rules, backward-chaining rules, frames,
or abductive inference engines.
\item
Also, using Prolog, we can partially evaluate these specifications into
a more optimised form. That is, where real-time performance is not critical,
we can use Prolog as the delivery language for the system.
\item
We have seen lots of awful Prolog code. Prolog programs can have
an elegant succinctness to them which we find appealing. 
We plan to lead by example and demonstrate numerous such succinct and elegant
programs.
\ei

Our enthusiasm for Prolog is not due to a poor understanding of other
paradigms. We have turned to Prolog
after years of commercial object-oriented
development.
We are now convinced that the only tame the
object-oriented software engineering problem is to use meta-level
logics.  Using such meta-level logics, we can build automatic
tools that can assess a specification written in an application
language. Such assessments can simplify software
maintenance.

In our view, 
practical Prolog code will have the following features:

\bi
\item
A variety of search strategies.
\item
Interpreters of high-level specification languages.
\item 
Optimisers of these specification languages using partial evaluation.
\item
Maintenance tools based on meta-level programming.
\item 
And tools for reducing the complexity of building the above features.
\ei

Note that some of the problems we tackle have been addressed in
non-standard Prolog extensions. We elect to remain with standard
Prolog. Numerous commercial strength standard Prolog systems are
available. Introductory Prolog texts are commonly available. Rather than
move on to a new language, we prefer to study what can be achieved with
commercially accessible tools.
The systems we build should be small extensions to standard Prolog. We
call such extended Prolog systems {\em Prologg}, or {\em G} for short.

This paper is the first step in the {\em G} project.  We simplify part
of the implementation of a forward-chaining system using record
structures in Prolog. \src{yuck} show code that pre-processes a rule
like \src{rule1}.

\begin{prol}\begin{verbatim}*/
% operators used in this paper.
:- op(999,xfx,if), op(998,xfx,then), op(997,xfx,or), op(996,xfx,and), 
   op(995,fx,not), op(50,xf,++),     op(50,xf,--),   op(50,xfx,in),
   op(10,fx,rule), op(9,xfx,at).
/*\end{verbatim}\index{operator definitions}\end{prol}

\begin{prol}\begin{verbatim}*/
rule    'check for badly paying job'
if      employee(Name,Job,_Age) and 
        salary(Job,0)
then    print(error(Name-poorlyPaid(Job))).
/*\end{verbatim}\label{rule1}
\index{check for badly paying job}
\end{prol}

\begin{prol}\begin{verbatim}*/
rTrans2(rule Name at Priority if Lhs0 then Rhs, 
        rule(Name,UsedIds,Ages,Specificity,Priority,Lhs,Rhs)) :-
        rTrans2(Lhs0,Lhs,[],Ages,0,Specificity,[],UsedIds).

rTrans2(A0 and B0,A and B,Ages0,Ages,       Spec0,Spec,  UsedIds0,UsedIds) :- !, 
        rTrans2(A0,A,     Ages0,Ages1,      Spec0,Spec1, UsedIds0,UsedIds1),
        rTrans2(B0,B,     Ages1,Ages,       Spec1,Spec,  UsedIds1,UsedIds).
rTrans2(A0 or B0, A or B, Ages0,Ages,       Spec0,Spec,  UsedIds0,UsedIds) :- !,
        rTrans2(A0,A,     Ages0,Ages1,      Spec0,Spec1, UsedIds0,UsedIds1),
        rTrans2(B0,B,     Ages1,Ages,       Spec1,Spec,  UsedIds1,UsedIds).
rTrans2(not A0, not A,    Ages0,Ages,       Spec0,Spec,  UsedIds0,UsedIds) :- !,
       rTrans2(A0,A,      Ages0,Ages,       Spec0,Spec,  UsedIds0,UsedIds).
rTrans2(A0,A,             Ages0,[Age|Ages0],Spec0,Spec,  UsedIds0,[Id|UsedIds0]) :-
        A0 =.. [Functor|Args],
        A  =.. [Functor,Id,Age|Args],
        Spec is Spec0 + 1.
/*\end{verbatim}\label{yuck}\index{rTrans2/2}\end{prol}

In this paper we will define a new predicate
{\tt defRecord/2} 
which we can use to simplify \src{yuck} to \src{dream0}.

\begin{prol}\begin{verbatim}
:- defRecord(rule, [
        name,lhs,rhs,usedIds=[],ages=[],specificity=0,priority=0]). 
\end{verbatim}\index{defRecord/2~{\em usage}}\end{prol}

\begin{prol}\begin{verbatim}*/
rTrans(rule Name at Priority if Lhs0 then Rhs,Rule) :- 
        create(rule,[name=Name, priority=Priority, rhs=Rhs, lhs=Lhs], Rule0),
        rTrans(Lhs0,Lhs,Rule0,Rule).

rTrans(A0 and B0,A and B) --> !, rTrans(A0,A), rTrans(B0,B).
rTrans(A0 or B0, A or B)  --> !, rTrans(A0,A), rTrans(B0,B).
rTrans(not A0, not A)     --> !, rTrans(A0,A).
rTrans(A0,A) -->
        { A0 =.. [Functor|Args],
          A  =.. [Functor,Id,Age|Args] },
        o([ages<<Age,specificity++,usedIds<<Id]).
/*\end{verbatim}
\label{dream0}
\index{rTrans/2}
\index{rTrans/4}
\end{prol}

Note that the simplification was achieved by defining a {\tt rule}
record that allows multiple fields to be passed around in one argument.
Such record structures have many advantages:

\bi

\item Communities of programmers can work on the same project.
Each programmer needs not know all the details of their colleagues
work. Rather, they only need to know certain high-level details
about the data structures passed from their colleagues' code. If the internals
of those passed structures ever change, then as long as the high-level
details do not change, those changes will not imply changes to the
rest of the system.

\item 
It is simple to extend a basic record structure to an abstract data
type/ object-oriented framework (a goal of the {\em G} project).

\ei

Prolog has no built-in record structures and so programmers are hence not
isolated from the internal structure of the data they are
processing. Indeed, the pattern-matching style of Prolog encourages
programmers to use the inner details of their data when building their
systems. 

Something like a record structure can be implemented using the  
Prolog
meta-level predicates {\tt arg/3, functor/3, =../2}.  See below.

\subsection{Notes}

This document was written at great speed. Hence, much of
the code shown here will be presented in a stream-of-consciousness manner.
In order to assist with the navigation of our tangled stream-of-thought,
we provide an index at the back for all our defined programs.

Despite the speed with which this document was written, all 
the code described here really works as advertised.
We passed out \LaTeX source code, plus some extra comment characters, 
directly to our SWI-Prolog interpreter. Thanks to David Poole for
showing us this trick, which simplified enormously the documentation
of our code.

\section{An Extended Example}

\subsection{A Forward Chainer}

Consider the
forward chaining 
interpreter of \src{fchain1} which can precess rules like that shown in
\src{rule1}.

\begin{prol}\begin{verbatim}*/
fChain1 :-  fChain1([]). % initialise the bindings
fChain1(Bindings0) :-
        rule Name if Lhs then Rhs,
        satisfied(Lhs),
        newBinding(Name,Lhs,Bindings0,Bindings), !,
        execute(Rhs),
        fChain1(Bindings).
fChain1(_).

satisfied(A  or B) :- !, (satisfied(A) ; satisfied(B)).
satisfied(A and B) :- !, satisfied(A), satisfied(B).
satisfied(not A)   :- !, \+ satisfied(A).
satisfied(A)       :- A.

newBinding(Name,Lhs,Bindings, [Name-Lhs|Bindings]) :- %don't repeat old bindings      
       \+ member(Name-Lhs,Bindings).

execute(A and B)   :- !, execute(A), execute(B).
execute(A)         :- A.
/*\end{verbatim}\label{fchain1}
\index{fChain1/0}
\index{fChain1/1}
\index{satisfied/1}
\index{newBindings/4}
\index{execute/1}
\end{prol}

There are many ways to
improve
{\tt fchain1/1}; e.g. indexing the search
{\tt Bindings} list in {\tt newBindings/4}.  
For the purposes of demonstrating our records-in-Prolog technique,
we will explore certain re-write techniques for the KB.
This re-write technique assumes
that all the database terms are ground (i.e. not variables) and have a
unique numeric {\tt Id}. 
Suppose the forward
chainer has access to the {\tt Id}s used in the rule (as in
\src{rule2}).

\begin{prol}\begin{verbatim}*/
rule    'check for badly paying job; version 2' 
==      [Id1,Id2]
if      employee(Id1,Name,Job,_Age) and 
        salary(Id2,Job,0)
then    print(error(Name-poorlyPaid(Job))).
/*\end{verbatim}\label{rule2}
\index{check for badly paying job; version 2}
\end{prol}

Using \src{fchain2}, we  can now reduce the size of the
structures examined in the {\tt newBindings/4} test.

\begin{prol}\begin{verbatim}*/
fChain2 :-  fChain2([]). % initialise the bindings
fChain2(Bindings0) :-
        rule Name == UsedIds if Lhs then Rhs,
        satisfied(Lhs),
        newBinding(Name,UsedIds,Bindings0,Bindings), !,
        execute(Rhs),
        fChain2(Bindings).
fChain2(_).
/*\end{verbatim}\label{fchain2}\index{fchain2/0}
\index{fchain2/1}\end{prol}

If we assume that all facts store their {\tt Id} as their first
argument, then a KB translator could automate the process of collecting
the {tt Id}s.  If this was done, then \src{rule2} could be shorter;
e.g. \src{rule3}.
\begin{prol}\begin{verbatim}*/
rule    'check for badly paying job; version 3' 
if      employee(Name,Job,_Age) and 
        salary(Job,0)
then    print(error(Name-poorlyPaid(Job))).
/*\end{verbatim}\label{rule3}
\index{check for badly paying job; version 3}\end{prol}

The rest of this
section describes a translator that automatically converts
rules like \src{rule3} into a more useful internal
form; e.g. \src{rule2}.

\subsection{Rule Translator}

Our version 1 rule translator
updates a list of {\tt Id}s
as it performs a recursive descent of the rule {\tt Lhs}.
 
\begin{prol}\begin{verbatim}*/
rTrans1(Name if Lhs0 then Rhs, Name == UsedIds if Lhs then Rhs) :-
        rTrans1(Lhs0,Lhs, [],     % initialise used Ids to the empty set
                          UsedIds % final value of the used Ids
        ).

rTrans1(A0 and B0,A and B,UsedIds0,UsedIds) :- !, 
        rTrans1(A0,A,UsedIds0,UsedIds1),
        rTrans1(B0,B,UsedIds1,UsedIds).
rTrans1(A0 or B0, A or B,UsedIds0,UsedIds) :- !,
        rTrans1(A0,A,UsedIds0,UsedIds1),
        rTrans1(B0,B,UsedIds1,UsedIds).
rTrans1(not A0, not A, UsedIds0,UsedIds) :- !,
       rTrans1(A0,A,UsedIds0,UsedIds).
/*\end{verbatim}\label{rTransA}\index{rTrans1/2}\end{prol}

The ``engine room'' of the process is the last {\tt rTrans1/4}
clause in \src{rTrans1base}. 

\begin{prol}\begin{verbatim}*/
rTrans1(A0,A,UsedIds0,[Id|UsedIds0]) :-
        A0 =.. [Functor|Args],
        A  =.. [Functor,Id|Args].
/*\end{verbatim}\label{rTrans1base}\index{rTrans1/2}\end{prol}

This clause uses the {tt univ} predicate ({\tt =..}) to bust 
apart the input term {\tt A0} and inserts a new
first argument {\tt Id}. This new {\tt Id} is then added to the
{\tt UsedIds0} list. \src{rTransAtest} will now generate
\src{rTransAout}.
 
\begin{prol}\begin{verbatim}*/
rTrans1Test(What) :-
        rule  What if Lhs0 then Rhs0,
        rTrans1(rule What if Lhs0 then Rhs0,Out),
        print(Out),nl.
/*\end{verbatim}\label{rTransAtest}\index{rTrans1Test/1}\end{prol}

\begin{prol}\begin{verbatim}
:- rTrans1Test('check for badly paying job; version 3').

rule    'check for badly paying job; version 3' 
==      [G1036,G932] 
if      employee(G932, G788, G792, G796) and 
        salary(G1036, G792, 0) 
then    print(error(G788 - poorlyPaid(G792))).
\end{verbatim}\label{rTransAout}\index{rTrans1Test/1!{\em output}}\end{prol}

\subsection{Conflict Resolution Strategies}

Now consider what happens to {\tt rTrans/1}
if we extend the forward chainer. For example,
the {\tt newBindings/4} test implements
conflict resolution by {\em refraction}; i.e. don't do the same
thing twice. Other conflict resolution strategies require more
information about the rules:
\bi

\item
Conflict resolution by {\em specificity} favours rules
with larger {\tt Lhs}.
To implement specificity, our rule translator should also return
the
number of tests in the {\tt Lhs}.
\item
Conflict resolution by {\em recency}  favours
rules whose {\tt Lhs} matches assertions that are the most recent.
We will assume that whenever an assertion is
modified, its {\tt assertionAge} argument (stored at position 2)
is updated by one\footnote{We could make the {\tt Id} parameter
serve double duty and make it also act as the {\tt assertionAge}.
We will not since we need to complicate
our translator for demonstration purposes.}.
To implement recency, our rule translator should also return the
average {\tt assertionAge}s of the matched assertions.    
\item
Conflict resolution by {\em priority} favours rules with a
larger number priority rating supplied by the user. To use
priority, we need to extend our rule syntax (e.g. see \src{rule4}).
\ei
\begin{prol}\begin{verbatim}*/
rule    'check for badly paying job; version 4' 
at      10                                       % rule priority
if      employee(Name,Job,_Age) and 
        salary(Job,0)
then    print(error(Name-poorlyPaid(Job))).
/*\end{verbatim}\label{rule4}
\index{check for badly paying job; version 4}
\end{prol}

Our new rule translator will convert rules like \src{rule4}
into
the {\tt rule/7} format
shown in \src{defrule7}:

\begin{prol}\begin{verbatim}
rule(Name,UsedIds,Ages,Specificity,Priority,Lhs,Rhs).
\end{verbatim}\label{defrule7}\end{prol}

If we extend {\tt rTrans1/2}
such that extra arguments are
passed
to collect this new information,
then we get {\tt rTrans2/2} shown in \src{yuck}.
If we test {\tt rTrans2} using the code of \src{rTransBtest}
we get the desired output shown in \src{rTransBtestout}.

\begin{prol}\begin{verbatim}*/
rTrans2Test(What) :-
        rule  What at Priority if Lhs0 then Rhs0,
        rTrans2(rule What at Priority if Lhs0 then Rhs0,Out),
        print(Out),nl.
/*\end{verbatim}\label{rTransBtest}\index{rTrans2Test/1}\end{prol}

\begin{prol}\begin{verbatim}
:- rTrans2Test('check for badly paying job; version 4').

rule('check for badly paying job; version 4',           % Name 
      [G2108,G1964],                                    % UsedIds
      [G2096,G1952],                                    % Ages
      2,                                                % Specificity
      10,                                               % Priority
      employee(G1964, G1952, G1800, G1804, G1808) and   % Lhs
      salary(G2108, G2096, G1804, 0),                   
      print(error(G1800 - poorlyPaid(G1804)))           % Rhs
).
\end{verbatim}
\label{rTransBtestout}
\index{rTrans2Test/1!{\em output}}
\end{prol}

\subsection{The Desired Rule Translator}

Note that it is a tedious task to add all
the required parameters to the sub-routines of {\tt rTrans/2}
in \src{yuck}. 
In
practice,
this tedium complicates maintenance, discourages program improvement,
and may introduce errors into the program.
Ideally, we would like some
record structure that we could pass around
as a single parameter. 
Further, we would like a
set
of common operations defined on the fields of that record; for example:

\bi
\item
{\tt Field\verb+<<+Item}: append {\tt Item} to the list stored
in {\tt Field}.
\item
{\tt Field\verb2++2}: increment the number stored in {\tt Field}
by one.
\ei

Once so defined, then the rule translator would look like
\src{rTrans3/2}.
\begin{prol}\begin{verbatim}
:- defRecord(rule,[name,lhs,rhs,
                   usedIds=[],    ages=[],
                   specificity=0, priority=0]). 
\end{verbatim}\index{defRecord/2!{\em usage}}\end{prol}

\begin{prol}\begin{verbatim}*/
rTrans3(rule Name at Priority if Lhs0 then Rhs,Rule) :- 
        create(rule,[name=Name, priority=Priority, rhs=Rhs, lhs=Lhs], Rule0),
        rTrans3(Lhs0,Lhs,Rule0,Rule).

rTrans3(A0 and B0,A and B,R0,R) :- !, rTrans3(A0,A,R0,R1), rTrans3(B0,B,R1,R).
rTrans3(A0 or B0, A or B, R0,R) :- !, rTrans3(A0,A,R0,R1), rTrans3(B0,B,R1,R).
rTrans3(not A0,   not A,  R0,R) :- !, rTrans3(A0,A,R0,R).
rTrans3(A0,       A,      R0,R) :-
        A0 =.. [Functor|Args],
        A  =.. [Functor,Id,Age|Args],
        o([ages<<Age,specificity++,usedIds<<Id],R0,R).
/*\end{verbatim}
\label{rTrans3/2}
\index{rTrans3/2}
\index{rTrans3/4}
\end{prol}

{\tt rTrans3/4} uses the {\tt o/3} predicate to
access the record structures.
This is a, currently fictional, predicate
that modifies the second argument to produce the third argument using
the instructions stored in the first argument.
Note that the programmer is now more isolated from the internals
of
our rule structure.
\bi
\item
The first argument to {\tt o/3} need not be in any particular
order.
\item If new fields are added to {\tt rule} using the {\tt
defRecord/2} command, then the code for {\tt rTrans3} will not need
to be changed.
\ei


Using DCG syntax, we can even avoid the tedium of coding how different
versions of the rule are passed around as the last two arguments of
each {\tt rTrans3/4} clause. This re-coding is shown in \src{dream0}.

\section{Implementation}

The previous sections motivated the need for a record
system in Prolog.
This section describes its implementation.

\subsection{Primitive Accessors and Updates}

Records are defined using {\tt defRecord/2}. The first argument is a
symbol identifying the record type, and the second argument is a list
of fields for that record, optionally with initialisations. 
For
example, we can define a {\tt Person} record
with four fields as per \src{defPerson}.
Note that our default {\tt Person}'s fourth field ({\tt shoeSize}
has an initial value of 12.

\begin{prol}\begin{verbatim}
:- defRecord(person,[
        name,duties,age,shoeSize=12])
\end{verbatim}\label{defPerson}
\index{defRecord/2!{\em usage}}
\end{prol}

Once a record is defined, a set of {\em primitive accessors} are
automatically asserted for each field in the record. The accessors for
{\tt person/4} are shown in \src{person03}.

\begin{prol}\begin{verbatim}
% example person0/3: asserted by defRecord/2
person0(name,     person(Name, _,      _,   _),        Name).
person0(duties,   person(_,    Duties, _,   _),        Duties).
person0(age,      person(_,    _,      Age, _),        Age).
person0(shoeSize, person(_,    _,      _,   ShoeSize), ShoeSize).
\end{verbatim}\label{person03}\index{person0/3}
\index{primitives!accessor!{\em example}}
\end{prol}

Note the convention. If the record name is {\tt X} then the primitive
accessor
is {\tt X0/3}.  Further, {\tt X0/5} is a {\em primitive update} predicate that is
automatically
defined which lets us swap values (e.g \src{person05}.

\begin{prol}\begin{verbatim}
% example person0/5: asserted by defRecord/2
person0(name,    person(Old,B,  C,  D),  Old, person(New,B,  C,  D),  New).
person0(duties,  person(A,  Old,C,  D),  Old, person(A,  New,C,  D),  New).
person0(age,     person(A,  B,  Old,D),  Old, person(A,  B,  New,D),  New).
person0(shoeSize,person(A,  B,  C,  Old),Old, person(A,  B,  C,  New),New).
\end{verbatim}\label{person05}
\index{person0/5}
\index{primitives!update!{\em example}}
\end{prol}

A programmer can use these primitives
without knowledge of the internal structures
of each record; e.g. verb+person0(name,Person,Name)+
returns the {\tt Name} of {\tt Person}. If the definition of
{\tt Person} was to change in the future, {\tt defRecord/2}
will automatically rewrite {\tt person0/3} and {\tt person0/5}.

\subsection{Using the Primitives}

Note that to use the primitives, the accessor needs knowledge
of the magic name {\tt person0}. A generic shell needs to map from
these magic names to a more general predicate. This is
task of {\tt o1/3}.

\begin{prol}\begin{verbatim}
% example o1/3: asserted by defRecord
o1(person(A,B,C,D),E,F) :- 
        person0(E, person(A,B,C,D),F).
\end{verbatim}\label{o1/3}\index{o1/3}\end{prol}

The {\tt swap/5} predicate maps the generic processing
into the primitive update predicate.

\begin{prol}\begin{verbatim}
% swap/5 asserted by defRecord
swap(person(A,B,C,D),E,F,G,H) :- 
        person0(F,person(A,B,C,D),E,G,H).
\end{verbatim}\label{swap/5}\index{swap/5!{\em example}}\end{prol}

In operation, there will be many {\tt o1/3, swap/5} and (e.g.) {\tt person0}
assertions. We use Prolog's defaukt indesinxg strategy (functor of
first argument) to optimise the seearch fro the correct predicate.
{\tt o1/3} is indexed by the term passed into its first argument.
The primitives are indexed by the name of the principle functor and their
first arguments.

Calls to {\tt o1/3} are via {\tt o0/3}.
{\tt o0/3} extracts a field or prints an error message
if it can't find it. 

\begin{prol}\begin{verbatim}*/
o0(F,Term,V) :- o1(Term,F,V0),!,V = V0.
o0(F,Term,V) :- write(failed(o0(F,Term,V))), nl, fail.
/*\end{verbatim}\index{o0/3}\end{prol}

\subsection{The General Shell}

A programmer using the {\tt defRecord} system can ignore the
{\tt o1/3, o0/3} and {\tt swap/5} predicates. The high-level
general record accessor is the {\tt o/3} predicate.

\begin{prol}\begin{verbatim}*/
% updates
o(Field=New, T0,T)    :- swap(T0,_,Field,T,New).
% accessors
o(Field==X,     T, T) :- o1(T,Field, X).
/*\end{verbatim}\label{o3a}\index{o/3}\end{prol}

{\tt o/3} implements certain common record operations.

\begin{prol}\begin{verbatim}*/
% queries
o(\+ X,         T, T) :- \+ o(X,          T,_).                 % negation
o(Field>=Value, T, T) :-    o1(T,Field,X), X >= Value.     % comparisons
o(Field> Value, T, T) :-    o1(T,Field,X), X > Value.
o(Field\=Value, T, T) :-    o1(T,Field,X), X \= Value.
o(Field< Value, T, T) :-    o1(T,Field,X), X < Value.
o(Field=<Value, T, T) :-    o1(T,Field,X), X =< Value.     
o(Field in List,T, T) :-    o1(T,Field,X), member(X,List). % membership
/*\end{verbatim}\index{o/3}\end{prol}

\begin{prol}\begin{verbatim}*/
% updates
o(Field++, T0,T) :- % increment
	 o1(T0,Field,Old),                                    
        New is Old + 1, 
        swap(T0,_,Field,T,New).
o(Field--, T0,T) :- o(Field + -1 ,     T0,T).                   % decrement
o(Field-N, T0,T) :- 
	o(Field + (-1 * N),T0,T).                   % minus
o(Field<<X, T0,T) :-                                            
        o1(T0,Field,Old),                                    % list append
        New = [X|Old],                                          % to head
        swap(T0,_,Field,T,New).                                      % (fast)
o(Field+N, T0,T) :-                                             % plus
        o1(T0,Field,Old),                                    
        New is Old + N, 
        swap(T0,_,Field,T,New).
/*\end{verbatim}\index{o/3}\end{prol}

We implement queries with {\tt o/2}.

\begin{prol}\begin{verbatim}*/
% queries only (ignore the output)
o(Gs,T) :- o(Gs,T,_).
/*\end{verbatim}\index{o/2}\end{prol}

We also support multiple
queries by calling {\tt o/3} for each item in a list.

\begin{prol}\begin{verbatim}*/
o([],T,T).
o([G|Gs],T0,T) :- 
        o(G,T0,T1), 
        o(Gs,T1,T).
/*\end{verbatim}\index{o/3}\index{o/3!multiple calls}\end{prol}

\subsection{{\tt DefRecord/2} Side-Effects}

We have seen above that a call to {\tt defRecord/2} asserts
several predicates:
\bi
\item primitive accessor predicates; e.g. \src{person03}.
\item primiitve update predicates; e.g. \src{person05}.
\item mapping predicates that connect a general record accessor
shell to the primitives; i.e. {\tt o1/3} and {\tt swap/5}
(see Listings \src{o1/3}~\&\ref{swap/5}).
\ei

{\tt DefRecord/2}  also asserts two more predicates:
\bi
\item
{\tt Create/2} stores the default new record.
Recall that in our {\tt person/4} record, {\tt shoeSize} was the
fourth argument with an initial value of 12 (see \src{defPerson}). {\tt DefRecord/2}
therefore
asserts:
\begin{prol}\begin{verbatim}
% create/2 asserted by defRecord
create(person, person(A, B, C, 12)).
\end{verbatim}\index{create/2!{\em example}}\end{prol}
We define 
{\tt Create/3} to allow for over-rriding the default
initial values of a new record:
\begin{prol}\begin{verbatim}*/
create(Thing,Inits,New) :- 
        create(Thing,New0), 
        o(Inits,New0,New).
/*\end{verbatim}\index{create/3}\end{prol}
\item
{\tt DefRecord/2} changes the print behaviour for records. Since
records may be very complex structures, 
we do not show them in print statements.
\begin{prol}\begin{verbatim}
portray(person(A, B, C, D)) :- write('[Rec:'), write(person / 4), write(']').
\end{verbatim}\label{portray/1}\index{portray/1!{\em example}}\end{prol}
\item
{\tt DefRecord/2} stores skeletons of all the structures it asserts
in
{\tt Meta/4}.
\begin{prol}\begin{verbatim}
% meta/4 asserted by defRecord
meta(person, person(A, B, C, D), 
             person0(E, F, G),         % primitive accessor
             person0(H, I, J, K,L)     % primitive update predicate
).
\end{verbatim}\index{meta/4!{\em example}}\end{prol}
{\tt meta/4}
is useful for 
clearing away of out-dated records (see {\tt undefineRecord/1} in \src{undefineRecord/1}).

\ei
\begin{prol}\begin{verbatim}*/
undefineRecord(Type) :-
        retract(meta(Type,Skeleton, Match,Swap)),
        retractall(create(Type,_)),
        retractall((o1(Skeleton, _, _))),
        retractall(Match),
        retractall((swap(Skeleton, _,_,_,_))),
        retractall(Swap),
        retractall(portray(Skeleton)), 
        !.
undefineRecord(_).
/*\end{verbatim}\label{undefineRecord/1}\index{undefineRecord/1}\end{prol}

\subsection{Print Routines}

{\tt printRec/1}, {\tt records} and {\tt record}
permit the pretty printing of a
record as well as showing all the above structures.

\begin{prol}\begin{verbatim}*/
% pretty print a record
printRec(R) :- nl,o1(R,F,V), print(F=V),nl, fail.
printRec(_).

% print all assertions by defRecord/2.
records :- record(_), fail.
records.

% print all assertions relating to Type
record(Type) :-
        meta(Type, Skeleton,Match,Swap), nl, 
        write('%------| '),write(Type),write(' |----------------------------'),nl,
        myListing([     meta(Type, Skeleton,Match,Swap), 
                      portray(Skeleton), create(Type,Skeleton),
                      o1(Skeleton,_,_), swap(Skeleton,_,_,_,_), 
                      Match,Swap]).

myListing(L) :- member(X,L), nl, clause(X,Y), portray_clause((X :- Y)), fail.
myListing(_).
/*\end{verbatim}
\index{printRec/1}
\index{record/1}
\index{myListing/1}
\end{prol}

\subsection{Inside {\tt DefRecord/2}}

Defining a record is quite simple. {\tt DefRecord/2} retracts old
assertions relating to a record (using {\tt undefineRecord/2}), 
creates a magic internal name for the
primitive accessors and primitive update predicates, then calls {\tt
defRecord1/5}
to generate the new assertions.

\begin{prol}\begin{verbatim}*/
defRecord(Functor,Inits) :-
        undefineRecord(Functor),
        length(Inits,Arity),
        magicRecordNames(Functor,MagicName),
        defRecord1(Functor,Arity,Inits,MagicName,Assertion),
        assert(Assertion),
        fail.
defRecord(_,_).

magicRecordNames(Functor,Out) :-
        name(Functor,L0),
        name('0',Zero),
        append(L0,Zero,Out0),
        name(Out,Out0).
/*\end{verbatim}\index{defRecord/2}\index{magicRecordNames/2}\end{prol}

Most of the implementation of {\tt defRecord1/5} is straight-forward. 
\begin{prol}\begin{verbatim}*/
defRecord1(Functor,Arity,_,_,
        (portray(Term) :- write('[Rec:'),write(Functor/Arity),write(']'))) :-
       functor(Term,Functor,Arity).

defRecord1(Functor,Arity,_Inits,MagicName,meta(Functor,Skeleton,MatchG,SwapG)) :-
        functor(Skeleton,Functor,Arity),
        functor(MatchG,MagicName,3),
        functor(SwapG,MagicName,5).

defRecord1(Functor,Arity,_,MagicName,(o1(Term,Field,Value) :- Body)) :-
        Body =.. [MagicName,Field,Term,Value],
        functor(Term,Functor,Arity).

defRecord1(Functor,Arity,_,MagicName,(swap(Term0,V0,Field,Term,V) :- Body)) :-
        Body =.. [MagicName,Field,Term0,V0,Term,V],
        functor(Term0,Functor,Arity).

% create the primitive accessors
defRecord1(Functor,Arity,Inits,MagicName,MatchGoal) :-
        aField(Inits,Pos,Field),
        MatchGoal =.. [MagicName,Field,Term,Value],
        functor(Term,Functor,Arity),
        arg(Pos,Term,Value).
/*\end{verbatim}\index{defRecord1/3}\end{prol}        

The {\tt create/2} assertion has to be built by running down the
{\tt Inits} list and, if an initial value has been offered, installing
that value into the newly created term at the correct position.
The details of this processing is handled by {\tt installInitValues/3}
(see \src{misc-support}).

\begin{prol}\begin{verbatim}*/
defRecord1(Functor,Arity,Inits,_,create(Functor,Creation)) :-
        functor(Creation,Functor,Arity),
        installInitValues(Inits,1,Creation).
/*\end{verbatim}\index{defRecord1/5}\end{prol}        

To create the primitive updates, two new terms must be built. 
Next, for $a$ in 1 to the arity $A$, all the non-$a-th$ arguments must
be unified across to each other. The $a-th$ argument in each term then
becomes a handle for the old value and the new value. The details of
this
process is handled by {\tt swapVars/6} (see \src{misc-support}).

\begin{prol}\begin{verbatim}*/
defRecord1(Functor,Arity,Inits,MagicName,Swap) :-
        aField(Inits,Pos,Field),
        Swap =.. [MagicName,Field,Term0,Old,Term,New],
        functor(Term,Functor,Arity),
        functor(Term0,Functor,Arity),
        Term0 =.. [_|T0_fields],
        Term  =.. [_|T_fields],
        swapVars(T0_fields,T_fields,1,Pos,Old,New).
/*\end{verbatim}\index{defRecord1/5}\end{prol}       

\section{Support Code}
This section contains the low-level routines that supports the above
processing.

\begin{prol}\begin{verbatim}*/
aField(Inits,Pos,Field) :-
        nth(Inits,Pos/Item),
        (Item = (Name = _)
        ->        Field = Name
        ;        Field = Item). 

installInitValues([],_,_).
installInitValues([_=InitValue|FieldNames],N0,Term0) :- !,
        arg(N0,Term0,InitValue),
        N is N0 + 1,
        installInitValues(FieldNames,N,Term0).        
installInitValues([_|FieldNames],N0,Term0) :-
        N is N0 + 1,
        installInitValues(FieldNames,N,Term0).  

swapVars([Value0|T],[Value  |T],Pos,Pos,Value0,Value) :- !.
swapVars([H|T1],[H|T2],N0,Pos,Value0,Value) :- 
        N is N0 + 1,
        swapVars(T1,T2,N,Pos,Value0,Value).
/*\end{verbatim}\label{misc-support}
\index{aField/3}
\index{installInitValues/3}
\index{swapVars/6}
\index{}
\index{}
\end{prol}

\begin{prol}\begin{verbatim}*/
average(L,Av) :- sum(L,Sum),length(L,N), Av is Sum/N.

sum(L,Sum) :- sum(L,0,Sum).
sum([],Out,Out).
sum([H|T],In, Sum) :- Temp is H + In, sum(T,Temp,Sum).

nth(L,Out) :- nth(L,1,Out).
nth([H|_],N,N/H).
nth([_|T],N,Out) :- N1 is N + 1, nth(T,N1,Out).
/*\end{verbatim}\index{average/2}\index{sum/2}\index{sum/3}
\index{nth/2}\index{nth/3}
\end{prol}

\section{{\tt DefRecord} in Use}

\subsection{{\tt DefRecord} in Action}

The code of \src{oTest} now generates the output shown in
\src{oTestOut}.
\begin{prol}\begin{verbatim}*/
oTest :-
        defRecord(oTest,[age,duties]),
        record(oTest),
        create(oTest,[age=5,duties=[]],R0),
        nl,write('oTest0: '), 
        printRec(R0),

        % use the system in query mode
        o([age>=4, age>4, age\=20, age<100, 
           age=<100, age in [3,4,5]],           R0),
        
        % use the system in update mode        
        o([age=45, age++, age++,   age--,   
           duties<<planning  ,duties<<auditing
           ], R0,R1),
        nl, write('oTest1: '), 
        printRec(R1).
/*\end{verbatim}\label{oTest}\index{oTest/0}\index{defRecord/2!{\em example}}\end{prol}
\begin{prol}\begin{verbatim}
:- oTest.

%------| oTest |----------------------------

meta(oTest, oTest(A, B), oTest0(C, D, E), oTest0(F, G, H, I, J)).

portray(oTest(A, B)) :-
        write('[Rec:'),
        write(oTest / 2),
        write(']').

create(oTest, oTest(A, B)).

o1(oTest(A, B), C, D) :-
        oTest0(C, oTest(A, B), D).

swap(oTest(A, B), C, D, E, F) :-
        oTest0(D, oTest(A, B), C, E, F).

oTest0(age, oTest(A, B), A).
oTest0(duties, oTest(A, B), B).

oTest0(age, oTest(A, B), A, oTest(C, B), C).
oTest0(duties, oTest(A, B), B, oTest(A, C), C).

oTest0: 
age = 5
duties = []

oTest1: 
age = 46
duties = [auditing,planning]
\end{verbatim}\label{oTestOut}\index{oTest/0!{\em output}}\end{prol}

\begin{prol}\begin{verbatim}*/
timeIt(G,T) :-
        timeIt(G,10,T).

timeIt(G,Repeats,Time) :-
        timeIt1(true,Repeats,Time1),
        timeIt1(G,Repeats,Time2),
        Time is Time2 -Time1.

timeIt1(Goal, Repeats,Time) :-
        Start is cputime,
        timeIt2(Goal,Repeats),
        Stop is cputime,
        Time is (Stop - Start)/Repeats.

timeIt2(Goal, Repeats) :- between(1,Repeats,_), Goal, fail.
timeIt2(_,_).
/*\end{verbatim}\end{prol}

\subsection{Timing Experiments}

\begin{prol}\begin{verbatim}*/

defRecordTimingTest1(rule test at 10 if Lhs then print(1)) :-
	functor(C1,a,10), functor(C2,b,10), functor(C3,c,10),
	functor(C4,d,10), functor(C5,e,10), functor(C6,f,10),
	functor(C7,g,10), functor(C8,h,10), functor(C9,i,10),
	functor(C10,j,10), functor(C11,k,10), functor(C12,l,10),
	functor(C13,m,10), functor(C14,n,10), functor(C15,o,10),
	Lhs =    
          (C1 and not C2 or (C3 and not (C4 or C5)) and 
           not (not C6 or C7 and not (C8 or C9)) or
           C10 and (C11 or C12 and not C13 and C14 or C15)).
 
defRecordTimingTest :-
        defRecord(rule, [name,lhs,rhs,usedIds=[],
                  ages=[],specificity=0,priority=0]),
        defRecordTimingTest1(Rule1),
        defRecordTimingTest1(Rule2),
        timeIt(rTrans2(Rule1,_),500,T1),
	timeIt(rTrans( Rule2,_),500,T2),
	SlowDown is (T2 - T1) /T1,
	print(rTrans2(T1)), nl,print(rTrans(T2)), nl,
        print(costOfDefRecord(SlowDown)),nl.
/*\end{verbatim}\label{rTransBtest}\index{rTrans2Test/1}\end{prol}


\printindex

{\small
\bibliographystyle{myplain}
\bibliography{../../refs/refs}
}

{\footnotesize
Some of the Menzies papers can be found at
{\em  http:// www.sd.monash.edu.au/ $\sim$timm/pub/
docs/papersonly.html}}.


\end{document}*/
