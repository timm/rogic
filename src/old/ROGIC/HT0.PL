% things to pass around between goals
wme+[].

:- dynamic a/5, best/1.
:- index(a(1,1,1,0,0)).

ror(L,In,Out):- 
	any(L,Out=In+X,_), 
	X.

rand([],Out,Out).
rand([H|T],In,Out) :-
	any([H|T],Temp=In+X,Rest),
	X,
	rand(Rest,Temp,Out).

any([H|T],X,Rest) :-
	0 is random(2)
	->(X=H,Rest=T
          ;Rest=[H|Others],
	   any(T,X,Others))
        ; (Rest=[H|Others],
           any(T,X,Others)
          ;X=H,Rest=T).

%:- ht0(5,0,2,[1/sad,1/rich]).

ht0@[i 
    ,nGoals=0
    ,maxProved=0
    ,goalsProved=[]
    ,goals
    ,nProved
    ].

goal+[weight=1,id,goal].

ht0+ht0(Runs,G0)=Max--> 
	o new(ht0)
	o i := Runs
	o prep(G0,G)
	o goals := G
	o run
	o maxProved=Max.
	
ht0*prep(G0) = G --> 
	o +nGoals so N,
	{o([new(goal),id := N,goal := G0],G)}.
	
ht0+run   --> o i=0,!.
ht0+run   --> o notes o reset o proves o -i o run.
ht0+reset --> {retractall(a(_,_,_,_,_))},nProved := 0.
ht0+notes --> 
	o nProved=NProved
	o nGoals=All,
	New is NProved/All,
	o maxProved=Old,
	(New =< Old -> true; newBest(New)).
ht0+newBest(New) -->
	o maxProved is New,
	{retractall(best(_)),
	 forall(a(A,B,C,D,E),
	        assert(best(A,B,C,D,E)))}.     
ht0+proves -->
	o sort(goals) 
	o goals = G0
	{o(new(wme),Wme)},
	o goalsProved=[]
	o proves(G0,Wme,G)
	o goals := G.
	
ht0+proves([],_,[]).
ht0+proves([H0|T0],Wme0,[H|T]) -->
	o self(Old,New),
	{o(proves(G0,Wme0,G,Wme))},
	o proves(T0,Wme,T).
	
goal+proves(Old,Wme0,New,Wme) -->
	o prove(Wme0,Wme)
	-> o inwc(W)
	   o goal=G,
	   {o([goalsProved<<G,+nProved],Old,New)}
	;  o decw(W),
	   Old=New,
	   Wme0=Wme.
	   
goal+inc(X) --> X is 1 + random(10^4)/10^6.
goal+incw   --> o inc(X) o weigth + X.
goal+decw   --> o inc(X) o weigth - X.
goal+prove(Wme0,Wme) -->
	o goal=G
	o id=Id
	{o([new(path),id=Id,goal=G,wme=Wme0,ascend(G),wme=Wme],P)}.

path+[time=1,goal,route=[],wme].
	
path+ascend(Goal0) -->
	o id=Id,
	{canonical(Goal0,Goal),
	assume(Id,Goal,Addits,DOB)},
	o noLoops(DOB,Goal)
	o ascend1(Addits,Goal0).

path+noLoops(DOB,Goal) -->
	o route was Old now New,
	{now(Old,T=Now,New)},
	\+ looping(DOB,Goal,Now).

now([],_=[],[]).
now([T=Now|Rest],T=Now,Rest) :-  !.
now([Then|Rest0],T=Now,[Then|Rest]) :- now(Rest0,T=Now,Rest).

path+ascend1(0,_).
path+ascend1(+,G) --> o goal o push(G) o kb(G).

path+push(G) -->
	o route was [T=L|Rest] 
	        now [T=[G|L]|Rest].

looping(=,Goal,Now) :-  member(Goal,Now).

canonical(X,A of O @ T = V) :- about(X,A,O,V,T).

about(A of O @ T = V,A,O,V,T).
about(not(X),val,X,f,_).
about(X,val,X,t,_) :- atomic(X).

assume(N,A of O @ T = NewV,0,Order) :-
    a(A,O,T,N1,OldV), !, OldV = NewV,
    compare(Order,N,N1).
assume(N,A of O @ T = V,+,=) :- assert(a(A,O,T,N,V)).
assume(N,A of O @ T = V,_,_) :- retract(a(A,O,T,N,V)), fail.

fx(+,  1,  1). fx(+, -1, -1). 
fx(-, -1,  1). fx(-,  1, -1). 