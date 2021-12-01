% must be loaded after defs
% instance creation, no assertion

 fresh0(Class,Out) ?-
	touch(my class=Class
                with our defaults=D
                with my values := D,
	      Out).

 fresh(Class with Fields,Out) ?-
	fresh0(Class,Temp),
	touch(self := Temp with Fields,Out).

% instance creation, with assertion

 new0(Class with Fields,Out) ?-
	fresh(Class with Fields,Temp),
	touch(self := Temp with my  values=Vs
		           with my  index:=Hash
		           with my  id:=Id,
	      Out),	
        touch(the one=Class with the values=Vs
		            with the index=Index),
	hash_term(Index,Hash),
	flag(id,Id,Id+1).

%XXX need a deletion

 new(X) ?- new0(X,Y), assert(Y).

 X with Y ?- touch(X with Y).
