% runtime access
wmePrim(K,L1,L2,W0,W) :-
	wmeSize(w,S,_),
	hash_term(K,H),
	I is H mod S,
        w(I,L1,L2,W0,W).

% side-effect of accessing- move to fron
wmePut(X,W0,W) :-
	wmePrim(X,Old,[X|Less],W0,W),
	less1(Old,X,Less).

wmePull(X,W0,W) :-
	wmePrim(X,Old,Less,W0,W),
	less1(Old,X,Less).
