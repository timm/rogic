demo(N) :- demo(N,_,_).

demo(1) --> o get, o show.
demo(2) --> o get, o  r9cost=X, say(X).

demo(3) --> 
	{wmeReset},
	bagof(X=L,o(range(X,L)),Ranges),
	flag(counter,_,0),
	o classify(Ranges,C,X,Y),
	{inc(C,X,Y,_)},
	flag(counter,Old,Old+1),
	{memo(Old)},
	fail.
demo(3) --> [].
	
demo(4) -->
	demo(3),
	{normalizeF,compareF}.

normalizeF :-
	classSizes(S),
	retract(data(Class,B,C,F0)),
	member(Class/Total,S),
	F is F0/Total,
	assert(data(Class,B,C,F)),
	fail.
normalizeF.
	
compareF :-
	retractall(delta(_,_,_,_)),
	data(Class,B,C,F0),
	Class \= cCH,
	data(cCH,B,C,F1),
	F is F1/F0,
	assert(delta(Class,B,C,F)),
	fail.
compareF.

goodDeltas :-
	member(Class,['Cch','CCH',cch]),nl,
	bagof([N,Class,B,C],F^goodDelta(N,delta(Class,B,C,F)),L0),
	sort(L0,L),
	forall(member(X,L), (print(X),nl)),fail.
goodDeltas.


goodDelta(N,delta(Class,B,C,F)) :-
	member(N,[1.5,2,2.5,3,3.5]),
	delta(Class,B,C,F),
	F > N.
	
classSizes(L) :-
	bagof(X,classSize(X),L).

classSize(C/Size) :-
	o range(class,L),
	member(C,L),
	bagof(1,C^o(class=C),L1),
	length(L1,Size).


inc(C,X,Y,New) :- 
	%print(inc(C,X,Y)),nl,
	retract(data(C,X,Y,Old)), !, 
	New is Old + 1, 
	assert(data(C,X,Y,New)).

inc(C,X,Y,1) :- 
	assert(data(C,X,Y,1)).
