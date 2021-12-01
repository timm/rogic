compile(X,Y)   :- compile(X,Y,[]).
compile(X,Y,Z) :- compile1(X,Y,Z),!.
compile(X,_,_) :- bad(compile,X).

compile1(by(V,A,L0),  L1,L) :- compileParrallel(L0,_,A,V,L1,L).
compile1(to(V,A,L0),  L1,L) :- compileSeries(   L0,_,V,A,L1,L).
compile1(battery(X,Y),L, L) :- battery(X,Y).
compile1(X,      [X|L],L).
	
% same V across all things in parrallel
% A's sum
compileParrallel([],A, A,_,L,L).
compileParrallel([Thing|Things],A0,A,V,
	         [sum(A0,A1,A2)|L0],L) :-
	about(Thing,_,V,A1),
	compile(Thing,L0,L1),
	compileParrallel(Things,A2,A,V,L1,L).

% same A thru all things in series
% V's sum
compileSeries([],V,V,_,L,L).
compileSeries([Thing|Things],V0,V,A,
	      [sum(V0,V1,V2)|L0],L) :-
	about(Thing,_,V1,A),
	compile(Thing,L0,L1),
	compileSeries(Things,V2,V,A,L1,L).

demoCompiler(Name,N) :-
	get(Name,C),
	prep(C,_,Z),
	compile(Z,Out),
	lprint(Out),
	l2c(Out,Goal),
	n(Goal,N).

xpand(X has Y,(circuit(X,Db) :- Body)) :-
	get(X,C),
	prep(C,_,Z),
	compile(Z,Body).

term_expansion(X has Y, Out) :-
	xpand(X has Y,Out).