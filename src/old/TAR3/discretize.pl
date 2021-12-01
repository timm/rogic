discretize(Rel) :-
	write('% discretize'),
	fields(Rel,Fields),
	flag(Rel,N,N),
	blank(Rel,New),
	blank(Rel,Doomed),
	arg(1,Doomed,Id),
	between(1,N,Id),
	spit(Id,50,'.'),
	Doomed,
	discretize1(Fields,1,Rel,Doomed,New),
	retract(Doomed),
	assert(New),
	fail.
discretize(_) :- nl.

discretize1([],_,_,_,_).
discretize1([Field|Fields],N,Rel,Doomed,New) :-
	arg(N,Doomed,Num),
	range(Rel,Field,Range,_,Below,Above),
	Num >= Below,
	Num < Above, !,
	arg(N,New,r(Rel,Range)),
	N1 is N + 1,
	discretize1(Fields,N1,Rel,Doomed,New).
discretize1([_|Fields],N,Rel,Doomed,New) :-
	arg(N,Doomed,Val),
	arg(N,New,Val),
	N1 is N +1,
	discretize1(Fields,N1,Rel,Doomed,New).

portray(r(A,B)) :- rPrint(A,B).

rPrint(Rel,Range) :-
	range(Rel,Name,Range,I,N0,N),
	format('~p <= ~p < ~p {~p}',[N0,Name,i(N),I]).

portray(i(N)) :- infPrint(N).

infPrint(P) :- `maxNumber=Inf, P =:= Inf, !,write(inf).
infPrint(P) :- write(P).

