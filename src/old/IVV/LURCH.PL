:- [choices].

lurch(X)      :- lurch(X,[],_).
lurch(X,W)    :- lurch(X,[],W). 
lurch(X,W0,W) :- once(lurch0(X,Y,W0,W1)), lurch1(Y,W1,W).

lurch0(X,        bad(var)) --> {var(X)}. % always first
lurch0(call(X),    call(X)) --> [].
lurch0(true,         stop) --> [].
lurch0((X->Y;Z), (X->Y;Z)) --> [].
lurch0(once(X),   once(X)) --> [].
lurch0((X,Y),       (X,Y)) --> [].
lurch0((X;Y),           L) --> {c2l((X;Y),L)}. 
lurch0(X,       call(X=Y)) --> {choices(X,Y)},old(Y).
lurch0(X,          new(X)) --> {choices(X,_)}. 
lurch0(X,         call(X)) --> {knownBuiltIn(X)}.
lurch0(X,          sub(X)) --> {clause(X,_)}.
lurch0(X, bad(unknown(F))) --> {functor(X,F,_)}.

lurch1(stop)     --> [].
lurch1(bad(X))   --> {format('E> ~w\n',[X]), abort}.
lurch1(call(X))  --> {X}.
lurch1((X->Y;Z)) --> lurch(X) -> lurch(Y);lurch(Z).
lurch1((X,Y))    --> lurch(X), lurch(Y).
lurch1([H|T])    --> {rone([H|T],Y,_)}, lurch(Y).
lurch1(sub(X))   --> {clause(X,Y)},lurch(Y).
lurch1(once(X),W0,W) :- once(lurch(X,W0,W)).
lurch1(new(X), W0,[X|W]) :-   
	bagof(X/Y,clause(X,Y), L),
	rone(L,X/Y,_),
	lurch(Y,W0,W).	

d2l((X;Y),[X|Rest]) :- !,d2l(Y,Rest).
d2l(X,    [X]).

old(X,L,L) :- member(X,L).

assumable(X,K,V) :- 
	slot(X,isa,choice),
	slot(X,key,K),
	slot(X,value,V).

rone(L,X,Y) :- length(L,N), rone(L,N,X,Y,_).

rone([H],_,H,[],0) :- !.
rone([H|T],N0,X,Out,N) :-
        N is N0 - 1,
        Pos is random(N0) + 1,
        less1(Pos,One,[H|T],Rest),
        (X=One,
         Out=Rest
        ; Out=[One|Tail],
          N1 is N0 - 1,
          rone(Rest,N1,X,Tail,_)).

less1(1,H,[H|T],T) :- !.
less1(N0,X,[H|T],[H|L]) :-  N is N0 - 1, less1(N,X,T,L).
