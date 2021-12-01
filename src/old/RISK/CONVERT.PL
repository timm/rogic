:- write(':- go. % generates a file all.pl'),nl.

convertWhat(Table,All,db(DB),EG) :- 
	db(X), X =.. [Table|Items], length(Items,Arity),
	maplist(downcases,Items,Names0),
	maplist(string_to_atom,Names0,Names),
	DB =.. [Table|Names],
	functor(EG,Table,Arity),
	bagof(Pos,Items^Item^(nth1(Pos,Items,Item),idp(Item)),All).

downcases(X,Y) :- maplist(downcase,X,Y).

tail(T,[_|T]).
tail(T1,[_|T2]) :- tail(T1,T2).

idp("ID").
idp(X) :- tail("_ID",X).

cprintln(X) :- print(X),write('.'),nl.
go :- tell('all.pl'), go1(_), fail.
go :- told.

go1(Table) :-
	cprintln((:- discontiguous db/1)),
	convertWhat(Table,All,DB,EG),
	cprintln(DB),
	EG,
	EG=..[Table|Fields0],
	convert(Fields0,1,All,Fields),
	New=..[Table|Fields],
	cprintln(New).

convert([],_,_,[]).
convert([-|T0],Pos,Want,[-|T]) :- !,
	Pos1 is Pos + 1,
	convert(T0,Pos1,Want,T).
convert([H0|T0],Pos,Want,[H|T]) :-
	(member(Pos,Want) 
	-> maplist(downcase,H0,H1),
	   string_to_atom(H1,H)
        ;  (is_list(H0)
            -> string_to_atom(H0,H)
            ;  H0=H)),
	Pos1 is Pos + 1,
	convert(T0,Pos1,Want,T).
	
downcase(-,-) :- !.
downcase(X,Y) :- X  >= 65, X =< 90, !,Y is X + 32.
downcase(X,X).
	
