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
            egdemand, egtimes, egb
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
%% \call{within(?X,+Y)}: access items nested within lists
%<
within(X,Z) :-
	once(within0(Z,Y)), within1(Y,X).

within0(X,    item(X)) :- var(X).
within0([],      fail).
within0([H|T],  [H|T]).
within0(X,    item(X)).

within1(item(X),X).
within1([H|T],  X) :- member(Y,[H|T]),within(X,Y).
%>
%Prolog beginners might like to ponder why \call{within1}
%contains nothing to handle the \call{fail} case defined by
%\call{within0}.

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
%% \call{halve(+List,?Front,?Mid,?Back)}: split a list in half
%<
halve([X],[],X,[]).
halve([X,Y|L],[X|Front],Mid,Back) :-
	halve1(L,[Y|L],Front,[Mid|Back]).

halve1([_,_|Count], [H|T], [H|F], B) :- !,
        halve1(Count, T, F, B).
halve1(_, B, [], B).
%>
%\call{Halve/3} lets un implement a predicate
%that generates an \call{inOrder} traversal of a list.
%<
inOrder(L0,L) :- bagof(M,L0^inOrder1(L0,M),L).

inOrder1(L0,M) :- msort(L0,L), inOrder11(L,M).

inOrder11(L,M) :-
	halve(L,Front,M0,Back),
	(M0=M
        ;inOrder11(Front,M)
        ;inOrder11(Back,M)).
%>
%% Ordered Sets
%\label{sec:orderedSets}
%If a set is always ordered then certain operations can be optimized.
%For example, adding items:
%<
oset_add([], El, [El]). 
oset_add([H|T], El, Add) :-
    compare(Order, H, El),
    addel(Order, H, T, El, Add).

addel(<, H, T,  El, [H|Add]) :- oset_add(T, El, Add).
addel(=, H, T, _El, [H|T]). 
addel(>, H, T,  El, [El,H|T]).
%>
%%% Maths stuff 
%\label{sec:maths}
%% \call{sum(+List,-Num)}: sum a list of numbers %<
sum([H|T],S) :- sum(T,H,S).

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
%% \call{stats(+L,-Mean,-Sd)}
%Find the mean and standard deviation of a list
%of numbers.
%<
stats(L,Mean,Sd) :-
	stats_(new(L),_,S0),
	stats_(stats(Mean,Sd),S0,_).
%>
%Uses a working memory of the list's {\em sum},
%{\em sumSquared}, and {\em n} number of elements
%<
stats_(sum,        A0,A, stats(A0,B,C), stats(A,B,C)).
stats_(sumSquared, B0,B, stats(A,B0,C), stats(A,B,C)).
stats_(n,          C0,C, stats(A,B,C0), stats(A,B,C)).
%>
%Adding a new item:
%<
stats_(add(X)) -->
	stats_(+n),
	stats_(sum+X),
	stats_(sumSquared+X*X).
%>
%Calcuating the mean and standard
%deviation is pretty simple:
%<
stats_(stats(Mean,Sd)) -->
	stats_(n=N),
	N>2,!, %fails if too few items
	stats_(sum=S),
	stats_(sumSquared = S2),
	Var is ((N*S2) - (S*S))/(N*(N-1)),
	Sd is sqrt(Var),
	Mean is S/N.
%>
%Support code for the above follows. Standard stuff:
%<
stats_(X+Y)    --> stats_(X,Old,New),New is Old+Y.
stats_(+X)     --> stats_(X,Old,New),New is Old+1.
stats_(X is Y) --> stats_(X,_,Y).
stats_(X =  Y) --> stats_(X,Y,Y).
%>
%Mustn't forget to initialize things:
%<
stats_(new)-->
	stats_(n is 0),
	stats_(sum is 0),
	stats_(sumSquared is 0).
%>
%Add here's some stuff for bulk import of a list:
%<
stats_(new(L))--> stats_(new), stats_(L).

stats_([]) --> [].
stats_([H|T]) --> stats_(add(H)), stats_(T).
%>
%Demonstration code:
%<
egmaths :- % See \fig{egmaths.spy}
    Nums = [2,3,5,2,4,6,3,4,2,4],
    average(Nums,Av),
    sum(Nums,Sum),
    stats(Nums,Av1,Sd),
    format('The sum and average of\n~w\n are ~w and ~w.\n',
        [Nums,Sum,Av]),
    format('And our stats says: sum = ~w and sd = ~w.\n',
        [Av1,Sd]).
%>
%%% Lookup trees
%\label{sec:lookuptables}
%Here's the simplest tree look up predicate.
%<
find(K, V0,V,t(K, V0,L, R),t(K, V, L,R)).
find(K0,V0,V,t(K1,V1,L0,R),t(K1,V1,L,R)) :-
	K0 @< K1,
	find(K0,V0,V,L0,L).
find(K0,V0,V,t(K1,V1,L,R0),t(K1,V1,L,R)) :-
	K0 @> K1,
	find(K0,V0,V,R0,R).
%>
%Sometimes, we want to look up values without
%changing them.
%<
find(K,V,T,T) :- find(K,V,V,T,T).
%>
%Also, it can be useful to have a batch tree accessor:
%<
finds(L,T) :- finds(L,t(_,_,_,_),T).
finds([],T,T).
finds([Key=Value|Rest]) --> find(Key,Value), finds(Rest).
%>
%Of course, we can't test anything unless we can
%print it.
%<
tprint(T) :- tprint(T,[],'|    ').

tprint(X,_,_) :- var(X),!.
tprint(t(K,V,L,R),Ins,B4) :-
	forall(member(In,Ins),write(In)),
	write(K=V),nl,
	tprint(L,[B4|Ins],B4),
	tprint(R,[B4|Ins],B4).

egFinds :- egFinds(_).
egFinds(T) :-
	L0= [a=1,b=2,c=3,d=4,e=5,f=6
            ,g=7,h=8,i=9,j=10,k=11],
	inOrder(L0,L),
	finds(L,T),
	tprint(T).
%>
%%% Hashed trees
%Here's my (currently) favorite working memory.
%
%Some timing tests I did once suggest that up to lists
%of size 100, then a working memory consisting of (e.g.) 64
%lists
%works could access (e.g.) 6,400 items in reasonable time.
%
%So, this working memory is a hash tree of lists.
%These hash trees are one of a pre-defined sizes:
%<
htSizes([8,16,32,64,128]).
%>
%Since the tree sizes are known at load time,
% we can pre-compute and cache balanced binary trees
%for all the above sizes in \call{ht0/2}.
%Better yet, we can precompute pathways to every
%bucket and cache them  in \call{ht_cache/3}.
%So, at runtime, we can access any bucket just by
%looking up on of those cached paths.
%%Setting up for hash trees
%\label{sec:settingupht}
%Hash trees can get very big.
%So we'd best have
%someway to print these succinctly.
%<
portray(t(K,V,_,_)) :- print(t(K=V)).
%>
%In order for our cache to work, we need a tree access
%predicate with a path argument.
%
%The first predicate stops crazy backtracking by
%failing on variable sub-trees. This can be a problem
%during initializations
%when we backtrack to find all paths.
%<
htFind0(0,_,        _, _, _,aNyTHing,_) :- !,fail.
%>
%The other predicates handles the more usual
%case where the tree is built and bound.
%<
htFind0(=,[],       K, V0,V,t(K, V0,L, R),t(K, V, L,R)).
htFind0(<,[N|Path], K0,V0,V,t(K1,V1,L0,R),t(K1,V1,L,R)) :-
	htFind0(N,Path,K0,V0,V,L0,L).
htFind0(>,[N|Path], K0,V0,V,t(K1,V1,L,R0),t(K1,V1,L,R)) :-
	htFind0(N,Path,K0,V0,V,R0,R).
%>
%To initialize the hash trees, we need to generate
%\call{ht0/2} and all the \call{Paths} that takes us
%to the keys in \call{ht0/2}.
%<
initHts(All) :- bagof(One,initHt(One),All).

initHt(Out) :-
	htSizes(L),
	member(N0,L),
	once(ht0gen(N0,T)),
	N is N0 - 1,
	(Out=ht0(N0,ht(N0,T))
    ;between(0,N,K),
	 once(htFind0(Step,Path,K,V,V,T,T)),
	 Out= ht_cache(N0,K,[Step|Path])).
%>
%\call{ht0/2} stores 
%an empty hash tree. We'll generate it by
%reusing the \call{finds/2} predicates defined
%elsewhere in \tion{lookuptables}.
%<
ht0gen(N,T) :- htBuckets(N,L), finds(L,T).

htBuckets(N,L) :-
	N0 is N - 1,
	bagof(I=[],N^between(0,N0,I),L0),
	inOrder(L0,L).
%>
%Demonstration code:
%\SRC{egInitHt.spy}{From \tion{settingupht}.}
%<
egInitHt :- % see \fig{egInitHt.spy}
	N=16,
	Goal=ht_cache(N,_,_),
	forall(Goal,portray_clause(Goal)),
	ht0(N,H),
	htprint(H).

htprint(ht(_,T)) :- tprint(T).
%>
%%Using hash trees
%\label{sec:usingHashTrees}
%The \call{htFind/6} predicate looks up
%the bucket for some ``thing'', then modifies
%it according to a \call{Mode} argument. The three
%\call{Mode}s are \call{``-''} for deletions;
%<
modifyBucket(-,X0,K,_, V,X      ) :- less1(X0,K=V,X).
%>
%and \call{``=''} for matching, without modification;
%<
modifyBucket(=,X0,K,V0,V,[K=V|X]) :- less1(X0,K=V0,X).
%>
%and \call{``+''} for ensuring that
%a bucket has a certain key.
%<
modifyBucket(+,X0,K,V0,V,[K=V|X]) :- less1(X0,K=V0,X),!.
modifyBucket(+,X, K,_, V,[K=V|X]).
%>
%To store any ``thing'' in out hash trees,
%finds its hash value, ``mod'' it with the
%size of the hash tree to locate the index of
%the bucket for our ``thing''.
%<
htFind(Mode,K0,V0,V,ht(N,T0),ht(N,T)) :-
	hash_term(K0,H),
	K is H mod N,
%>
%Next, look up the pathway cache,
%access the appropriate bucket,
%and modify it according to the \call{Mode} flag.
%<
	ht_cache(N,K,[Step|Path]),
	htFind0(Step,Path,K,X0,X,T0,T),
	modifyBucket(Mode,X0,K0,V0,V,X).
%>
%Sometimes, we just want to access an item without
%changing anything.
%<
htFind(K,V,Ht) :- htFind(=,K,V,V,Ht,Ht).
%>
%Here's a batch create predicate for hash trees.
%We'll use it to implement the example predicate
%for hash trees.
%<
htFinds(N,L,Ht) :- ht0(N,Ht0), htFinds(L,Ht0,Ht).

htFinds([],Ht,Ht).
htFinds([K=V|T]) --> htFind(+,K,_,V), htFinds(T).
%>
%Here's the example predicate.
%\SRC{egHt.spy}{From \tion{usingHashTrees}.}
%<
egHt :- % see \fig{egHt.spy}
	N=16,
	htFinds(N,[fact(7)=5040,fred=23,fact(6)=720
                  ,fact(5)=120,death=life,fact(4)=24
		  ,aa=8
		  ,fact(3)=6,ff=23,fact(2)=2
		  ,aa=20 % change aa's value
	          ],Z),
	htFind(aa,V,Z),
	print(a=V),nl,
	htprint(Z).
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
    lookUp1(T,R,C,Out), gt(X,R), gt(Y,C).
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
egLookUpDemo has
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
%%% Random types
/*
Nondeterministic programs sometimes need to grab a
value for something. A {\em random type} is a Prolog
trick for implementing that grab:
\bi
\item
If called with an unbound
variable, the variable is bound to some value within a pre-defined
range.
\item
If called with a bound variable, then the predicate fails unless
the bound variable falls within a pre-defined range.
\ei
Note that these random types can be used in two ways:
\bi
\item
If a value is {\em unknown}, then an appropriate value can be guessed.
\item
If a value has been {\em supplied} by some other source, then
that value can be assessed.
\ei
*/
%The other random types are
%more detaild. Random symbols are real simple:
%<
rsym(X)  :- nonvar(X),!.
rsym(X)  :- gensym(g,X).
%>
%Sometimes, random symbols start with
%some seed symbol.
%<
rsym(_,X)  :- nonvar(X),!.
rsym(A,X)  :- gensym(A,X).
%>
%Testing for  random numbers within a range is easy:
%<
rin(M,N,_,X) :- nonvar(X),!, number(X),M =< X, X =< N.
%>
%It's a little more complicated generating a random
%number from a range. 
%<
rin(M,N,O,X) :- Steps is integer((N-M)/O),
	        between(1,Steps,_),
		Y is random(Steps+1),
		X is min(M + Y*O,N).
%>
%Here's the above code repeated for the case of
%integer steps between max and min:
%<
rin(M,N,X) :- nonvar(X),!, number(X),M =< X, X =< N.
rin(M,N,X) :- Steps is integer(N-M),
	      between(1,Steps,_),
	      Y is random(Steps+1),
	      X is min(M + Y,N).
%>
%Here's random member of a list:
%<
rin(X,L) :- number(X),!, member(Y,L), X =:= Y.
rin(X,L) :- nonvar(X),!, member(X,L).
rin(X,L) :- length(L,N), rmember1(L,N,X,_).

rone(X,Rest,L) :- length(L,N), rmember1(L,N,X,Rest).

rmember1([H],_,H,[])   :- !.
rmember1([H|T],N,X,Rest) :-
	Pos is random(N) + 1,
        lessN(Pos,Y,[H|T],L),
        ( X=Y,
	  Rest=L
        ; Rest=[Y|Rest1],
	  N1 is N - 1,
          rmember1(L,N1,X,Rest1)).

lessN(1,H,[H|T],T) :- !.
lessN(N0,X,[H|T],[H|L]) :-  N is N0 - 1, lessN(N,X,T,L).
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
%% \call{koset_add/3}
/*Ordered set addition to lists was shown above in \tion{orderedSets}. Here,
the same technique is applied to key-value pairs where the set is ordered
on the keys.
*/
%<
koset_add([], El, [El]). 
koset_add([H=X|T], El=Y, Add) :-
    compare(Order, H, El),
    kaddel(Order, H, X,T, El, Y,Add).

kaddel(=, H, _,T, _El, Y,[H=Y     |T]). 
kaddel(>, H, X,T,  El, Y,[El=Y,H=X|T]).
kaddel(<, H, X,T,  El, Y,[H=X     |Add]) :-
	koset_add(T, El=Y, Add).
%>
%To make life simper, we also define a predicte for bulk additions
%to pair lists.
%<
koset_adds(L,Out) :- koset_adds(L,[],Out).

koset_adds([],Out,Out).
koset_adds([H|T],In,Out) :- 
    koset_add(In,H,Temp), 
    koset_adds(T,Temp,Out).
%>
%% \call{inc(+Pairs,+Key,?Pairs)}: a lists of counters 
%\label{sec:inc/3}
%Maintain a list of pairs, sorted on the key, and the value
%is a number. Incrementing a key 
%means add one to its value. If a non-existant key is incremented,
%then it that key-value pair is created and initialized to 1.
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
    dist(L0,_,_,L,_).

dist(L0,L,Most) :- 
    dist(L0,_,_,L,Most).

dist(L0,Min,Max,L) :-
    dist(L0,Min,Max,L,_).

dist(L0,Min,Max,L,Most) :-
    msort(L0,[Min|L1]), % \MARK{distsort}
    dist([Min|L1],[],Min,Max,L,0,Most).

dist([],X,Max,Max,X,Most,Most).
dist([H|T],[H=N0|Rest],_,Max,Out,Most0,Most) :- !,
    N is N0 + 1,
    Most1 is max(Most0,N),
    dist(T,[H=N|Rest],H,Max,Out,Most1,Most).
dist([H|T],In,Min,Max,Out,Most0,Most) :-
    Most1 is max(Most0,1),
    dist(T,[H=1|In],Min,Max,Out,Most1,Most).
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
%%\call{b_/3}: a bounded key-value memory
/*
\label{sec:bounded/3}
Sometimes we collect items in order to find the
first $N$ useful items. One way to implement
that is to collect all the  results, sort them,
then return the $N$ items with the largest scores.
That way implies
that all the results must be are held in memory
at least until the sort terminates.

Another way is to take each result, just as it is
generated, score it,
and throw it into a bounded memory of size
$N$. The new item is inserted, in order, into the memory.
If that 
generates $N+1$ items that the {\em smallest} item in
the memory is discared.

The net result is that, after the any number of results are generated,
	the bounded memory holds the best $N$ results, already sorted.
It also means that, during the results generation, we never need more
memory than space to hold the $N$ items.

Internally, this {\em contents} of this
memory is a sorted list of key-value pairs, plus
some other information.
*/
%<
b_(contents, A0,A, b(A0,B,C,D), b(A,B,C,D)).
b_(maxU,     B0,B, b(A,B0,C,D), b(A,B,C,D)).
b_(maxSize,  C0,C, b(A,B,C0,D), b(A,B,C,D)).
b_(keys,     D0,D, b(A,B,C,D0), b(A,B,C,D)).
%>
%Other accessors handle common tasks.
%For example- set a field;
%<
b_(X is Y) --> b_(X,_,Y).
%>
%or access a fieldl
%<
b_(X=Y)    --> b_(X,Y,Y).
%>
%or test if we are full;
%<
b_(full)    --> b_(maxSize=S),b_(contents=L),length(L,S).
%>
%or initialize a new memory:
%<
b_(init(Max))-->
	b_(contents is []),
	b_(maxU is -9999999),
	b_(maxSize is Max),
	>< stats_(new,_,Keys),
	b_(keys is Keys).
%>
%or find the minumum value seen so far;
%<
b_(min(Key=Value))-->
	b_(contents=[Key=Value|_]).
%>
%or returns all the values;
%<
b_(values(L)) --> b_(contents=L0), maplist(arg(2),L0,L).
%>
%or update our summary of all keys seen to date:
%<
b_(key(K)) -->
	b_(keys,Old,New),
	>< stats_(add(K),Old,New).
b_(keys(Mean,Sd)) -->
	b_(keys=K),
	>< stats_(stats(Mean,Sd),K,_).
%>
%or run some command without changing the memory;
%<
b_(Com,X) :- b_(Com,X,X).
%>
%<
badd(K=V) -->
	b_(key(K)),
        (b_(full) -> badd(full,K=V) ; badd(space,K=V)).
	
%>
%If we are full, then after adding something, we delete the smallest item
%(which will be the head of the list):
%<
badd(full,K=V)  -->
	badd(space,K=V),
	b_(contents,[_|T],T).
%>
%If we try to add a new key=value pair to a full working memory, and
%it is less that the minimum value, we should just ignore it.
%Actually, this just happends automatically: the new minimum value will
%always be the left-most item and this is deleted after insertion by
%the above clause.
%
%If we have the space, then add in the new item and
%then update our knowledge of the maximum key seen so far.
%<
badd(space,K=V) -->
	b_(contents,Old,New),
	>< koset_add(Old,K=V,New),
	b_(maxU,Max0,Max),
	Max is max(Max0,K).
%>
%<
badds(N,L,B) :- b_(init(N),_,B0),badds1(L,B0,B).
badds1([],B,B).
badds1([H|T]) --> badd(H), badds1(T).
%>
%Example predicate:
%\SRC{egb.spy}{From \tion{bounded/3}.}
%<
egb:- % see \fig{egb.spy}
	egb(B),
	b_(keys(Mean,Sd),B),
	format('~p\n mean=~p; sd=~p\n',[B,Mean,Sd]). 
	

egb(B) :-
	Eg=[10=10,12=12,5=5,1=1,4=4,7=7,9=9,10=10.1,100=100,60=60],
	badds(4,Eg,B).
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
%A basic barph is just a burp
%<
burp(X) :- format('%W> ~p\n',X).
%>
%A standard barph:
%<
barph(X) :- burp(X),fail.
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
%%\call{all/1}
%<
all X :- X, fail.
all _.
%>
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
%% \call{ensure(+Term)}: some assertion exists
%\label{sec:ensure/1}
%<
ensure(X) :- X,!.
ensure(X) :- assert(X).
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
%% \call{!Repeats*!Goal1/!Goal2}: compare runtimes
%\label{sec:*/2}
%<
N*X/Y :- !,  
    times(N,X,T1),
    times(N,Y,T2),
    Inc=0.000001,
    Ratio is (T1+Inc)/(T2+Inc),
    write(goal1=X),nl,
    write(time(goal1)=T1),nl,
    write(goal2=Y),nl,
    write(time(goal2)=T2),nl,
    write(time(goal1)/time(goal2)=Ratio),nl.


N*X :- time(times(N,X,_)).
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

