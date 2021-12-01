% num2.pl

demo :- tell('num2.out'), ignore(demo1), told.

demo1 :- demo2, fail.
demo1.

demo2 :-
	member(X,["23", " 23", "23.3 ", "34.5671 "]),
	num(N,X,[]),
	format('"~s" = [~10f]\n',[X,N]).

space --> [32].
tabb  --> [9].
dot   --> [46].
zero  --> [48].
one   --> [49].
two   --> [50].
three --> [51].
four  --> [52].
five  --> [53].
six   --> [54].
seven --> [55].
eight --> [56].
nine  --> [57].

ascii2Number(N0,N) :-
	zero([Zero],[]),
	N is N0 - Zero.

blank --> space | tabb.

whitespace --> []
            | blank, whitespace.

digit --> 
	one | two | three | four
        | five | six | seven | eight | nine | zero.

digitNumber(N,[N0|L],Out) :-
	digit([N0|L],Out),
	ascii2Number(N0,N).

digits(N,0) --> digitNumber(N).
digits(N,P) -->
	    digitNumber(N1), digits(N2,P0),
	    {P is P0 + 1,
	     N is N1*10^P + N2}.

num1(N) --> digits(N,_).
num1(N) --> digits(N1,_), dot, digits(N2,P), {N is N1 + N2/10^(P+1)}.

num(N) --> whitespace,num1(N),whitespace.


