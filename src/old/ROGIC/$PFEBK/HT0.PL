:- dynamic a/5.
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

%:- ht0(5,[1/sad,1/rich]).

ht0(0,_) :-!.
ht0(N0,G0) :-
    rememberBestCover(G0),
    retractall(a(_,_,_,_,_)),
    sort(G0, G1),
    proves(G1,1,0,P,G),
    N is N0 - 1,
    ht0(N,G).

rememberBestCover
proves([],_,P,P[]).
proves([H0|T0],N,P0,P,[H|T]) :-
	N1 is N + 1,
	prove(N,H0,H,P1),
	P2 is P0 + P1,
	proves(T0,N1,P2,P,T).
	
prove(N,In/Goal,Out/Goal,P):-
    (prove1(N,Goal) 
     ->  X = 1, P=1
     ;   X = -1,P=0),
    Out is In+X*(1+random(10^2)/10^3).

prove1(N,Goal) :-
	kb(Goal,N=0/[],_).

kb(Goal0,N=T/Rin0,Out) :-
	canonical(Goal0,Goal),
	assume(N,Goal,Addits,DOB),
	now(Rin0,T=Now0,Rin1),
	\+ looping(DOB,Goal,Now0),
	kbMore(Addits,Goal0,
            N=T/[T=[Goal|Now0]|Rin1],
	    Out).

looping(=,Goal,Now) :- 
	member(Goal,Now).

kbMore(0,_,Out,Out).
kbMore(+,Goal,In,Out):- 
	kb1(Goal,In,Out).

canonical(X,A of O @ T = V) :-
	about(X,A,O,V,T).

about(A of O @ T = V,A,O,V,T).
about(not(X),val,X,f,_).
about(X,val,X,t,_) :- atomic(X).

now([],_=[],[]).
now([T=Now|Rest],T=Now,Rest) :-  !.
now([Then|Rest0],T=Now,[Then|Rest]) :-
	now(Rest0,T=Now,Rest).

assume(N,A of O @ T = NewV,0,Order) :-
    a(A,O,T,N1,OldV),
    !,
    OldV = NewV,
    compare(Order,N,N1).
assume(N,A of O @ T = V,+,=) :-
    assert(a(A,O,T,N,V)).
assume(N,A of O @ T = V,_,_) :-
    retract(a(A,O,T,N,V)),
    fail.

fx(+,  1,  1).
fx(+, -1, -1).
fx(-, -1,  1).
fx(-,  1, -1). 
