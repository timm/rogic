showBools :- forall((setof(B,abool(B),Bs),member(B,Bs)), 
                    showBool(B)).
showVars  :- forall((setof(V,avar(V),Vs),member(V,Vs)), 
                    showVar(V)).

abool(B) :- 	defVar(B,_,_,_,_,_,boolp(_)).
avar(V) :- 	defVar(V,_,_,_,_,_,_), \+ abool(V).

showBool(B) :-
	abool(B),
        defVar(B,_,String,On,_,_,_),
	sizedAtom(B,4,B1),
        format(' +-~w          ~w (default= ~w)~n',
                [B1,String,On]).
showVar(V) :-
	avar(V),
	defVar(V,_,String,On,_,_,_),
	sizedAtom(V,4,V1),
        format(' ~w   =X       ~w (default= ~w)~n',
                [V1,String,On]).
	
switch1([+X|Rest]) :- setSwitch(X,Rest),         switch(Rest).

switch1([*X|Rest]) :- loopSwitch(X,Rest,After),  switch(After).
switch1([/X|Rest]) :- applySwitch(X,Rest,After), switch(After).

setSwitch(X,Rest)         :- switchArgs(Rest,[],_), set(X,t).
clearSwitch(X,Rest)       :- switchArgs(Rest,[],_), set(X,f).

loopSwitch(X,Rest,After)  :- switchArgs(Rest,[Arg],After),
	                     name(Arg,Flags),
			     maplist(comFlag(X),Flags,_).
comFlag(X,Y,_) :- name(Flag,[Y]), com(X,Flag).

switchArgs1([+H|T], [], [+H|T]).

switchArgs1([/H|T], [], [/H|T]).
switchArgs1([*H|T], [], [*H|T]).




