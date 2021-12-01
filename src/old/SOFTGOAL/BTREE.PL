%---------------------------------------------
% binary tree stuff

% 2 kinds: t/4 - trees of only values
%          t/5 - trees of key-value pairs
btree0(value,X,  t(X,  1,t,t)).
btree0(pair, K,V,t(K,V,1,t,t)). 

% predicated on both tree types
bSize(0,t) :- !.
bSize(N,t(_,_,N,_,_)).
bSize(N,t(_,  N,_,_)).

bContent(K=V,L,R,t(K,V,_,L,R)).
bContent(X,  L,R,t(X,  _,L,R)).

% print
bprint(T) :- bprint(T, 0, '.', '').
bprint(t, _,_,_) :- !.
bprint(T, Indent, String, Prefix) :-
	bContent(X,L,R,T),
        indent(Indent, String),
        format('~w~w\n',[Prefix,X]),
        bprint(L, Indent+1, String, ' < '),
        bprint(R, Indent+1, String, ' > ').

% insertion of a value 
addV(T0,X,T) :- addV(T0,X,_,T).

addV(t(X,N,L,R),   X,=,     t(X,N,L,R)) :- !.
addV(t,            X,+,     t(X,1,t,t)) :- !.
addV(t(X0,N0,L0,R),X,Z,t(X0,N, L, R)) :-
	X @< X0,addV(L0,X,Z,L),(Z=(+) -> N is N0+1; N=N0).
addV(t(X0,N0,L,R0),X,Z,t(X0,N, L,R )) :-
	X @> X0, addV(R0,X,Z,R),(Z=(+) -> N is N0+1; N=N0).

% insertion of a key value pair
addPair(T0,K,V,T) :- addPair(T0,K,V,_,T).

addPair(t(K,V,N,L,R),    K,V,=,     t(K,V,N,L,R)) :- !.
addPair(t,               K,V,+,     t(K,V,1,t,t)) :- !.
addPair(t(K0,V0,N0,L0,R),K,V,Z,t(K0,V0,N, L, R)) :-
	K @< K0, addPair(L0,K,V,Z,L), (Z=(+) -> N is N0+1; N=N0).
addPair(t(K0,V0,N0,L,R0),K,V,Z,t(K0,V0,N, L,R )) :-
	K @> K0, addPair(R0,K,V,Z,R), (Z=(+) -> N is N0+1; N=N0).

delPair(T0,K,V,T) :- delPair(T0,K,V,_,T).
addPair(t(K,V,N,L,R),    K,V,-,     t(K,V,N,L,R)) :- !.
addPair(t(K0,V0,N0,L0,R),K,V,Z,t(K0,V0,N, L, R)) :-
	K @< K0, addPair(L0,K,V,Z,L), (Z=(+) -> N is N0+1; N=N0).
addPair(t(K0,V0,N0,L,R0),K,V,Z,t(K0,V0,N, L,R )) :-
	K @> K0, addPair(R0,K,V,Z,R), (Z=(+) -> N is N0+1; N=N0).

% convert a list of key value pairs into a balanced tree
pairs2t(KVs0,T) :-
	msort(KVs0,[K=V|L]),
	btree0(pair,K,V,T0),
	pairs2t(L,T0,T).
pairs2t([],T,T) :- !.
pairs2t([K=V],T0,T) :- addPair(T0,K,V,_,T),!.
pairs2t(L,T0,T) :-
        halve(L,Left,K=V,Right),
        addPair(T0,K,V,_,T1),
        pairs2t(Left,T1,T2),
        pairs2t(Right,T2,T).

% convert a list of values into a balanced tree
values2t(L0,T) :-
	msort(L0,[X|L]),
	btree0(value,X,T0),
	values2t(L,T0,T).
values2t([],T,T) :- !.
values2t([X],T0,T) :- addV(T0,X,_,T),!.
values2t(L,T0,T) :-
        halve(L,Left,X,Right),
        addV(T0,X,_,T1),
        values2t(Left,T1,T2),
        values2t(Right,T2,T).

% richard o'keith magic- chops a list in half
halve([X],[],X,[]).
halve([X,Y|L],[X|Front],Mid,Back) :-
        halve1(L,[Y|L],Front,[Mid|Back]).

halve1([_,_|Count], [H|T], [H|F], B) :- !,
        halve1(Count, T, F, B).
halve1(_, B, [], B).

% showing off
addPairDemo(T) :-
	pairs2t([k=1,m=2,s=5,a=4,n=2,b=10,g=19,f=1,z=0,y=2],T),
	bprint(T).

addVDemo(B) :-
	values2t([a,h,d,z,j,r,y,i,o,q,f,g,n],B),
	bprint(B).
