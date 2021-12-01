term_expansion( (with X0 <-- Y), Out) :- !, 
	swi(flag(currentFrame,Class)),
	X =.. [Class,X0],
	xpandMethod(X,Y,Out).
term_expansion( (with X0),['#known'(Class0,X0),X]) :- !,
	swi(flag(currentFrame,Class0)),
	accessorName(Class0,Class),
	X =.. [Class,X0,A,A].

memberWith(X,Y with Z) :- !,(X=Y; memberWith(X,Z)).
memberWith(X,X).

xpandMethod(X,Y,Out) :-
	bagof(One,X^Y^xpandMethod1(X,Y,One),Out).

xpandMethod1(X,_,'#known'(Class,M)) :-
	X =.. [Class,M].
xpandMethod1(X,Y0,Out) :-
	X =.. [Class,M],
	accessorName(Class,A),
	Head =.. [A,M,T1,T2],
	(Y0=[] -> Out=Head
	       ;  odcg(Y0,Y,A,T1,T2),
		  Out=(Head :- Y)).

accessorNames(In,Out) :- maplist(accessorName,In,Out).

accessorName(Class,A) :- asString('~w_',[Class],A).

odcg(X, oo(In,X,Out) , _,In ,Out ) :- 
	var(X), !.
odcg((X0 -> Y0; Z0),(X -> Y; Z), A,In,Out) :- !,
	odcg(X0 ,X,A,In,T),
        odcg(Y0,Y,A,T, Out),
	odcg(Z0,Z,A,T,Out).
odcg((X,Y),(oo(In,X,Temp),Z),A,In,Out) :- 
	var(X),!,
	odcg(Y,Z,A,Temp,Out).
odcg((value(In),Y),Z,A,In,Out) :- !,
	odcg(Y,Z,A,In,Out).
odcg((= In,Y),Z,A,In,Out) :- !,
	odcg(Y,Z,A,In,Out).
odcg((X0,Y0),(X,Y), A,In,Out):- !,
	odcg(X0 ,X,A,In,T), 
        odcg(Y0,Y,A,T, Out).
odcg((X0;Y0),(X;Y),A,In,Out):- !,
	odcg(X0,X,A,In,Out),
        odcg(Y0,Y,A,In,Out).
odcg((X|Y),Z,     A,In,Out):- !,
	odcg((X;Y),Z,A,In,Out).
odcg(\+ X0, \+ X, A,In,In) :- !,
	odcg(X0 ,X,A,In,_).
odcg(not X0, X, A,In,In) :- !,
	odcg(\+ X0 ,X,A,In,_).
odcg({X} , X  , _, In, In ) :- !.
odcg(value(X),true,_,X,X) :- !.
odcg(= X,true,_,X,X) :- !.
odcg(oo(A,B)   , Call, Ac,In,Out) :- !,
	odcg(oo(A,B,_),Call,Ac,In,Out).
odcg(oo(A,B,C) , oo(A,B,C), _,In, In) :- !.
odcg(!,!,_,In,In) :- !.
odcg(X,oo(In,X,Out),_,In,Out).






