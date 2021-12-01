f([],_).
f([H|T],One) :- f(H,One), f(T,One).
f(F >= T,X)  :- f(F=V,X), V >= T.
f(F < T,X)   :- f(F=V,X), V <  T.
f(`F=V,X)    :- `F=F1, f(F1=V,X).
f(F=V,X)     :- functor(X,R,_), h(R,F,N), arg(N,X,V).