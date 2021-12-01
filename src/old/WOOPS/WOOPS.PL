%%%%%%%%%%
% operators
:- op(850, xfy,<>).
:- op(100,xfx, :).
:- op(1, xfx, .. ).

%%%%%%%%%%
% macro to expand class definition

term_expansion(X <> Y,Items) :-
	diamond2List(X <> Y,Items).

/*
x 
<>isa <>[meta,builtIn] 
<>has<>[1-many : string]
<>uses<>[2..3 - 4..5 : posInt]
<> with <>[name=1: string,age=23:posInt].

==>

with(x, init, '#id', x, atom), 
with(x, init, '#class', x, atom), 
isa(x, init, meta), 
isa(x, init, builtIn), 
relationship(x, init, has, has, 1, 1, many, many, string), 
relationship(x, init, uses, uses, 2, 3, 4, 5, posInt), 
with(x, init, name, string, 1), 
with(x, init, age, posInt, 23)] 
*/

diamond2List(Class <> Meta,[with(Class,View,'#id',Class,atom)
			   ,with(Class,View,'#class',Class,atom)
                           |Items]) :-
	currentView(View),
	diamondDetails(Class,View,Meta,Items).

diamondDetails(Class,View,Meta,Items) :-
	bagof(Item,Class^Meta^View^meta2List(Class,View,Meta,Item),Items),!.
diamondDetails(_,_,_,[]).

meta2List(Class,View,Metas,Item) :-
	metaSlot(Metas,Meta,Data),
	member(Datum,Data),
	metaSlotItem(Meta,Datum,View,Class,Item).

metaSlot(Meta <> Data <> _, Meta, Data).
metaSlot(_ <> _ <> Rest, Meta,Data) :- 	metaSlot(Rest, Meta,Data).
metaSlot(Meta <> Data,Meta,Data)    :- \+ Data = (_ <> _).

metaSlotItem(X,_,View,Class,error(Class,View,Error)) :-
	goodMetaSlotNames(Names),
	\+ member(X,Names),
	sformat(Error,'~w- not one of ~w',[X,Names]).

metaSlotItem(isa,Parent,View,Class,isa(Class,View,Parent)).

metaSlotItem(with,With,View,Class,with(Class,View,Name,Type,Default)) :-
	attributeTypeDefault(With,Name,Type,Default).

metaSlotItem(does, X : Y, View,Class,does(Class,View,Name,Y,Args)) :- !,
	X =.. [Name|Args0],
	maplist(argType,Args0,Args).
metaSlotItem(does,X , View,Class,does(Class,View,Name,any,Args)) :- 
	X =.. [Name|Args0],
	maplist(argType,Args0,Args).
	
metaSlotItem(R,Here - There : Class1, 
	View,Class,
	relationship(Class,View,R,R,MinFrom,MaxFrom,
                                 MinTo,MaxTo,Class1)) :- 
	member(R,[uses,has]),!,
	minMaxMult(Here,MinFrom,MaxFrom),
	minMaxMult(There,MinTo,MaxTo).
			
metaSlotItem(R,There : Class1, View,Class, Item) :- 
	member(R,[uses,has]),
	metaSlotItem(R,1-There:Class1,View,Class,Item).

argType(Name : Type,arg(Name,Type)) :- !.
argType(Type,arg(_,Type)).

attributeTypeDefault(Name = Default : Type,Name,Type,Default) :- !.
attributeTypeDefault(Name           : Type,Name,Type,_) :- !.
attributeTypeDefault(Name = Default       ,Name,any,Default) :- !.
attributeTypeDefault(Name                 ,Name,any,_      ).

minMaxMult(X .. Y,X,Y) :- !.
minMaxMult(X ,X,X) :- !.

goodMetaSlotNames([isa, with, does,uses, has]).

%%%%%%%%%%
% basic data types for woops

wme(view(view,stakeHolder)).
wme(with(object,view,name,returnType,default)).
wme(does(object,view,name,returnType,[arg(name,inputType)|_])).
wme(relationship(object1,view,name,type
		,minFrom,maxFrom,minTo,maxTo,object2)). % type is has or uses
wme(isa(object1,view,object2)).
wme(error(object,view,string)).
wme(warning(object,view,string)).

setup :- wme(X), functor(X,F,A), (multifile F/A), (discontiguous F/A), (dynamic F/A), fail.
setup.

:- setup.

%%%%%%%%%%
% feature extractors for woops data

currentView(View) :- view(View,_),!.
class2Id(Class,Id) :- 	currentView(V),with(Id,V,'#class',Class,_).
id2Class(Id,Class) :- 	currentView(V),with(Id,V,'#class',Class,_).

kid(Parent,Child) :-
	currentView(V),
	isa(Child,V,Parent).

kids(Parent,Kids) :- setof(Kid,Parent^kid(Parent,Kid),Kids).
	
newView(X,Y) :- retractall(view(_,_)), assert(view(X,Y)).

%%%%%%%%%%
% basic woops  types in woops syntax

:- newView(view0,woops).

any 	 
<>  isa <>[builtIn]
<>  with <>[view: atom].      %attribute / methods return types default to any
			      % default parents are any
meta	 <>  isa <>[builtIn]. % documents internal data structure of woops.
abstract <>  isa <>[builtIn]. %denotes abstract classes.

view	
<>	isa   <>[any]
<> with <>[author: string
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
<>  isa <>[meta,abstract,any] 
<> with <>[object1,name,minFrom,maxFrom,minTo,maxTo,object2].

uses <> isa  <>[relationship].
has  <> isa  <>[relationship].
isa  <> isa  <>[relationship] 
     <> with <>[name='isa',minFrom=1,maxFrom=1,minTo=1,maxTo=1].


%%%%%%%%%%
% utility for simplifying reaching inside a term

term_expansion(struct(Term),All) :- wmes(Term,All).

struct0(X,W) :- struct0(X,W,_).
struct0([],W, W).
struct0([H|T],W0,W) :- struct0(H,W0,W1), struct0(T,W1,W).
struct0(X=Old,W, W) :- struct0(X,Old,Old,W,W).
struct0(X is Old/New, W0,W) :- struct0(X,Old,New,W0,W).
struct0(X + M,W0,W) :- 
	struct0(X,N0,N,W0,W),
	N is N0 + M.
struct0(X << [H|T],W0,W) :- !,
	struct0(X,L0,L,W0,W),
	append([H|T],L0,L).
struct0(X << Item,W0,W) :- 
	struct0(X,L,[Item|L],W0,W).

pp0(X) :-
	struct0(Field,Value,_,X,_), 
	format('~n~a ~`.t~20| ~a',[Field,Value]),
	fail.
pp0(_).

wmes(Term,All) :- bagof(One,Term^(wmes1(Term,One)),All).

:- discontiguous pp/1.

wmes1(Term,Out) :-
	Term =.. [S|Args0],
	maplist(secondItem,Args0,Inits),
	New =.. [S|Inits],
	Out =.. [S,new(New)].
wmes1(Term,One) :-
	functor(Term,S,_),
	expandStruct0(S,One).
wmes1(Term,One) :-
	prettyPrint0(Term,One).
wmes1(Term,One) :-
	Term =.. [S|Args0],
	maplist(firstItem,Args0,Firsts),
	length(Firsts,Arity),
	functor(Term0,S,Arity),
	nth1(Pos,Firsts,Arg),
        copyArgs(Term0,Pos,Value0,Value,Term1),
	One =.. [S,Arg,Value0,Value,Term0,Term1].

copyArgs(T0,Except,Old,New,T) :-
        T0 =.. [Functor|Args0],
        copyArgs1(Args0,1,Except,Old,New,Args),
        T  =.. [Functor|Args].

copyArgs1([],_,_,_,_,[]).
copyArgs1([Old|Args],Pos,Pos,Old,New,[New|Args]) :- !.
copyArgs1([Arg|Args0],Pos0,Except,Old,New,[Arg|Args]) :-
        Pos is Pos0+1,
        copyArgs1(Args0,Pos,Except,Old,New,Args).


%%%%%%%%
% macros in prolog
% simple utility for changing some functors in a clause

subF(In,L,Out) :- once(subF1(In,L,Out)).

subF1([],_,[]).
subF1([H0|T0],L,[H|T])     :- subF(H0,L,H), subF(T0,L,T).
subF1((A0:-B0),L,(A :- B)) :- subF([A0,B0],L,[A,B]).
subF1((A0,B0), L,(A,B))    :- subF([A0,B0],L,[A,B]).
subF1((A0;B0), L,(A;B))    :- subF([A0,B0],L,[A,B]).
subF1((A0->B0),L,(A->B))   :- subF([A0,B0],L,[A,B]).
subF1(In,L,Out)            :- 
	In  =.. [Old|T], member(Old/New,L), Out =.. [New|T].
subF1(Out,_,Out).

% e.g.      
expandStruct0(S,One) :-
	member(Head,[struct0(_,_,_),struct0(_,_)]),
	clause(Head,Body),
	subF((Head :- Body),[struct0/S],One).

prettyPrint0(Term,One) :-
	functor(Term,Functor,Arity),
	functor(Blank,Functor,Arity),
	clause(pp0(Blank),Body),
	subF((pp0(Blank) :- Body),[struct0/Functor,pp0/pp],One).

%%%%%%%%%%%%%%%
% low level utils

asList(X,X)   :- is_list(X),!.
asList(X,[X]).

asNumber(X,X) :- number(X),!.
asNumber(_,0).

firstItem(X,Y) :- arg(1,X,Y),!.
firstItem(X,X).

secondItem(X,Y) :- arg(2,X,Y),!.
secondItem(_,_).

%%%%%%%%%%
% display stuff

primShow :-
	wme(X),
	functor(X,F,A),
	listing(F/A),
	fail.
primShow.

show :-
	currentView(V),
	setof(Class,Id^class2Id(Class,Id),Classes),
	member(Class,Classes),
	show(Class,V),
	fail.
show.

show(This) :-	currentView(V), show(This,V).
show(This,View) :- 
	nl,
	class2Id(This,Id),
	print(This),nl,
	wme(X),
	functor(X,F,A),
	functor(Find,F,A),
	arg(1,Find,Id),
	arg(2,Find,View),
	Find,
	print(Find), nl,
	fail.
show(_,_).

%%%%%%%%%%
% checking stuff
% e.g. referencing to an non-object

% todo

%%%%%%%%%%
% woops mark-up generation stuff

roots(Roots) :- setof(Root,root(Root),Roots).

root(Class) :-
	currentView(V),
	isa(_,V,Class),
	\+ isa(Class,V,_).
struct(chWme(todo=[],depth=0,n=1,seen=[],h=[])).

classHiearchy(H) :- 
	roots(R), 
	chWme(new(Wme0)),
	classHierarchy(R,Wme0,Wme),
	chWme(h=H,Wme).

classHierarchy([],W,W).
classHierarchy([Class|Classes],W0,W) :-
	classHierarchy1(Class,W0,W1),
	chWme(toDo,ToDo,[],W1,W2),
	append(Classes,ToDo,Next),
	classHierarchy(Next,W2,W).

%classHierarchy1(Class,W0,W) :- true.

struct(netSweepWme(todo=[],depth=0,n=1,seen=[],net=[])).

term_expansion(defSweep(Subs),All) :-
	bagof(One,Subs^expandNewSweep(Subs,One),All).

expandNewSweep(Subs,One) :-
	member(Head,[netSweep(_,_),netSweep(_,_,_)]),
	clause(Head,Body),
	subF((Head :- Body),[netSweep/xxx|Subs],One).

% sub netSweep, netRoots
netSweep(Net) :-
	netSweepWme(new(Wme0)),
	netRoots(Roots),
	netSweep(Roots,Wme0,Wme),
	netSweepWme(net=Net,Wme).

netSweep([],Out,Out).


