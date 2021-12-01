go1 :-
	def(a(_=me,_X:key,_Y,_Z=z:key:asString,_,_=charmed),A,B),
	print(A),nl,
	forall(member(B1,B),portray_clause(B1)).	

go :-
	def(a(_:key:asString,_=fred,__=charmed,_),A,B),
	print(A),nl,
	numbervars(B,1,_),
	print(B),nl,
	forall(member(B1,B),(portray_clause(B1))).	

