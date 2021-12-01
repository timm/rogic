% given some inputs, find what outputs can be consistently made

wme(y(_,_)).
wme(used(_)).

clear    :- forall(wme(X), retractall(X)).
dynamics :- forall(wme(X),(functor(X,F,A), (dynamic F/A))).

:- dynamics.

run :- chaining(0),clear,inputs(I), maplist(assertfv,I,_),ids(Ids),chaining(1),fchain(Ids).

assertfv(X=V,_) :- assert(y(X,V)).

ids(L) :- findall(Id,rule(Id,_),L0), rlmembers(L0,L).

rlmembers(L0,L) :-  bagof(One,rlmember(L0,One),L).

rlmember([H|T],Item) :- 
	length([H|T],L),
	Pos is random(L), 
	rlmember1(Pos,[H|T],Y,New), 
	(Item=Y;rlmember(New,Item)).

rlmember1(0,[H|T],H,T).
rlmember1(N0,[H|T],Out,[H|Rest]) :- N0 > 0, N is N0 - 1, rlmember1(N,T,Out,Rest).

fchain(Ids) :- 
	member(Id,Ids), 
	%chaining(Id),
	rule(Id,X), 
	ok(Id,X),
	%chaining(ok),
	lhs(Id,So), 
	%chaining(yes),
	then(Id,So),
	fchain(Ids).
fchain(_).

chaining(Id) :- write(' '),print(Id),flush_output(user).

ok(Id,X)     :- \+ used(Id), \+ y(X,_).
then(Id,X=V) :- assert(used(Id)), assert(y(X,V)),print(y(X,V)),nl.

term_expansion((:- m(X),Y),L) :- findall(X,Y,L).

ifThen(Out) :-	
	clause(x(X,_,V),Body),
	change(Body,If),
	flag(id,Id,Id+1),
        (Out=rule(Id,X)
        ;Out=(lhs(Id,X=V):-If)).

change((X0,Y0),(X,Y)) :- !, change(X0,X), change(Y0,Y).
change(x(X,_,V),y(X,V)).

:- discontiguous rule/2, lhs/2.

:- m(X), ifThen(X).








