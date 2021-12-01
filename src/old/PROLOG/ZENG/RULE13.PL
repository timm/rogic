%  --------------------------------------------
% operator definitions
:- op(1175, xfx, <--).
:- op(990,xfx,if).
:- op(990,fx,o).
:- op(980,xfx,then).
:- op(970,xfx,or).
:- op(970,xfy,with).
:- op(960,xfy,be). 
:- op(950,xfy,has).
:- op(950,xfy,does).
:- op(950,xfy,but).
:- op(950,xfy,and).
:- op(925,xfy,are).
:- op(925,xfx,isa).
:- op(910,xfx,in).
:- op(910,xfx,add).
:- op(910,xfx,equal).
:- op(910,xfx,sub).
:- op(800,fx,--).
:- op(800,fx,++).
:- op(680,xfx,includes).
:- op(720,xfx,of).
:- op(720,fx,the).
:- op(710,xfy,with).
:- op(300,xfx,on).
:- op(10,fx,rule).   
:- op(5,fx,an).
:- op(5,fx,a).
:- op(2,fx,:).
:- op(1,fx ,:$).
:- op(1,xfx,..).
:- op(1,fx,&).
:- op(1,fx,above).
:- op(1,fx,below).
:- op(1,fx,upTo).
:- op(1,fx,downTo).




%------------------------------------------------------
%  rule language utilities

X and Y :- X, Y. 

-- X :- is_list(X),!,retractList(X).
-- X :- retract(X).

++ X :- is_list(X),!, assertList(X).
++ X :- asserta(X).

retractList(X):- member(Y,X),retract(Y),fail.
retractList(_). 

assertList(X) :- member(Y,X), assert(Y), fail.
assertList(_).

X includes Y :- member(Y,X).

item(insulated(X),X) :-!.
item(X,X).                   

X <-- X :- X. 
 
%------------------------------------------------------
% clear /0                                        
% clear all the assertions generated at the last
% run of the program.
% clear /1
% fire asserts a 'alreadyUsed/2' fact which clear must
% remove as well as the other assertions.
   

clear :- wme(X), retractall(X), fail.
clear.
%------------------------------------------------------
% tools for debug

show :- wme(X), X, print(X), nl,fail.
show.

clearEnt :-
	blank(_,Doomed),
	retract(Doomed),
	fail.
clearEnt.

showent :- 
	blank(X,Goal),
	string_concat('---| ',X,Y), 
	string_concat(Y,' |------------------',Z), 
	nl,
	write(Z), 
	nl, 
	Goal, 
	print(Goal), 
	nl, 
	fail.
showent.

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

doAll(X) :- X, fail.
doAll(_).
             
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
        nl,
	wTerm(LABEL),
        talk(firing(LABEL)),
        ACTION.

:- dynamic watchOn/0.

talk(X) :- watchOn,!, print(X),nl.
talk(_). 

 
%------------------------------------------------------

sum([],0).
sum([H|T],OUT) :- sum(T,TEMP), OUT is TEMP + H. 


mb(X1,Y1,X2,Y2,M,B) :-
	M is (Y2-Y1)/(X2-X1),
	B is Y1 - M*X1.

member(X,[X|_]).
member(X,[_|T]) :- member(X,T).  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% some declarations

:- discontiguous demo/2, (<--)/2.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% misc low-level stuff
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% print stuff
w(X)     :- write(X), flush_output(user).
w(N,X)   :- tab(N), write(X), flush_output(user).


pairs([H1|_],[H2|_],H1,H2).
pairs([_|T1],[_|T2],H1,H2) :- pairs(T1,T2,H1,H2).


wTerm(T) :-
	T =.. L,
	wlist(L).

wlist(X) :- member(Item,X), wln(5,Item), fail.
wlist(_).

wln(X)   :- write_ln(X).
wln(N,X) :- tab(N), write_ln(X).

%% list stuff

nList(L) :- nList(L,1).
nList([],_).
nList([H|T],N0) :- write_ln(N0=H),N is N0 + 1, nList(T,N).

asList(X,X) :- is_list(X),!.
asList(X,[X]).

oneTwo([X,Y|_],X,Y). 
oneTwo([_,Y|T],One,Two) :- oneTwo([Y|T],One,Two).

%% term stuff

aMember(X,(X,_)).
aMember(Z,(_,Y)) :- !, aMember(Z,Y).
aMember(X,X).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% buidling accessors into terms

%% macros for auto-generating the accessors
%% neat thing about term_expansion is that when the source
%% file is reloaded, all the expanded terms are auto-retracted.

:- discontiguous isEntity/1, touch/5, new0/2, blank/2, entities1/2, entities1Zap/2.
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
        Out =   new0(S,New).
entities1Zap(F,retractall(new0(F,_))).

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

%% support code for entities1/2

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% standard skeleton for processing a structure
%% query with no chance of changing anything
o(X,W) :- o(X,W,_).

o(X and Y, W0,W)      :- !, o(X,W0,W1), o(Y,W1,W).
o([],W, W).
o([H|T],W0,W)         :- o(H,W0,W1), o(T,W1,W).

% grab a value out of a term
o(X=Old,W, W)         :- touch(W,X,Old,W,_),!.
% two attributes in one 
% ZZ: ??? define a new  key word here

o(X equal Y,W0,W0)    :- touch(W0,X,First,_,_),
                         touch(W0,Y,Second,_,_),
                         is_list(First),
                         is_list(Second),
                         length(First,N),
                         length(Second,N).

% change values (note: breaks rule #1)
o(X is Old/New, W0,W) :- !, touch(W0,X,Old,W,New). % access old and new value
o(X is New,     W0,W) :- touch(W0,X,_,W,New).      % insert new value only

% simple maths
o(X + M,W0,W)          :- touch(W0,X,Old,W,New), 
                          New is Old + M.
o(Y in X,W0,W0)        :- o(X = List,W0,W0), member(Y,List).

o(X >= M,W0,W0)        :- touch(W0,X,Old,_,_),  Old >= M.
o(X >  M,W0,W0)        :- touch(W0,X,Old,_,_),  Old >  M.
o(X \= M,W0,W0)        :- touch(W0,X,Old,_,_),  Old \= M.
o(X <  M,W0,W0)        :- touch(W0,X,Old,_,_),  Old <  M.
o(X =< M,W0,W0)        :- touch(W0,X,Old,_,_),  Old =< M.


o(X << Add0 on Field,W0,W) :- !,
	  asList(Add0,Add),
	  touch(W0,X,L0,W,L),
	  append(Add,L0,L1),
	  b_sort1(L1,Field,L).

o(X << Add0,W0,W) :- 
        asList(Add0,Add),
        touch(W0,X,L0,W,L),
        append(Add,L0,L).


 
% two accesses for updates, not 3.
o(X add Y,W1,W2,W3) :-  touch(W1,X,Temp1,W3,Temp3),     
                     	touch(W2,Y,Temp2,_,_),
                     	Temp3 is Temp1 + Temp2.
o(X sub Y,W1,W2,W3) :-  
			touch(W1,X,Temp1,W3,Temp3),     
                     	touch(W2,Y,Temp2,_,_),
                     	Temp3 is Temp1 - Temp2.
	 
/*
o(X sub Y,W1,W2,W3) :-  touch(W1,X,Temp1,_,_),     
                     touch(W2,Y,Temp2,_,_),
                     Temp3 is Temp1 - Temp2,
                     o(X is Temp3, W1,W3). 
o(X add Y,W1,W2,W3) :-  touch(W1,X,Temp1,_,_),     
                     touch(W2,Y,Temp2,_,_),
                     Temp3 is Temp1 + Temp2,
                     o(X is Temp3, W1,W3).
*/
pp(X) :- touch(X,Field,Value,_,_),
          format('~n~a ~`.t~20| ~a',[Field,Value]),
          fail.
pp(_).

comp1(X,W0,W1) :-
        X =.. [OP,Field1,Field2],
        touch(W0,Field1,First,_,_),
        touch(W1,Field2,Second,_,_),
        Goal =.. [OP,First,Second],
        Goal.
comp(X >= Y,W0,W1)  :- touch(W0,X,First,_,_),
                         touch(W1,Y,Second,_,_), First >= Second.
comp(X >  Y,W0,W1)  :- touch(W0,X,First,_,_),
                         touch(W1,Y,Second,_,_), First >  Second.
comp(X \= Y,W0,W1)  :- touch(W0,X,First,_,_),
                         touch(W1,Y,Second,_,_), First \= Second.
comp(X <  Y,W0,W1)  :- touch(W0,X,First,_,_),
                         touch(W1,Y,Second,_,_), First <  Second.
comp(X =< Y,W0,W1)  :- touch(W0,X,First,_,_),
                         touch(W1,Y,Second,_,_), First =< Second.
comp(X == Y,W0,W1)  :- touch(W0,X,First,_,_),
                         touch(W1,Y,First,_,_). %think bout this, First == Second.
comp(X equal Y ,W0,W1):-touch(W0,X,First,_,_),
                        touch(W1,Y,Second,_,_),length(First,N),length(Second,N).
commit(X,Y) :-
	o(X,Y,Z),
	wln(in(Y)),
	retract(Y),
	assert(Z),
	wln(out(Z)).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% some tools
b_sort(L,S):- append(U,[A,B|V],L),
               touch(A,recordNumber,X,_,_),
               touch(B,recordNumber,Y,_,_),
               Y < X,
               append(U,[B,A|V],M),
               b_sort(M,S).
b_sort(L,L).
i_sort([H|T],S):- i_sort(T,L),insert(H,L,S).
i_sort([],[]).

insert(X,[H|T],[H|L]):- touch(H,recordNumber,A,_,_),
                        touch(X,recordNumber,B,_,_),
                        A < B,!,insert(X,T,L).
                       
insert(X,L,[X,L]).

g_time(X):- get_time(Now),
            convert_time(Now,Year,Month,Day,_,_,_,_),
             X is Year * 10000 + Month *100 + Day .

b_sort1([],_,[]) :- !.
b_sort1(L,Field,Sorted) :-
	maplist(addKey(Field),L,L1),
	keysort(L1,L2),
	maplist(stripKey,L2,Sorted).

addKey(Field,X,Value-X) :- o(Field=Value,X).
stripKey(_-X,X).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% method stuff

new(X,Y)       :- new(X,[],_,Y).
new(X,Inits,Y) :- new(X,Inits,_,Y).

new(X,Inits,Id,Y) :- 
        new0(X,Temp), 
        o([init is _|Inits], Temp,Y),
        arg(1,Y,Id). 

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
        ->      Out=Head
        ;       odcg(Body0,Body,T1,T2),
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

a(Entity,Properties,E,Id) :-
        blank(Entity,E0),
        E0,
        arg(1,E0,Id),
	o(Properties,E0,E).

a(Entity,E) :- a(Entity,E,_).

a(Entity,E,Id) :-
	a(Entity,[],E,Id).


average(Field,Items,A) :-
	bagof(A,Field^Items^fields(Field,Items,A),All),
	length(All,L),
	sum(All,S),
	A is S/L.

my_bagof(X,G,Out) :- bagof(X,G,Out),!.
my_bagof(_,_,[]).


fields(Field,Items,Value) :-
	member(Item,Items),
	o(Field = Value,Item).

all(Withs,Out) :-
	bagof(One,Withs^all1(Withs,One),Out).

all1(Withs,One) :-
	member(Entity with Properties,Withs),
	a(Entity,Properties,One,_).	
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% definition of temporaries
wme(the step is _).
wme(event(_)).

wmeSetup :- wme(X),
        functor(X,F,A),
        (dynamic F/A),
        fail.
wmeSetup.

% IMPORTANT: called AFTER the wme/1 database is defined
:- wmeSetup.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%------------------------------------------------------
% define the class and its method.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%define the class register   
%------------------------------------
entity(register(
       number)).

register does init=Id <--
        flag(id,Id,Id+1),
        o id is Id.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%define the class session   
%------------------------------------
entity(session(
       startTime,
       endTime)).

person does init=Id <--
        flag(id,Id,Id+1),
        o id is Id.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%define the class person   
%------------------------------------
entity(person(
       name,
       age,
       address, 
       phoneNo, 
       hireStatus,
       cashierId)).

person does init=Id <--
        flag(id,Id,Id+1),
        o id is Id.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%define the class cashier
%------------------------------------
entity(cashier(
       cashierId,
       password,
       authorizationLevel=0,
       currentSession,
       warning=[],
       personId)).

cashier does init=Id <--
        flag(id,Id,Id+1),
        o id is Id.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%define the class item
%------------------------------------
entity(item(
       itemId,
       quantity,
       description,
       reorder = f,
       discountQuantity,
       warningQuantity,
       lowQuantityWarning = f)).
item   does init=Id <--
       flag(is,Id,Id+1),
       o id is Id.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%define the class sale 
%------------------------------------    
entity(sale(
       time,
       checkStatus = f,
       itemIdList = [],
       quantityList = [],
       analystSataus = 0
       )).

sale  does init=Id <--
        flag(id,Id,Id+1),
        o id is Id.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%define the class saleLineItem
%------------------------------------
entity(saleLineItem(
       itemId,
       saleId,    
       quantity = 0,
       saleStatus = f,
       analystSataus = 0)).

saleLineItem does init=Id <--
        flag(is,Id,Id+1),
        o id is Id.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%define the class itemDailySaleRecord
%------------------------------------
entity(itemDailySaleRecord(
        recordId,
        itemId,
        quantity = 0,
        analystStatus = 0)).
itemDailySaleRecord does init= Id <--
        flag(is,Id,Id+1),
        o id is Id.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%define the class itemDailySaleRecordList
%------------------------------------
entity(itemDailySaleRecordList(
        itemId,
        recordList=[],
        analystStatus = 0)).
itemDailySaleRecordList does init=Id <--
        flag(is,Id,Id+1),
        o id is Id.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%define the class join
%------------------------------------       
entity(join(
        from,
        to)).
join does init=Id <--
        flag(is,Id,Id+1),
        o id is Id.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    construct the database                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

aPerson(Person,Name,Age,Address,PhoneNo) :-
        new(person,P1),
        o(      name    is Name       and 
                age     is Age        and 
                address is Address    and 
                phoneNo is PhoneNo    and
                hireStatus  is undecided 
                ,P1,Person),
        ++ Person.

%-------------------------------------------------------

aItem(Item,ItemId,Quantity,Description,DiscountQuantity,
      WarningQuantity):-
      new(item,
                itemId is ItemId                     and
                quantity is Quantity                 and
                description is Description           and
                discountQuantity is DiscountQuantity and
                warningQuantity is WarningQuantity  
                ,_,Item),
        ++ Item.

%---------------------------------------------------------- 

aSale(Sale,ItemIdList,QuantityList) :-
      g_time(X),
      new(sale,
           time is X                          and
           itemIdList is ItemIdList           and
           quantityList is QuantityList    
           ,_SaleId,Sale),
       ++ Sale .
%--------------------------------------------------------------------

aItemDailySaleRecord(ItemDailySaleRecord,ItemId):-
      g_time(X), 
      new(itemDailySaleRecord,
           recordId  is  X       and
           itemId is ItemId              
          ,_
          ,ItemDailySaleRecord),
      ++ ItemDailySaleRecord.  

%-------------------------------------------------------------------
aItemDailySaleRecordList(ItemDailySaleRecordList,ItemId):-
      new(itemDailySaleRecordList,
           itemId is ItemId
           ,_
           ,ItemDailySaleRecordList),
        ++ ItemDailySaleRecordList.
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          rules                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rule can_not_hire_because_of_too_young_1 
if      a(person,age < 18 and hireStatus =undecided ,Person,_)       
       
then    wlist(['----------------------------------------------------------'
              ,'Can not hire the person because  too young.'
              ,'The person is:'
              ,Person
              ,'----------------------------------------------------------'
              ])                       and
        -- Person .               
        

rule can_not_hire_because_of_too_old_2
if      a(person,hireStatus = undecided and age > 65,Person,_) 
then    wlist(['-----------------------------------------------------'
              ,'Can not hire the person because too old.'
              ,'The person is:'
              ,Person                                                  
              ,'-----------------------------------------------------'
              ])                       and
        -- Person .     
       
rule  hire_the_cashier_3
if      a(person, age > 18 and 	age < 65 and hireStatus=undecided,
	     Person, Person_Id)
then    new(cashier,
                cashierId is  0              and
                password  is password        and 
                authorizationLevel is 0      and 
                currentSession is session    and
                warning is []                and
                personId is Person_Id ,Cashier_Id,Cashier)      and
        new(join,
                from is Person_Id and
                to is   Cashier_Id
                ,_
                ,Join)                       and
        ++ Join                              and 
        o(cashierId is Cashier_Id and hireStatus is hired , Person,NewPerson) and
        -- Person                                          and
	++ [NewPerson,Cashier]                             and 
        wlist(['-----------------------------------------------------'
              ,'Hire the person .'
              ,'The person is:'
              , NewPerson                                                  
              ,'-----------------------------------------------------'
              ]).                                                
                                                   

rule   fire_the_cashier_because_of_too_Many_Warnings_4
if     a(cashier,warning= [_,_,_|_],Cashier,Cashier_Id)       and
       a(person,Person,Person_Id)                             and  
       a(join,from is Person_Id and to is Cashier_Id,Join) 
then   wlist(['-----------------------------------------------------------'
             ,'Fire the cashier because of too many warning.'
             ,'The person is:'
             ,Person
             ,'The cashier is:'
             ,Cashier
             ,'-----------------------------------------------------------']) and
       -- [Cashier,Person,Join].

 
rule   cashier_retire_because_of_age_5 
if     a(person,age > 65,Person,Person_Id)                and
       a(cashier,Cashier,Cashier_Id)                      and
       a(join,from is Person_Id and to is Cashier_Id,Join)
then   wlist(['--------------------------------------------------'
             ,'A cashier retire because of the age .'
             ,'The person is:'
             ,Person
             ,'The cashier is:'
             ,Cashier
             ,'------------------------------------------------']) and  
       -- [Cashier,Person,Join].


rule   item_low_quantity_warning_6
if     a(item,owQuantityWarning = f,Item)                     and  
       comp(warningQuantity > quantity,Item,Item)         
then   wlist(['-------------------------------------------------'
             ,'The item quantity is very low'
             ,'The item is:'])                                and
       commit( lowQuantityWarning is t ,Item).

rule discount_check_7
if      a(saleLineItem,saleStatus=t and 
           discountStatus = f ,SaleLineItem,SaleLineItem_Id)  and
        a(item,Item,Item_Id)                                  and
        a(join,from is Item_Id and to is SaleLineItem_Id,_,_) and
        comp(quantity > discountQuantity,SaleLineItem,Item)
then   wlist(['----------------------------------------------'
              ,'The sale sale quantity is bigger than '
              ,'Please use the discount price'
              ,'The item is:'
              ,Item
              ,'-------------------------------------------------']) and
        commit(discountStatus is t , SaleLineItem ). 

rule   check_sale_8
if     a(sale,Sale)                                           and
       not o(itemIdList = [_|_] ,Sale)     
then   -- Sale .

rule   check_sale_9
if     a(sale,Sale)                                           and
       not o(quantityList = [_|_] ,Sale)  
then   -- Sale .

rule   check_sale_10
if     a(sale,Sale)                                           and
       not o(quantityList equal itemIdList,Sale)     
then   -- Sale.

% ZZ: look for other check rules
% ZZ: make sure that the step is checkSale is asserted

% ZZ: seperate checking rules from processing rules
% ZZ : checking rules should have no step statement (fire whenever
%      soemthing mucks up)
rule check_sale_11
if   a(sale,Sale)                          and
     o(itemIdList = [_|_] ,Sale)           and
     o(quantityList equal itemIdList,Sale)   and 
     o(checkStatus = f ,Sale)   
then 
     commit(checkStatus is t,Sale).



rule    createSaleLineItem_12
if	a(sale, checkStatus = t    and
                quantityList = QL  and
                itemIdList  = IL,_,Sale_Id)      and
	pairs(QL,IL,Quantity,ItemId)            and
	not a(saleLineItem, saleId = Sale_Id and
            quantity = Quantity and itemId = ItemId,_,_)
        
then	new(saleLineItem,quantity is Quantity   and 
                         saleId is Sale_Id      and
                         itemId is ItemId,
            SaleLineItem_Id,SaleLineItem)       and
	++ SaleLineItem                                          and
        wlist([' --------------------------------------------'
              ,SaleLineItem 
              ,Sale_Id
              ,'--------------------------------------------'])  and
        new(join,from is Sale_Id and to is SaleLineItem_Id,_,Join) and
        ++ Join .


rule check_the_saleLineItem_13
if      a(item,Item,Item_Id)                          and
        a(saleLineItem,SaleLineItem,SaleLineItem_Id)  and
        o(saleStatus = f,SaleLineItem)                and
        a(sale,_,Sale_Id)                             and
        a(join,from = Sale_Id and to = SaleLineItem_Id,_,_) and
        comp(itemId == itemId ,SaleLineItem,Item)     and
        comp(quantity =< quantity,SaleLineItem,Item)        
then    o(quantity sub quantity, Item,SaleLineItem,NewItem)  and
        o(saleStatus is t,SaleLineItem,NewSaleLineItem)      and  
        -- [Item,SaleLineItem]                               and
        ++ [NewSaleLineItem,NewItem]                         and
        wlist([' --------------------------------------------'
               ,NewSaleLineItem 
               ,'--------------------------------------------'])   and
        new(join,from is Item_Id and to is SaleLineItem_Id,_,Join) and
        ++ Join.

rule check_saleLineItem_14
if      a(item,Item)                                                and
        a(sale,_,Sale_Id)                                           and  
        a(saleLineItem,saleStatus = f,SaleLineItem,SaleLineItem_Id) and    
        a(join,from = Sale_Id and to = SaleLineItem_Id,Join,_)      and 
        comp(itemId == itemId ,SaleLineItem,Item)                   and
        comp(quantity > quantity,SaleLineItem,Item)            
then   wlist([' --------------------------------------------'
              ,'Can not make the sale because of' 
              ,'not enough quantity '
              ,'The item is:'
              , Item
              ,'--------------------------------------------']) and
       commit(saleStatus is impossible,SaleLineItem)            and
       -- Join.


rule  statistic_the_daily_sale_record_15
if     a(saleLineItem, analystSataus = 0,SaleLineItem,SaleLineItem_Id) and 
       a(itemDailySaleRecord,ItemDailySaleRecord)        and
       a(sale,Sale,Sale_Id)                              and
       comp(itemId == itemId,SaleLineItem,ItemDailySaleRecord)   and
       a(join,from = Sale_Id and to = SaleLineItem_Id,_Join,_)   and
       comp(recordId == time,ItemDailySaleRecord,Sale)
then
       o(quantity add quantity
       ,ItemDailySaleRecord, SaleLineItem 
       ,NewItemDailySaleRecord)                          and
       -- ItemDailySaleRecord                            and
       ++ NewItemDailySaleRecord                         and
       commit( analystSataus is 1 ,SaleLineItem).  

rule   initiate_DSS
if     the step is initDSS                  and
       a(itemDailySaleRecordList,RL)        and
       a(itemDailySaleRecord,SR)            and
       comp(itemId == itemId,RL,SR)         and
       not o(SR in recordList,RL) 
then   commit(recordList << SR on recordId,RL).

rule  do_DSS
if    the step is initDSS
then  -- the step is initDSS                and
      ++ the step is doDSS.

rule  analyst_the_sale_record_list_16
if    the step is doDSS and
      a(itemDailySaleRecordList,recordList = [H|T],X,_)
then 
      commit(begin is 1,X)                  and
 %XXXXX
      wlist([H|T]).
      
rule xxx
if	the step is doDSS and
	a(itemDailySaleRecordList,recordList = [H|T],_,_) and
	oneTwo([H|T],One,Two) and
	o(recordId=Time1,quantity=Quantity1,One) and
	o(recordId=Time2,quantity=Quantity2,Two)
then	mb(Time1,Quantity1,Time2,Quantity2,M,B) and
	new(lineSegment,.....). % XXX

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                      main                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
connie(What):-
        clear,
        What,
        fchain,  
        wln('finish test'),
        show.
              
hireCashier :-
        aPerson(_Tim,tim,77,here,1234),
        aPerson(_Zeng,zeng,24,here,1234),
        aPerson(_Pan,pan,14,here,1234).
       

checkCashier:-
        aCashier(_Person1,_Cashier1, ming,25,concord ,97434606,555,abc,1,session,[one,two,three,four]),
        aCashier(_Person2,_Cashier2,dong,85,concord ,97434606,555,abc,1,session,[one]).

                 
checkItem:-
        aItem(_Item1 ,416 ,400,'photos of clinton',100,150), 
        aItem(_Item2 ,436 ,300,'photos of Tim',100,50), 
        aItem(_Item3 ,466 ,200,'photos of abc',100,50),
        aItem(_Item4 ,456 ,100000,'photos of efg',100,50).
makeSale :-
        aSale(_,[416,436,466],[100,21,22]),
        aSale(_,[456,436,466],[100,21,22]),
        aSale(_,[456,436,466],[100,21,22]),
        aSale(_,[456,436,466],[100,21,22]).  
statistic :-
        aItemDailySaleRecord(_,416),
        aItemDailySaleRecord(_,436),
        aItemDailySaleRecord(_,456),
        ++ itemDailySaleRecord(1,  19980210,416, 24, 0),
        ++ itemDailySaleRecord(2,  19980211,416, 24, 0),
        ++ itemDailySaleRecord(3,  19980212,416, 24, 0),
        ++ itemDailySaleRecord(4,  19980310,456, 200, 0),
        ++ itemDailySaleRecord(5,  19980210,456, 200, 0), 
        ++ itemDailySaleRecord(6,  19980211,456, 200, 0),  
        ++ itemDailySaleRecord(7,  19980217,456, 200, 0),
        ++ itemDailySaleRecord(8,  19980213,456, 200, 0),
        ++ itemDailySaleRecord(9,  19980214,456, 200, 0),
        ++ itemDailySaleRecord(10, 19980215,456, 200, 0),
        aItemDailySaleRecordList(_,416),
        aItemDailySaleRecordList(_,436),
        aItemDailySaleRecordList(_,456).

main:-
      clearEnt,
      connie( hireCashier and checkItem and  makeSale ),
      connie( ++ the step is initDSS and statistic).
   
