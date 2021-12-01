% things we can run at load time

 %eval(_) :- !, fail.
 eval(nth0(A,B,_))   :- ground(A),ground(B).
 eval(nth0(_,B,C))   :- ground(B),ground(C).
 eval(append(A,B,_)) :- nonvar(A),nonvar(B).
 eval(append(_,B,C)) :- nonvar(B),nonvar(C).
 eval(append(_,B,C)) :- nonvar(B),nonvar(C).
 eval(length(L,N))   :- nonvar(L);nonvar(N).
 %eval(_ is Y)        :- ground(Y).
 eval(atomic(X))     :- ground(X).
 eval(touch(an(A),_,_,D,_)) :- ground(A), nonvar(D).
 eval(demand(X,_)) :- nonvar(X).
 eval(X)           :- class(Class,X), nonvar(Class).
