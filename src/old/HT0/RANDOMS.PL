%"\Program Files\pl\BIN\Plcon" -f randoms.pl > swaps.pl
% main driver. randomly swap the elements of
% a list

rlswap(In,Out) :-
	length(In,N),
	rlswap(N,In,Out).
rlswap(N,In,Out) :-
	N=0 
	-> In = Out
        ;  (rlswap0s(N,Size,In,All)
	   -> I is random(Size),
	      nth0(I,All,Out)
           ; print(failed(rlswap(N-In))),nl, fail).

rcswap(C0,C) :-
	csize(C0,N),
	rcswap(N,C0,C).
rcswap(N,C0,C) :-
	rcswap0s(N,Size,C0,All)
	-> I is random(Size),
	   nth0(I,All,C)
        ;  print(failed(rcswap(N))),nl.

% effeciency. pre-compute and cache
maxSwappedSize(32).
maxSwappedRepeats(32).

% you should not need to look below here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% permute a list randomly
rlmembers(N0,L0,L) :- 
	length(L0,LSize),
	N is min(LSize^2,N0),
	between(1,N,_),
        bagof(One,rlmember(L0,One),L).

rlmember([H|T],Item) :- 
	length([H|T],L),
	Pos is random(L), 
	rlmember1(Pos,[H|T],Y,New), 
	(Item=Y;rlmember(New,Item)).

rlmember1(0,[H|T],H,T).
rlmember1(N0,[H|T],Out,[H|Rest]) :-
	N0 > 0,
	N is N0 - 1,
	rlmember1(N,T,Out,Rest).

% how to pre-compute and cache lots of lists sorted randomly
term_expansion((:- preComputeListSwappers),Out) :-
	findall(One,genrlSwap(One),Out).

genrlSwap(rlswap0(Size,L0,L)) :-
	maxSwappedSize(MaxSize),
	maxSwappedRepeats(Repeats),
	between(1,MaxSize,Size),
	length(L0,Size),
	rlmembers(Repeats,L0,L).

term_expansion((:- accumulateListSwappers),Out) :-
	findall(One,accumulateListSwappers(One),Out).

accumulateListSwappers(rlswap0s(N,Size,List,L)) :-
	maxSwappedSize(MaxSize),
	between(1,MaxSize,N),
	findall(Lin-Lout,rlswap0(N,Lin,Lout),L1),
	length(List,N),
	maplist(linsert(List),L1,L),
	length(L,Size).

linsert(L,L-L1,L1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% permute a conjunction randomly
% (uses the above code)

rcmembers(N0,C0,C) :-
	a2l(C0,L0),
	rlmembers(N0,L0,L),
	l2a(L,C).

asize(1,_).
asize(N0,(_,Y)) :- N0 > 1, N is N0 - 1, asize(N,Y).

csize((_,Y),N) :-  !, csize(Y,N1), N is N1 +1.
csize(_,1).

l2a([X],X) :- !.
l2a([X|T],(X,Z)) :- l2a(T,Z).

a2l(X,[X]) :- var(X),!.
a2l((X,Y),[X|Z]) :- !, a2l(Y,Z).
a2l(X,[X]).

term_expansion((:- preComputeConjunctionSwappers),Out) :-
	findall(One,genrcSwap(One),Out).

genrcSwap(rcswap0(Size,C0,C)) :-
	maxSwappedSize(MaxSize),
	maxSwappedRepeats(Repeats),
	between(1,MaxSize,Size),
	asize(Size,C0),
	rcmembers(Repeats,C0,C).

term_expansion((:- accumulateConjunctionSwappers),Out) :-
	findall(One,accumulateConjunctionSwappers(One),Out).

accumulateConjunctionSwappers(rcswap0s(N,Size,C,C2)) :-
	maxSwappedSize(MaxSize),
	between(1,MaxSize,N),
	findall(Cin-Cout,rcswap0(N,Cin,Cout),C1),
	asize(N,C),
	maplist(linsert(C),C1,C2),
	length(C1,Size).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
uniqueFile(F) :-
	repeat,
	X is random(10000),
	sformat(S,'~p~p.tmp',[tmp,X]),
	string_to_atom(S,F),
	\+ exists_file(F),
	!.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% do the work

:- preComputeListSwappers.
:- preComputeConjunctionSwappers.
:- accumulateListSwappers.
:- accumulateConjunctionSwappers.

makeSwaps :- 
	print(telling('swaps.pl')),nl,
	tell('swaps.pl'),
	write(':- style_check(-singleton).'),nl,
	forall(member(X,[rcswap,rlswap,csize,rlmembers,
                         rlmember, rlmember1,rcswap0s,rlswap0s]),
	       listing(X)),
        told,
	print(told),nl.

:- makeSwaps.
   







