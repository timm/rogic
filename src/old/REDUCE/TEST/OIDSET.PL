hasN([],Out,Out).
hasN([H|T],In,Out) :- has(In,H,+,Temp), hasN(T,Temp,Out).

hasnotN([],Out,Out).
hasnotN([H|T],In,Out) :- hasnot(In,H,Temp), hasnotN(T,Temp,Out).

go :-
	forall(adds(Out,L), (hasN(L,[],L1),write(adds(Out/L1)),nl)),
	forall(dels(Adds,Dels), (hasN(Adds,[],L),
                                 (hasnotN(Dels,L,Out)
				 -> Report=dels(Dels/Out)
                                 ;  Report=failed(Adds/Dels)
                                 ),
                                 write(Report),nl)).

adds([],[e(1,a),e(2,b)]).
adds([10=Z, % a
   6=Six,   % l
   4=Four], % b, not a!! 
   [e(10,a), e(4,a),  
    e(6,l),  e(7,m),
    e(1,ee), e(4,b),
    e(10,Z), e(6,Six),
    e(4,Four)
   ]).

dels([e(1,a),e(2,b)],[e(1,_)]).
dels([e(1,a),e(2,b)],[e(1,_),e(1,_)]).
