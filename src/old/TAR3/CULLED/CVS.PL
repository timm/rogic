% read it stuff

csv(Rel) :-
	B=bucket(_,_),
	retractall(B),
	+[Rel],spit(/),
	forall(sortIntoBucket(Rel,B), assert(B)).

one(Rel,X) :- blank(Rel,X), X.
columns(Rel,C) :- fields(Rel,L), length(L,C).

dd(C,Rel,[fields(Rel,Fields),blank(Rel,One)|Rest]) :-
	flag(n(Rel),_,0),
	mostC2l(C,L),
	Fields=[id|L],
	length(Fields,A),
	functor(One,Rel,A),
	bagof(h(Rel,Item,Pos),
		L^nth1(Pos,Fields,Item), 
	      Rest).

eg(C,Rel,Datum) :-
	mostC2l(C,L),
	flag(n(Rel),N,N+1),
        spit(N,50,+),
	Datum =.. [Rel,N|L].

mostC2l((X,Y),[X|Z]) :- !,mostC2l(Y,Z).
mostC2l(_,[]).

f([],_).
f([H|T],One) :- f(H,One), f(T,One).
f(F >= T,X)  :- f(F=V,X), V >= T.
f(F < T,X)   :- f(F=V,X), V <  T.
f(`F=V,X)    :- `F=F1, f(F1=V,X).
f(`F,X)      :- atomic(F), `F=F1, f(F1=1,X).
f(`Do/F,X)   :- f(`F=V,X), call(Do,V).
f(F=V,X) :-
	functor(X,Func,_),
	h(Func,F,N),
	arg(N,X,V).

goodColumn(Rel,Name,Pos) :-
	`skip=Bad,
	fields(Rel,Fields),
	nth1(Pos,Fields,Name),
	not(member(Name,Bad)).

cols(Rel,Pos,Ns) :-
	goodColumn(Rel,Name,Pos),
	bagof(N,Name^Rel^col(Rel,Pos,N),Ns).
col(Rel,Pos,N) :-	
	one(Rel,One),
	arg(Pos,One,N).

any(Rel,Com) :- any(Rel,Com,_).

any(Rel,Com,One) :-
	flag(n(Rel),Eg,Eg),
	between(1,Eg,Id),
	blank(Rel,One),
	arg(1,One,Id),
	One,
	f(Com,One).