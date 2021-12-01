% hist- histogram stuff
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
distBin(B) :- distBin(5,5,3,B).
  
dist(W1,W2,W3,L) :-
    bins(L,Bins),
    distBin(W1,W2,W3,Bins).

distBin(W1,W2,W3,Bins) :-
    sformat(S,'~~~wP  ~~~wP ~~~wS\n',[W1,W2,W3]),
    nl,
    format(S,[item,frequency,0]),
    forall(member(What-N,Bins),format(S,[What,N,N])).

% misc print utilities (needed for the histogram stuff)

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
