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

blank --> space | tabb.

whitespace --> []
            | blank, whitespace.

digit --> one | two | three | four
        | five | six | seven | eight | nine | zero.

digits --> digit
        |  digit, digits.

num1 --> digits
        | digits, dot, digits.

num --> whitespace,num1,whitespace.

prove(true,      L,L) :- !.
prove((X;Y),     L0,L) :- !,(prove(X,L0,L); prove(Y,L0,L)).
prove((X,Y),   L0,L) :- !,prove(X,L0,L1), prove(Y,L1,L).
prove(X,         L,L) :- builtin(X),!,X.
prove(X,         [F|L0],L) :- functor(X,F,_),
                     clause(X,Z), prove(Z,L0,L).

builtin(X) :- predicate_property(X,built_in).
