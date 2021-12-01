:- load_files([plog],[silent(true),if(changed)]).

a=aa(x,g,l).


a,mm(1).
a,c(X),inline :- `x>>X.
a,d(X,Y)      :- `x>>X, `x << Y.
a,e(X,Y)      :- `[x>>X, x << Y], print(?g), love(?l), hate(?m).
a,f(1,l),inline :-
	!x is ?x + 1 / ?g + min(?g,?l),
	append(?g,?l,!x),
	length(?x,3), % note- not !x
	!x is ?x * 3,
	print(?x),
	?x > ?g,
	!x = [1],
	append([2],?x,!x).
        %!x=[1|?x] wont wok- ?x is a symbol not a list
a,g         :- !x is ?x + 1.
a,h         :- `f(1,l), z`kk, `d(1,2), print(?x).
a,i(X,Y,Z)  :- print(?X), `X >> Y, `f(AA,BB), `Z.

% mythical polymorphic call
%a,j(X,Y,Z)  :- X`a(Y,Z).