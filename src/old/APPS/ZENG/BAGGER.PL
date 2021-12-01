:- write('
-----------------
BAGGER  [v0.02] 
(timm\'s  version)
(c) UNSW AI, 1998   
-----------------'),nl.

%------------------------------------------------------
% operator definitions
% author: tjm, april '92
:- op(990,xfx,if).
:- op(980,xfx,then).
:- op(970,xfx,or).
:- op(960,xfy,and).
%:- op(950,fx,not). % pre-defined in SWI
:- op(800,fx,--).
:- op(800,fx,++).
:- op(800,xfx,<--).
:- op(680,xfx,includes).
:- op(720,xfx,has).
:- op(720,xfx,isa).
:- op(720,xfx,of).
:- op(720,fx,the).
:- op(710,xfy,with).
:- op(10,fx,rule).   


%------------------------------------------------------
% bagger rule language utilities
% author: tjm, april '92
X and Y :- X, Y. 

%%already defined in SWi
%not X :- not(X).

-- X :- retract(X).

++ X :- asserta(X).

X includes Y :- member(Y,X).

X has Y :-                    
	item(X,ITEM),
	grocery(ITEM, TYPE, SIZE, FROZEN),
	fields(Y,grocery(ITEM, TYPE, SIZE, FROZEN)).

fields(A with B, TUPLE) :- !,
	fields(A, TUPLE),
	fields(B, TUPLE).
fields(FIELD = VALUE, TUPLE) :-
	field(FIELD,_,TUPLE,VALUE).

% If the following predicate still confuses you, ignore how
% it is implemented. Have a look at how it is used in rule B4.
number(ITEMS) of FIELD/VALUE>=N :-
	my_bagof(1,
		(member(X,ITEMS), 
		 item(X,ITEM),
		 ITEM has FIELD = VALUE),
		L),
	length(L,M),
	M >= N.

number(ITEMS) of FIELD/VALUE>N :-
	my_bagof(1,
		(member(X,ITEMS), 
		 item(X,ITEM),
		 ITEM has FIELD = VALUE),
		L),
	length(L,M),
	M > N.

number(ITEMS) of FIELD/VALUE=N :-
	my_bagof(1,
		(member(X,ITEMS), 
		 item(X,ITEM),
		 ITEM has FIELD = VALUE),
		L),
	length(L,M),
	M =  N.

number(ITEMS) of FIELD/VALUE<N :-
	my_bagof(1,
		(member(X,ITEMS), 
		 item(X,ITEM),
		 ITEM has FIELD = VALUE),
		L),
	length(L,M),
	M < N.

number(ITEMS) of FIELD/VALUE=<N :-
	my_bagof(1,
		(member(X,ITEMS), 
		 item(X,ITEM),
		 ITEM has FIELD = VALUE),
		L),
	length(L,M),
	M =< N.

my_bagof(X,Y,Z) :- bagof(X,Y,Z),!.
my_bagof(_,_,[]).

item(insulated(X),X) :-!.
item(X,X).	             

X <-- X :- X. 
 
%------------------------------------------------------
% bagger main module
% author: tjm, april '92
 
% bagger/2
% assert the shopping items, run the inference engine,
% collect the asserted bags.
% As this program runs, the asserted shopping items are
% retracted as they are moved into bags.   
bagger(ITEMS, BAGS) :-
	clear, 
	assertItems(ITEMS),
	++ the step is check_order,
	fchain,
	!,
	collectBags(BAGS).
          
% assertL/1                  
% assert everything in the list.
assertItems(L) :-
	doAll((
		member(I,L),
		assert(there isa item(I))
	)).
  
% doAll/1                              
% backtrack through all solutions to X.
doAll(X) :- X, fail.
doAll(_).
         
% collectBags/1                              
% collect all the shopping bags.
collectBags(BAGS) :-
	my_bagof(ITEMS,bag(ITEMS), BAGS).   
                                
% clear /0                                        
% clear all the assertions generated at the last
% run of the program.
% clear /1
% fire asserts a 'alreadyUsed/2' fact which clear must
% remove as well as the other assertions.
   

clear :- wme(X), retractall(X), fail.
clear.

show :- wme(X), X, print(X), nl,fail.
show.

% fchain /0
% find all the triggerred rules with satisfied
% conditions, select one to fire, fire it, then
% loop. Terminate when there are no more triggered
% rules. Also, print some debug information on the
% way through.
fchain :-    
	triggeredRules(RULES),   
	watch(RULES),
	conflictResolution(RULES, RULE),
	fire(RULE),
	fchain.
fchain.

% watch/1
% prints out trace information if the 'watchOnas' fact is
% asserted. In particular, the predicate lists all the 
% current bags, then prints the labels of all the rules 
% in the conflict set.
% Assumes that RULES is a list of items of the form
% rule X if Y then Z
watch(RULES) :-  
	watchOn,
	!,
	show,    
	%show,
	doAll((
		nl, write('conflict set:'),
		member(rule L if _ then _, RULES),
		write(' '), print(L)
	)),
	nl.    
watch(_).
             
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% triggered rules                        
% calls triggeredRule via a bagof, then tests for an
% non-empty list (hence, fails when no rules are 
% triggered).

triggeredRules(RULES) :-
	bagof(RULE, triggeredRule(RULE), RULES).

% a rule is triggered if its premise is true and we
% have not used it previously.
triggeredRule(rule LABEL if PREMISE then ACTION) :-
	rule LABEL if PREMISE then ACTION,   
	PREMISE.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% conflict resolution
% Run down  list a find the rule with the most conditions.

conflictResolution(RULES, RULE) :-
%	print(RULES),nl,
	conflictResolution(RULES,RULE,_).
                           
conflictResolution([rule L if IF then THEN],
		rule L if IF then THEN, 
		SIZE) :- !,    
	sizeOf(IF,SIZE).
conflictResolution([rule L if IF then THEN| RULES],
		BEST, SIZE) :-
	conflictResolution(RULES, TEMP, SIZE1),
	conflictResolution1(rule L if IF then THEN, 
				TEMP, SIZE1, BEST, SIZE).

conflictResolution1(rule L if IF then THEN, _, SIZE1,  
		    rule L if IF then THEN, SIZE2) :-   
	sizeOf(IF,SIZE2),
	SIZE2 > SIZE1,
	!.
conflictResolution1(_,RULE,SIZE,RULE,SIZE).
        
sizeOf(A and B,S) :- !,sizeOf(A,SA),sizeOf(B,SB), S is SA + SB. 
sizeOf(not A,S) :- !, sizeOf(A,S).
sizeOf(_,1).
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fire: a trivial predicate.

fire(rule LABEL if _ then ACTION) :-
	talk(firing(LABEL)),
	ACTION.

:- dynamic watchOn/0.

talk(X) :- watchOn,!, print(X),nl.
talk(_). 

 
%------------------------------------------------------
% bagger general utilities
% author: tjm '92

% test /0
% convenient top-lvel driver for testing your system
test :-                            
	ITEMS = [bread, glop, granola, granola,iceCream,potatoChips],
	test1(ITEMS).

test1(ITEMS) :-
	bagger(ITEMS,BAGS),
	nl,  
	write('ITEMS:'),nl,
	write('     '),
	write(ITEMS),nl,
	write('FINAL BAGS:'),nl,
	member(BAG,BAGS),
	write('     '),
	write(BAG),nl,
	fail.
test1(_).

sum([],0).
sum([H|T],OUT) :- sum(T,TEMP), OUT is TEMP + H. 

member(X,[X|_]).
member(X,[_|T]) :- member(X,T).  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% records.pl
%% Tim Menzies, 1998
%% 
%% The predicates in this file are listed dumbest to smartest.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% operators
% ZENG: unify these oeprators with operators at top of file
:-	op(1200, xfx, <--),
	op(990,fx,o),
	op(970,xfy,with),
	op(960,xfy,be),
	op(950,xfy,has),
	op(950,xfy,does),
	op(950,xfy,but),
	op(950,xfy,and),
	op(925,xfy,are),
	op(920,fx,of),
	op(910,fx,in),
	op(900,xfx,to),
	op(5,fx,an),
	op(5,fx,a),
	op(2,fx,:),
	op(1,fx ,:$),
	op(1,xfx,..),
	op(1,fx,&),
	op(1,fx,above),
	op(1,fx,below),
	op(1,fx,upTo),
	op(1,fx,downTo).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% some declarations

:- discontiguous demo/2, (<--)/2.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% misc low-level stuff

%% print stuff
w(X)     :- write(X), flush_output(user).
w(N,X)   :- tab(N), write(X), flush_output(user).

wln(X)   :- write_ln(X).
wln(N,X) :- tab(N), write_ln(X).

%% list stuff

nList(L) :- nList(L,1).
nList([],_).
nList([H|T],N0) :- write_ln(N0=H),N is N0 + 1, nList(T,N).

asList(X,X) :- is_list(X),!.
asList(X,[X]).

%% term stuff

aMember(X,(X,_)).
aMember(Z,(_,Y)) :- !, aMember(Z,Y).
aMember(X,X).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% buidling accessors into terms

%% macros for auto-generating the accessors
% neat thing about term_expansion is that when the source
% file is reloaded, all the expanded terms are auto-retracted.

:- discontiguous isEntity/1, touch/5, new/2, blank/2, entities1/2, entities1Zap/2.
:- dynamic isEntity/1.

term_expansion(entity(Term),All) :- entities(Term,All).

entities(Term0,All) :-
	Term0 =.. [F|Args],
	Term  =.. [F,id=0|Args],
	entitiesZap(F),
	bagof(One,Term^(entities1(Term,One)),All). 

entitiesZap(Functor) :- entities1Zap(Functor,Zapper), Zapper, fail.
entitiesZap(_).

entities1(Term, (:- index(Blank)) ) :-
	functor(Term,F,A),
	functor(Blank,F,A),
	Blank =.. [F|Args],
	indexFirstNArgs(Args,4).
entities1(Term,(:- dynamic F/A)) :- functor(Term,F,A).
entities1(Term,(:- multifile F/A)) :- functor(Term,F,A).
entities1(Term,(:- discontiguous F/A)) :- functor(Term,F,A).
entities1(Term,(:- discontiguous F/5)) :- 
	functor(Term,F0,_), accessorName(F0,F).

entities1(Term,isEntity(X)) :- 
	functor(Term,F,A), 
	functor(X,F,A).
entities1Zap(F,retractall(isEntity(X))) :-
	isEntity(X),
	functor(X,F,_).

entities1(Term,Out) :-
	Term =.. [S|Args0],
	maplist(secondItem,Args0,Inits),
	New =.. [S|Inits],
	Out =   new(S,New).
entities1Zap(F,retractall(new(F,_))).

entities1(Term,Out) :-
	functor(Term,F,A),
	functor(Blank,F,A),
	Out= blank(F,Blank).
entities1Zap(F,retractall(blank(F,_))).

entities1(Term,Touch) :-
	Term =.. [S0|Args0],
	accessorName(S0,S),
	maplist(firstItem,Args0,Firsts),
	length(Firsts,Arity),
	functor(Term0,S0,Arity),
	nth1(Pos,Firsts,Arg),
        copyArgs(Term0,Pos,Value0,Value,Term1),
	Touch =.. [S,Arg,Value0,Value,Term0,Term1].
entities1Zap(F0,retractall(Doomed)) :-
	accessorName(F0,F),
	functor(Doomed,F,5).

entities1(Term,(Head :- Touch)) :-
	Head=touch(Term1,Arg,Value0,Term2,Value),
	functor(Term,Functor,Arity),
        functor(Term1,Functor,Arity),
  	functor(Term2,Functor,Arity),
        accessorName(Functor,IName),
        Touch =.. [IName,Arg,Value0,Value,Term1,Term2].
entities1Zap(F,retractall(Doomed)) :-
	Doomed = touch(Term,_,_,_,_), 
	clause(Doomed,_),
	functor(Term,F,_).

% support code for entities1/2

indexFirstNArgs(Args,N) :-
	indexFirstNArgs(Args,N,1).

indexFirstNArgs([],_,_).
indexFirstNArgs(Args,0,1) :- !,
	indexFirstNArgs(Args,0,0).
indexFirstNArgs([I|T],N0,I) :-
	N is N0 -1,
	indexFirstNArgs(T,N,I).

accessorName(F,N) :- name(F,X),name('0',Y), append(X,Y,Z), name(N,Z).

firstItem(X,Y) :- arg(1,X,Y),!.
firstItem(X,X).

secondItem(X,Y) :- arg(2,X,Y),!.
secondItem(_,_).

copyArgs(T0,Except,Old,New,T) :-
        T0 =.. [Functor|Args0],
        copyArgs1(Args0,1,Except,Old,New,Args),
        T  =.. [Functor|Args].

copyArgs1([],_,_,_,_,[]).
copyArgs1([Old|Args],Pos,Pos,Old,New,[New|Args]) :- !.
copyArgs1([Arg|Args0],Pos0,Except,Old,New,[Arg|Args]) :-
        Pos is Pos0+1, 
        copyArgs1(Args0,Pos,Except,Old,New,Args).

%% standard skeleton for processing a structure

% query with no chance of changing anything
o(X,W) :- o(X,W,_).

% call "o" for lots of things
o(X and Y, W0,W)      :- !, o(X,W0,W1), o(Y,W1,W).
o([],W, W).
o([H|T],W0,W)         :- o(H,W0,W1), o(T,W1,W).

% grab a value out of a term
o(X=Old,W, W)         :- touch(W,X,Old,W,_).

% change values (note: breaks rule #1)
o(X is Old/New, W0,W) :- !, touch(W0,X,Old,W,New). % access old and new value
o(X is New,     W0,W) :- touch(W0,X,_,W,New).      % insert new value only

% simple maths
o(X + M,W0,W)         :- touch(W0,X,Old,W,New), 
    			 New is Old + M.
o(X >= M,W0,_)        :- touch(W0,X,Old,_,_),  Old >= M.
o(X > M,W0,_)         :- touch(W0,X,Old,_,_),  Old > M.
o(X \= M,W0,_)        :- touch(W0,X,Old,_,_),  Old \= M.
o(X < M,W0,_)         :- touch(W0,X,Old,_,_),  Old < M.
o(X =< M,W0,_)        :- touch(W0,X,Old,_,_),  Old =< M.

% rules for extending query language:
%	1)	functor of first argument MUST be unique

% head append to a list
o(X << Add0,W0,W) :- 
	asList(Add0,Add),
	touch(W0,X,L0,W,L),
	append(Add,L0,L).

pp(X) :- touch(X,Field,Value,_,_),
	  format('~n~a ~`.t~20| ~a',[Field,Value]),
	  fail.
pp(_).

%% demo of the accessors

entity(demo_o(name,age=0,shoes=[])).

demo(o,Y) :-
	new(demo_o,X),
	o(	[name=tim
		, age+4
		, shoes<<leather
		]
	  	,X
	  	,Y).
	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% method stuff

term_expansion( X does Y=R <-- Z, Out) :- 
	xpandMethod(X,Y,R,Z,Out).
term_expansion( X does Y=R, Out) :- 
	xpandMethod(X,Y,R,true, Out).

xpandMethod(Class,Action,Result,Body,Out) :-
	bagof(One,xpandMethod1(Class,Action,Result,Body,One),Out).

xpandMethod1(Class,Action,Result,Body0,Out) :-
	accessorName(Class,A),
	Head =.. [A,Action,_,Result,T1,T2],
	(Body0=true
	->	Out=Head
	;	odcg(Body0,Body,T1,T2),
		Out=(Head :- Body)
	).

odcg(X       ,X     ,In, In)    :- var(X),!.
odcg((X0->Y0;Z0),New, In,Out)   :- !,( odcg(X0 ,X,In,T),
                                       odcg(Y0,Y,T, Out),
                                       New=(X,!,Y)
                                     ; odcg(Z0,Z,In,Out),
                                       New=Z).
odcg((X0,Y0) ,(X,Y), In,Out) :- !,odcg(X0 ,X,In,T),    odcg(Y0,Y,T, Out).
odcg((X0;Y0) ,X,     In,Out) :- !,(odcg(X0,X,In,Out);  odcg(Y0,X,In,Out)).
odcg((X0|Y0) ,X,     In,Out) :- !,(odcg(X0,X,In,Out);  odcg(Y0,X,In,Out)).
odcg(not X0, not X,  In,In)  :- !,odcg(X0 ,X,In,_).
odcg(o X,o(X,In,Out),In,Out) :- !.
odcg(X  ,X,          In, In).

entity(methodDemo(happy,age,name,dob,shoeSize,weigh)).

 methodDemo does init=Id <--
	flag(id,Id,Id+1),
	get_time(Time), 
	convert_time(Time,Y,Mn,D,_,_,_,_),
	o 	id is Id and 
		dob is date(Y,Mn,D) and
		name= who('Menzies','Tim').

demo(method,Ready) :-
	new(methodDemo,New),
	o(init is _,New,Ready).

 methodDemo does this(1,2,3)=y.
 methodDemo does this(A,1,B)=y <--
        A=B,
        b(a,5,A),
        c,!,
        (d ->
                e,
                o fred + 1,
                o fred > 10,
                o tom = 23
         ;      Z is 1 + 1,
                f(Z,B)
        ),
        not (a(a),
             l(1),
             o z + 1
            ),
         o a + -1 ,
         l(h).


demo(odcg,y) :- clause(methodDemo0(this(_,_,_),B,C,D,E),Body),
		\+ Body=true,
		portray_clause((methodDemo0(this(_,_,_),B,C,D,E) :- Body)),
		fail.
demo(odcg,y).

%------------------------------------------------------
% bagger item knowledge
% auther: tjm, april '92
        
entity(person(name,age,address, phoneNo)).

person does init=_ <--
	flag(id,Id,Id+1),
	o id is Id.

entity(cashier(
	number,
	password,
	authorizationLevel=0,
	currentSession,
	warning=[])).

cashier does init=_ <--
	flag(id,Id,Id+1),
	o id is Id.

% WARNING: tims code is vvery buggy!!!!!!!!!!!!!

cashier does addWarning = New <--
	o	warning << New.

cashier does tooManyWarnings = t <--
	o	warning = [_,_,_|_].

% example of hand writing a method
% 57 ?- new(cashier,X), o(init is _,X,Y), o(somethingElse is hello,Y,Z).
%
% X = cashier(0, _G659, _G660, 0, _G662, [])
% Y = cashier(30, _G659, _G660, 0, _G662, [])
% Z = cashier(30, _G659, hello, 0, _G662, []) 

cashier0(somethingElse,_ignore,Input,OldWme,NewWme) :-
	o(password is Input,OldWme,NewWme).

a(Entity,E,Id) :-
	blank(Entity,E),
	E,
	arg(1,E,Id).

rule 1
if	hiring(P) and
	o(age < 18,P)
then	-- hiring(P).

rule 2
if     a(cashier,C,_) and 	
       not dump(C)  and
       o(warning= [_,_,_|_],C) 
then   ++ dump(C).

rule 3
if     	dump(C)
then 	wln(iAmFiring(C)) and
	-- dump(C) and
	-- C.

connie :-
	clear,
	initConnie,
	fchain,
	wln('---------------'),
	show.
		
initConnie :-
	tim(T),
        btim(T1),
	zeng(Z),
        ++ T1,
	++ hiring(Z),
	++ hiring(T).

zeng(P) :-
	new(person,P0),
	o(init is _,P0,P1),
	o(	name is tim and 
		age is 17 and 
		address is here and 
		phoneNo is 1234
		,P1,P).

tim(P) :-
	new(person,P0),
	o(init is _,P0,P1),
	o(	name is tim and 
		age is 21 and 
		address is here and 
		phoneNo is 1234
		,P1,P).
btim(C):-
	new(cashier,C0),
	o(init is _,C0,C1),
	o(	number is 123  and 
		password  is hello  and 
		authorizationLevel is 0 and 
	         currentSession  is session and 
                 warning is [one,two, three, four]
		,C1,C).
% definition of temporaries
wme(hiring(_)).
wme(dump(_)).

wmeSetup :- wme(X),
	functor(X,F,A),
	(dynamic F/A),
	fail.
wmeSetup.

% IMPORTANT: called AFTER the wme/1 database is defined
:- wmeSetup.

:- write('Bagger loaded. For a demo, enter the goal :- test'),nl.


/*

     
   2 Elmagarmid Ahmed K              Database transaction models fo  1992      
   3 Elmagarmid Ahmed K              Video database systems issues   1997      
   5 Hackathorn Richard D            Enterprise database connectivi  1993      
   8 International Workshop on Cons  Constraint databases and appli  1996      
   9 Jackson Glenn A                 Relational database design wit  1988     
                
 11 Lucas Robert                    Database applications using Pr  1988      
  12 Lynch Clifford A                Extending relational database   1987      
  13 Marcus Claudia                  Prolog programming application  1986     
  15 Rao Bindu Rama                  Object oriented databases tech  1994     
  17 Tansel Abdullah Uz              Temporal databases theory desi  1993 

*/     

