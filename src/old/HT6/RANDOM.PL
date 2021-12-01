/*true random
rand(R,N) :- N is random(R).

r(X) :- X is random(10000)/10000.
*/

% random with controlled seed
r(X) :- X is rand(10000)/10000.

rand(R,N) :- my_random(R,N).

seed(13).

reset_seed :- retractall(seed(_)), assert(seed(13)).

my_random(R, N) :-
        retract(seed(S)),
        N is (S mod R),
        NewSeed is (125 * S + 1) mod 4096,
        asserta(seed(NewSeed)), !.

oneLessN(1,[H|T],H,T) :- !.
oneLessN(N0,[H|T],X,[H|Rest]) :- N is N0 - 1, oneLessN(N,T,X,Rest).	

rone([H],H,[]) :- !.
rone([H|T],X,Out) :-
	length([H|T],N),
	Pos is rand(N) + 1,
	oneLessN(Pos,[H|T],One,Rest),
	(X=One, Out=Rest
	; Out=[One|Tail],
	  rone(Rest,X,Tail)).
