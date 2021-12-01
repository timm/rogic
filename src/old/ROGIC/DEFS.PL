% for an example, see defsDemo.pl
% comment out the following to stop typos checking in accessors
% (which is faster, but not as safe).
cautious.

% standard stuff for all terms. if you invent a new operation that
% is useful for everyone, add it here
o([X],           F,Y,W0,   W):- !,                o(X,F,Y,W0, W).
o([X|T],         F,Y,W0,   W):- o(X,                  F,_,W0, W),o(T,F,Y,W0,W).
o(new(F),        F,Y,W0,   W):- o([isa(F,W0),init(F)],F,Y,W0, W).
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
o(A  o   B,      F,Y,W0,   W):- o(A,                  F,_,W0,W1), o(B,F,Y,W1,W).
o(K  =   V,      F,V,F/W,F/W):- o0(F,K,I), arg(I,W,V).
o(K is  V0,      F,V,F/W,F/W):- V is V0,   o0(F,K,I), setarg(I,W,V).
o(K :=   V,      F,V,F/W,F/W):- o0(F,K,I), setarg(I,W,V).
o(K was V0 now V,F,V,F/W,F/W):- o0(F,K,I), arg(I,W,V0), setarg(I,W,V).
o(self(F/W0,F/W),F,_,F/W0,F/W).
o(show,          F,_,F/W,F/W):- write(F),write('('),write(type=F),
                                forall(o0(F,K,I),
                                       (arg(I,W,V),write(', '),print(K=V))), 
                                write(')').
                                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% secrets of the jedi masters start here. 
% you might not want to read  any further
:- X=(o1/3,(o)/5), 
   (dynamic X), (discontiguous X), 
   (multifile X),index(o1(1,1,0)), 
   index(o(1,1,0,0,0)).

term_expansion((B*A=Out-->C),X) :- !,rules0((B+A=Out--> C),X).
term_expansion((B+A=Out-->C),X) :- !,rule0((B+A=Out--> C),X).
term_expansion((B+A-->C),    X) :- !,rule0((B+A=_  --> C),X).
term_expansion(B+A=Out,      X) :- !,rule0((B+A=Out--> true),X).
term_expansion(B+L,          X) :- is_list(L), !, def(B,L,X).
term_expansion(B+A,          X) :- rule0((B+A=_  --> true),X).

rules0((B+A=Out --> C),[End,Inc]) :-
	iteratorEnd(B,A=Out,End0),
	iterator(B,A=Out,C,Inc0),
	expand_term(End0,End),
	expand_term(Inc0,Inc).
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

f0([],[],[]).
f0([A|T],[A|As],F0s) :- atom(A),!,f0(T,As,F0s).
f0([A=B|T], [A|As], [A=B|F0s]):- !,f0(T,As,F0s).

iteratorEnd(F,P0=_,(F+Head)) :- 
	P0 =.. [P,_],
	Head =.. [P,[],[]].
iterator(F,P0=Out,Do,
        (F+Head --> Do, o Tail)) :-
	P0 =.. [P,In],
	Head =.. [P,[In|T0],[Out|T]],
	Tail =.. [P,T0,T].
	
:-  dynamic cautious/0.

o0(K,F,I) :- o1(K,F,I).
o0(K,F,I) :- 
	cautious,
  	nonvar(K),
  	nonvar(F),
  	\+ o1(K,F,I), 
  	!,
  	print(badAccess(K,F)),nl,
  	fail.

o(X)        :- o(X,_,_, _,_).
o(X,     W) :- o(X,_,_, _,W).
o(X,F/W0,W):- o(X,F,_,F/W0,W).

=( X,X,W, W).
>( X,Y,W, W) :- X> Y.
<( X,Y,W, W) :- X< Y.
=<(X,Y,W, W) :- X=<Y.
>=(X,Y,W, W) :- X>=Y.
is(X,Y,W, W) :- X is Y.

true(W,W).
fail(W,W)   :- fail.

olist(X) :- olist(_,X).
olist(F,X) :-
	clause(o(A,Y,B,C,D),Body),
	functor(A,F,_),
	nonvar(Y),
	X=Y,
	portray_clause((o(A,X,B,C,D) :- Body)).