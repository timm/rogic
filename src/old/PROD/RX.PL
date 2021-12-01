%%%% Optimization

rx(Rx) :-
	rx(round,7,50,1000,1.05,1,Rx).

rx(Prefix,Stop,Cache,Repeats,Epsilon,Beam,Rx) :-
	rx1(Prefix,Stop,0,Cache,Repeats,
	    -999999999,Epsilon,Beam,[],Rx).

rx1(Prefix,Stop,Generation,Cache,
    Repeats,Last,Epsilon,Beam,Rx0,Rx) :-
	b_(init(Cache),_,Low0),
	b_(init(Cache),_,High0),
	concat_atom([Prefix,Generation,'.','csv'],F),
	format('~w) ',F),
        tell(F),
	lurching(Repeats,Rx0,Low0,Low,High0,High,0,Sum),
	told,
	Average is Sum/Repeats,
	dists(Low,High,Dists,Max),
	backbone(Dists,Beam,Max,Rx0,Rx1),
	format(' ~p using ~p and\n',[Average,Rx0]),
	((abs(Last/Average)>Epsilon,
	 Generation < Stop)
        -> GenerationNext is Generation+1,
	   rx1(Prefix,Stop,GenerationNext,Cache,
	       Repeats,Average,Epsilon,Beam,Rx1,Rx)
        ;  Rx=Rx0).
	
lurching(0,_,L, L,H, H,S,S).
lurching(N,Rx,L0,L,H0,H,Sum0,Sum) :-
	N>0,
	spit(N,50,'.'),
	N1 is N - 1,
	once(lurchOver(estimate(A,_,_),Rx,How)),
	print(A),nl,
	Sum1 is Sum0+A,
	NegA is -1*A,
	badd(A=How,H0,H1),
	badd(NegA=How,L0,L1),
	lurching(N1,Rx,L1,L,H1,H,Sum1,Sum).

dists(Low,High,Out,Max) :-
	items(Low,-,LowItems),
	items(High,+,HighItems),
	append(LowItems,HighItems,Items),
	dist(Items,Out,Max).

items(B,Sym,Ws) :-
	b_(contents=C,B,B),
	bagof(AB,C^Sym^items1(C,Sym,AB),Ws).

items1(W,Sym,x(oneOf(A),B,Sym)) :-
	member(_=w(_,L),W),
	member(oneOf(A)=B,   L),
	goal(A,B).

backbone(HCD,Beam,Max,Rx0,Rx) :-
	b_(init(Beam),_,Candidates0),
	backbone1(HCD,Max+1,Candidates0,Candidates),
	b_(values(Rx1),Candidates),
	koset_adds(Rx1,Rx2), % gets rid of multiple references to the same key
	append(Rx0,Rx2,Rx3),
	sort(Rx3,Rx).
        
backbone1([],_,B,B).
backbone1([x(A,B,-)=F1,x(A,B,+)=F2|T1],Max) --> !,
	{R     is F1/F2},
	badd(R=(A=B)),
	backbone1(T1,Max).
backbone1([x(A,B,-)=F|T1],Max) --> !,
	{R  is Max*F},
	badd(R=(A=B)), 
	backbone1(T1,Max).
backbone1([_|T],Max) -->  backbone1(T,Max).

x(L,Key=Values) :-
	member(Key=_,L),
	whatevered(Blank,Key,_,Value),
	bagof(Value,Blank^Blank,Values).
