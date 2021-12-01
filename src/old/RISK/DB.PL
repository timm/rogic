:- discontiguous touch/5, new/2,isa/2.
:- multifile     touch/5, new/2,isa/2.
:- Common=(inits/2,show/1,db/1),
   (discontiguous Common),
   (multifile Common).

xdbs(X,L) :- bagof(Y,dbs(X,Y),L).

dbs(X,isa(Functor,Term)) :-
	dbs1(X,Functor,_,_,Term).
dbs(X,(touch(T0,Field,Old,New,T1) :- Body)) :-
	dbs1(X,Functor,_,_,T0),
	Body =.. [Functor,Field,Old,New,T0,T1].
dbs(X,Out) :-
	dbs1(X,Functor,Fields,Arity,Term0),
	Out =.. [Functor,Field,Old,New,Term0,Term],
	(nth1(N,Fields,Field),
	 Term0=..[_|L0],
	 functor(Term,Functor,Arity),  Term=.. [_|L],
         joinArgs(1,N,L0,Old,New,L)
        ;Field=self,
         New=Old,
	 Term0=Old,
	 Term=Old).
	 
dbs1(X,Functor,Fields,Arity,Term) :-
	X =.. [Functor|Fields],
	length(Fields,Arity),
	functor(Term,Functor,Arity).

joinArgs(N,N,[Old|Rest],Old,New,[New|Rest]).
joinArgs(N0,N1,[X|L0],Old,New,[X|L]) :- 
	N0 < N1,
	N2 is N0 + 1,
	joinArgs(N2,N1,L0,Old,New,L).

% runtime support

term_expansion(db(X),[db(X)|L]) :- xdbs(X,L).

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





