
xpand(A,Head0,Body0,(Head :- Body)) :-
	isa(A,In),
	swap(Head0,Head1,In,Out),
	appendArgs(Head1,[In,Out],Head),
	swap(Body0,Body,In,Out)). 

appendArgs(Old,Args,New) :-
	Old =.. L0,
	append(L0,Args,L),
	New =.. L.

swap(X,Y,In,Out) :-
	once(swap1(X,Y,In,Out)).

swap1(X,X,In,In) :-  
	var(X);atomic(X).
swap1([],[],Out,Out).
swap1([H0|T0],[H|T],In,Out) :-
	swap(H0,H,In,Temp),
	swap(T0,T,Temp,Out).
swap1(=X,Y,In,Out) :- 
	swap(X,Z,In,Out),
	appendArgs(X,[In,Out],Y).
swap1(self,X,X,X).
swap1(?X,Y,In,Out) :- touch(In,X,Y,Y,Out).
swap1(!X,Y,In,Out) :- touch(In,X,_,Y,Out). 
swap1(X,Y,In,Out)  :- 
	X =.. L0, 
	swap(L0,L1,In,Out),
	Y =.. L1.
swap1(X,_,In,_) :-
	functor(In,F,A),
	print(user_error,failed(swap(X,F/A))),
	fail.

term_expansion((Table=Head),Head) :- 
	xpand(Table,Head,true,(Head :- _)).
term_expansion((Table=Head0 :- Body0),Out) :- 
        xpand(Table,Head0,Body0,Out).














