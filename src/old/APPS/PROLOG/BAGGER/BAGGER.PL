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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rule	b1
if   	the step is check_order 		and
	there isa item(potatoChips) 		and
	not (there isa item(X) and
	     X has type = bottle)
then 	
	++ there isa item(pepsi).           


rule	b2
if     	OLD <-- the step is check_order
then	
	-- OLD					and
	++ the step is bag_large_items.  

rule	b3
if	the step is bag_large_items 		and
	there isa item(X) 		and 
	X has size = large 			and
	ITEM <-- there isa item(Y)		 	and
	Y has type = bottle with size = large 	and
	BAG <-- bag(ITEMS) 			and                
	number(ITEMS) of size/large < 6
then				
	-- ITEM					and
	-- BAG					and
	++ bag([ Y | ITEMS ]).

rule b4
if	the step is bag_large_items 		and
	ITEM <-- there isa item(X)	 	and  
        X has size = large			and
	BAG <-- bag(ITEMS) 			and                
	number(ITEMS) of size/large < 6
then				
	-- ITEM					and
	-- BAG					and
	++ bag([ X | ITEMS ]).

rule b5
if	the step is bag_large_items		and  
	there isa item(X)		 	and  
        X has size = large		
then
	newBag.
                                                          
rule	b6
if     	OLD <-- the step is bag_large_items
then	
	-- OLD					and
	++ the step is bag_medium_items.

rule b7a
if	the step is bag_medium_items		and
	ITEM <-- there isa item(X)		and    
	X has size = medium			and
	BAG <-- bag([])		and
	X has frozen = y			
then	-- ITEM					and
	-- BAG					and
	++ bag([insulated(X)]).         

rule b7b
if	the step is bag_medium_items		and
	ITEM <-- there isa item(X)		and    
	X has size = medium			and
	BAG <-- bag(ITEMS)			and
	ITEMS includes ANOTHER_ITEM		and
	ANOTHER_ITEM has size = medium		and
	not fullBag(ITEMS)			and
	X has frozen = y			
then	-- ITEM					and
	-- BAG					and
	++ bag([insulated(X)|ITEMS]).

rule b8a
if	the step is bag_medium_items		and
	ITEM <-- there isa item(X)		and
	X has size = medium			and    
	BAG <-- bag([])	
then	-- ITEM 				and
	-- BAG					and
	++ bag([X])				and
	abort.

rule b8b
if	the step is bag_medium_items		and
	ITEM <-- there isa item(X)		and
	X has size = medium			and    
	BAG <-- bag(ITEMS)			and
	ITEMS includes ANOTHER_ITEM		and
	ANOTHER_ITEM has size = medium		and 
	not fullBag(ITEMS)
then	-- ITEM 				and
	-- BAG					and
	++ bag([X | ITEMS ])			and
	abort.


rule b9
if	the step is bag_medium_items		and
	there isa item(ITEM)			and
	ITEM has size = medium
then	newBag.
                                             
rule b10      
if	OLD <-- the step is bag_medium_items
then	-- OLD					and
	++ the step is bag_small_items.  

rule b11
if	the step is bag_small_items		and
	ITEM <-- there isa item(X)		and
	X has size = small			and
	BAG <-- bag(ITEMS)			and
	not fullBag(ITEMS)			and
	not (ITEMS includes ITEM1 and
	    ITEM1 has type = bottle)               
then	-- BAG					and
	-- ITEM					and
	++ bag([X | ITEMS ]).

rule b12
if	the step is bag_small_items		and
	ITEM <-- there isa item(X)		and    
	X has size = small			and
	BAG <-- bag(ITEMS)			and
	not fullBag(ITEMS)			
then	-- ITEM					and
	-- BAG					and
	++ bag([ X | ITEMS ] ).

rule b13
if	the step is bag_small_items		and
	there isa item(_)		
then	newBag.

rule b14
if	OLD <-- the step is bag_small_items
then	-- OLD.

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
                              
wme(the _ is _).
wme(there isa item(_)).
wme(bag(_)).

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
% prints out trace information if the 'watchOn' fact is
% asserted. In particular, the predicate lists all the 
% current bags, then prints the labels of all the rules 
% in the conflict set.
% Assumes that RULES is a list of items of the form
% rule X if Y then Z
watch(RULES) :-  
	watchOn,
	!,
	listing(bag),    
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
	print(RULES),nl,
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
% bagger item knowledge
% auther: tjm, april '92
        
:- dynamic bag/1.
            
% grocery(name,		
%	container type, -- one of [bag(plastic), jar, box(cardboard), 
%				   bottle(cardboard), bottle]
%	size, 	 	-- one of [small, medium, large]
%	frozen?       	-- one of [y,n]
%	)                                  

grocery(	bread,		bag(plastic),		medium,		n).
grocery(	glop,		jar,			small,		n).
grocery(	granola,	box(cardboard),		large,		n).
grocery(	iceCream,	carton(cardboard), 	medium, 	y).
grocery(	pepsi,		bottle,			large,		n).
grocery(	potatoChips,	bag(plastic),		medium,		n).		


% field/4
% selector library for grocerys.  Used by X has Y.

%ATTRIBUTES
field(name,	grocery,	grocery(X,_,_,_),	X).  
field(type,	grocery,	grocery(_,X,_,_),	X).  
field(size,	grocery,	grocery(_,_,X,_),	X).  
field(frozen,	grocery,	grocery(_,_,_,X),	X).  
%METHODS
field(junk,     grocery,        _,                      X) :-
	field(type,grocery,G,carton(_)),
	field(name,grocery,G,X),
	print(name(X)),nl,
	print(goal(G)),nl,
	G.
	 

% newBag/0
% creates a new bag.
newBag :-                                         
	asserta(bag([])). 
                           
% fullBag/1
% definition of a full bag.
fullBag(ITEMS) :-
	volumeOfBag(ITEMS,V1),
	bagSize(V2),
	V1 >= V2.

volumeOfBag(ITEMS, VOLUME) :-
	my_bagof(V, (member(X,ITEMS),
		  volumeOfItem(X,V)),
	     L),
	sum(L,VOLUME).   

volumeOfItem(X,VOLUME) :-
	item(X,ITEM),  
	ITEM has size = SIZE,
	volume(SIZE,VOLUME). 

volume(large,3).
volume(medium,2).
volume(small,1).

bagSize(20).
 
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

:- write('Bagger loaded. For a demo, enter the goal :- test'),nl.
