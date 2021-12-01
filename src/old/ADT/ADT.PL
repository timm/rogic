% an adt shell
% tim@menzies.com, 1998

% adt support code

% a simple test engine. you supply facts of the form test(A,B,C)
% where A is a unique id, B is something to be reduced, and
% C is what should come back after the reduction.
tests :- 
	listing(test),
	nl,
	test(X,Y,Expected), 
	(r(Y,Out)
        -> Actual=Out
        ;  Actual='call to r/2 failed'), 
	print(X), 
	(Expected=Actual
        -> write(': PASSED. Found ['),
           write(Actual),
	   write('].')
        ;  write(': FAILED.'),
	   write(' Expected=['),
	   print(Expected),
	   write(']. Actual=['),
	   write(Actual),
	   write('].')),
	nl,
	fail.
tests.

% macros
% ======
% shorthand for recording what are the right return types
:- op(800,fx,*).
term_expansion(* X = Y,Out) :- sigs(* X = Y,Out).

sigs(X,All)                 :- bagof(One,X^sig(X,One),All).
sig(* X = Y, returns(F,Y))  :- functor(X,F,_).

term_expansion((:- usePattern(Pattern,X=Things,Swaps)),
               Out) :-
	applyPattern1(Pattern,X,Things,Swaps,Out).

% secret prolog magic: don't even bother to read below
sub(X,X).
sub(X,Out) :- 
	functor(X,_,Arity),
	between(1,Arity,Nth),
        arg(Nth,X,Y),
        sub(Y,Out).

applyPattern1(P,X,Things,Swaps,Out) :-
	bagof(One,P^X^Things^Swaps^
                    applyPattern2(P,X,Things,Swaps,One),
              Out).

applyPattern2(P,X,Things,Swaps,One) :-
	member(X,Things),
	rewrite(P,Swaps,One).

rewrite(P,Swaps,Out):- 
	clause(pattern(P,Head),Body), 
	swap((Head :- Body),Swaps,Out).

swap(X,Swaps,Y)   :- X =.. L0, once(maplist(swap1(Swaps),L0,L1)), Y =.. L1.

swap1(_,H,H)      :- var(H).
swap1(Swaps,H0,H) :- member(H0/H,Swaps).
swap1(_,H,H)      :- atomic(H).
swap1(Swaps,H0,H) :- swap(H0,Swaps,H).



