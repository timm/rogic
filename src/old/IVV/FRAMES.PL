:- X=slot/3, 
	dynamic(X),
	discontiguous(X),
	multifile(X).

:- index(slot(1,1,1)).

term_expansion(X=Super+L0,Out) :-
	super(Super,Defaults),
	addDefaults(Defaults,L0,L),
	bagof(Slot,X^L^Super^slot0(L,X,Super,Slot),Out).

super(Super,Defaults) :- 
	slot(Super,spec,Defaults),!.
super(_,[]).

addDefaults([],New,New).
addDefaults([Slot=Value|Defaults],New,
            [Slot=Value|Rest]) :-
	\+ member(Slot=_,New),!,
	addDefaults(Defaults,New,Rest).
addDefaults([_|Defaults],New,Rest) :-
	addDefaults(Defaults,New,Rest).

slot0(_, X, Super, slot(X,isa, Super)).
slot0(L, X, _    , slot(X,spec,L    )).
slot0(L, X, _    , slot(X,Slot,Value)) :- member(Slot=Value,L).
