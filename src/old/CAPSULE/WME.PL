term_expansion(defwme(X),[defwme(X),id|L]) :- 
	bagof(Y,wme1(X,Y),L).

wme1(X,wme(Functor,Term)) :-
	wme0(X,Functor,_,_,Term).
wme1(X,(touch(T0,Field,Old,New,T1) :- Body)) :-
	wme0(X,Functor,_,_,T0),
	Body =.. [Functor,Field,Old,New,T0,T1].
wme1(X,Out) :-
	wme0(X,Functor,Fields,Arity,Term0),
	Out =.. [Functor,Field,Old,New,Term0,Term],
	nth1(N,Fields,Field),
	Term0=..[_|L0],
	functor(Term,Functor,Arity),  
	Term=.. [_|L],
        joinArgs(1,N,L0,Old,New,L).
	 
wme0(X,Functor,Fields,Arity,Term) :-
	X =.. [Functor|Fields],
	length(Fields,Arity),
	functor(Term,Functor,Arity).

joinArgs(N,N,[Old|Rest],Old,New,[New|Rest]).
joinArgs(N0,N1,[X|L0],Old,New,[X|L]) :- 
	N0 < N1,
	N2 is N0 + 1,
	joinArgs(N2,N1,L0,Old,New,L).

% runtime support

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


