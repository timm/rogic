
% hooks

 term_expansion((X in C ?- Y),Z) :- !, makeMethod((X in C ?- Y),Z).
 term_expansion((X in Y),  Z)    :- expand_term((X in Y ?- []),Z).
 term_expansion((X ?-  Y), Z)    :- demandZip((X:-Y),1,Z).
 term_expansion((X ?-- Y), Z)    :- demandZip((X:-Y),2,Z).

 demandZip(In,Level,Out) :-
	demand(zip(In,Level,Out),
	       'failed optimization').