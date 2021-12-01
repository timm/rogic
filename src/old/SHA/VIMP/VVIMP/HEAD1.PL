:- [ops,o].

demo(What,Time) :-
	what2Do(A,R,F),
	!,
	member(What,[wmeLif, % always do first
                    wmeavlf]), 
	nl,print(What),nl,
	[What],
	demo(A,R,F,W),	
	is_valid(W),
	timeIt(demo(A,R,F,_),100,Time).
	
what2Do(A,R,F) :-
 	A=[1-a,2-b,3-c,4-d,5-e,6-f,7-g],
        R=[4-d,6-f],
        F=[1-a,2-b].

demo(A,R,F,W3):-
	wmeSetUp,
	wmeReset(_,_),
	wmeInit(W0),
	%printsp(W0),
	wmeA(A,W0,W1),
	%printsp(W1),
	wmeR(R,W1,W2),
	%printsp(W2),
	wmeF(F,W2,W3),
	%printsp(W3),
	%print(W),nl,
	%print(W1),nl,
	%print(O),nl,
	!.

demos :-
	bagof(W-T,demo(W,T),L),
	nl,nl,nl,
%	print(L),nl,nl,nl,nl,
	demoReport(L).

demoReport([W1-T1|Rest]) :-
	demoReport1([W1-T1|Rest],T1).

demoReport1([],_).
demoReport1([W-T|Rest],Zero) :-
	Comparison is integer(T *100/ Zero),
	print(W - T - Comparison),nl,
	demoReport1(Rest,Zero).
