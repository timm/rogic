% num1.pl

demo :- tell('num1.out'), ignore(demo1), told.

demo1 :- demo2, fail.
demo1.

demo2 :- member(X,["23", " 23", "23.3 "]),num(X,[]),print(num(X)),nl.

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

