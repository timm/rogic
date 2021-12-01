invariant(i(V1,V2)) :-
	class(Class,_,_,_,_,discrete),
	domain(Class,Domain),
	\+ (Class = and),
	remove1(Domain,Value1,Domain1),
	member(Value2,Domain1),
	vertexDetailsFast(V1,Object,Value1,Class,_,_),
	vertexDetailsFast(V2,Object,Value2,Class,_,_).
	
