:- [ops,o].

demo(What,Time) :-
	what2Do(A,R,F),
	!,
	member(What,[wmeLif, % always do first
                     wmeoset,
                     wmeassert,
                     wmeasserta,
                     wmesplayf,
%		     wmeavlf,
         	     wme234
	       	     ]),
	nl,print(What),nl,
	[What],
	demo(A,R,F,W),	
	is_valid(W),
	timeIt(demo(A,R,F,_),1000,Time).
	
rhat2Do(A,R,F) :-
 	A=[1-emp(1,jeff,23,11),2-emp(2,ferry,25,10),3-emp(3,stella,22,7),
           4-emp(4,ben,22,8),5-emp(5,bill,26,10),6-emp(6,wills,27,9),
           7-emp(7,david,23,11)],
        R=[4-emp(4,ben,22,8),6-emp(6,wills,27,9)],
        F=[1-emp(1,jeff,23,11),2-emp(2,ferry,25,10)].

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
	demoReport(L).

demoReport([W1-T1|Rest]) :-
	demoReport1([W1-T1|Rest],T1).

demoReport1([],_).
demoReport1([W-T|Rest],Zero) :-
	Comparison is integer(T *100/ Zero),
	print(W - T - Comparison),nl,
	demoReport1(Rest,Zero).
