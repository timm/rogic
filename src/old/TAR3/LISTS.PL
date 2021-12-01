pairs(In,N,P1,P2) :- pairs(In,1,N,P1,P2).

pairs([X,Y|_],N,N,X,Y).
pairs([_,Y|Z],N0,N,P1,P2) :- N1 is N0 +1, pairs([Y|Z],N1,N,P1,P2).

foreach(X,L,Y) :- forall(member(X,L),Y).

l(L) :- foreach(X,L,(print(X),nl)).

unique(L0,L) :- unique(L0,[],L).

unique([],_,[]).
unique([H|T], L0, L) :- member(H,L0),!,unique(T,L0,L).
unique([H|T], L0, [H|L]) :- unique(T,[H|L0],L).

c2l((X,Y),[X|Z]) :- !,c2l(Y,Z).
c2l(X,[X]).
