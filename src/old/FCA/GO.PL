term_expansion((+X :- Y),All) :-
	bagof(One,X^Y^xpand((X :- Y),One),All).

term_expansion(X=Y,(type(X,Z) :- member(Z,Y))).

xpand(X,_)               :- var(X),!,print(user_error,hasVar),nl, fail.
xpand((X :- Y),i(X,Z))   :- !,xpand(Y,Z).
xpand((X0,Y0),Z)         :- !,(Z0=X0;Z0=Y0), xpand(Z0,Z).
xpand(X,X)               :- X =.. [T,V], type(T,V),!.
xpand(X,_)               :- print(user_error,unknown(X)),nl,fail.

attributes(All) :- setof(One,X^i(X,One),All).
objects(All)  :- setof(One,X^i(One,X),All).
oa(O,Out) :- 
	objects(All),member(O,All), 
	setof(One,O^i(O,One),Out).


subs([H|T],[H|Rest]) :- subs(T,Rest).
subs([_|T],Out) :- subs(T,Out).
subs([],[]).

biggun(O1/O2=X) :-
	oa(O1,All1), 
	downTo(All1,I),
	oa(O2,All2), 
	O1 @> O2,
	subs(All1,X),
	length(X,I),
	subs(All2,X).

downTo(L,X) :- length(L,N),between(1,N,Z), X is N-Z+1.


all(All) :- setof(One,one(One),Temp),reverse(Temp,All).

borrower = [checkIn, checkOut].
library  = [checkOut].
source   = [borrower,library].
input    = [book,card].
action   = [checkIn,checkOut].
output   = [book,card].
dest     = [borrower,clerk].

+borrower(checkIn) :- 
	source(borrower), 
	input(book), 
	action(checkIn), 
	dest(clerk).
+borrower(checkOut) :- 
	source(borrower), 
	input(card), 
	action(checkOut), 
	output(book), 
	output(card), 
	dest(borrower).
+library(checkOut) :- 
	source(library), 
	input(book), 
	action(checkOut), 
	output(book), 
	output(card), 
	dest(borrower).





