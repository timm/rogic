% read it stuff

relation :-
	`relation=R, relation(R).

relation(Rel) :-
	format('% [~p]\n',[Rel]), 
	write('% loads'),
	+[Rel], nl,
	buckets(Rel),
	ranges(Rel).
	
dd(C,Rel,[(:- dynamic Rel/A), fields(Rel,Fields),
	  blank(Rel,One)|Rest]) :-
	flag(Rel,_,0),
	mostC2l(C,L),
	Fields=[id|L],
	length(Fields,A),
	functor(One,Rel,A),
	bagof(h(Rel,Item,Pos),
		L^nth1(Pos,Fields,Item), 
	      Rest).

eg(C,Rel,Datum) :-
	mostC2l(C,L),
	flag(Rel,N,N+1),
        spit(N,50,'.'),
	Datum =.. [Rel,N|L].

mostC2l((X,Y),[X|Z]) :- !,mostC2l(Y,Z).
mostC2l(_,[]).

goodColumn(Rel,Name,Pos) :-
	`skip=Bad,
	fields(Rel,Fields),
	nth1(Pos,Fields,Name),
	not(member(Name,Bad)).

one(Rel,X) :- blank(Rel,X), X.
columns(Rel,C) :- fields(Rel,L), length(L,C).

any(Rel,Com) :- any(Rel,Com,_).

any(Rel,Com,One) :-
	flag(Rel,Eg,Eg),
	between(1,Eg,Id),
	blank(Rel,One),
	arg(1,One,Id),
	One,
	f(Com,One).