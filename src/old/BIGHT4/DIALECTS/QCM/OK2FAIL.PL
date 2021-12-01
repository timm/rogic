ok2Fail(Std) :-
	steadyVertex(Std),
	\+ (sibling(Std,UpDown),
	    parentsReachable(UpDown)).

sibling(Std,UpDown) :-
	v(Std,Lid1,_),
	l(Lid1,Object,std),
	coi(measure,Oid),
        o(Oid,Object,_), 
	oli(Oid,Lid2),  
	l(Lid2,Object,State),   
	\+ State = std,
	lvi(Lid2,UpDown).

parentsReachable(X) :-
	parent(X,Y),
	inStar(Y).


