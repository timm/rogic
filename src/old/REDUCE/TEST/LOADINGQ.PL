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


go2 :-  Head=(@aka(A:key,B:asString,C,X= charmed)),
        Body = (@charmed(X) rand @xid(A) 
                           rand @string(B)  rand @sourceId(C)),
        term_expansion((Head :- Body),L),
	forall(member(Item,L),(portray_clause(Item))).	

go3 :-  Head=(aka(A:key,B:asString,C,X= charmed:asFucked)),
        Body = (@charmed(X) rand @xid(A) 
                            rand @string(B)  rand @sourceId(C)),
        filter0(Head,L),
	portray_clause(L).	

go4 :-  Head=(@source(A, 
                      B, when(C,D,E,F,G,H),
	              X): sometimes),

        Body =(@charmed(X)
                rand @sym(A) 
	        rand @sym(B) 
                rand @when(C,D,E,F,G,H)),
                
        term_expansion((Head :- Body),L),
	forall(member(Item,L),(portray_clause(Item))).	
go5 :-
	
        term_expansion((@day(A, 2, B=year) :-
                           @year(B),
                           C is B mod 4,
                           C>0,
                           rnum(0, 28, A)),L),
	forall(member(Item,L),(portray_clause(Item))).	

