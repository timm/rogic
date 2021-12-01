r(X) :- X is rand(10000)/10000.

rand(R,N) :- my_random(R,N).

%%%%%%%%%
seed(13).

reset_seed :- retractall(seed(_)), assert(seed(13)).

my_random(R, N) :-
        retract(seed(S)),
        N is (S mod R),
        NewSeed is (125 * S + 1) mod 4096,
        asserta(seed(NewSeed)), !.

