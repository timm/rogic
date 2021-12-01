% high-level 

 portray(X) :- class(About,X),write(About).
 portray(X) :- instance(About,X), write(About).

 zapInstances :-
	flag(id,_,0), instance(_,X), retract(X), fail.
 zapInstances.

 zapClasses   :- class(_,X), retract(X), fail.
 zapClasses.

 reset :- zapInstances, zapClasses.

% class creation (can't be optimized cause there may be no "=the" yet

 has0(Class=About, Meta) :-
	the(About,Fs,Vs,Index,Ds),
	touch(the class=Class with the fields=Fs
                              with the index=Index
                              with the values=Vs
			      with the defaults=Ds,
	      Meta).

 Class has About :- has0(Class=About,The0), assert(The0).

 the([+F=D|T],[F|Fs],[V|Vs],[V|L],[D|Ds]) :- !, the(T,Fs,Vs,L,Ds).
 the([+F  |T],[F|Fs],[V|Vs],[V|L],[_|Ds]) :- !, the(T,Fs,Vs,L,Ds).
 the([F=D |T],[F|Fs],[_|Vs],   L, [D|Ds]) :- !, the(T,Fs,Vs,L,Ds).
 the([F   |T],[F|Fs],[_|Vs],   L, [_|Ds]) :- !, the(T,Fs,Vs,L,Ds).
 the([],          [],    [],   [],    []).

 fresh0(Class,Out) ?-
	touch(my class=Class
                with our defaults=D
                with my values := D,
	      Out).

 fresh(Class with Fields,Out) ?-
	fresh0(Class,Temp),
	touch(self := Temp with Fields,Out).

% instance creation, with assertion

 new0(Class with With,Out) ?- 
	fresh(Class with With,Temp),
	touch(self := Temp with my  values=Vs
		           with my  index:=Hash
		           with my  id:=Id,
	      Out),	
        touch(the one=Class with the values=Vs
		            with the index=Index),
	hash_term(Index,Hash),
	flag(id,Id,Id+1).

%XXX need a deletion

 new(X) ?- new0(X,Y), assert(Y).

 X with Y ?- touch(X with Y).

 with(X,Y,A,B) ?- touch(X with Y,A,B).

 makeMethod(X0 in C ?- Y0,Out) :-
	functor(X0,F,A),
	Head =.. [C,X0],
	expand_term((Head --> Y0),Temp),
	(Temp= (X:-Y)
        -> demandZip((X :- Y),in(C,F/A,1),Out)
        ;  Out=Temp).

 makeMethodCall(A0,C,M,Out) :-
	A0 =.. L0,
	touch(my class=C,W0),
	append(L,[W0,W],L0),
	Head =.. L,
	wrapper(Head,Temp),
	makeMethodCall1(Temp,C,M,Out,W0,W).

 makeMethodCall1([H],C,M,One) -->
	makeMethodCall2(H,C,M,One),!.
 makeMethodCall1([H1,H2|T],C,M,(One,Rest)) -->
	makeMethodCall2(H1,C,M,One),!,
	makeMethodCall1([H2|T],C,M,Rest).

 makeMethodCall2(touch(A),_,_,touch(A,W0,W),W0,W).
 makeMethodCall2(H,C,_,X,W0,W) :-
	X =.. [C,H,W0,W],
	myclause(X,_). %  a method we defined before
 makeMethodCall2(H,C,F/A,X,W0,W) :-
	functor(H,F,A),
	X =.. [C,H,W0,W]. % this current method
 makeMethodCall2(H,_,_,Thing,W,W) :-
	H =.. L,
	append(B4,[W,W],L),
	Thing =.. B4,
	clause(Thing,_). % some other clause
 makeMethodCall2(X,_,_,X,W,W).

 wrapper(X,Out) :-
	wrap(X,Before,[],After,[],Goal),
	append(Before,[Goal|After],Out).

 wrap(X,B0,B,A0,A,Y) :-
	once(wrap0(X,Z)), 
	wrap1(Z,B0,B,A0,A,Y).

 wrap0(X,        leaf(X) ) :- var(X).
 wrap0(X,        leaf(X) ) :- atomic(X).
 wrap0([],    leaf(true) ).
 wrap0([H|T],      [H|T] ).
 wrap0(X? ,           X? ).
 wrap0(X` ,           X` ).
 wrap0(X,        term(X) ).

 wrap1(leaf(X),  B,B,  A,A, X). 
 wrap1([H0|T0], B0,B, A0,A, [H|T]) :-
	wrap(H0,   B0,B1,A0,A1,H), 
	wrap(T0,   B1,B, A1,A, T).
 wrap1(term(X),B0,B, A0,A, Y) :-
	X =.. L0, 
	wrap(L0,B0,B,A0,A,L), 
	Y =.. L.
 wrap1(X?, [H|B],B,    A,A,Y) :- H= touch(an X  = Y).
 wrap1(X`,    B, B,[H|A],A,Y) :- H= touch(an X := Y).
