term_expansion(X:Y is This with With,Out) :- !,
	bagof(One,X^Y^This^With^withs(X:Y is This with With,One),Out).
term_expansion(X is This with With,Out) :- !,
	term_expansion(stackP:X is This with With,Out).
term_expansion(is This with With,Out) :- !,
	gensym(thing,X),
	term_expansion(db:X is This with With,Out).
term_expansion(is This,All) :- 
	gensym(thing,X),
	term_expansion(db:X is This,All).
term_expansion(What:Class is This,All) :- !,
	frameHeader(This,Root,Fields,Inits),
	frameSize(Fields,Size),
	swi(flag(currentFrame,_,Class)),
	bagof(One,Class^Root^Fields^What^Inits^
	            defMeta(What,Class,Root,Fields,
                                 Inits,Size,One),
                All).
term_expansion(Class is This,All) :- 
	term_expansion(stackP:Class is This,All).

frameHeader(X,Root,Fields,Inits) :-
	once(frameHeader1(X,Root,Fields0,Inits0)),
	asList(Fields0,Fields),
	asList(Inits0, Inits).

frameHeader1(Root + Fields * Inits,  
	    Root,Fields,Inits).
frameHeader1(Root + Inits  + Fields, 
            Root,Fields,Inits).
frameHeader1(Root * Inits,           
            Root,[],    Inits).
frameHeader1(Root + Fields,          
            Root,Fields,[]   ).
frameHeader1(Root,                   
            Root,[],    []   ).

frameSize([],same) :- !.
frameSize(_,bigger).

withs(X:Y is This with With,Out) :- 
	term_expansion(X:Y is This,Out)
	; memberWith(Method,With),
          term_expansion((with Method),Out).

defMeta(MemType,Class,Root,Fields1,Inits1,Size,Out) :-
	property(Root,'#fields'(Fields0)),
	property(Root,'#inits0'(Inits0)),
	property(Root,'#types'(Types0)),
	slots2Stuff(Fields1,Fields2-Types1),
	append(Fields0,Fields2,Fields),
	append(Inits0, Inits1, Inits),
	append(Types0,Types1,Types),
	defMeta1(MemType,Class,Fields,Inits,
                 Types,Root,Size,Out).

slots2Stuff([],[]-[]).
slots2Stuff([Slot|Slots],Out) :-
	slots2Stuff(Slots,Temp),
	once(slot2Stuff(Slot,Temp,Out)).

slot2Stuff(Name        :Type
          ,Names       -Types
          ,[Name|Names]-[Type|Types]
          ).
slot2Stuff(Name
          ,Names       -Types
          ,[Name|Names]-[any|Types]
          ).

defMeta1(MemType,Class,Fields,Inits,
         Types,Parent,Size,Out) :- 
	accessorNames([Class,Parent],[Acc,AccParent]),
	length(Fields,Arity),
	functor(Blank,Class,Arity),
	arg(1,Blank,Id),
        defMeta2(
                  [size_      /Size
                  ,memType_   /MemType
                  ,b_         /Blank
                  ,isa_       /Parent
	          ,arity_     /Arity
                  ,f_         /Fields
	          ,i_         /Inits
	          ,types_     /Types
                  ,self_      /Class
                  ,id_        /Id
                  ,acc_       /Acc
                  ,p_         /AccParent
                  ,var_       /_
                  ], Out).

defMeta2(Spec,Out) :- 
	swaps(ooFirst(_),Spec,Out).
defMeta2(Spec,Out) :- 
	swaps(oo(_),Spec,Out).
defMeta2(Spec,Out) :- 
	member(size_/ bigger,Spec), 
	swaps(ooClass(_),Spec,Out).
defMeta2(Specs,Out) :-
	member(size_/ bigger,Specs), 
	member(f_ /Fields,Specs),
	nth1(Pos,Fields,Get),
	swaps(oos(_),[nth_/Pos,x_/Get,xIs_/Get|Specs]
                    ,Out).
defMeta2(Specs,Out) :-
	member(memType_ /db,Specs)
        -> swaps(ooAsAssertion,Specs,Out)
        ;  swaps(ooOnStack,Specs,Out).
defMeta2(Spec,Out) :- 
	swaps(ooLast(_),Spec,Out).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% runtime support

classes(L)    :- setof(X,class(X),L).
class(X)      :- clause(oo(X,_,_),_), atomic(X).
property(X,Y) :- '#known'(X,Y).

badput(X) :- barph(X,'cannot put stack objects').


superClass(X,Y) :- 
	'#known'(X,parent(Z)), 
	(Y=Z; superClass(Z,Y)).
subClass(X,Y) :- superClass(Y,X).

kindOf(X,X).
kindOf(X,Y) :- subClass(X,Y).



