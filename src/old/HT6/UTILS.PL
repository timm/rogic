
isList([]).
isList([_|_]).

asList(X,X) :- is_list(X),!.
asList(X,[X]).



%=========================

% histogram stuff
bins(L,B) :-
    msort(L,L1),
    bins(L1,[],B).

bins([],X,X).
bins([H|T],[H-N0|Rest],Out) :- !,
    N is N0 + 1,
    bins(T,[H-N|Rest],Out).
bins([H|T],In,Out) :-
    bins(T,[H-1|In],Out).

dist(L) :- dist(5,5,3,L).
  
dist(W1,W2,W3,L) :-
    sformat(S,'~~~wP  ~~~wP ~~~wS\n',[W1,W2,W3]),
    bins(L,Bins),
    nl,
    format(S,[item,frequency,0]),
    forall(member(What-N,Bins),format(S,[What,N,N])).

% misc print utilities (needed for the bistogram stuff)

:- format_predicate('P',padChars(_,_)).

padChars(default,A) :- padChars(5,A).
padChars(S,A) :-
    atom_length(A,N),
    Pad is S - N,
    forall(between(1,Pad,_),put(32)),
    write(A).

:- format_predicate('S',twiddle(_,_)).

twiddle(default,A) :- twiddle(25,A).
twiddle(W,N) :-
    N1 is round(N/W),
    forall(between(1,N1,_),put(126)).

%-----------------

runiv(Term0, Swaps,Term) :-
        Term0 =..L0,
        once(maplist(runiv1(Swaps), L0, L)),
	Term =.. L.

runiv1(_,H,H)  :- var(H).
runiv1(Swaps,Old,New)  :- atomic(Old), member(Old/New,Swaps),!.
runiv1(_,H,H) :- atomic(H).
runiv1(Swaps,H0,H) :- runiv(H0,Swaps,H).

	


