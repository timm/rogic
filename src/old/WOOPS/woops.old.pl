:- op(850, xfy,<>).
:- op(100,xfx, :).
:- op(1, xfx, .. ).

term_expansion(X <> Y,Items) :-
	diamond2List(X <> Y,Items).

/*
x 
<>isa <>[meta,builtIn] 
<>has<>[1-many : string]
<>uses<>[2..3 - 4..5 : posInt]
<> with <>[name=1: string,age=23:posInt],Z).

==>
with(object177, '#id', object177, atom), 
with(object177, '#class', x, atom), 
relationship(object177, has, has, 1, 1, many, many, object159), 
relationship(object177, uses, uses, 2, 3, 4, 5, object163), 
isa(object177, meta), isa(object177, builtIn), 
with(object177, name, string, 1), 
with(object177, age, posInt, 23)] 
*/



diamond2List(Class <> Meta,[with(Object,'#id',Object,atom)
			   ,with(Object,'#class',Class,atom)
                           |Items]) :-
	gensym(object,Object),
	diamondDetails(Object,Meta,Items).

diamondDetails(Object,Meta,Items) :-
	bagof(Item,Object^Meta^meta2List(Object,Meta,Item),Items),!.
diamondDetails(_,_,[]).

meta2List(Object,Metas,Item) :-
	metaSlot(Metas,Meta,Data),
	member(Datum,Data),
	metaSlotItem(Meta,Datum,Object,Item).

metaSlot(Meta <> Data <> _, Meta, Data).
metaSlot(_ <> _ <> Rest, Meta,Data) :- 	metaSlot(Rest, Meta,Data).
metaSlot(Meta <> Data,Meta,Data)    :- \+ Data = (_ <> _).

metaSlotItem(X,_,Object,error(Object,Error)) :-
	goodMetaSlotNames(Names),
	\+ member(X,Names),
	sformat(Error,'~w- not one of ~w',[X,Names]).

metaSlotItem(isa,Parent,Object,Out) :-
	member(Parent,[builtIn,meta])
	->	Out=isa(Object,Parent)
	;	(class2Id(Parent,Object1)
		->	Out=isa(Object,Object1)
		;	sformat(Error
				,'can''t make a child of unknown parent ~w'
				,Parent),
			Out=error(Object,Error)).

metaSlotItem(with,With,Object,with(Object,Name,Type,Default)) :-
	attributeTypeDefault(With,Name,Type,Default).

metaSlotItem(does, X : Y, Object,does(Object,Name,Y,Args)) :- !,
	X =.. [Name|Args0],
	maplist(argType,Args0,Args).
metaSlotItem(does,X , Object,does(Object,Name,any,Args)) :- 
	X =.. [Name|Args0],
	maplist(argType,Args0,Args).
	
metaSlotItem(R,Here - There : Class1, 
	Object0, 
	Out) :- 
	member(R,[uses,has]),!,
	(class2Id(Class1,Object1)
	->	minMaxMult(Here,MinFrom,MaxFrom),
		minMaxMult(There,MinTo,MaxTo),
		Out= relationship(Object0,R,R,MinFrom,MaxFrom,
                                            MinTo,MaxTo,Object1)
	 ;      Out= warning(Object0,Error),
		sformat(Error
			 ,'can''t make a relationship to unknown class ~w'
		   ,Class1)). % mannie: this is a bug
			
metaSlotItem(R,There : Class1, Object0, Item) :- 
	member(R,[uses,has]),
	metaSlotItem(R,1-There:Class1,Object0,Item).

argType(Name : Type,arg(Name,Type)) :- !.
argType(Type,arg(_,Type)).

attributeTypeDefault(Name = Default : Type,Name,Type,Default) :- !.
attributeTypeDefault(Name           : Type,Name,Type,_) :- !.
attributeTypeDefault(Name = Default       ,Name,any,Default) :- !.
attributeTypeDefault(Name                 ,Name,any,_      ).

minMaxMult(X .. Y,X,Y) :- !.
minMaxMult(X ,X,X) :- !.

goodMetaSlotNames([isa, with, does,uses, has]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% basic data types for woops

wme(view(id,stakeHolder)).
wme(with(object,name,returnType,default)).
wme(does(object,name,returnType,[arg(name,inputType)|_])).
wme(relationship(object1,name,type,minFrom,maxFrom,minTo,maxTo,object2)). % type is has or uses
wme(isa(object1,object2)).
wme(error(object,string)).
wme(warning(object,string)).

setup :- wme(X), functor(X,F,A), (multifile F/A), (discontiguous F/A), (dynamic F/A), fail.
setup.

:- setup.

% feature extractors for woops data

class2Id(Class,Id) :- 	with(Id,'#class',Class,_).
id2Class(Id,Class) :- 	with(Id,'#class',Class,_).

primShow :-
	wme(X),
	functor(X,F,A),
	listing(F/A),
	fail.
primShow.

show :-
	setof(Class,Id^class2Id(Class,Id),Classes),
	member(Class,Classes),
	show(Class),
	fail.
show.

show(This) :- 
	nl,
	class2Id(This,Id),
	print(This),nl,
	wme(X),
	functor(X,F,A),
	functor(Find,F,A),
	arg(1,Find,Id),
	Find,
	print(Find), nl,
	fail.
show(_).

% basic types

any 	 <>  isa <>[builtIn]. %attribute / methods return types default to any
			      % default parents are any
meta	 <>  isa <>[builtIn]. % documents internal data structure of woops.
abstract <>  isa <>[builtIn]. %denotes abstract classes.

view	 <> with <>[author: string
                   ,name  : string].

boolean  <>  isa <>[builtIn].
string 	 <>  isa <>[builtIn].
atom 	 <>  isa <>[builtIn].
number 	 <>  isa <>[builtIn].
integer  <>  isa <>[number].
posInt 	 <>  isa <>[integer].
set 	 <>  isa <>[builtIn].

view     <>  isa <>[meta] <> with <>[id,stakeHolder].

feature  <>  isa <>[meta,abstract]    <> with <>[object,name,returnType].
with     <>  isa <>[feature] <> with <>[default].
does     <>  isa <>[feature] <> uses <>[0 - many : arg].

arg      <>  isa <>[meta] <> with <>[name: string, inputType: any].

relationship 
<>  isa <>[meta,abstract] 
<> with <>[object1,name,minFrom,maxFrom,minTo,maxTo,object2].

uses <> isa  <>[relationship].
has  <> isa  <>[relationship].
isa  <> isa  <>[relationship] 
     <> with <>[name='isa',minFrom=1,maxFrom=1,minTo=1,maxTo=1].

