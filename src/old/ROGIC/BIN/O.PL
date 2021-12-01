% for an example, see defsDemo.pl 
	
% standard stuff for all terms. if you invent a new operation that
% is useful for everyone, add it here]
%o(X,             _,_,   _, _) :- print(o(X)),nl,fail.
o(true,          _,true,W, W).
o(as W,          _,W,W,    W).
o(A   of O = V,  F,V,   W0,W):- in(A,O,V),o(assert(A of O = V),F,V,W0,W).
o(val of O = 0,  F,V,   W0,W):- o(proveSteady(O),     F,V,W0, W).
o(A   of O = V,  F,V,   W0,W):- aoIndex(A,O,X),  o(X, F,V,W0, W).
o(not A,         F,Y,W,    W):- \+ o(A,               F,Y, W, _).
o(K ask A,       F,Y,W0,   W):- o(K=V,                F,Y,W0, W), o(A,V).
o(K keep  A,     F,Y,W0,   W):- o(K was V0 now V,     F,Y,W0, W), o(A,V0,V).
o(new(F),        F,Y,W0,   W):- o(isa(F,W0)o init(F), F,Y,W0, W).
o(new,           F,Y,W0,   W):- o(isa(F,_),           F,_,W0,W1), o(new(F),F,Y,W1,W).
o(map(K,P),      F,Y,W0,   W):- o(K was X now Y,      F,Y,W0, W), maplist(P,X,Y).
o(sort(K),       F,Y,W0,   W):- o(K was X now Y,      F,Y,W0, W), sort(X,Y).
o(in(K,V),       F,Y,W0,   W):- o(K=L,                F,Y,W0, W), member(V,L).
o(+K,            F,Y,W0,   W):- o(K was X now Y,      F,Y,W0, W), Y is X + 1.
o(-K,            F,Y,W0,   W):- o(K was X now Y,      F,Y,W0, W), Y is X - 1.
o(K +    V,      F,Y,W0,   W):- o(K was X now Y,      F,Y,W0, W), Y is X + V.
o(K -    V,      F,Y,W0,   W):- o(K was X now Y,      F,Y,W0, W), Y is X - V.
o(K *    V,      F,Y,W0,   W):- o(K was X now Y,      F,Y,W0, W), Y is X * V.
o(K /    V,      F,Y,W0,   W):- o(K was X now Y,      F,Y,W0, W), Y is X / V.
o(K ^    V,      F,Y,W0,   W):- o(K was X now Y,      F,Y,W0, W), Y is X ^ V.
o(K <<   H,      F,Y,W0,   W):- o(K was T now [H|T],  F,Y,W0, W).
o(K >>   H,      F,Y,W0,   W):- o(K was [H|T] now T,  F,Y,W0, W).
o(A so   B,      F,B,W0,   W):- o(A,                  F,B,W0, W).
o(o      A,      F,Y,W0,   W):- o(A,                  F,Y,W0, W).
o(A o    B,      F,Y,W0,   W):- o(A,                  F,_,W0,W1), o(B,F,Y,W1,W).
o(print(K),      F,Y,W0,   W):- o(K=V,                F,Y,W0, W), print(K=V).
o(write(K),      F,Y,W0,   W):- o(K=V,                F,Y,W0, W), write(K=V).
o(println(K),    F,Y,W0,   W):- o(K=V,                F,Y,W0, W), print(K=V),nl.
o(writeln(K),    F,Y,W0,   W):- o(K=V,                F,Y,W0, W), write(K=V),nl.
o(print,         _,_, W,   W):-  print(W).
o(write,         _,_, W,   W):-  write(W).
o(println,       _,_, W,   W):-  print(W),nl.
o(writeln,       _,_, W,   W):-  write(W),nl.
o(A rand B,      F,Y,W0,   W):- maybe 
                                -> o(A,F,_,W0,W1),o(B,F,Y,W1,W)
                                ;  o(B,F,_,W0,W1),o(A,F,Y,W1,W).
o(A ror  B,      F,Y,W0,   W):- maybe 
                                -> (o(A,F,Y,W0,W);o(B,F,Y,W0,W))
                                ;  (o(B,F,Y,W0,W);o(A,F,Y,W0,W)).
o(K  =   V,      F,V,F/W,F/W):- o0(F,K,I), arg(I,W,V).
o(K is  V0,      F,V,F/W,F/W):- V is V0,   o0(F,K,I), setarg(I,W,V).
o(K :=   V,      F,V,F/W,F/W):- o0(F,K,I), setarg(I,W,V).

o(K was V0 now V,F,V,F/W,F/W):- o0(F,K,I), arg(I,W,V0), setarg(I,W,V).
o(K was V0 
      do X now V,F,V,F/W0,F/W):-o0(F,K,I), arg(I,W,V0),o(X,F,_,W0,W), setarg(I,W,V).
o(self(F/W0,F/W),F,_,F/W0,F/W).
o(show,          F,_,F/W, F/W):-showo(F/W).

showo(F/W) :- numbervars(W,1,_), showo(0,F/W), fail.
showo(_)  :- nl.

showo(N,L) :-
	is_list(L),!,
	member(X,L),
	showo(N+4,X).
showo(N,F/W) :- 
	o1(F,_,_), !,
	nl,tab(N),write(F),write('= '),
        o1(F,K,I),
        nl,tab(N+2),write(K),write(': '),
        arg(I,W,V),
        showo(N+4,V).
showo(_,'$VAR'(_)) :-  !,
	write('???').
showo(_,X) :- 
	write('<'),print(X), write('> ').
 
o(X)        :- o(X,_,_, _,_).
o(X,     W) :- o(X,_,_, _,W).
o(X,F/W0,W):- o(X,F,_,F/W0,W).

o0(K,F,I) :- o1(K,F,I).
o0(K,F,I) :- 
 	cautious,
   	nonvar(K),
   	nonvar(F),
   	\+ o1(K,F,I), 
   	!,
   	print(badAccess(K,F)),nl,
   	fail.

%%%%%%%%%%%%%
% patterns lib

pattern(collect,o(xcall,xf,_)) :-
	xjoin.
pattern(collect,xall([],[],xf)).
pattern(collect,xall([xin|T0],[xout|T],xf)) :-
	xone,
	xall(T0,T,xf).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% secrets of the jedi masters start here. 
% you might not want to read  any further
maybe :- 0 is myrand(2).

rules0((B+A=C --> Bod),Out) :-
	A =.. [Pred,In],
	Call =.. [Pred,From,To],
	Join=..[Pred,From,To,B],
	uses(collect
	     ,[xf=B,xall=Pred,xcall=Call,xjoin=Join
	      ,xone=Bod,xin=In,xout=C
	      ]
	     ,Out).
	
rule0((B+(A of O) = V --> C),Out) :- !, 
	hash_term(O/A,Hash),
	rule0((B+Hash=V --> C),Rule),
	(aoIndex(A,O,Hash) -> Out=Rule ; Out=[aoIndex(A,O,Hash),Rule]).
	
rule0((B+A=X--> C),(o(A,B,X,B/Y,Z) :- Bod)) :-  !,
	expand_term((o(A,B,X) --> C),
	            (o(A,B,X,B/Y,Z) :- Bod)).

def(F,L,[Maker,DD,Isa|Out]):-
	f0(L,Fields,F0s),
	length(L,Arity),
	functor(New,F,Arity),
	findall(o1(F,Item,Pos),nth1(Pos,Fields,Item),Out),
	term_expansion((F+init(F) --> o(F0s)),Maker),
	term_expansion(F+dd(F,L),DD),
	term_expansion(F+isa(F,F/New),Isa).

f0([],[],true).
f0([A|T],[A|As],F0s) :- atom(A),!,f0(T,As,F0s).
f0([A:=B|T],[A|As],A := B o F0s):- !,f0(T,As,F0s).


%%%%%%%

olist(F) :- forall(olist1(F),true).
olist1(F) :- 
	clause(o(F,B,C,D,E),Body),
	portray_clause((o(F,B,C,D,E) :- Body)).
	
olists(F) :- forall(olists1(F),true).

olists1(F) :-
	clause(o(A,F1,C,D,E),Body),
	nonvar(F1),
	F1=F,
	portray_clause((o(A,F1,C,D,E) :- Body)).