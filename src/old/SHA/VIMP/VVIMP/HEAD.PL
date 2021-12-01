
:- [ops,o].

xxx(What,Time) :-
	between(1,20,_),
	between(1,8,Size0),
	between(1,5,Tsize0),
	between(1,10,Recents0),
	Size is 10*2^Size0,
	TSize is  (2^Tsize0) * 1.5,
	Recents is 2* Recents0,
	print(Size),nl,
	print(TSize),nl,
	print(Recents),nl,
	demo(Size,TSize,Recents,What,Time),
	print(demo(Size,TSize,Recents,What,Time)), nl.

%
/*

	
demo(WmeSize,TermSize,Recents,What,Time) :-
	what2Do(WmeSize,TermSize,A,R,F),
	!,
	member(What,[
			wmeLif, % always do first
                     wmeoset,
                     wmeassert,
                     wmeasserta,
                     wmesplayf,
		     wmeavlf,
         	     wme234
	       	     ]),
	Repeats=5 , % no need to vary, unless you get
		    % divide / 0 errors
	[What],
	demo(Recents,A,R,F,W),	
	is_valid(W),
	timeIt(demo(Recents,A,R,F,_),Repeats,Time).
*/

demo(What,Time) :-
	WmeSize = 50,
	TermSize = 32, %20,
	what2Do(WmeSize,TermSize,A,R,F),
	!,
	member(What,[
			wmeLif, % always do first
                     wmeoset,
                     wmeassert,
                     wmeasserta,
                     wmesplayf,
		     wmeavlf,
         	     wme234
	       	     ]),
	Recents=10,
	Repeats=5 , % no need to vary, unless you get
		    % divide / 0 errors
	[What],
	demo(Recents,A,R,F,W),	
	is_valid(W),
	timeIt(demo(Recents,A,R,F,_),Repeats,Time).
	
what2Do(Size,TSize,A,R,F) :-
	length(A,Size),
	what2Do1(A,TSize,1),
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

/*demo(A,R,F,W4):-
	wmeSetUp,
	wmeInit(W0),
	demo1(A,R,F,W0,W4).

demo1(A,R,F,W0,W4) :-
	wmeReset(W0,W1),
	%printsp(W0),
	wmeA(A,W1,W2),
	%printsp(W1),
	wmeR(R,W2,W3),
	%printsp(W2),
	wmeF(F,W3,W4),
	%printsp(W3),
	%print(W),nl,
	%print(W1),nl,
	%print(O),nl,
	!.

*/
demo(N,A,R,F,Out) :-
	wmeSetUp,
	wmeInit(W0),
	wmeReset(W0,W1),
	wmeA(A,W1,W2),
%	wmeR(R,W2,W3),
	demo1(N,A,R,F,W2,Out),
	!.

% recency test
demo1(0,_,_,_,W,W).
demo1(N0,A,R,F,W1,W) :-
	N0 > 0,
	wmeF(F,W1,W2),
	N is N0 - 1,
	demo1(N,A,R,F,W2,W).
	
demos :-
	bagof(W-T,demo(W,T),L),
	demoReport(L).

demoReport([W1-T1|Rest]) :-
	demoReport1([W1-T1|Rest],T1).

demoReport1([],_).
demoReport1([W-T|Rest],Zero) :-
	Comparison is integer(T *100/ Zero),
	print(W - T - Comparison),nl,
	demoReport1(Rest,Zero).

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

