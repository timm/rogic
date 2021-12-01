% use the wme
wmeSetUp :- dynamic wme/2.
 
% empty all contents of Wmes
wmeReset(_,_) :-
	retractall(wme(_,_)).
 
%return a fresh wme
wmeInit(_) :- wmeReset(_,_).
 
wmeA(X,Y,Z):- a_inserts(X,Y,Z).
wmeR(X,Y,Z):- a_deletes(X,Y,Z).
wmeF(X,Y,Z):- a_finds(X,Y,Z).

a_inserts(Pairs,T0,T):-
	%is_splay(T0),
	inserts(Pairs,T0,T).
	%is_splay(T).

inserts([],T,T).
inserts([Key-Value|Rest],T0,T):-
	insert(Key-Value,T0,T1),
	inserts(Rest,T1,T).

insert(Key-Value,T,T) :-
	asserta(wme(Key,Value)).

a_deletes(Pairs,T0,T):-
	%is_splay(T0),
	deletes1(Pairs,T0,T).
	%is_splay(T).

a_finds(Pairs,X,Y):-
	%is_splay(X),
	look(Pairs,X,Y).
	%is_splay(Y).

look([],T,T).
look([Key-Value|Rest],T0,T):-
	wme(Key,Value),
	look(Rest,T0,T).
	

deletes1([],T,T).
deletes1([Key-_|Rest],T0,T):-
	retract(wme(Key,_)),
	deletes1(Rest,T0,T).


printa(_) :-
	listing(wme).
	
is_valid(_) :-
	wme(X,Y),
	\+ ground(wme(X,Y)),
	!,
	fail.
is_valid(_).


