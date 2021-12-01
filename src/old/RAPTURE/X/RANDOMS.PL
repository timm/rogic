:- module(random,[nNumbers/2]).

nNumbers(N,Out) :-
	bagof(Item,L^I^N^(
			bagof(I,between(1,N,I),L), 
			someMember(L,Item)),
		Out).

nPairs(N,Out) :-
	flag(v,_,0),
	nNumbers(N,Nums),
	maplist(nPair,Nums,Out).

nPair(X,X-V) :- flag(v,V,V+1).

:- arithmetic_function(myrand/1).
myrand(R,N) :- my_random(R,N).


seed(13).

my_random(R, N) :-
        retract(seed(S)),
        N is (S mod R),
        NewSeed is (125 * S + 1) mod 4096,
        asserta(seed(NewSeed)), !.


rMember(L,X) :- length(L,N), rMember(N,L,X).
rMember(N,L,X) :- I is myrand(N), nth0(I,L,X).

someMember(L,Item) :- 
	someMember1(L,L1),
	member(Item,L1).

someMember1([],[]).
someMember1([H|T],[X|Rest]) :-
	rMember([H|T],X),
	oneLess([H|T],X,Left),
	someMember1(Left,Rest).
	
oneLess([H|T],H,T).
oneLess([H|T],Out,[H|Rest]) :- oneLess(T,Out,Rest).
