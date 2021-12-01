%%%% Predicates
%%% Code to demonstrate predicates
%% Define demos %<
eglib :- 
    forall(member(G,[
            egwrites, egdeletes,   egmaths,  eglookup,
            eginc, 
            egrands,  egbeta,      egnormal, eggamma,
            egformat, eginc,       egdist, 
            egbarsNormal, egbarsBeta,
            egbarsGamma1, egbarsGamma2, egbarsGamma3,
            egnormalize, egchars,  egtidy,
            egdemand, egtimes
            ]),
        demos(G)).
%>
%% Processing demos
/* To demo our code, we need to:
\bi
\item Write a demo predicate that shows off our code in action.
 In {\PROD}, these predicates are named  {\tt egXXX/0}. 
 Include with this predicate, 
 a pointer to the output; e.g.
\begin{verbatim}
egXXX :- % See \fig{egXXX.spy}
    ... 
\end{verbatim}
\item Trap the output to a file. This is accomplished using
the {\tt demos/1} predicate shown below. The goal
{\tt demos(egXXX)} generates a file {\tt egXXX.spy}. 
\item Include that file. This is accomplished using
the following {\LaTeX} magic:
\begin{verbatim}
\SRC{egXXX.spy}{From \tion{egXXX/1}.}
\end{verbatim}
\ei
Note the call to \verb+\tion{egXXX/1}+.
Sections can be referenced
symbolically 
when (e.g.) \verb+\label{sec:egXXXX/1)+
is added on the first line after a heading definition.
Once this has been done, then \verb+\tion{egXXX/1}+ will
be typset as a reference to the relevant section.

After all that, then:
\bi
\item The output of the demo will be shown in the document,
\item
The demo predicate will include a pointer to the figure,
\item
The caption of the figure will include a pointer to the section
in the text that generated it. 
\ei
Most of the demonstrations in this file use this approach.
*/
%% \call{demos(+Goal)}
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
    nl,write('\n%-------------------------------\n'),
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
%% Using {\tt Demos/1}.
/* Next, we need to run the demo code as follows: 
\begin{LISTING}
?- demos(egXXX).
\end{LISTING}
Once that is done, then when this document will include the
output in the figure with the label {\tt egXXX.spy}.
*/
%%% List stuff
%% \call{writes(+List)}: print a list 
%\label{sec:writes/1}
%<
writes([H|T]) :- 
    forall(member(One,[H|T]),(print(One),nl)).
%: Demonstration code: \SRC{egwrites.spy}{From \tion{writes/1}.}
egwrites :-  % see \fig{egwrites.spy}
    writes([aa,bb,cc,dd]).
%>
%% \call{deletes(+List1,+List2,-List3)}:  delete items from a list 
%\label{sec:deletes/3}
%< 
deletes([],_,[]).
deletes([Doomed|T],Doomeds,Rest) :- 
    member(Doomed,Doomeds),!,
    deletes(T,Doomeds,Rest).
deletes([Saved|T],Doomeds,[Saved|Rest]) :-
    deletes(T,Doomeds,Rest).
%: Demonstration code: \SRC{egdeletes.spy}{From \tion{deletes/3}.}
egdeletes :- % see \fig{egdeletes.spy}
    List = [a,b,r,a,c,a,d,a,b,r,a],
    Doomed=[b,c],
    deletes(List,Doomed,Out),
     format('If we take ~w from\n~w we get\n~w.\n',
           [Doomed,List,Out]).
%>
%%% Maths stuff 
%\label{sec:maths}
%% \call{sum(+List,-Num)}: sum a list of numbers %<
sum([H|T],S) :- 
    sum(T,H,S).

sum([],S,S).
sum([H|T],In,Out) :- Temp is H + In, sum(T,Temp,Out).
%>
%% \call{average(+List,-Num)}: average a list of numbers %<
average(L,Av)  :- average(L,_,Av).
average([H|T],N,Av) :- average1(T,1,N,H,Sum), Av is Sum/N.

average1([],N,N,Out,Out).
average1([H|T],N0,N,In,Out) :-
    Temp is H+In,
    N1 is N0 + 1,
    average1(T,N1,N,Temp,Out).
%>
%Demonstration code:
%<
egmaths :- % See \fig{egmaths.spy}
    Nums = [2,3,5,2,4,6,3,4,2,4],
    average(Nums,Av),
    sum(Nums,Sum),
    format('The sum and average of\n~w\n are ~w and ~w\n.',
        [Nums,Sum,Av]).
%>
%%% Lookup tables
%\label{sec:lookuptables}
%Convert a list of tabular data to one
%fact for each cell.
%<
lookUpTable(X,Out) :-
    bagof(Y,X^list2Relation1(X,Y),Out).

list2Relation1(Table=Cols+Rows, lookUp1(Table,R,C,X)):-
    nth1(Pos,Cols,C),
    member([R|Cells],Rows),
    nth1(Pos,Cells,X),
    nonvar(X).
%>
%Access the cells 
%<
lookUp(T,X,Y,Out) :-
    lookUp1(T,R,C,Out), gt(X,R), gt(Y,C), !.
%>
%Cell access can be via an exact match or
%via a range query:
%<
gt(Value,X to Y) :- !,X =< Value, Value =< Y.
gt(Value,Value).
%>
%Demonstration code:
%\SRC{eglookup.spy}{From \tion{lookuptables}.}
%<
egLookUpDemo =
    % age         weight
    % ----------  -------------------------------
                  [1 to 19, 20 to 50, 51 to inf]+
    [[ 0 to 20,        low,      low,       avg]
    ,[21 to 40,        low,      avg,      high]
    ,[41 to inf,       avg,     high,      high]
    ].

eglookup :- % see \fig{eglookup.spy}
    Age=30,
    Weight=40,
    lookUp(egLookUpDemo,Age,Weight,X),
    format('[age(~w),weight(~w)]= ~w\n',
           [Age,Weight,X]).
%>
%%% Random numbers
%% Basic randoms
%\label{sec:rands}
%Generate a number $0 \le X \le 1$.
%<
rand(X) :- 
    X is random(inf+1)/inf.
%>
%Generate a number $X$ between  some $Min$ and
%$Max$ value.
%<
rand(Min,Max,X) :- 
    X is Min + (Max-Min)*rand.
%>
%Demonstration code:
%\SRC{egrands.spy}{From \tion{rands}.}
%<
egrands :-  % see \fig{egrands.spy}
    Rand1 is rand, 
    format('~w is a random number between 0 and 1.\n',
            [Rand1]),
    Rand2 is rand(10,20),
    format('~w is a random number between 10 and 20.\n',
           [Rand2]).
%>           
%% Beta distributions
%\label{sec:betas}
%Generate a number $X$ whose mean is $B$\% 
%between $Min$ and
%$Max$. Technically, this is an application
%of a $beta$ function.
%Here, I use a very simplistic method that
%only works for certain values of $B$:
%($B=0.1,0.2,0.3,...,0.9,1$).
%<
rand(Min,Max,B,X) :-
    X is Min + (Max-Min)*beta(B).
    
beta(B,X) :- beta1(B,X),!.
beta(B,X) :- B1 is 1 - B, beta1(B1,Y),X is 1 - Y.

beta1(0.50,X) :- X is rand.
beta1(0.60,X) :- X is rand^0.67.
beta1(0.67,X) :- X is rand^0.5.
beta1(0.75,X) :- X is rand^0.33.
beta1(0.80,X) :- X is rand^0.25.
beta1(0.9,X)  :- X is rand^(1/9).
beta1(1,1).
%>
%Demonstration code:
%\SRC{egbeta.spy}{From \tion{betas}.}
%<
egbeta :- % see \fig{egbeta.spy}
    R1 is rand(10,20,0.2),
    R2 is rand(10,20,0.2),
    R3 is rand(10,20,0.2),
    R4 is rand(10,20,0.2),
    R5 is rand(10,20,0.2),
    Nums=[R1,R2,R3,R4,R5],
    format('~w\n are random numbers 20\% between 10 and 20.\n',
           [Nums]).
%>
/* Note that the numbers in \fig{egbeta.spy}
may not look like they are, on average, 20\% between 10
and 20. Later, we run this code 10,000 times
and the true average results can be seen.
*/
%% Normal distributions
%\label{sec:normals}
%Generate a random number from a normal distribution
%with mean $M$ and standard deviation $S$.
%This number is generated using the Box-Muller method
%(no, I don't understand it either).
%<
normal(M,S,N) :- 
    box_muller(M,S,N).

box_muller(M,S,N) :-
    wloop(W0,X),
    W is sqrt((-2.0 * log(W0))/W0),
    Y1 is X * W,
    N is M + Y1*S.

wloop(W,X) :-
    X1 is 2.0 * rand - 1,
    X2 is 2.0 * rand - 1,
    W0 is X1*X1 + X2*X2,
    (W0  >= 1.0 -> wloop(W,X) ; W0=W, X = X1).
%>
%Demonstration code:
%\SRC{egnormal.spy}{From \tion{normals}.}
%<
egnormal :- % see \fig{egnormal.spy}
    R1 is normal(10,2),
    R2 is normal(10,2),
    R3 is normal(10,2),
    R4 is normal(10,2),
    R5 is normal(10,2),
    Nums=[R1,R2,R3,R4,R5],
    format('~w\n are random numbers from normal(10,2).',
           [Nums]).
%> 
%% Gamma distributions
%\label{sec:gammas} 
%Generate random numbers from zero to infinity.
%<
gamma(Mean,Alpha,Out) :-
    Beta is Mean/Alpha,
    (Alpha > 20
    ->  Mean is Alpha * Beta,
        Sd is sqrt(Alpha*Beta*Beta),
        Out is normal(Mean,Sd)
    ;   gamma(Alpha,Beta,0,Out)).

gamma(0,_,X,X) :- !.
gamma(Alpha,Beta, In, Gamma) :-
    Temp is In + ( -1 * Beta * log(1-rand)),
    Alpha1 is Alpha - 1,
    gamma(Alpha1,Beta,Temp,Gamma).
%>
/* Technically, this is {\em gamma} distribution.
A standard random {\em gamma} distribution has the mean
$=\frac{alpha}{beta}$.
The $alpha$ value is the ``spread'' of the 
distribution and controls the
clustering of  the distribution
around the mean. As
$alpha$ increases,
the $gamma$ distribution flattens out to become 
more evenly-distributed about the mean. That is, for large
$alpha$ (i.e. $alpha\ge20$), $gamma$ can be modeled as a noraml
function.
The standard $alpha,beta$ terminology can be confusing
to some audiences. Hence, I define a
(slightly) more-intuitive $gamma$
distribution where:
\[
myGamma(mean,alpha)=gamma\left(alpha,\frac{alpha}{mean}\right)
\]
*/
%Demonstration code:
%\SRC{eggamma.spy}{From \tion{gammas}.}
%<
eggamma :- % see \fig{eggamma.spy}
    R1 is gamma(10,2),
    R2 is gamma(10,2),
    R3 is gamma(10,2),
    R4 is gamma(10,2),
    R5 is gamma(10,2),
    Nums=[R1,R2,R3,R4,R5],
    format('~w\n are random numbers from gamma(10,2).',
           [Nums]).
%> 
%%% String Stuff
%\label{sec:strings}
%% Right-justify a string.
%Right-justifies a string \call{A} in a space 
%\call{S}: 
%<
right_justify(S,A) :-
    writeThing(A,Thing,N),
    Pad is S - N,
    forall(between(1,Pad,_),put(32)),
    write(Thing).

writeThing(X,S,L) :- 
    sformat(S,'~w',[X]), 
    string_length(S,L).
%>
%Map \call{right_justify} into the \call{format}
%predicate.
%<
padChars(default,A) :- right_justify(5,A).
padChars(S,      A) :- right_justify(S,A).   
%>  
%% Left-justify a string %<
left_justify(S,A) :-
    writeThing(A,Thing,N),
    atom_length(A,N),
    Pad is S - N,
    write(Thing),
    forall(between(1,Pad,_),put(32)).

charsPad(default,A) :- left_justify(5,A).
charsPad(S,A)       :- left_justify(S,A).
%>
%% Print some squiggles
%Generates \call{N} squiggles in a space normalized 
%to a screen with maximum width \call{W}. 
%<
squiggles(W,N) :-
    N1 is round(N/W),
    forall(between(1,N1,_),put(126)).

squiggle(default,A) :- squiggles(25,A).
squiggle(W,N)       :- squiggles(W,N).
%> 
%Demonstration code.
%\SRC{egformat.spy}{From \tion{strings}.}
%<
egformat :- % \fig{egformat.spy}
    format('[~>]\n',tim),   % right-justify
    format('[~12>]\n',tim), %  
    format('[~<]\n',tim),   % left-justify
    format('[~12<]\n',tim), %  
    format('[~S]\n',100),    % print some twiddles
    format('[~50S]\n',100),  %  
%>

%%% Predicates for Pairs
%% \call{pairs(?Keys,?Values,?Pairs)}: key-value pairs %<
pairs([],[],[]).
pairs([X|Xs],[Y|Ys],[X=Y|T]) :- pairs(Xs,Ys,T).
%>
%% \call{key(+Pairs,?Key,?Value,?Pairs)}: a key-in-front working memory
%Acccess values in a list of {\tt key=value}
%pairs. As a side-effect of accessing, move the
%accessed pair to the front of the list.
%<
key(L0,K,V0,V,[K=V|L]) :- 
    less1(L0,K=V0,L).

less1([H|T],H,T).
less1([H|T],Out,[H|Rest]) :- 
    less1(T,Out,Rest).
%>
%% \call{inc(+Pairs,+Key,?Pairs)}: a lists of counters 
%\label{sec:inc/3}
%Maintain a list of keys. Incrementing a key 
%add one to its value.
%<
inc([], A, [A=1]).
inc([A=B|C],D,E) :- 
    compare(F,A,D),inc(F,A=B,C,D,E).

inc(<, A, B, C, [A|D]) :- inc(B, C, D).
inc(=, A=B, C, A, [A=D|C]) :- D is B+1.
inc(>, A, B, C, [C=1, A|B]).
%: Demonstration code:\SRC{eginc.spy}{From \tion{inc/3}.}
eginc :- % see \fig{eginc.spy}
    List = [a,b,r,a,c,a,d,a,b,r,a],
    eginc1(List,[],Incs),
    format('The keys in\n~w\n occur  with frequencies\n~w. ',
          [List,Incs]).
    
eginc1([],W,W).
eginc1([H|T],W0,W) :- inc(W0,H,W1), eginc1(T,W1,W).
%>
%% \call{dist(+List,-Pairs)}: Simple collection of histogram data 
%\label{sec:dist/2}
%<
dist(L0,L) :- 
    dist(L0,_,_,L).

dist(L0,Min,Max,L) :-
    msort(L0,[Min|L1]), % \MARK{distsort}
    dist([Min|L1],[],Min,Max,L).

dist([],X,Max,Max,X).
dist([H|T],[H=N0|Rest],_,Max,Out) :- !,
    N is N0 + 1,
    dist(T,[H=N|Rest],H,Max,Out).
dist([H|T],In,Min,Max,Out) :-
    dist(T,[H=1|In],Min,Max,Out).
%: Demonstration code: \SRC{egdist.spy}{From \tion{dist/2}.}
egdist :- % see \fig{egdist.spy}
    List = [a,b,r,a,c,a,d,a,b,r,a],
    dist(List,Dist),
    format('The distribution of symbols\n~w is\n~w.\n',
          [List,Dist]).
%>
%Note that {\tt dist/2} {\em could be} implemented
%using {\tt inc/3}. However, the call of {\tt msort} at \Line{distsort}
%makes  {\tt dist/2} faster for large lists.
%% \call{bars(+Num1,+Num2,+Num3,+Pairs)}: print a bar chart
%\label{sec:bars}
%Display the pairs as a bar chart.
%\call{Num1} is the width of the first ``item'' column
%displaying the name of each bar;
%\call{Num2} is the width of the second 
%``frequency'' column showing how many items
%fall into that bar;
%\call{Num3} is the width of the last column showing
%the population size.
%<
bars(Num1,Num2,Num3,List) :-
%>
%Use \call{sformat} to builds a string  that
%stores the widths and scale factor
%for our columns. Note the use of ">" and "S"
%which are special format commands defined above.
 %<  
    sformat(S,'~~~w>  ~~~w> ~~~wS\n',
        [Num1,Num2,Num3]),
    dist(List,Dist),
    nl,
    format(S,[item,frequency,0]),
    forall(member(What=N,Dist),
           format(S,[What,N,N])).
%>   
%A useful default call.
%<
bars(List) :- 
    bars(5,     % the "item" column is 5 wide
         5,     % the "frequency" column is 5 wide
         3,     % the "scale factor" is 3
         List  % now, go display these pairs
         ).
%>
%Demonstration code:
%\SRC{egbarsNormal.spy}{From  \tion{bars}.}
%\SRC{egbarsBeta.spy}{From  \tion{bars}.}
%\SRC{egbarsGamma1.spy}{From  \tion{bars}.}
%\SRC{egbarsGamma2.spy}{From  \tion{bars}.}
%\SRC{egbarsGamma3.spy}{From  \tion{bars}.}
%<
egbarsNormal :- % see \fig{egbarsNormal.spy}
    egbarDemos(10000,normal(20,2)).
    
egbarsBeta :- % see \fig{egbarsBeta.spy}
    egbarDemos(10000,rand(10,20,0.2)).
    
egbarsGamma1 :- % see \fig{egbarsGamma1.spy}
    egbarDemos(10000,gamma(10,15)).
    
egbarsGamma2 :- % see \fig{egbarsGamma2.spy}
    egbarDemos(10000,gamma(10,5)).
    
egbarsGamma3 :- % see \fig{egbarsGamma3.spy}
    egbarDemos(10000,gamma(10,2)).
%>
%Support code for the demostration code:
%<
egbarDemos(Repeats,F) :-
    format('\n\n---| ~w * ~w |-------',[Repeats,F]),
    Size=1,
    findall(X,(between(1,Repeats,_),X is F),L0),
    cutDown2Sizes(Size,L0,L),
    bars(5,5,100,L).

cutDown2Sizes(Size) --> maplist(cutDown2Size(Size)).
cutDown2Size(Size,X,Y) :- Y is round(X/Size).
%>
%% \call{normalize(+Pairs1,-Pairs2)}: normalize a list of numbers
%\label{sec:normalize/2}
%Input list with values $M_1,M_2\ldots M_i$
%with sum $M_1+M_2+\ldots + M_i$ to
%a second list of numbers  $N_1,N_2,\ldots,N_i$
%where $0\le N_i\le1$ and $N_1+N_2+\ldots+N_i=1$.
%<
normalize(L,N) :- 
    mostnormal(L,N,_).

mostnormal(L,N,Most) :-
    sumpairs(L,Sum), 
    mostnormal1(L,Sum,junk= -1,N,Most).

mostnormal1([],_,Out,[],Out).
mostnormal1([X=V0|T],Sum,Y=N,[X=N1|Out],Most) :-
    N1 is V0/Sum,
    (N1 > N
    -> mostnormal1(T,Sum,X=N1,Out,Most)
        ;  mostnormal1(T,Sum,Y=N,Out,Most)).

sumpairs([_H=V|T],S) :- 
    sumpairs(T,V,S).

sumpairs([],S,S).
sumpairs([_=V|T],In,Out) :- 
    Temp is V + In, sumpairs(T,Temp,Out).
%:Demonstration code:\SRC{egnormalize.spy}{From \tion{normalize/2}.} 
egnormalize :- % see \fig{egnormalize.spy}
    L=[a=10,b=5,c=20,d=50,e=5,c=10],
    normalize(L,Normals),
    format('When ~w\n is normalized it generates\n~w.\n',
                [L,Normals]).
%>
%%% Input/output stuff
%Demonstrations are offered for only some of the predicates in this
%section. I/O code can makes explicit calls to
%input/output streams which mucks up our demonstration system.
%% \call{sneak(+List)}: load files.
%Don't bother loading the files if they haven't changed.
%But if you do load them, don't print anything to the screen.
%<
sneak(X) :- 
    load_files(X,[silent(true),if(changed)]).
%>
%% \call{spit(+Num1,+Num2,+Term)}: Print something, sometimes.
%Useful for tracking a long process since it, sometimes,
%spits out a marker.
%<
spit(N1,N2,X) :- 
    (0 is N1 mod N2 -> blurt(X) ; true).
%>
%% \call{blurt(+Term)}: print, then flush.
%<
blurt(X) :- 
    write(user,X),flush_output(user).
%>
%% \call{chars(+String)}: copy a file to the screen.
%\label{sec:chars/1}
%\SRC{nowarranty.txt}{A text file.}
%<
chars(File) :- 
    see(File), get_byte(X), ignore(chars1(X)), seen.
    
chars1(-1) :- !.
chars1(X)  :- put(X), get_byte(Y), chars1(Y).
%>
%Demonstration code:
%\SRC{egchars.spy}{The code in \tion{chars/1}
%displays the contents of \fig{nowarranty.txt}
%to the screen.}
%<
egchars :-  % see \fig{egchars.spy}.
    chars('nowarranty.txt').
%>
%% \call{barph(+Term)}: print a warning, then fail.
%A standard barph:
%<
barph(X) :- format('%W> ~p\n',X),fail.
%>
/* A barph that also prints line numbers showing
 the origin of the barph. */
%<
barphln(X) :-
    here(File,Line),
    format('%W> ~p@~p : ~p\n',[File,Line,X]),
        fail. 

here(File,Line) :-
        source_location(Path,Line),
        file_base_name(Path,File).
%>        
%%% Meta-level predicates
%% \call{tidy(+Rule0,-Rule1}: remove stray ``trues'' from a rule body. 
%\label{sec:tidy/2}
%<
tidy(A,C) :-
    tidy1(A,B),
    (B = (Head :- true) -> C=Head ;  C=B).

tidy1(A,C) :- once(tidy2(A,C)).

tidy2(A,             A) :- var(A). 
tidy2((A,B),    (A,TB)) :- var(A), tidy1(B,TB).
tidy2((A,B),    (TA,B)) :- var(B), tidy1(A,TA).
tidy2(((A,B),C),     R) :- tidy1((A,B,C), R).
tidy2((true,A),      R) :- tidy1(A,R).
tidy2((A,true),      R) :- tidy1(A,R).
tidy2((A;true),      R) :- tidy1(A,R).
tidy2((true;A),      R) :- tidy1(A,R).
tidy2((A;B),   (TA;TB)) :- tidy1(A,TA), tidy1(B,TB).
tidy2((A->B), (TA->TB)) :- tidy1(A,TA), tidy1(B,TB).
tidy2(not(A),  not(TA)) :- tidy1(A,TA).
tidy2((A :- B), R) :-
    tidy1(B,TB),(TB=true-> R=A; R=(A:-TB)).
tidy2((A,B),  R) :-
    tidy1(A,TA), tidy1(B,TB),(TB=true -> R=TA; R=(TA,TB)).
tidy2(A,A).
%>
%Demonstration code:
%\SRC{egtidy.spy}{From \tion{tidy/2}.}
%<
egtidy :- % see \fig{egtidy.spy}
    In1= (a :- b, true,c, (d->true;e)),
    In2= (f :- true,(true;true;true),true),
    tidy(In1,Out1),
    portray_clause(Out1),
    tidy(In2,Out2),
    portray_clause(Out2).
%>
%% \call{demand(+Goal)}: warn if a goal fails. 
%\label{sec:demand/1}
%<
demand(X) :- X,!.
demand(X) :- numbervars(X,0,_),barph(failed(X)).
%>
%Demonstration code:
%\SRC{egdemand.spy}{From \tion{demand/1}.}
%<
egdemand :- % see \fig{egdemand.spy}
    demand(3 > 2),
    demand(10 > 20).
%>
%% \call{repeats(+Num,+Goal)}: run a goal $N$ times
%<
repeats(N0,G) :-
    N is N0,
    forall(between(1,N,_),G).
%> 
%% \call{times(+Num,+Goal,-Time)}: time an execution
%\label{sec:times/3}
%<
times(N,G,Out) :-
    T1 is cputime, repeats(N,true),
    T2 is cputime, repeats(N,G),
    T3 is cputime, Out is (T3-T2-(T2-T1))/N.
%>   
%Demonstration code:
%\SRC{egtimes.spy}{From \tion{times/3}.}
%<
egtimes :- % see \fig{egtimes.spy}
    N=10000,
    List = [a,b,r,a,c,a,d,a,b,r,a,s],
    times(N,member(s,List),T),
    format('In ~w repeats, each run took ~w seconds.\n',
           [N,T]).
%> 
%% Lists/ conjuctions conversions.
%Convert a conjunction to a list:
%<
c2l((X,Y),[X|Z]) :- !,c2l(Y,Z).
c2l(X,[X]).
%>
%Convert everything but the last item of a conjunction to a list:
%<
mostC2l((X,Y),[X|Z]) :- !,mostC2l(Y,Z).
mostC2l(_,[]).
%>
%Convert a list to a conjunction:
%<
l2c([W,X|Y],(W,Z)) :- l2c([X|Y],Z).
l2c([X],X).
%>
%Convert disjunctions to a list.
%<
d2l((X;Y),[X|Z]) :- !,d2l(Y,Z).
d2l(X,[X]).
%>
%% \call{clause1(?Head,?Body)}: does a goal match only one clause? %<
clause1(X,Y) :- 
    singleton(X), clause(X,Y).

singleton(X) :-
    Sym='$singleton_',
    flag(Sym,_,0),
    \+ singleton1(Sym,X),
    flag(Sym,1,1).

singleton1(Sym,X) :- 
    clause(X,_),flag(Sym,N,N+1),N > 1,!.
%>
%% \call{only(?Goal)}: can a goal  only  succeed once? %<
only(X) :-
    Sym='$only_',
    flag(Sym,_,0),
    \+ only1(Sym,X),
    flag(Sym,1,1).

only1(Sym,X) :- 
    X, flag(Sym,N,N+1),N > 1,!.

solo(X) :- 
    only(X), X.
%>
