ab((A,B),X) :- ab(A,X); ab(B,X).
ab(A,X) :- clause(A,B), ab(B,X).
ab(A,A) :- \+ clause(A,_).