choices(X,Y) :- 
	clause(choice(X,_,_,IndexTerm),_),
	hash_term(IndexTerm,Y).

choice(X of Y, of,descrete,X of Y). 
