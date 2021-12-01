%---------------------------------------------
% binary tree stuff

btree0(X, t(X,1,nil,nil)).

bSize(0,nil).
bSize(N,t(_,  N,_,_)).

portray(t(_,N,_,_)) :- write({t/N}).

% print
bprint(T) :- bprint(T, 0, '.. ', '').
bprint(nil, _,_,_) :- !.
bprint(t(X,_,L,R), Indent, String, Prefix) :-
        indent(Indent, String),
        format('~w~w\n',[Prefix,X]),
        bprint(L, Indent+1, String, ' < '),
        bprint(R, Indent+1, String, ' > ').

% insertion of a value 
b(T0,X,T) :- b(T0,X,_,T).

b(nil,X,+,Out) :- btree0(X,Out).
b(t(X0,N0,L0,R0), X, Z, t(X0,N,L,R)) :-
	compare(C,X,X0),
	b1(C,t(X0,N0,L0,R0),X,Z,t(X0,_, L, R)),
	(Z=(+) -> N is N0 + 1; N=N0).

b1(=,t(X, N,L, R),X,=,t(X, N,L,R)).
b1(<,t(X0,N,L0,R),X,Z,t(X0,N,L,R)) :- b(L0,X,Z,L).
b1(>,t(X0,N,L,R0),X,Z,t(X0,N,L,R)) :- b(R0,X,Z,R).	

% convert a list of values into a balanced tree
l2t(L0,T) :-
	msort(L0,[X|L]),
	btree0(X,T0),
	l2t(L,T0,T).
l2t([],T,T) :- !.
l2t([X],T0,T) :- b(T0,X,_,T),!.
l2t(L,T0,T) :-
        halve(L,Left,X,Right),
        b(T0,X,_,T1),
        l2t(Left,T1,T2),
        l2t(Right,T2,T).

% richard o'keith magic- chops a list in half
halve([X],[],X,[]).
halve([X,Y|L],[X|Front],Mid,Back) :-
        halve1(L,[Y|L],Front,[Mid|Back]).

halve1([_,_|Count],[H|T],[H|F],B) :- !,halve1(Count,T,F,B).
halve1(_, B, [], B).

% showing off
bDemo(B) :-
	l2t([a,h,d,z,j,r,y,i,o,q,f,g,n],B),
	bprint(B).
