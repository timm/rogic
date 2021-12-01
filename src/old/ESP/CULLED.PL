\begin{prol1}*/

a --> [1].

:- op(999,xfx,means).

term_expansion(X means P,Assertions) :- 
	specialise(P,X,Assertions). 

specialise(P,New,L) :-
	bagof(X,P^New^specialise1(P,New,X),L).

specialise1(P0,New0, (New0 :- X)) :-
	clause(P0,X0),
	copy_term([P0-New0],[P-New]),
	specialise2(X0,X,P-New,_).
     
specialise2((X0,Y0),(X,Y),T0,T) :- !,
	specialise2(X0,X,T0,T1),
	specialise2(Y0,Y,T1,T).
%specialise2(meta(Head,[X,X]),true,T,T) :- Head == identity,!.
%specialise2(meta(X,Y),Z,T,T) :- \+ var(X),!,meta(X,Y,Z).

specialise2(X,New0,P0-New0,P-New) :-
	\+ \+ X = P0,!,
	copy_term([P0-New0],[P-New]),
	X=P0.
specialise2(X,X,T,T).	 

/*\end{prol1}


skeleton(treeSearch(A, [B]), [C = debug(found(B)),D = found(B),E = bite(A, B, F),G = treeSearch(A, [B])], (G :- E, D, C)).
skeleton(treeSearch(A, [B|C]), 
[D = treeSearchNext(E, C),
F = prune(G, E),
H = rank(I, G),
J = combine(K, L, I),
M = next(B, K),
N = bite(A, B, L),
O = debug(states(A)),
P = treeSearch(A, [B|C])], 
(P :- O, N, M, J, H, F, D)
).
