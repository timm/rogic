
avt(A) :- 
	xs(All),
	length(All,N1),
	gs(L),
	warshall(L,T),
	maplist(tsize,T,T1),
	av(T1,N2),
	A is round((N2*100)/N1).

tsize(_-X,S) :- length(X,S).

gs(L) :- findall(X,g(X),L).

g(X-All) :- 
	xs(L),
	member(X,L),
	(setof(One,X^g0(X,One),All) -> true ; All=[]).

g0(X=V1,Y=V2) :-
	clause(x(Y,T,V2),Sub), 
	membera(x(X,T,V1),Sub).

xs(L) :- setof(X,x1(X),L).

x1(Out) :- clause(x(X,_,V),Body), 
	  (Out=(X=V) 
          ; membera(x(Y,_,V1),Body),
            Out=(Y=V1)
          )
          ; defined(X),
	    member(V,[-1,1,0]),
            Out=(X=V). 

inputs(I) :- roots(X), between(1,10000,_),rMembers(23,X,I).
roots(L) :- setof(X,root(X),L).

nonroot(X) :- xs(XS), roots(Roots),subtract(XS,Roots,NonRoots0),
              sublist(notDummyP,NonRoots0,NonRoots), member(X,NonRoots).

someIo(Top,I,Roots,Goals) :- 
	xs(XS), 
	roots(Roots),
	subtract(XS,Roots,NonRoots0),
	sublist(notDummyP,NonRoots0,NonRoots),
	length(NonRoots,Size), N is round(Size/2),
	%NonRoots0=NonRoots
	%N is random(11) + 1,
	between(1,Top,I),
	print(a),nl,
	rMembers(N,NonRoots,Goals),
	print(b),nl.
	
root(X) :- 
	gs(G),member((X) -_,G),
	isChange(X),
	\+ dummyP(X),
	\+ (member(_-Kids,G), member(X ,Kids)).

isChange(_=0) :- !,fail.
isChange(_).

dummyName([100, 117, 109, 109, 121|_]).

dummyP(X=_) :- name(X,L), dummyName(L).

notDummyP(X) :- \+ dummyP(X).

rMembers(N,In,Out) :-
	length(In,L),
	(L =< N 
        -> Out=In
        ;  rMembers1(N,In,Out)).

rMembers1(0,_,[]).
rMembers1(N0,In,[X|Rest]) :-
	dec(N0,N),
	length(In,L),
        Pos is random(L), 
        aMember(Pos,In,X,New), 
	rMembers1(N,New,Rest).

dec(N0,N1) :- N0 > 0, N1 is N0 -1.

aMember(0,[H|T],H,T).
aMember(N0,[H|T],Out,[H|Rest]) :-
	N0 > 0,
	N is N0 - 1,
	aMember(N,T,Out,Rest).

nInsAre(N) :- 
	clause(go(_,_,_),
	ht0(_NTH,_Gs,I0,_Cover,_L)), 
	sublist(isChange,I0,I1),
	sublist(notDummyP,I1,I2),
	length(I2,N).
nGoalsAre(N) :- 
	clause(go(_,_,_),
	ht0(_NTH,Gs,_I0,_Cover,_L)), 
	length(Gs,N).

%membera(X,(Y,Z)) :- !, (X=Y ; membera(X,Z)).
%membera(X,X).
t(W) :-G0=[a-[b]
	  ,b-[d,k]
	  ,c-[e]
	  ,d-[c,d]
	  ,e-[]
	  ,k-[c]
          ],
          warshall(G0,W).

warshall(Graph, Closure) :-
        warshall(Graph, Graph, Closure).

warshall([], Closure, Closure) :- !.
warshall([V-_|G], E, Closure) :-
        memberchk(V-Y, E),      %  Y := E(v)
        warshall(E, V, Y, NewE),
        warshall(G, NewE, Closure).

warshall([X-Neibs|G], V, Y, [X-NewNeibs|NewG]) :-
        memberchk(V, Neibs),!,
        ord_union(Neibs, Y, NewNeibs),
        warshall(G, V, Y, NewG).
warshall([X-Neibs|G], V, Y, [X-Neibs|NewG]) :- !,
        warshall(G, V, Y, NewG).
warshall([], _, _, []).

ord_union([],B,B) :- !.
ord_union(A,[],A) :- !.
ord_union([H|T1], [H|T2], [H|T3]) :- !, ord_union(T1, T2, T3).
ord_union([H1|T1],[H2|T2],[H1|T]) :- H1 @< H2,!, ord_union(T1,[H2|T2],T).
ord_union(A,[H2|T2],[H2|T])       :- ord_union(A,T2,T).
