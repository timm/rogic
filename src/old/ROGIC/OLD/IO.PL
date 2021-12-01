
io(In,Goals) :-
	scenarios(S),
	twoMembers(S,[rx/Rx1|E1],[rx/Rx2|E2]),
	delta(E1,E2,Goals,_),
	delta(Rx1,Rx2,In0,InsNow),
	append(In0,InsNow,In).

delta([],_,[],[]).
delta([X/ValX|Xs],[X/ValY|Ys],
      [X=Delta|Rest],[now(X)=ValY|Nows]) :-
	good(ValX),good(ValY),!
	compare(Comp,ValY,ValX),
	delta1(Comp,Delta),
	delta(Xs,Ys,Rest,Nows).
delta([_|Xs],[_|Ys], Rest,Nows) :-
	delta(Xs,Ys,Rest,Nows).


good(X) :- var(X),!,fail.
good(-) :- !,fail.
good(_).

delta1(<,-1). delta1(=,0). delta1(>,1).

twoItems(S,X,Y) :- 
	option(even,t),!,
 	twoMembers(S,X,Y).
twoItems(S,X,Y) :- 
	member(X,S),
	member(Y,S),
	X \= Y.
	
