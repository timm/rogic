:- [optimize].

define(stats(sum,sumSq,n)).

`stats_(add(X))      --> `((+n, sum+X, sumSq+X*X)).
`stats_(adds([H|T])) --> `add(H), stats_(adds(T)).
`stats_(adds([])).
`stats_(new)         --> `((n = 0!, sum = 0!, sumSq = 0!)).
`stats_(new([H|T]))  --> `((new, adds([H|T]))).
`stats_(Mean/Sd)     -->
	`((n=N, sum=S, sumSq = S2)),
	N>2,
	Sd is sqrt(((N*S2) - (S*S))/(N*(N-1))),
	Mean is S/N.

/*define(bin(key,contents,numericP))

`bin_(add(X)) --> `((mark(X),numericP=What,
`bin_(new) --> `((contents = []!,numericP=(?)!)).
`bin_(mark(X)) :- `((numericP= numeric)),number(X),!.
`bin_(mark(_)) :- `((numericP= symbol!)).
*/
hash of key= [values

%%%%%%%%%%%%%%%%

less1([H|T],H,T).
less1([H|T],Out,[H|Rest]) :- less1(T,Out,Rest).

pairs(=,K,V0,V,P0,[K=V|P]) :- less1(P0,K=V,P).   %query
pairs(+,K,V, V,P0,      P) :- less1(P0,K=V ,P),!. %demand
pairs(+,K,_, V,P, [K=V|P]).

pairs(<<,K,V0,V,P0, [K=P) :- less1(P0,K=V0 ,P),!. %demand
pairs(<<,K,_, V,P, [K=V|P]).

pairs(-,K,_, V,P0,      P) :- less1(P0,K=V,P).    %delete

five_(1,A0,A,five(A0,B,C,D,E),five(A,B,C,D,E)).
five_(2,B0,B,five(A,B0,C,D,E),five(A,B,C,D,E)).
five_(3,C0,C,five(A,B,C0,D,E),five(A,B,C,D,E)).
five_(4,D0,D,five(A,B,C,D0,E),five(A,B,C,D,E)).
five_(5,E0,E,five(A,B,C,D,E0),five(A,B,C,D,E)).

portray(five(_,_,_,_,_)) :- write('F').

:- op(999,xfx,@). % tag for bucket location
:- op(999,xfx,#). % denotes a hash

@(K/V0/V) --> find5(K,B0,B),{pairs(=,B0,K,V0,V,B)}.
@(K=V)    --> find5(K,B, B),{pairs(=,B, K,V ,V,B)}.
@(K+V)    --> find5(K,B0,B),{pairs(+,B0,K,_ ,V,B)}.
@(K-V)    --> find5(K,B0,B),{pairs(-,B0,K,_ ,V,B)}.
@( -K)    --> find5(K,B0,B),{pairs(-,B0,K,_ ,_,B)}.

find5(_@Where,Bucket0,Bucket,F0#D,F#D) :- !,
	cache5s(D,Where,Path),
	walk5s(Path,Bucket0,Bucket,F0,F).
find5(Thing,Bucket0,Bucket,F#D,Out) :-
	hash_term(Thing,Hash),
	Where is Hash mod (5^D),
	find5(Thing@Where,Bucket0,Bucket,F#D,Out).

walk5s(=(H), X0,X) --> five_(H,X0,X).
walk5s((H,T),X0,X) --> five_(H,Z0,Z), {walk5s(T,X0,X,Z0,Z)}.

%%%%%%%%%%%%%%%%%%%
% stuff to cache pathways through the hash table

resetHash :-
	Depths=[2,3,4],
	retractall(cache5s(_,_,_)),
	retractall(hash0(_,_)),
	index(cache5s(1,1,0)),
        forall(member(D,Depths),
	       forall(resetHash1(D,X),
	              assert(X))).

resetHash1(D,X) :- walked5s(D, X).
resetHash1(D,hash0(D,Fs#D)) :- make5s(Fs,D,0,_).

walked5s(D,cache5s(D,N,Path)) :-
	make5s(Fs,D,0,_),
	walk5s(Path,N=_,_,Fs,_).

make5s(N0=[],0,N0,N) :- !,N is N0 + 1.
make5s(F,D0,N0,N)    :-
	var(F),!, D0 > 0,
	D is D0 - 1,
	length(L,5),
	make5s(L,D,N0,N),
	F=..[five|L].
make5s([],_) --> [].
make5s([H|T],D) --> make5s(H,D), make5s(T,D).

:- resetHash.
	
%%%%%%%%%%%%%%%%%%%%%%%%%

prints(X) :-forall(prints(X,[],'   '),true).

prints(X=Y,Ins,_) :- !,prints1(X=Y,Ins).
prints([],_,_) :- !.
prints([H|T],Ins,B4) :- !,
	Next =.. [list,H|T],prints(Next,Ins,B4).
prints(X,Ins,_) :- functor(X,X,0), prints1(X,Ins).
prints(X,Ins,B4) :-
	functor(X,F,A), A > 0,
	prints(F,Ins,B4),
	arg(_,X,Y),
	prints(Y,[B4|Ins],B4).

prints1(X,L) :- forall(member(Y,L),write(Y)), write(X),nl.