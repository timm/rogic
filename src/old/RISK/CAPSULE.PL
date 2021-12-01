:- discontiguous touch/5, new/2,isa/2.
:- multifile     touch/5, new/2,isa/2.
:- Common=(inits/2,show/1,db/1),
   (discontiguous Common),
   (multifile Common).

:- op(1,fx,?), op(1,fx,!), op(1,fx,=).

xcapsules(X,L) :- bagof(Y,capsules(X,Y),L).

capsules(X,isa(Functor,Term)) :-
	capsules1(X,Functor,_,_,Term).
capsules(X,(touch(T0,Field,Old,New,T1) :- Body)) :-
	capsules1(X,Functor,_,_,T0),
	Body =.. [Functor,Field,Old,New,T0,T1].
capsules(X,Out) :-
	capsules1(X,Functor,Fields,Arity,Term0),
	Out =.. [Functor,Field,Old,New,Term0,Term],
	(nth1(N,Fields,Field),
	 Term0=..[_|L0],
	 functor(Term,Functor,Arity),  Term=.. [_|L],
         joinArgs(1,N,L0,Old,New,L)
        ;Field=self,
         New=Old,
	 Term0=Old,
	 Term=Old).
	 
capsules1(X,Functor,Fields,Arity,Term) :-
	X =.. [Functor|Fields],
	length(Fields,Arity),
	functor(Term,Functor,Arity).

joinArgs(N,N,[Old|Rest],Old,New,[New|Rest]).
joinArgs(N0,N1,[X|L0],Old,New,[X|L]) :- 
	N0 < N1,
	N2 is N0 + 1,
	joinArgs(N2,N1,L0,Old,New,L).

term_expansion((Table-Head :- Body),L) :-  
        bagof(X,Table^Head^Body^
                 method(-,Table,Head,Body,X),L).
term_expansion((Table-Head),X) :-
	term_expansion((Table-Head :- true),X).
term_expansion((Table=Head),X) :- 
        term_expansion((Table=Head :- true),X).
term_expansion((Table=Head :- Body),L) :- 
        bagof(X,Table^Head^Body^
                 method(=,Table,Head,Body,X),L).

method(Mode,A,Head0,Body0,Out) :-
	isa(A,In),
	method(Mode,In,Head0,Body0,Head,Body),
	(Body=true
	-> Out=Head
	; Out=(Head :- Body)).

method1(=,In,Head0,Body0,Head,Body) :-
	append2Args(Head0,In,Out,Head),
	swap(Body0,Body,In,Out).
method1(-,In,Head0,Body0,Head,Body) :-
	append1Arg(Head0,In,Head),
	swap(Body0,Body,In,_).

append1Arg(Old,In,New) :- 
	Old=.. L0,append(L0,[In],L),New=.. L.
append2Args(Old,In,Out,New) :- Old =.. 
	L0, append(L0,[In,Out],L), New=.. L.

swaps(X,X,In,In)   :- var(X),!.
swaps(-X,Y,In,In)  :- !,append1Arg(X,In,Y).
swaps(=X,Y,In,Out) :- !,append2Args(X,In,Out,Y).
swaps((W0->X0;Y0),(W->X;Y),In,Out) :- !,
	swaps(W0,W,In,Temp),
	swaps(X0,X,Temp,Out),
	swaps(Y0,Y,In,Out).
swaps((X;Y),Z,In,Out) :- !,
	(Z0=X;Z0=Y),
	swaps(Z0,Z,In,Out).
swaps(?X,Y,In,In) :- !,	touch(In,X,Y,_,_).
swaps(!X,Y,In,Out) :- !, touch(In,X,_,Y,Out).
swaps([],[],Out,Out) :- !.
swaps([H0|T0],[H|T],In,Out) :- !,
	swaps(H0,H,In,Temp),
	swaps(T0,T,Temp,Out).
swaps(X,Y,In,Out)  :- 
	X =.. L0, 
	swaps(L0,L1,In,Out),
	Y =.. L1.

% runtime support

term_expansion(db(X),[db(X)|L]) :- xcapsules(X,L).

portray(X) :- 
	clause(show(X),_),
        show(X).

iss(F is V, In) :-  
	touch(In,F,_,V,_).
iss(F is V,In,Out) :-
	touch(In,F,_,V,Out).
iss([],Out,Out).
iss([F is V|Rest],In,Out) :-
	touch(In,F,_,V,Temp),
	iss(Rest,Temp,Out).

prints(X) :- 
	functor(X,F,_),
	isa(F,Eg), db(Eg), 
	Eg=..[_|List0],
	msort(List0,List),
	forall(member(Item,List),(
	            touch(X,Item,V,_,_),
		    write(Item/V),nl)).





