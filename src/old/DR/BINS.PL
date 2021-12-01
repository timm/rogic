%bin(size,n,bins

binAdd(X,bin(S,N,

set_addel([], Key, [El]). 
set_addel([Key1=H|T], Key2=El, Add) :- 
	compare(Order, Key1, Key2), 
	     addel(Order, H, T, El, Add).

addel(<, H, T,  El, [H|Add]) :- set_addel(T, El, Add).
addel(=, H, T, _El, [H|T]). 
addel(>, H, T,  El, [El,H|T]).

incBin(X,bin(N0,[A0,B|Old]),bin(N,[A,B|Rest])) :- 
	     X>A, !,
	     N is N0 + 1,
	     A is A0 + 1.
incBin(X,bin(N,[A,





