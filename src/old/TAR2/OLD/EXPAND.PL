term_expansion((A=B -> C),eg(Domain,Dataset,B,C)) :-
	member(domain=Domain,A),
	member(dataset=Dataset,A).
