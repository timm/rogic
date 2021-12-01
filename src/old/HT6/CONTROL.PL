% test for things already in the knowns

goP(Before,Try) :-
	R=100,
	print(repeats(R)),nl,
	profile(forall(between(1,R,_),
                       go(Before,Try,_)),
                plain,
                20).


go(Before,Try,P) :-
	o([ new
            ,inputs is Before
            ,goals is Try
            ,debug is 0],_,W0),
	thrash(W0,W),
	o(proved(P),W,_).
	

thrash --> o init, o tries1 = Loops, thrash(Loops),!.

thrash(0) --> [].
thrash(_) --> o maxxed.
thrash(M) -->
	{dec(M,N)},
	o init,
	o tries2 = Loops,
	thrash1(Loops), 
	thrash(N).

thrash1(0) --> [].
thrash1(_) --> o maxxed,!.
thrash1(M) --> {dec(M,N)},  todoDone,  update, o report, thrash1(N).

todoDone   --> 
	o resetBeliefs,
	o todo^Todo^[],
	o done^Done^[],
	todoOrNotTodo(Todo), 
	todoOrNotTodo(Done).

todoOrNotTodo([])    --> !.
todoOrNotTodo(Goals) --> 
	{rone(Goals,Goal,Rest)}, 
	o reset(path),
        (do(?Goal) 
	-> o done << Goal 
        ;  o todo << Goal),
        todoOrNotTodo(Rest).

update -->
	o done=Done,
	o maxProved=BestYet,
	{length(Done,BestNow),
        compare(X,BestNow,BestYet)},
	update1(X,BestNow,Comment),
	o shout(Comment).

update1(=,_,'  ') --> [].
update1(<,_,'  ') --> [].
update1(>,N,'>>') --> 
	o maxProved is N, 
	o known = K, 
	o best is K.

