:- Stuff = (thing/3,type/2,temp/2,kb1/3,scenarios/1),
	(discontiguous Stuff),
	(dynamic Stuff).

:- index(thing(1,1,0)).

xpands(A,B) :- maplist(term_expansion,A,B).
c2fact(C, (:- flag(This,_,That))) :-
	memberA(C,This is That),
	(isOption(This) -> true ; print(unknownOption(This)),nl).

term_expansion((*X is Y),(:- flag(X,_,Y))) :- !,
	(isOption(X) -> true ; print(unknownOption(X)),nl).
term_expansion((*X is Y,Rest),All) :-  !,
	bagof(One, X^Y^Rest^c2fact((X is Y,Rest),One),All).
term_expansion((* rx=RX,Results),Scenarios) :- !,
	genScenario([rx=RX|Results],Scenarios).
term_expansion(* X=Whats,Out) :- !,
	bagof(type(X,Item),
		Whats^What^(memberA(Whats,What),
                            member(Item,What)),
	      Out).
term_expansion((* Type: Var1,Vars),Out) :- !,
	bagof(thing(H,Var,Type),
		Vars^(memberA((Var1,Vars),Var),hash_term(Var,H)),
	      Out).
term_expansion((* Type: Var),thing(H,Var,Type)) :- !,hash_term(Var,H).
term_expansion((* X if Y) ,Out) :-
	+thing(X,bool),!,
	term_expansion((* X=1 if Y),Out).
term_expansion((* A=B if Y),temp(kb1(A,B,_),Y)) :- !.
term_expansion((*if no X then Y + Z), Out) :- !,
    xpands([(*Y=  1 if now(X)= -1 and Z=  1)  
	   ,(*Y= -1 if now(X)= -1 and Z= -1)
	   ,(*Y= 1  if X = -1)
	   ,(*Y= -1 if X =  1)
           ],Out).
term_expansion((*if no X then Y - Z),Out) :- !,
    xpands([(*Y=  1 if now(X)= -1 and Z= -1)
           ,(*Y= -1 if now(X)= -1 and Z=  1)
           ,(*Y= 1  if X =  1)
	   ,(*Y= -1 if X = -1)
           ],Out).
term_expansion((*if no X then Y ++ Z), Out) :- !,
    xpands([(*Y=  1 if now(X)= -1 and Z=  1)  
	   ,(*Y= 1  if X = -1)
           ],Out).
term_expansion((*if no X then Y -+ Z), Out) :- !,
    xpands([(*Y= -1 if now(X)= -1 and Z=  1)  
	   ,(*Y= 1 if X = 1)
           ],Out).
term_expansion((*if X then Y + Z), Out) :- !,
    xpands([(*Y=  1 if now(X)= 1 and Z=  1)  
	   ,(*Y= -1 if now(X)= 1 and Z= -1)
	   ,(*Y= 1  if X = 1)
	   ,(*Y= -1 if X = -1)
           ],Out).
term_expansion((*if X then Y - Z),Out) :- !,
    xpands([(*Y=  1 if now(X)= 1 and Z= -1)
           ,(*Y= -1 if now(X)= 1 and Z=  1)
           ,(*Y=  1 if X = -1)
	   ,(*Y= -1 if X =  1)
           ],Out).

term_expansion((*if X then Y ++ Z), Out) :- !,
    xpands([(*Y=  1 if now(X)= 1 and Z=  1) 
	   ,(*Y= 1  if X = 1)
           ],Out).

term_expansion((*if X then Y -+ Z),Out) :- !,
    xpands([(*Y=  1 if now(X)= 1 and Z= -1)
           ,(*Y=  1 if X = -1)
           ],Out).
term_expansion((* A ++ B),Out) :-
	flag(even,_,f),
	term_expansion((*A =1 if B=1),Out).
term_expansion((* A -+ B),Out) :-
	flag(even,_,f),
	term_expansion((*A = -1 if B=1),Out).
term_expansion((* A + B),Out) :- !,
    xpands([(*A=  1 if B=  1)
           ,(*A= -1 if B= -1)
           ],Out).
term_expansion((* A - B),Out) :- !,
    xpands([(*A=  1 if B= -1)
           ,(*A= -1 if B= 1)
           ],Out).
term_expansion(* end,Out) :- !,
	ends(Out).
term_expansion((* A),Out) :-
	term_expansion((* A if true),Out).
