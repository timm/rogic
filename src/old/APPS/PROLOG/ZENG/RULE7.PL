%------------------------------------------------------
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
:- op(910,fx,in).
:- op(900,xfx,to).
:- op(800,fx,--).
:- op(800,fx,++).
:- op(680,xfx,includes).
:- op(720,xfx,of).
:- op(720,fx,the).
:- op(710,xfy,with).
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
	wTerm(LABEL),
        talk(firing(LABEL)),
        ACTION.

:- dynamic watchOn/0.

talk(X) :- watchOn,!, print(X),nl.
talk(_). 

 
%------------------------------------------------------

sum([],0).
sum([H|T],OUT) :- sum(T,TEMP), OUT is TEMP + H. 

member(X,[X|_]).
member(X,[_|T]) :- member(X,T).  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% records.pl
%% Tim Menzies, 1998
%% 
%% The predicates in this file are listed dumbest to smartest.




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
o(X >= M,W0,W0)        :- touch(W0,X,Old,_,_),  Old >= M.
o(X >  M,W0,W0)        :- touch(W0,X,Old,_,_),  Old >  M.
o(X \= M,W0,W0)        :- touch(W0,X,Old,_,_),  Old \= M.
o(X <  M,W0,W0)        :- touch(W0,X,Old,_,_),  Old <  M.
o(X =< M,W0,W0)        :- touch(W0,X,Old,_,_),  Old =< M.


% rules for extending query language:
%       1)      functor of first argument MUST be unique

% head append to a list
o(X << Add0,W0,W) :- 
        asList(Add0,Add),
        touch(W0,X,L0,W,L),
        append(Add,L0,L).

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

demo(comp1,t) :-
        new(salelineitem,S0),
        o(quantity = 23,S0,S1),
        new(taxcategory,T0),
        o(rate = 12,T0,T1),
        comp1(quantity > rate,S1,T1).

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


%% demo of the accessors

entity(demo_o(name,age=0,shoes=[])).

demo(o,Y) :-
        new(demo_o,X),
        o(      [name=tim
                , age+4
                , shoes<<leather
                ]
                ,X
                ,Y).
        

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

entity(methodDemo(happy,age,name,dob,shoeSize,weigh)).

 methodDemo does init=Id <--
        flag(id,Id,Id+1),
        get_time(Time), 
        convert_time(Time,Y,Mn,D,_,_,_,_),
        o       id is Id and 
                dob is date(Y,Mn,D) and
                name= who('Menzies','Tim').

demo(method,Ready) :-
        new(methodDemo,Ready).

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
% define the class and its method.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%define the class supermarket   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
entity(supermarket(
       name=bigW)).

supermarket does init=Id <--
        flag(id,Id,Id+1),
        o id is Id.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%define the class register   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
entity(register(
       number)).

register does init=Id <--
        flag(id,Id,Id+1),
        o id is Id.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%define the class sale   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
entity(sale(
       time)).
  

sale  does init=Id <--
        flag(id,Id,Id+1),
        get_time(Now),
        o(time is Now),
        o id is Id.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%define the class salelineitem   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
entity(salelineitem(
       number,
       possible=t,
       quantity,
       taxstatus,
       discountStatus = f
       )).

salelineitem  does init=Id <--
        flag(id,Id,Id+1),
        o id is Id.

        

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%define the class session   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
entity(session(
       startTime,
       endTime)).

person does init=Id <--
        flag(id,Id,Id+1),
        o id is Id.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%define the class person   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
entity(person(
       name,
       age,
       address, 
       phoneNo, 
       hireStatus,
       cashierId )).

person does init=Id <--
        flag(id,Id,Id+1),
        o id is Id.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%define the class cashier
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
entity(cashier(
       number,
       password,
       authorizationLevel=0,
       currentSession,
       warning=[],
       personId)).

cashier does init=Id <--
        flag(id,Id,Id+1),
        o id is Id.


cashier does addWarning = New <--
        o       warning << New.

cashier does tooManyWarnings = t <--
        o       warning = [_,_,_|_].


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%define the class cashdrawer   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
entity(cashdrawer(
       operationState,
       position,
       balance,
       smallChange)).

cashdrawer does init=Id <--
        flag(id,Id,Id+1),
        o id is Id.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%define the class taxcategory   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
entity(taxcategory(
       category,
       rate,
       effectivedate)).

taxcategory does init=Id <--
        flag(id,Id,Id+1),
        o id is Id.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%define the join class
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
entity(join(from,to)).

join does init=Id  <--
       flag(is,Id,Id+1),
       o   id is Id.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%define the class warnings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
entity(warning(
       number, 
       discription )).
warning does init=Id  <--
       flag(is,Id,Id+1),
       o   id is Id.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%define the class item
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
entity(item(
       number,
       quantity,
       description,
       reorder = f,
       discountQuantity,
       warningQuantity,
       lowQuantityWarning = f)).
item   does init=Id <--
       flag(is,Id,Id+1),
       o id is Id.



a(Entity,Properties,E,Id) :-
        blank(Entity,E0),
        E0,
        arg(1,E0,Id),
	o(Properties,E0,E).
a(Entity,E,Id) :-
	a(Entity,[],E,Id).
    

rule 1 
if      a(person,P,_)                  and
        o(qhireStatus = undecided and age < 18,P)   
then    wlist(['----------------------------------------------------'
              ,'Can not hire the person because of age.The person is'
              ,P
              ,'----------------------------------------------------'
              ]) and
        -- P .               
        

rule 2
if      a(person,P,_)                 and
        o(hireStatus = undecided,P)   and
        o(age > 65,P)
then    wln('----------------------------------------------------') and
        wln('Can not hire the person because of age.The person is') and
        wln((P))                                                    and
        wln('----------------------------------------------------') and
        -- P .     
       
rule  3 
if      a(person, 
		age > 18 and 
		age < 65 and 
		hireStatus=undecided,
	     P, P_Id)
then    wln('---------------------------------------------') and
        wln(' Hire the person .The person is')               and
        wln((P))                                             and 
        wln('---------------------------------------------') and
        new(cashier,
                number is  0                 and
                password  is password        and 
                authorizationLevel is 0      and 
                currentSession is session    and
                warning is []                and
                personId is P_Id
               ,C_Id,C)                                       and
        o(cashierId is C_Id and hireStatus is hired , P,P1)   and
        -- P and
	++ [P1,C].                                                
                                                   

rule   fire2ManyWarnings(P,C)
if     a(cashier,C,C_Id)         and
       a(person,P,P_Id)          and  
       o(cashierId = C_Id,P)     and
       o(personId = P_Id,C)      and      
       o(warning= [_,_,_|_],C) 
then   %wln('-----------------------------------------------------------') and
       %wln('Fire the cashier because of too many warning.The person is')  and
       %wln(P)                  and
       %wln('The cashier is ')    and
       %wln(C)                  and
       %wln('-----------------------------------------------------------') and
       -- C                      and
       -- P.

 
 rule 5 
if     a(person,P,P_Id)          and
       a(cashier,C,C_Id)         and
       o(cashierId = C_Id,P)     and
       o(personId = P_Id,C)      and
       o(age > 65,P)
then   wln('--------------------------------------------------')  and
       wln('A cashier retire because of the age .The person is')  and
       wln((P))                  and 
       wln(' The Cashier is')                                             and
       wln((C))                  and
       wln('--------------------------------------------------')  and      
       -- C                      and
       -- P . 

rule 6
if     a(item,I,_)                      and                       
       o(lowQuantityWarning = f,I)      and     
       comp(warningQuantity > quantity,I,I)         
then   wln('-------------------------------------------------') and
       wln('The item quantity is very low')                     and
       wln('The item is')                                       and
       o( lowQuantityWarning is t ,I,I1 )                       and
       -- I                                                     and
       ++ I1                                                    and 
       wln((I1))                                                and
       wln('-------------------------------------------------').

rule 7
if      a(salelineitem,S,S_id)         and
        o(possible=t,S)                and
        a(item,I,I_id)                 and
        a(join,J,_)                    and
        o(to = I_id and from = S_id,J) and
        comp(quantity > quantity,S,I)
then    wln('-------------------------------------------------') and
        wln('Can not make the Sale because of not enough items') and
        wln('The item is')             and
        wln((I))                       and
        wln('-------------------------------------------------') and
        o(possible is n,S,NewS)        and
        o(reorder  is t,I,NewItem)     and
        -- [S,I]                       and
        ++ [NewS,NewItem].

rule 8
if      a(salelineitem,S,S_id)         and
        o(possible=t,S)                and
        a(item,I,I_id)                 and
        a(join,J,_)                    and
        o(to = I_id and from = S_id,J) and
        o(discountStatus = f ,S)       and
        comp(quantity > discountQuantity,S,I)
then    wln('-------------------------------------------------') and
        wln('The salelineitem sale quantity is bigger than '   ) and
        wln('Please use the discount price')                     and         
        wln('The item is')             and
        wln((I))                       and
        wln('-------------------------------------------------') and
        o(discountStatus is t,S ,NewS)                           and
        -- S                           and
        ++ NewS.
       

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
connie(What):-
        clear,
        What,
        fchain,  
        wln('finish test'),
        show.
              
hireCashier :-
        aPerson(Tim,tim,77,here,1234),
        aPerson(Zeng,zeng,24,here,1234),
        aPerson(Pan,pan,14,here,1234),
        ++ Pan,
        ++ Tim,
        ++ Zeng.

checkCashier:-
        aCashier(Ming,ming,25,concord ,97434606,555,abc,1,session,[one,two,three,four]),
        ++ Ming,
        aCashier(Dong,dong,85,concord ,97434606,555,abc,1,session,[one]),
        ++ Dong.
         
makeSale :-
        aSale(S),
        ++ S.
checkItem:-
        aItem(I1 ,_ ,'#436' ,10,'photos of clinton',100,150), 
        aItem(I2 ,_ ,'#436' ,100,'photos of Tim',100,50),
        ++ I1,
        ++ I2.
main:-
      clearEnt,
      connie(hireCashier and makeSale and checkItem and checkCashier).
%      connie(makeSale),
%      connie(checkItem), 
%      connie(checkCashier). 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


aPerson(P,Name,Age,Address,PhoneNo) :-
        new(person,P1),
        o(      name    is Name       and 
                age     is Age        and 
                address is Address    and 
                phoneNo is PhoneNo     and
                hireStatus  is undecided 
                ,P1,P).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

aItem(I,I_Id,Number,Quantity,Description,DiscountQuantity,WarningQuantity):-
        new(item,
                number is Number                     and
                quantity is Quantity                 and
                description is Description           and
                discountQuantity is DiscountQuantity and
                warningQuantity is WarningQuantity  
                ,I_Id,I).

      

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

aCashier([P1,C1],Name,Age,Address,PhoneNo,Number,Password,AuthorizationLevel,CurrentSession,
         Warning):-
        new(person,
                name is Name                 and 
                age is  Age                  and 
                address is Address           and 
                phoneNo is PhoneNo           and 
                hireStatus is  hired         and
                cashierId is 0              
               ,PId,P0),
         new(cashier,
                number is  Number            and
                password  is Password        and 
                authorizationLevel is AuthorizationLevel    and 
                currentSession is CurrentSession            and
                warning is Warning           and
                personId is PId
               ,CId,C1),
         o(cashierId is CId, P0,P1).
       
        
       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
aSale([Sale,Item1,Item2,SaleLine1,SaleLine2,
        Join1, Join2, Join3, Join4]) :-
        new(sale,[],SaleId,Sale),   
        aItem(Item1,ItemId1 ,'#43456' , 1000, 'photos of clinton' , 100,15),        
        aItem(Item2,ItemId2 ,'#47756' , 10000, 'photos of hilary' , 100,50), 
        new(salelineitem,
                number is '#43456'                      and
                quantity is 2000                        and 
                taxstatus is 'taxfree'
            ,SaleLineItemId1 
            ,SaleLine1),
        
        new(salelineitem,
                number is '#47756'                      and
                quantity is 10                          and 
                taxstatus is 'taxfree'
            ,SaleLineItemId2 
            ,SaleLine2),
        
        new(join, from is SaleId                        and
                  to   is SaleLineItemId1
            ,Join1),
        
        new(join, from is SaleId                        and 
                  to   is SaleLineItemId2
            ,Join2),
        new(join, from is SaleLineItemId1               and 
                  to   is ItemId1
            ,Join3),

        new(join, from is SaleLineItemId2               and 
                  to   is ItemId2
            ,Join4).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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







