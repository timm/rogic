%%%% Demonstration code
%\label{sec:fibs}
%<
fib(0,0).
fib(1,1).
fib(N,F) :-
        N > 1,
        N1 is N - 1,
        N2 is N - 2,
        fib(N1,F1),     
        fib(N2,F2),
        F is F1 + F2.
%>
%Faster one.
%<
:- dynamic fibmemo2/2.

fibM(N,F) :- retractall(fibmemo2(_,_)), fib2(N,F).

fib2(0,0).
fib2(1,1).
fib2(N,F) :- fibmemo2(N,F) -> true ; fib2a(N,F).

fib2a(N,F) :- 
        N1 is N - 1,
        N2 is N - 2,
        fib2(N1,F1),    
        fib2(N2,F2),
        F is F1 + F2,
        assert(fibmemo2(N,F)).
%>
%%Demo code for fib
%<
egfib :- % \tion{egfig.spy}
	L=[15,17,19,21,23],
	L1=[15,20,25,30,35,40,45,50],
	egfib1(X,L,1,fib(X),fib(X,_)),
	egfib1(X,L1,100,fibM(X),fibM(X,_)),
	egfib1(X,L1,100,lurch(fib(X)),lurch(fib(X,_))).

egfib1(X,L,N,Show,Goal) :- 
	nl,forall(member(X,L),(
	           times(N,Goal,T),
	           format('~20> takes ~w secs\n',[Show,T]))).
	       
%	N=19,	
	%10*fib(N,_)/lurch(fib(N,_)),nl,
	%100*fibM(N,_)/lurch(fib(N,_)).
%>
%\SRC{egfib.spy}{From \tion{figs}.}