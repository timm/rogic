touch(Field,Wme,Value) :-
	functor(Wme,F,_), 
	fpos(F,Field,Pos), 
	arg(Pos,Wme,Value).

poke(Field,New,Wme) :-
	functor(Wme,F,_), 
	fpos(F,Field,Pos), 
	setarg(Pos,Wme,New).

wmesOk :-  
	runAllChecks, 
	findDuplicateKeys.

runAllChecks :-
	ensure(enabled,active)
	-> (all w Term)
        ;  (all w Term, ok(Term)).

findDuplicateKeys :-
	bagof(Keys-Term, w(Term,Keys),All),
	sort(All,Sorted),
	findDuplicateKeys(Sorted).

findDuplicateKeys([]).
findDuplicateKeys([K-T1,K-T2|Rest]) :-
	\+ K=[],!,
	print(duplicateKey(K,T1,T2)),nl,
	findDuplicateKeys([K-T2|Rest]).
findDuplicateKeys([_,K-T2|Rest]) :-
	findDuplicateKeys([K-T2|Rest]).

oops(Tests,Term) :-  all
	member(Test,Tests),
	\+ Test,
	print(not(Term,Test)),nl.

wmeClear(What) :-  all
	wme_also(What,Also), 
	def(Also,W), 
	retractall(W).

wmePrint :- 
	wmes([H|_]), 
	wmePrint(H,_).

wmePrint(Topic) :- all
        wme_also(Topic,Also), 
	wmePrint1(Also).

wmePrint1(Category) :- all
	nl,nl,write('%---------------------------------------'),
        nl, write('% ['),
        print(Category), write('] related facts'), nl,
	def(Category,Term), functor(Term,This,Arity), nl, 
	write('% '), print(This/Arity), nl,
	Term, print(Term), write('. '),nl.

wme_also(X,Y) :-
	wmes(All),
	once(after(X,All,Tail)),
	member(Y,[X|Tail]).

after(X,[X|T],T).
after(X,[_|T0],T) :- after(X,T0,T).
