ht0=[scenario
    ,maxProvedPercent   := -1
    ,ins
    ,goals
    ,runs        := 4
    ,runtime
    ,i 
    ,nGoals      := 0
    ,nProved     := 0
    ,wme
    ,doDot         := f
    ,doDribble     := t
    ,doReport      := t % if t then speak
    ].
   
ht0+ht0 -->
	{flag(n,_,1),
	 flag(done,_,0),
	 Start is cputime},
	o runs = R,
	o scenario(N,Ins,Goals),
	{N < 20},
	o scenario := N,
        o ins:= Ins,
	% {format('\n\n---------------\n')},
	o zaps(Ins),
	o ht0(R,Goals),
	o runtime is cputime - Start,
	o report(N).
ht0+report(S) --> o doReport=t,!,o maxProvedPercent=P, {flag(n,N,N+1),flag(done,Done,Done+P), Av is (Done+P)/N, write(p(P)=Av),nl}, o dot(S).
ht0+report(_).
ht0+dribble(D) --> o doDribble=t,!,{say(D)}.
ht0+dribble(_).
ht0+dot(N)--> o doDot=t,!,{draw(N),get(_)}.
ht0+dot(_).
ht0+zaps(Ins) -->
	{retractall(in(_,_,_))},
	o zap(Ins,_).
ht0*zap(A of O = V) -->
	{assert(in(A,O,V))}.
ht0+ht0(Runs,G0)=Max--> 
	o i := Runs,
	o prep(G0,G),
	o goals := G,
	o run,
	o maxProvedPercent=Max.
ht0+scenario(N,In,Goals) -->
	o scenarios(S),
	{getScenario(S,N,In,Goals0),
	 noSteadies(Goals0,Goals)
	 %Goals=Goals0
	 }.
ht0*prep(AOV) = Out --> 
	o +nGoals,
	{o new(goal) o aov := AOV o as Out}.
	
ht0+run   --> (o nGoals=0; o i=0; o maxProvedPercent=100), !.
ht0+run   --> o reset, o proves, o notes, o -i, o run.
ht0+reset --> 	
	 %o i = I,{format('\n\n%--| ~a |-----------------------\n',[I])},
	{retractall(a(_,_,_,_,_))}, o nProved := 0.
ht0+notes --> 
	o nProved=NProved,
	o nGoals=All,
	New is NProved*100/All,
	o maxProvedPercent=Old,
	{compare(Change,New,Old)},
	o dribble(Change),
	o update(Change,New).

ht0+update(= , _).
ht0+update(<,_).
ht0+update(>,New) -->
	o maxProvedPercent is New,
	{retractall(best(_)),
	 forall(a(A,B,C,D,E),
	assert(best(a(A,B,C,D,E))))}.
ht0+proves -->
	o sort(goals) so G0,
	o i = I,
	{o new(wme) o i := I o as Wme},
	o wme := Wme, 
	o prove(G0,G),
	o goals := G.

ht0+prove(G0,G) -->
	{numberGoals(G0,1,G1)
        %, write(G1),nl
        },
	o prove1(G1,G).

ht0*prove1(G0)=G -->
	{%mayspy(o,G0),
	%nl,nl,write(G0),nl,
        o as G0 o id=Id o aov=AOV
        },
	o wme keep prove(AOV,Id)
	-> o wme ask route=R,
	   {o as G0 o yeah(R) o as G},
	   o +nProved
	;  {o as G0 o boo  o as G}.

numberGoals([],_,[]).
numberGoals([G0|G0s],N0,[G|Gs]) :-
	o as G0 o id := N0 o as G,
	N is N0 + 1,
	numberGoals(G0s,N,Gs).
	
isSteady(val of _ = 0).

noSteadies([],[]).
noSteadies([H|T],Rest) :- isSteady(H),!, noSteadies(T,Rest).
noSteadies([H|T],[H|Rest]) :- noSteadies(T,Rest).