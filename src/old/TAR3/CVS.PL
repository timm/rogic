% read it stuff

csv(X) :-
	B=bucket(_,_),
	retractall(B),
	+[X],spit(/),
	forall(sortIntoBucket(B), assert(B)).

one(X) :- blank(X), X.
columns(C) :- fields(L), length(L,C).

dd(C,[fields(Fields),blank(One)|Rest]) :-
	`cvsStore=CVS,
	flag(eg,_,0),
	mostC2l(C,L),
	Fields=[id|L],
	length(Fields,A),
	functor(One,CVS,A),
	bagof(h(CVS,Item,Pos),
		L^nth1(Pos,Fields,Item), 
	      Rest).

eg(C,Datum) :-
	`cvsStore=CVS,
	mostC2l(C,L),
	flag(eg,N,N+1),
        spit(N,50,+),
	Datum =.. [CVS,N|L].

mostC2l((X,Y),[X|Z]) :- !,mostC2l(Y,Z).
mostC2l(_,[]).

f(X) :- oneByOne(X).

f([],_).
f([H|T],One) :- f(H,One), f(T,One).
f(F >= T,X)  :- f(F=V,X), V >= T.
f(F < T,X)   :- f(F=V,X), V <  T.
f(`F=V,X)    :- `F=F1, f(F1=V,X).
f(`F,X)      :- atomic(F), `F=F1, f(F1=1,X).
f(F=V,X) :-
	functor(X,Func,_),
	h(Func,F,N),
	arg(N,X,V).

goodColumn(Name,Pos) :-
	`skip=Bad,
	fields(Fields),
	nth1(Pos,Fields,Name),
	not(member(Name,Bad)).

cols(Pos,Ns) :-
	goodColumn(Name,Pos),
	bagof(N,Name^col(Pos,N),Ns).
col(Pos,N) :-	
	one(One),
	arg(Pos,One,N).

oneByOne(Com) :- oneByOne(Com,_).

oneByOne(Com,One) :-
	flag(eg,Eg,Eg),
	between(1,Eg,Id),
	blank(One),
	arg(1,One,Id),
	One,
	f(Com,One).