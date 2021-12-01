
my_consult(P) :-
        '$consult_file'(P,[]).

:- [ops,o].

xxx(What,Time) :-
%	between(1,2,_),
%	between(1,4,Size0),
%	between(1,8,Size0),
%	between(1,5,Tsize0),
%	between(1,2,Tsize0),
%	between(1,10,Recents0),
%	between(1,1,Recents0),
%	Size is 10*2^Size0,
%	member(Size,[40,80,160,320]),
%	TSize is  (2^Tsize0) * 1.5,
	Size is 100, % init = 30
	TSize is 12,  % init = 48
%	Recents is 1* Recents0,
	Recents is 10,
	print(wmeSize(Size)),write(' '),
	print(termArity(TSize)),write(' '),
	print(recents(Recents)),nl,
	between(1,5,_), % increase to reduce % error
	demo(Size,TSize,Recents,What,Time).
%	print(demo(Size,TSize,Recents,What,Time)), nl.

demo(WmeSize,TermSize,Recents,What,Time) :-
	what2Do(WmeSize,TermSize,A,R,F),
	!,
	member(What,[
		     lif, % always do first
                     oset,
                     assert,
       %              splay,
		     avl,
         	     234
	       	     ]),
	Repeats=5 , % increase to remove /0 error in timing
	my_consult(What),
	demoA(Recents,A,R,F,W),	
	is_valid(W),
	timeIt(demoA(Recents,A,R,F,_),Repeats,Time).



what2Do(Size,TSize,A,R,F) :-
	length(A0,Size),
	what2Do1(A0,TSize,1),
	random_order(A0,A),
	Finds is integer(Size / 10) + 1,
	random_members(A,Finds,F).

what2Do1([],_,_).
what2Do1([N-Thing|Rest],TSize,N) :-
	Arity is random(TSize + 1),
	length(Fields,Arity),
	makeGround(Fields),
	Thing =.. [x|Fields],
	N1 is N + 1,
	what2Do1(Rest,TSize,N1).

makeGround([]).
makeGround([1|T]) :-
	makeGround(T).


demoA(N,A,R,F,Out) :-
	wmeSetUp,
	wmeInit(W0),
	wmeReset(W0,W1),
	wmeA(A,W1,W2),
	wmeR(R,W2,W3),	% comment out if splay not working
	demo1(N,A,R,F,W3,Out),
	!.

% REcency test
demo1(0,_,_,_,W,W).
demo1(N0,A,R,F,W1,W) :-
	N0 > 0,
	wmeF(F,W1,W2),
	N is N0 - 1,
	demo1(N,A,R,F,W2,W).
	
demos :-
	bagof(W-T,xxx(W,T),L),
	demoReport(L).

demoReport([W1-T1|Rest]) :-
	demoReport1([W1-T1|Rest],[]).

demoReport1([],[Base-Zero|Report]) :-
	stats(Zero,S0),
	member(average-A,S0),
	demoReport2([Base-Zero|Report],A).

demoReport1([W-T|Rest],Report0) :-
	pushA(W,T,Report0,Report),
	demoReport1(Rest,Report).

demoReport2(X,A) :-
	member(What-Amounts,X),
	stats(Amounts,Stats),
	member(average-Average,Stats),
	member(error-Error,Stats),
	Out1 is integer(100*Average/A),
	Out2 is integer(Error*100/Average),
	print(What),write(' '), print(Average), write(' +/- '), print(Error),
             write(' = '), print(Out1), write(' +/- '), 
               write(Out2),write('%'),nl,
	fail.
demoReport2(_,_).

sumA([],0).
sumA([H|T],N) :- sumA(T,N0), N is N0 + H.

getA(X,Value,_Default,L) :- member(X-Value,L),!.
getA(_,Default,Default,_).

putA(X,Value,L0,L) :- putA1(L0,X,Value,L).

putA1([],X,Value,[X-Value]).
putA1([H-_|T],H,Value,[H-Value|T]) :- !.
putA1([H|T],X,Value,[H|T1]) :- putA1(T,X,Value,T1).

pushA(X,Item,L0,L) :-
	getA(X,Old,[],L0),
	putA(X,[Item|Old],L0,L).

incA(X,Inc,Value,L0,L) :- 
	getA(X,Old,0,L0),
	Value is Old + Inc,
	putA(X,Value,L0,L).

random_order([],[]).
random_order(L0,[Item|Rest]) :-
	random_delete(L0,Item,L1),
	random_order(L1,Rest).

random_delete(L0,Item,L) :-
	length(L0,Max),	
	Pos is random(Max) +1,
	oneLessN(1,Pos,L0,Item,L).

oneLessN(Pos,Pos,[H|T],H,T) :- !.
oneLessN(N0,Pos,[H|T],Item,[H|Rest]) :- 
	N is N0 + 1,
	oneLessN(N,Pos,T,Item,Rest).

oneLess([A|B], A, B).
oneLess([A|B], C, [A|D]) :- oneLess(B, C, D).

random_members(List,N,Members) :-
        length(List,Max),
        random_numbers(N,Max,Numbers),
        random_members1(Numbers,1,List,Members).

random_members1([],_,_,[]).
random_members1([N|Rest],N,[H|T],[H|Others]) :- !,
        N1 is N + 1,
        random_members1(Rest,N1,T,Others).
random_members1([H|Rest],N,[_|T],Out) :-
        N1 is N + 1,
        random_members1([H|Rest],N1,T,Out).

random_numbers(N,Max,S) :-
        set_new(S0),
        random_numbers(N,Max,S0,S).

random_numbers(0,_,S,S) :- !.
random_numbers(N,Max,S0,S) :-
        Random is random(Max) + 1,
        (set_newel(S0,Random,S1)
        ->      N1 is N - 1,
                random_numbers(N1,Max,S1,S)
        ;       random_numbers(N,Max,S0,S)).

set_new([]).



%----- set add new element
% fails if new element already in set.
set_newel([], El, [El]).
set_newel([H|T], El, Add) :-
        compare(Order, H, El), newel(Order, H, T, El, Add).

newel(<, H, T,  El, [H|Add]) :- set_newel(T, El, Add).
%newel(=, H, T, _El, [H|T]).
newel(>, H, T,  El, [El,H|T]).


stats(L, [n-N, min-Min,max-Max, sum-Sum,average-Average, sd-Sd, error-Error]) :-
        stats(L,N,Min,Max,Sum,Average,Sd,Error).
 
stats([H|T],N,Min,Max,Sum,Average,Sd,Error) :-
        SumSquared0 is H*H,
        stats1(T,H,H,H,SumSquared0,Min,Max,Sum,SumSquared),
        length([H|T],N),
        Average is Sum / N,
        (N = 1
        ->      Var = 0, Sd = 0, Error = 0
        ;       Var is ((N * SumSquared) - (Sum*Sum))/(N*(N-1)),
                Sd is sqrt(Var),
                Error is (Sd/sqrt(N - 1))
                ).
 
stats1([],Min,Max,Sum,SumSquared,Min,Max,Sum,SumSquared).
stats1([H|T],Min0,Max0,Sum0,SumSquared0,Min,Max,Sum,SumSquared) :-
        Min1 is min(H,Min0),
        Max1 is max(H,Max0),
        Sum1 is Sum0 + H,
        SumSquared1 is SumSquared0 + (H*H),
        stats1(T,Min1,Max1,Sum1,SumSquared1,Min,Max,Sum,SumSquared).
 

