say(X)   :- write(X), write(' '), flush_output.
sayln(X) :-  write(X), write(' '), nl,flush_output.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%

less1([H|T],H,T).
less1([H|T],X,[H|Rest]) :- less1(T,X,Rest).

twoMembers(L,One,Two) :-
	less1(L,One,Less),
	less1(Less,Two,_).
	
c2([One|T],One,Two) :-
	member(Two,T).
c2([_|T],One,Two) :-
	c2(T,One,Two).

asList(X,X) :- is_list(X),!.
asList(X,[X]).
%%%%%%
reset_seed :- 
	seed0(N),
	retractall(seed(_)),
	assert(seed(N)).

my_random(R,N) :-
        retract(seed(S)),
        N is (S mod R),
        NewSeed is (125 * S + 1) mod 4096,
        asserta(seed(NewSeed)), !.
        
%%%%%%%%%%%%%
% patterns processing

uses(P,Swaps,All) :-
	bagof(One,P^Swaps^use(P,Swaps,One),All).
use(P,Swaps,Out):- 
	clause(pattern(P,Head),Body), 
	swap((Head --> Body),Swaps,Temp),
	expand_term(Temp,Out).

swap(X,Swaps,Y)   :- 
	X =.. L0, 
	once(maplist(swap1(Swaps),L0,L1)), 
	Y =.. L1.

swap1(_,H,H)      :- var(H).
swap1(Swaps,H0,H) :- member(H0=H,Swaps).
swap1(_,H,H)      :- atomic(H).
swap1(Swaps,H0,H) :- swap(H0,Swaps,H).

%%%%%%%%%%%%%%%%%%%%
memberC(Z,(X,Y)) :- !,(Z=X;memberC(Z,Y)).
memberC(Z,Z).

memberD(Z,(X|Y)) :- !,(Z=X;memberD(Z,Y)).
memberD(Z,Z).

%%%%%%%%%%%%%%%%%%%%
mayspy(_,_).

mayspy(X,G) :-
	%true ; fail, 
	write('Spy on '),write(G),write('? '),
	get_single_char(C),
	name(What,[C]), write(What),nl,
	(C=121
        -> spy(X)
        ;  true).

%%%%%%%%%%%%%%%%%%%%
firstcol([],[]).
firstcol([[H|_]|R],[H|Hs]) :- firstcol(R,Hs).

nextcols([],[]).
nextcols([[_|T]|R],[T|Ts]) :- nextcols(R,Ts).

transpose([[]|_],[]).
transpose(R,[H|C]) :- firstcol(R,H), nextcols(R,T), transpose(T,C).
%%%%%%%%%%%%%%%%%%%%
atoms(T,A) :-
	all(T,atomic(X),X,A).

all(In,P,V,Out) :-
	setof(One,In^P^V^all1(In,P,V,One),Out).
all1(V,P,V,V) :- P,!. 
all1(X,_,_,_) :- var(X),!,fail.
all1([H|T],V,P,Out) :-
	all1(H,V,P,Out)
	; all1(T,V,P,Out).
all1(X,V,P,Out) :-
	functor(X,F,A),
	A > 0,
	(all1(F,V,P,Out)
        ;between(1,A,N),
	 arg(N,X,One),
         all1(One,V,P,Out)).
	