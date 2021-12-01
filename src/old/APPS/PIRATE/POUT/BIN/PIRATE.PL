%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pirate.pl
%% Tim Menzies, 1998
%% 
%% The predicates in this file are listed dumbest to smartest.

%% pirate2 : some = 1 to many
%%           some shorthand for has :fred of &fred
%%           add parent pointers to hierarchy
%%           remove relationship pointers if they don't exist
%%	     build relationship groups

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%% some declarations

:- discontiguous demo/2.

 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% operators
:-	op(1200, xfx, <--),
	op(995,xfx,if),
	op(990,fx,o),
	op(970,xfy,with),
	op(960,xfy,be),
	op(960,xfy,or),
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
%%%% misc low-level stuff

%% demo stuff
demo(X) :- demo(X,_).
demos :- bagof(What,
			Return^Body^
				clause(demo(What,Return),Body),
		Whats),
	 nList(Whats).

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

% simple utility for changing some functors in a clause
% L is a list of symbol pairs "old"/"new". Terms with the functor
% "old" become terms with the functor "new".

subF(In,L,Out) :- subF1(In,L,Out),!.

subF1([],_,[]).
subF1([H0|T0],L,[H|T])     :- subF(H0,L,H), subF(T0,L,T).
subF1((A0:-B0),L,(A :- B)) :- subF([A0,B0],L,[A,B]).
subF1((A0,B0), L,(A,B))    :- subF([A0,B0],L,[A,B]).
subF1((A0;B0), L,(A;B))    :- subF([A0,B0],L,[A,B]).
subF1((A0->B0),L,(A->B))   :- subF([A0,B0],L,[A,B]).
subF1(In,L,Out)            :- In  =.. [Old|T], member(Old/New,L), 
                              Out =.. [New|T].
subF1(Out,_,Out).

% maths stuff


upTo(I,J)                :- upTo(I,J,_).
upTo(I0,J0,N)            :- I is I0,  J is J0,  between(I,J,N).

upToDo(J,Action)         :- upToDo(1,J,_,Action).
upToDo(J,Item,Action)    :- upToDo(1,J,Item,Action).
upToDo(I,J,Item,Action)  :- forall(upTo(I,J,Item), Action).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% buidling accessors into terms

%% macros for auto-generating the accessors
% neat thing about term_e pansion is that when the source
% file is reloaded, all the expanded terms are auto-retracted.

:- discontiguous isWme/1, touch/5, new/2, blank/2, wmes1/2, wmes1Zap/2.
:- dynamic isWme/1.

term_expansion(wme(Term),All) :- wmes(Term,All).

wmes(Term0,All) :-
	Term0 =.. [F|Args],
	Term  =.. [F,id|Args],
	wmesZap(F),
	bagof(One,Term^(wmes1(Term,One)),All). 

wmesZap(Functor) :- wmes1Zap(Functor,Zapper), Zapper, fail.
wmesZap(_).

wmes1(Term, (:- index(Blank)) ) :-
	functor(Term,F,A),
	functor(Blank,F,A),
	Blank =.. [F|Args],
	indexFirstNArgs(Args,4).
wmes1(Term,(:- dynamic F/A)) :- functor(Term,F,A).
wmes1(Term,(:- multifile F/A)) :- functor(Term,F,A).
wmes1(Term,(:- discontiguous F/A)) :- functor(Term,F,A).
wmes1(Term,(:- discontiguous F/5)) :- 
	functor(Term,F0,_), accessorName(F0,F).

wmes1(Term,isWme(X)) :- 
	functor(Term,F,A), 
	functor(X,F,A).
wmes1Zap(F,retractall(isWme(X))) :-
	isWme(X),
	functor(X,F,_).

wmes1(Term,(Head :- Body)) :-
	Term =.. [S|Args0],
	maplist(secondItem,Args0,Inits),
	New =.. [S|Inits],
	Head =   new(S,New),
	Body =   (flag(id,Id,Id+1), arg(1,New,Id)).
wmes1Zap(F,retractall(new(F,_))).

wmes1(Term,Out) :-
	functor(Term,F,A),
	functor(Blank,F,A),
	Out= blank(F,Blank).
wmes1Zap(F,retractall(blank(F,_))).

wmes1(Term,Touch) :-
	Term =.. [S0|Args0],
	accessorName(S0,S),
	maplist(firstItem,Args0,Firsts),
	length(Firsts,Arity),
	functor(Term0,S0,Arity),
	nth1(Pos,Firsts,Arg),
        copyArgs(Term0,Pos,Value0,Value,Term1),
	Touch =.. [S,Arg,Value0,Value,Term0,Term1].
wmes1Zap(F0,retractall(Doomed)) :-
	accessorName(F0,F),
	functor(Doomed,F,5).

wmes1(Term,(Head :- Touch)) :-
	Head=touch(Term1,Arg,Value0,Term2,Value),
	functor(Term,Functor,Arity),
        functor(Term1,Functor,Arity),
  	functor(Term2,Functor,Arity),
        accessorName(Functor,IName),
        Touch =.. [IName,Arg,Value0,Value,Term1,Term2].
wmes1Zap(F,retractall(Doomed)) :-
	Doomed = touch(Term,_,_,_,_), 
	clause(Doomed,_),
	functor(Term,F,_).

% support code for wmes1/2

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

/*transaction(X with Y) :-
	getThis(X,W0,W), 
	(W0
	->	W1=W0	
	;	true
	),
	o(W0,W),
	retract(W0), % W0 does/ does not exist
	assert(W).   % W  does/ does not exist

X with Y :- getThis(X,W0,W), o(Y,W0,W).
*/
getThis(&X=W,W0,W)  :- !, new(X,W0).
getThis(X=W,W0,W)   :- !, getThis(&X=W,W0,W).
getThis(a X,W0,W)   :- !, getThis(X,W0,W).
getThis(an X,W0,W)  :- !, getThis(X,W0,W).
getThis(X,W0,W)     :- getThis(&X=_,W0,W).

o(X,W) :- o(X,W,_).

o(X and Y, W0,W)      :- !, o(X,W0,W1), o(Y,W1,W).
o([],W, W).
o([H|T],W0,W)         :- o(H,W0,W1), o(T,W1,W).
o(X=Old,W, W)         :- label(X,Y), touch(W,Y,Old,W,_).
o(X is Old/New, W0,W) :- !, label(X,Y), touch(W0,Y,Old,W,New).
o(X is New,     W0,W) :- label(X,Y), touch(W0,Y,_,W,New). 
o(X + M,W0,W)         :- label(X,Y), touch(W0,Y,Old,W,New), 
    			 New is Old + M.
o(X << Add0,W0,W) :- 
	label(X,Y),
	asList(Add0,Add),
	touch(W0,Y,L0,W,L),
	append(Add,L0,L).

label(:X,X) :- !.
label(X,X).

pp(X) :- touch(X,Field,Value,_,_),
	  format('~n~a ~`.t~20| ~a',[Field,Value]),
	  fail.
pp(_).

%% demo of the accessors

wme(demo_o(name,age=0,shoes=[])).

demo(o,Y) :-
	new(demo_o,X),
	o(	[name=tim
		, age+4
		, shoes<<leather
		]
	  	,X
	  	,Y).
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% the Pirate internal representation of its specificaions

wme(r_view(view,stakeHolder)).
wme(r_error(view,object,string)).
wme(r_warning(view,object,string)).
wme(r_isa(view,object1,object2)). 
wme(r_slot(view,object,slotId)).
wme(r_facet(view,object,slotId,facet,value)). 

isFacet(name).
isFacet(name(N)) :- number(N). 
isFacet(nArguments). % if exists, then its a method
isFacet(default). 
isFacet(above).
isFacet(minValue). 
isFacet(below).
isFacet(maxValue). 
isFacet(oneOfValue). 
isFacet(type).                 
isFacet(type(N)) :- number(N).                 
isFacet(minFrom). 
isFacet(maxFrom). 
isFacet(minTo). 
isFacet(maxTo).              
isFacet(localValue).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% convert a Pirate spec to wmes

:- dynamic theView/1.

viewpoint(X) :- retractall(theView(_)), assert(theView(X)).

currentView(X) :-  
	theView(X) 
	; X = background.

inView(This,V0) :- arg(1,This,V), (V=V0 ; V=background).

wme(cxt(view,object,slotId)). % data used by the parser

term_expansion(X be Y,Items) :-
	bes(X be Y,Items).

bes(&Class be This, Items) :-
	%(1,&Class),
	once(currentView(View)),
	new(cxt,Cxt0),
	o([view=View,object=Class],Cxt0,Cxt),
	In=(&Class be This),
	bagof(Item,In^Cxt^be1(In,Cxt,Item),Items).

be1(X,Cxt,B) :- be1(X,_,Cxt,B).

be1(_ be   Y,_,   Cxt,B)  :- !,be1(Y,   root,Cxt,B).
be1(X has  Y,Last,Cxt,B)  :- !,(be1(X,Last, Cxt,B); be1(Y,slot,    Cxt,B)). 
be1(X does Y,Last,Cxt,B)  :- !,(be1(X,Last, Cxt,B); be1(Y,method,  Cxt,B)).
be1(X but Y,Last,Cxt,B)   :- !,(be1(X,Last, Cxt,B); be1(Y,override, Cxt,B)).

be1(:X=Default are Constraints, slot,Cxt,B) :- !,
	gensym(slot,SlotId),
	o([slotId=SlotId,object=Ob,view=V],Cxt,_),
	( new(r_slot,B0),
	  o([slotId=SlotId, object=Ob, view=V],B0,B)
	; facet(Cxt,name,X,B)
	; \+ var(Default), 
          facet(Cxt,default,Default,B)
	; beSlot(Constraints,Cxt,B)
	).
be1(Slot0, slot,  Cxt, B) :- !, xpandSlot(Slot0,Slot), be1(Slot,slot,Cxt,B).
be1(X,     method,Cxt, B) :- !, beMethod(X,Cxt,B).
be1(:X=Z,override,Cxt, B) :- !, 
	gensym(slot,SlotId),
	o([slotId=SlotId,object=Ob,view=V],Cxt,_),
	( new(r_slot,B0),
	  o([slotId=SlotId, object=Ob, view=V],B0,B)
	; facet(Cxt,name,X, B)
	; facet(Cxt,localValue,Z, B)
	).
be1(&X,root,C,    Isa) :- 
	o([view=View,object=Class],C,_),
	new(r_isa,Isa0),
	o([view=View, object1=Class, object2=X],Isa0,Isa).

beSlot(X are Y,   Cxt,B)        :- !,(beSlot(X,Cxt,B) 
                                     ; beSlot(Y,Cxt,B)).
beSlot(of &X,     Cxt,B)        :-  facet(Cxt,type,X,B). 
beSlot(above  X,  Cxt,B)        :-  facet(Cxt,above,X,B).
beSlot(below  X,  Cxt,B)        :-  facet(Cxt,below,X,B).
beSlot(upTo   X,  Cxt,B)        :-  beSlot(in negInf to X, Cxt,B).
beSlot(downTo X,  Cxt,B)        :-  beSlot(in X to inf,    Cxt,B).
beSlot(in X to Y, Cxt,B)        :- !,(facet(Cxt,minValue,X,B)
				     ; facet(Cxt,maxValue,Y,B)
                                     ; facet(Cxt,type,number,B)
                                     ).
beSlot(in X, Cxt,B)             :-   aMember(Y,X),
                                     facet(Cxt,oneOfValue,Y,   B)
                                   ; facet(Cxt,type,      atom,B).
beSlot(W .. X to Y .. Z, Cxt,B) :- !,cardinality(Cxt,W,X,Y,Z,B).
beSlot(X      to Y .. Z, Cxt,B) :- !,cardinality(Cxt,X,X,Y,Z,B).
beSlot(W..X   to Y     , Cxt,B) :- !,cardinality(Cxt,W,X,Y,Y,B).
beSlot(X      to Y     , Cxt,B) :- !,cardinality(Cxt,X,X,Y,Y,B).
beSlot(many,             Cxt,B) :- cardinality(Cxt,1,1,0,many,B).
beSlot(maybe,            Cxt,B) :- cardinality(Cxt,1,1,0,1,B).

xpandSlot(X,Y) :- once(xpandSlot1(X,Y)). 

xpandSlot1(:X=Default are Constraints,:X=Default are Constraints).
xpandSlot1(:X         are Constraints,:X=_       are Constraints).
xpandSlot1(:X=Default,                :X=Default are of &type).
xpandSlot1(:X,                        :X=_       are of &type).

aLocalValue(Local, (X,Y)) :- !, aMember(Local,(X,Y)).
aLocalValue(X,X).

facet(Cxt,Facet,Value,B) :-
	goodFacet(Facet),	
	o([slotId = Id ,view=V,object=O],Cxt,_),
	new(r_facet,B0),
        o([object = O 
          ,view  = V 
          ,slotId = Id  
	  ,facet = Facet
          ,value  = Value
          ], B0,B).

goodFacet(X) :- isFacet(X),!.
goodFacet(X) :- print(badFacet(X)), nl, fail.

cardinality(Cxt,MinFrom,MaxFrom,MinTo,MaxTo,B) :-
	facet(Cxt,minFrom,MinFrom,B) 
        ; facet(Cxt,maxFrom,MaxFrom,B)
     	; facet(Cxt,minTo,MinTo,B) 
	; facet(Cxt,maxTo,MaxTo,B)
        .

beMethod(:Method are of &ReturnType,Cxt,B) :- !,
	Method =.. [Name|Args],
	beMethod1(Name,Args,ReturnType,Cxt,B).
beMethod(:Method ,Cxt,B) :- 
	beMethod(:Method are of &something,Cxt,B).

beMethod1(Name,Args,ReturnType,Cxt,B) :-
	gensym(slot,SlotId),
	o([slotId=SlotId,object=Ob,view=Vi],Cxt,_),
	beMethod2(SlotId,Ob,Vi,Cxt,ReturnType,Name,Args,B).

beMethod2(SlotId,Ob,Vi,Cxt,ReturnType,Name,_,B) :-
	new(r_slot,B0),
	o([slotId=SlotId,object=Ob,view=Vi],B0,B)
	; \+ var(Name), 
          facet(Cxt,name,Name,B)
	; facet(Cxt,type,ReturnType,B)
	.

beMethod2(_,_,_,Cxt,_,_,Args,B) :-
	length(Args,NArgs),
	( facet(Cxt,nArguments,NArgs,B)
	; nth1(N,Args,Arg),
	  beArgument(Arg,N,Cxt,B)
	).

beArgument(X are of &Y,N,Cxt,B) :- !,
	( facet(Cxt,type(N),Y,B)
	; \+ var(X), facet(Cxt,name(N),X,B)
        ).
beArgument(&X ,N,Cxt,B) :- !,
	beArgument(_ are of &X,N,Cxt,B). 
beArgument(X ,N,Cxt,B) :-
	beArgument(X are of &type,N,Cxt,B). 
	
demo(parse0,X) :-
	bes(&store be &something
		  has  :name='junior',
	   X),
        nList(X).

demo(parse1,X) :-
	bes(&store be &something
		  does :getCashierForNumber(&number
                                           , fred are of &something
                                           , john are of &posInt) 	
	               are of &cashier
	    ,X),
        nList(X).

demo(parseAll,X) :-
	bes(&store be &something
			has  :name
			has  :cashiers 	are many
	               			are of &cashier
			has :position=1	are in 1 to 17
			does :getCashierForNumber(&number) 	
					are of &cashier
			does :getItemForUPC(upc are of &posint) 
					are of &item
			has :doors	are upTo 20
			has :customers	are of &number
					are downTo 20
			has :interiorColor are below 10
			has :floorTiles	are above 100
			but :date=1
			has :owners	are of &person
					are 1 to 4
			has :closedOn	are of &dayOfName
					are 1 to 1..7
			has :auditor	are of &person
					are maybe 	
			has :suburb	are in (bondi,cronulla,coogee)
			has :auditor	are of &person
					are maybe 	
			has :silly1	are of &person
					are 1..4 to 7..9 	
			has :silly2	are of &person
					are 2..3 to 12
	       ,X),
	nList(X).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% object management

%term_expansion(&X=Y,Items) :- xx.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% method stuff

term_expansion(&X does Y=R <-- Z, Out) :- 
	xpandMethod(X,Y,R,Z,Out).
term_expansion(&X does Y=R, Out) :- 
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

wme(methodDemo(name,dob,shoeSize)).

&methodDemo does init=Id <--
	flag(id,Id,Id+1),
	get_time(Time), 
	convert_time(Time,Y,Mn,D,_,_,_,_),
	o 	id is Id and 
		dob is date(Y,Mn,D) and
		name= who('Menzies','Tim').

demo(method,Ready) :-
	new(methodDemo,New),
	o(init is _,New,Ready).

&methodDemo does this(1,2,3)=y.
&methodDemo does this(A,1,B)=y <--
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

	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% some tests

tut :- shell('sh pirate -outdir tutout src/tut'),
       ['/home/timm/apps/pirate/tutout/tut.pl'].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% runtime support for terms we have meta-knowledge of
%% (these are called working meory elements or "wmes")

things(All) :- setof(One,thing(One),All).

thing(V,X) :- isClass(V,X) ; isGlobal(V,X).
thing(X) :- currentView(V), thing(V,X).

isClass(X)   :- currentView(V), isClass(V,X).
isClass(V,X)   :- currentView(V), r_isa(_,V,X,_).

isGlobal(X) :- currentView(V), isGlobal(V,X).
isGlobal(_V,_X) :- fail.

facets(O)       :- facets(O,_).
facets(O,All)   :- currentView(V), facets(V,O,All).
facets(V,O,All) :- bagof(One,aFacet(V,O,One),All),nList(All).

aFacet(V,O,r_facet(Id,V,O,X,L,Value)) :-
	r_slot(_,V,O,X),
	r_facet(Id,V,O,X,L,Value). 

/*literalise :-
	currentView(V),
	class2Wme(V,C,X).
*/

class2Wme(C,X) :- currentView(V), class2Wme(V,C,X).
class2Wme(V,C,wme(X)) :-
	isClass(V,C),
	attributes(V,C,A),
	X =.. [C|A].

attributes(C,All) :- currentView(V), attributes(V,C,All).
attributes(V,C,All) :-
	bagof(A,V^C^attribute(V,C,A),All).

attribute(C,A) :- currentView(V), attribute(V,C,A).
attribute(V,C,A) :-
	r_slot(_,V,C,X),
	r_facet(_,V,C,X,name,A),
	\+ method(V,C,A,X),
	r_facet(_,V,C,X,type,T), 
	once(isa(T,type)).
	
method(C,A,X) :- currentView(V), method(V,C,A,X).
method(V,C,A,X) :-
	r_facet(_,V,C,X,name,A),
	r_facet(_,V,C,X,nArguments,_).

r :-	rMatrix(M,Cols),
	dumbPrintList(Cols),nl,
	member(C1/C2=R,M),
	R =.. [r|RL],
	dumbPrintList([C1,C2|RL]),
	nl,
	fail.
r.

rAll :-	rAllMatrix(M,Cols),
	dumbPrintList(Cols),nl,
	member(C1/C2=R,M),
	R =.. [r|RL],
	dumbPrintList([C1,C2|RL]),
	nl,
	fail.
rAll.

dumbPrintList(L) :-
	member(X,L),
	write(X),
	write(' '),
	fail.
dumbPrintList(_).
	
rMatrix(All,Cols) :-
	bagof(R,relationship(R), All),
	setof(Col, All^rcolumn(All, Col), Cols).
	
rcolumn(L,C2) :- member(_/C2=_,L), \+ C2=type.

relationship(C1/C2=R) :-
	relationship(C1,C2,R).
relationship(C1,C2,R) :- currentView(V), relationship(V,C1,C2,R).
relationship(V,C,T,r(A,MinF,MaxF,MinT,MaxT)) :-
	r_slot(_,V,C,X),
	r_facet(_,V,C,X,name,A),
	\+ method(V,C,A,X),
	r_facet(_,V,C,X,type,T), 
	\+ isa(T,type),
	card(minFrom,V,C1, X, MinF),
	card(maxFrom,V, C1,X, MaxF),
	card(minTo,V, C1, X, MinT),
	card(maxTo,V, C1, X, MaxT).
relationship(V,C,P,r(S,many,many,1,1)) :-
	parent(V,C,P),
	\+ P=something,
	string_concat('Parent',P,S).

card(What,V,C,X,Out) :-
	r_facet(_,V,C,X,What,Out),!.
card(_,_,_,_,1).

rAllMatrix(All,Cols) :-
	setof(R,allRelationship(R),All),
	setof(Col, All^rcolumn(All, Col), Cols).

allRelationship(C1/C2=R) :-
	allRelationship(C1,C2,R).
allRelationship(C1,C2,R) :- currentView(V), allRelationship(V,C1,C2,R).
allRelationship(V,C,T,R) :-
	isa(C,C1),
	relationship(V,C1,T,R).

	

isa(X,Y) :- currentView(V), isa(V,X,Y).
isa(V,X,X) :- r_isa(_,V,X,_).
isa(V,X,Y) :-
	r_isa(_,V,X,Z),
	(Y=Z
	; \+ Z=something,
	  isa(Z,Y)
	).

parent(X,P) :- currentView(V), parent(V,X,P).
parent(V,X,P) :-
	isClass(X),
	r_isa(_,V,X,P),
	\+ X=P.


kids(X,Kids) :- currentView(V), kids(V,X,Kids).

kids(V,X,Kids) :-
	isClass(X),
	bagof(Kid,Id^V^X^(r_isa(Id,V,Kid,X),\+ Kid=X),Kids),
	!.
kids(_,_,[]).

isType(X) :- currentView(V), isType(V,X).
isType(V,X) :- isa(V,X,type).

goodWme(Wmes) :- \+ badWmes(Wmes).
badWmes(Wmes) :- member(Wme,Wmes), \+ isWme(Wme).

show :- show(_).

show(W) :- isWme(W), W, print(W), write('.'), nl, fail.
show(_).

az :- 
        isClass(X),
	\+ isType(X),
	print(X), 
	nl,
	fail.
az.
tree :-
	tree(something).

tree(Root) :-
	numberTree(Root,All0), 
	reverse(All0,All),
	member(about(Item,Depth),All), 
	upToDo(Depth,write('|  ')), 
	tree1(Item), 
	nl,
	fail.
tree(_).

%tree1(Term^Number) :- format('&~w^~w ',[Term,Number]).
tree1((Term,_)) :-
	(attributes(Term,A)
	->	 Out =.. [Term|A]
	;	Out = Term),
	format('&~w ',[Out]).
	
numberTree(Root,Out) :-
        numberTree(Root,0,1,_,[],Out).

numberTree(X,Depth,N0,N,In,Out) :-
        once(numberTree1(X,Depth,N0,N,In,Out)).

numberTree1([],_,N,N,Out,Out).
numberTree1([Kid|Kids],Depth,N0,N,In,Out) :-
        numberTree(Kid,Depth,N0,N1,In,Temp),
        numberTree(Kids,Depth,N1,N,Temp,Out).
numberTree1(Parent,Level,N,N,In,[about((Parent^DD),Level)|In]) :-
        member(about((Parent,DD),_),In).
numberTree1(Parent,Depth0,N0,N,In,Out) :-
        N1 is N0 + 1,
        Depth is Depth0 + 1,
        kids(Parent,Kids0),
        msort(Kids0,Kids),
        numberTree1(Kids,Depth,N1,N,
                                [about((Parent,N0),Depth0)|In],
                                Out).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% generate the relationships matrix
% a relationship is a "has" connection to a non-primitive type.
	
simp(X,Y) :- 
	simp1(X,Z),
	!, 
	(X=Z             % if nothing changed, 
	-> Y=Z           % then stop
	;  simp(Z,Y)).   % else, try and simplify again

simp1(W..W,      W         ). 
simp1(X0 to Y0,  X to Y    ) :- simp(X0,X), simp(Y0,Y).
simp1(many,      1 to *    ).
simp1(maybe,     1 to 0    ).
simp1(X,X).



