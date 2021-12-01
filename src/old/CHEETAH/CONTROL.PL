% test for things already in the knowns

proves(N,F1,F2,X) :-
	tell(F1),
        names(X),
        told,
        tell(F2),
	forall(between(1,N,_),proveC(X)),
	told.

prove(X) :- 	
	go([],[X=t],_,Y),o([findings,reasons],Y,_).

goP(Before,Try) :-
	R=100,
	print(repeats(R)),nl,
	profile(forall(between(1,R,_),
                       go(Before,Try,_,_)),
                plain,
                20).

go(Before,Try,P,W1) :-
        maplist(vs,Try,Goals),
	retractall(computedRuleValue(_,_,_)),
	o([ new
            ,maybeResetSeed
            ,inputs is Before
            ,goals is Goals
            ,seeJaneRun

            ],_,W0),
	%nl,nl,
	thrash(W0,W),
	o([policies,proved(P)],W,W1).
%	show(W1).
	
thrash --> o init, o tries1 = Loops, thrash(Loops),!.

thrash(0) --> [].
thrash(_) --> o maxxed.
thrash(M) -->
	{M>0,N is M - 1},
	o init,
	o tries2 = Loops,
	thrash1(Loops), 
	thrash(N).

thrash1(0) --> [].
thrash1(_) --> o maxxed,!.
thrash1(M) --> 
	{M>0,N is M -1},  
	todoDone,  
	update, 
	o report, 
	thrash1(N).

todoDone   --> 
	o resetBeliefs,
	o todo^Todo^[],
	o done^Done^[],
	todoOrNotTodo(Todo), 
	todoOrNotTodo(Done).

todoOrNotTodo([])    --> !.
todoOrNotTodo(Goals) --> 
	{rone(Goals,X=Goal0,Rest),
         v(goal(X),Goal,Goal0)}, 
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
	(o succinct=n -> o shout(Comment); {true}).

update1(=,_,'  ') --> [].
update1(<,_,'  ') --> [].
update1(>,N,'>>') --> 
	o maxProved is N, 
	o known = K, 
	o best is K.

proveC(L) :-
	member(goal=G,            L),
	member(options=L1,        L),
	member(debating=L2,       L),
	member(costT=CostT,       L),
	member(chancesT=ChancesT, L),
	go([],[G=t],_,Wme),
	o([findings,reasons,best=Best,orsCostCombine=OCC],Wme,_),
	member(G=V,Best),
	v(cost,Cost,V),
	v(chances,Chances,V),
	Dat=dat(Best,L1,Cost,Chances,CostT,ChancesT,L2),
        nl,print(Cost), write(','),print(Chances),write(','), 
        print(OCC),write(','),
	forall(detail(1,Dat,_XX=YY),format('~w,',[YY])).

detail(1,dat(_,_,_,_,_,_,L2),S=N) :-
	member(RuleId,L2),
	member(What,[cost,chances]),
	getComputedRuleValues(What,RuleId,N),
	sformat(S,'~w~w',[RuleId,What]).

detail(1,dat(Best,_L1,_,_,_,_,_),One=X) :-
        label(known,One),
        One \= true,
	(member(One=V,Best) 
        -> v(value,X,V)
        ;  X=xx).

classOf(N,T,_ ,Hi,Hi) :- N >= T,!. 
classOf(_,_,Lo,_,Lo).

names(L) :-
	%member(options=L1,        L),
	member(debating=L2,       L),
	write('cch,cCH, Cch,CCH.'),nl,nl,
        format('orsCostCombine : sum,max\n',[]),
        forall((member(RuleId,L2),
                member(What,[cost,chances])),
               format('~w~w : continuous\n',[RuleId,What])),
	forall(label(known,Opt),
               format('~w : t,f,xx\n',[Opt])),
	 nl.      



