

incZero :-
	retractall(incData(_,_,_,_,_)).

inc(A,B,C,D) :-
	retract(incData(A,B,C,D,Z0)),!,
        Z is Z0+1,
        assert(incData(A,B,C,D,Z)).

inc(A,B,C,D) :-
	assert(incData(A,B,C,D,1)).