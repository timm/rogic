:- style_check(-atom).
:- op( 1,xfx,:).

% slot(Class,SlotName).
%            SlotName one of ... and '$parent'
% facet(Class,SlotName,FacetName,Facet).
%                      FacetName one of value,rule

:- index(slot(1,1)).
:- index(facet(1,1,1,0)).

:- discontiguous class/1, slot/2, facet/4.

term_expansion(X is Y + Z,Out) :- !, defThing(class,X,Y,Z,Out).
term_expansion(X is Y    ,Out) :- term_expansion(X is Y + [], Out).
term_expansion(X =  Y + Z,Out) :- !, defThing(instance,X,Y,Z,Out).
term_expansion(X =  Y    ,Out) :- term_expansion(X = Y + [], Out).
term_expansion(Y + Z     ,Out) :- mySym(X), term_expansion(X=Y+Z,Out).

defThing(Type,Thing,Parent,Details, Slots) :-
	(Type=class
	-> Up='$isa'
	;  Up='$ako'
        ),
	defSlots(Details,Thing,[],Slots0),
	defSlot(Up=Parent,Thing,Slots0,Slots).

defSlots([],_,Slots,Slots).
defSlots([H|T],Thing) --> 
	defSlot(H,Thing), !, 
	defSlots(T,Thing).

defSlot(Name=Value:Rule,Thing) -->
	defSlot1(Thing,Name),
	defFacet(Thing,Name,rule,Rule),
	defFacet(Thing,Name,value,Value).
defSlot(Name=Value,Thing) --> 
	defSlot(Name=Value:_,Thing).
defSlot(Name:Rule,Thing) --> 
	defSlot(Name=_:Rule,Thing).
defSlot(Name,Thing) --> 	
	defSlot(Name=_:_,Thing).

defSlot1(Thing,  Name, Slots, [slot(Thing,Name)|Slots]).
defFacet(Thing, Name, Facet, Value, Slots0, Slots) :-
	var(Value)
	-> Slots0=Slots
	;  Slots=[facet(Thing,Name,Facet,Value) | Slots0].

% meta model

class(thing).
class(X) :- facet(X,'$isa',_,_).

instance(X) :- facet(X,'$ako',_,_).

isa(X,X).
isa(X,Y) :- down(X,Y).
	
down(X,Y) :- up(Y,X).

up(X,Y) :- member(Up,['$ako','$isa']),
	   facet(X,Up,value,Z),  
           (Y=Z
	      ; up(Z,Y)
	      ).
	
grab(I,S,V) :-	value(I,S,V),!.
grab(I,S,V) :-  nl,print(cannot(grab(I,S,V))), nl, abort.

value0(Instance,Slot,Value) :-
	facet(Instance,Slot,value,Value).

value(Instance,Slot,Value) :-
	facet(Instance,Slot,value,Value),!.
value(Class,Slot,Value) :-
	up(Class,Super),
	value(Super,Slot,Value).

writes(X) :- format('~s',[X]).


reports([]).
reports([File-Commands|Rest]) :-
	tell(File),
	reports1(Commands),
	told,
	reports(Rest).
reports1(Commands) :-
	member(C,Commands),
	ignore(C).

:- dynamic mySym_counter/1.

mySym(Y) :-
	(retract(mySym_counter(X))
	->	Y is X + 1
	;	Y = 1),
	assert(mySym_counter(Y)).
	
zapSym :- 
	ignore(retract(mySym_counter(_))),
	assert(mySym_counter(0)).

:- [db,report].

