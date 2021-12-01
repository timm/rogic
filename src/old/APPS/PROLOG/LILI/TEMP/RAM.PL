is_wme(X) :- wme(_,X),!.
is_wme(X) :- print(notAWme(X)),nl, fail.

wmeSetUp :- wmeGroups(P), wme(Type,W), \+ member(Type,P),
	    print(badWmeType(Type,wme(Type,W))), nl, fail.
wmeSetUp :- wme(_,W), functor(W,F,A), (dynamic F/A),  fail.
wmeSetUp.

wme_also(X,Y) :-
	wmeGroups(All),
	after(X,All,Tail),
	member(Y,[X|Tail]).

wmeClear :- wmeGroups([H|_]), wmeClear(H,_).
wmeClear(This) :- wmeClear(This,_).

wmeClear(What,This) :- 
	wme_also(What,Also),
	wme(Also,W), 
	functor(W,This,_), 
	wmeRetract(W), 
	fail.
wmeClear(_,_).

wmeRetract(W) :- is_wme(W),retract(W), fail.
wmeRetract(W) :- is_wme(W),clause(W,Y), retract(( W :- Y)), fail.
wmeRetract(_).

wmePrint       :- wmeGroups([H|_]), wmePrint(H).
wmePrint(Topic) :- 
        wme_also(Topic,Also),
	wme(Also,Term),
	functor(Term,Functor,Arity),
	nl, write('% '), write(Functor/Arity),
	listing(Functor/Arity),
        fail.
wmePrint(_).

wmeGet(X) :- is_wme(X), X.
