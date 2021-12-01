
%\begin{prol1}*/
%:- op(1001,fx,all).
%all X :- X, fail.
%all _.
%
%:- op(999,fx,do).
%do [X|Y] :- X, do Y.
%do [].

\begin{prol1}*/
% wmeShow
%wmezap (with catergories)
% wmeStore
%wme restore

ensure((X :- Y)) :- !, (clause(X,Y) -> true | assert((X :- Y))).

ensure(X) :- X,!.
ensure(X) :- assert(X).

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

\begin{prol1} */
member1(X,Y) :- member(X,Y), !.

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

\begin{prol1}*/
meta([Predicate|Predicates],Arguments) :- !,
	append([Predicate|Predicates],Arguments,List),
	Goal =.. List,
	Goal.
meta(Predicate,Arguments) :- 
	Goal =.. [Predicate|Arguments],
	Goal.

\begin{prol1}*/
:- op(999,xfx,:).

	


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

\begin{prol1}*/
slotsOf(nothing,[]) :- !.
slotsOf(F,Slots)    :- frame(F,Slots).

value(F,S,V)      :- slotsOf(F,Slots), value0(S,Slots,V).
value0(S,Slots,V) :- member(S:All,Slots), member(V,All).

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

\begin{prol1}*/
type([],list).
type([_|_],list).
type(dList(_,_),dList).
type(lList(_,_),lList).

\begin{prol1}*/
cwrite([H|T],S)            :- print(S,[H|T]).
cwrite([],S)               :- print(S,[]).
cwrite(lList(_,L),S)       :- print(S,L).
cwrite(dList(S,X),Stream)  :- c2l(dList(S,X),L),print(Stream,L).

\begin{prol1}*/
empty([]).
empty(list,[]).

empty(lList(0,[])).
empty(lList,lList(0,[])).

empty(dList(0,empty)).
empty(dList,dList(0,_)).

\begin{prol1}*/
% fails for empty thing
bite(X,_,_) :- empty(X),!,fail.

bite([H|T],              H,T).
bite(lList(N0,[H|T]),    H,lList(N,T))     :- N is N0 - 1.
bite(dList(1,[H|_]-_),   H,Out)            :- !, empty(dList,Out).
bite(dList(N0,[H|T]-End),H,dList(N,T-End)) :- N is N0 - 1.  

\begin{prol1}*/
cinit(list, X,[X]).
cinit(lList,X,lList( 1,[X])).
cinit(dList,X,dList(1,[X|T]-T)).

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


\begin{prol1}*/
c2l([H|T],[H|T]).
c2l([],[]).
c2l(lList(_,L),L).
c2l(dList(0,_),[])   :- !.
c2l(dList(_,In),Out) :- copyFromDList(In,Out).

copyFromDList([W|_]-_,[]) :- var(W),!.
copyFromDList([W,X|Y]-Z,[W|Rest]) :-
	copyFromDList([X|Y]-Z,Rest).

\begin{prol1}*/
ordered([],[]).
ordered([H|T],Out) :- sort([H|T],Out).
ordered(lList(S,L0),lList(S,L)) :- msort(L0,L).
ordered(dList(S,D0),D) :- 
	c2l(dList(S,D0),L0), msort(L0,L),l2c(dList,L,D).

\begin{prol1}*/
orderedBy([],[]).
orderedBy([H|T],Out) :- keysort([H|T],Out).
orderedBy(lList(S,L0),lList(S,L)) :- keysort(L0,L).
orderedBy(dList(S,D0),D) :- 
	c2l(dList(S,D0),L0), keysort(L0,L),l2c(dList,L,D).

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

\begin{prol1}*/
addFirst([],Item,[Item]).
addFirst([H|T],Item,[Item,H|T]).
addFirst(lList(N0,In),Item,lList(N,[Item|In])) :- 
	N is N0+1.
addFirst(dList(0,_),Item,dList(1,[Item|T]-T)) :- !.
addFirst(dList(N0,L-End),Item, dList(N,[Item|L]-End)) :- 
	N is N0 + 1.

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

\begin{prol1}*/


\begin{prol1}*/
cardinality([],0).
cardinality([H|T],X) :- length([H|T],X).
cardinality(lList(S,_),S).
cardinality(dList(S,_),S).

\begin{prol1}*/


\begin{prol1}*/
within([H|T],X)          :- member(X,[H|T]).
within(lList(_,L),X)     :- member(X,L).
within(dList(S,In),Item) :- S > 0,memberDList(Item,In).

memberDList(_,[Y|_]-_) :- var(Y),!,fail.
memberDList(Item,[Item|_]-_).
memberDList(Item,[_,X|Y]-Z) :- memberDList(Item,[X|Y]-Z).

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

\begin{prol1} */
treeSearch(Start,Route) :-
	cinit(Start,States0),
	treeSearch1(States0,Route),!.

assertion  = [writer: skeletonWriter, assert: fail].
treeSearch = assertion   + [source: treeSearch/2].          
bfsL12     = treeSearch  + [assert: true,
                            swaps : [treeSearch1/2: bfsTwelveL1/2,
                                     cinit(X,Y)   : { cinit(list,X,Y) }]].

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


\begin{prol1} */

demo(bfsSlowFast) :-
	demo(breadthFirstSearch(list(slow,Path1))),
	demo(breadthFirstSearch(list(fast,Path2))),
	Path1=Path2,
	compareTimes([demo(breadthFirstSearch(list(slow,_))), 
                     demo(breadthFirstSearch(list(fast,_)))],200,T),
	write_ln(T). 

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


*/

dfsTwelveL1 = dfsTwelve1 +
[ assert : true
, swaps : [  bite(C,Head,Tail) : {C = [Head|Tail]} 
           , next(A,B)         : finiteBinaryTree(15,list,A,B)
	   , combine/3         : append/3
           , other(swaps)
]         ].


*/

\begin{prol1}*/	
demo(firstSearchTest) :-
	depthFirstSearch(1,[=,12],[finiteBinaryTree,15],_Path).

demo(bestFirstSearch) :-
	bestFirstSearch(1,[=,12],[binaryTree,list],[close2n,12],_Path).

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

