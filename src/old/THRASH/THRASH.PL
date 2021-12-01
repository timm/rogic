+ X :- load_files(X,[silent(true),if(changed)]).

:- + [ops,utils,dcgfix,olog,kb,demos].

:- format('THRASH v[1.0]\n\n').

:- discontiguous do/2, function/3.

term_expansion(Head := Outs,Out) :- xpand1(Head := Outs,Out).

xpand1(Head := Outs, function(Head,Outs,All)) :-
	Head  =.. [F1|Ins],
	append(Ins,Outs,Args),
	All   =.. [F1|Args].

goal_expansion((X0 and Y and Z), thrash(and,A,N1,B,0,N1,[X|L])) :- !,
	xpand2(X0,X),
	goal_expansion((Y and Z), thrash(and,A,N,B,_,_,L)),
	N1 is N + 1.
goal_expansion((X0 and Y0), thrash(and,l2r,2,n,0,2,[X,Y])) :-
	xpand2([X0,Y0],[X,Y]).
goal_expansion((X0 or Y or Z), thrash(or,A ,N1,B,N,1,[X|L])) :- !,
	xpand2(X0,X),
	goal_expansion((Y or Z),thrash(or,A,N,B,_,_,L)),
	N1 is N + 1.
goal_expansion((X0 or Y0),thrash(or,l2r,2, n,1,1,[X,Y])) :-
	xpand2([X0,Y0],[X,Y]). 
goal_expansion((X ors Y), thrash(ors,A,B,C,D,B,F)) :-
	goal_expansion((X or Y), thrash(_,A,B,C,D,_,F)).
goal_expansion((X any Y), thrash(any,A,B,y,D,E,F)) :-
	goal_expansion((X ors Y), thrash(_,A,B,_,D,E,F)). 
goal_expansion((X rand Y), thrash(rand,random,B,C,D,E,F)) :-
	goal_expansion((X and Y), thrash(_,_,B,C,D,E,F)).
goal_expansion((X ror Y), thrash(ror,random,B,C,D,E,F)) :-
	goal_expansion((X or Y), thrash(_,_,B,C,D,E,F)).
goal_expansion((X rors Y), thrash(rors,random,B,C,D,E,F)) :-
	goal_expansion((X ors Y), thrash(_,_,B,C,D,E,F)).
goal_expansion((X rany Y), thrash(rany,random,B,C,D,E,F)) :-
	goal_expansion((X any Y), thrash(_,_,B,C,D,E,F)).

xpand2([H|T],L) :- !,maplist(xpand2,[H|T],L).
xpand2(X,Y)     :- goal_expansion(X,Y),!.
xpand2(X,X).

%goal_expansion(X := Y,clause(
%thrash(Order,NItems,SkipSome,AllowedFailures,NTries,Items)

prove(X,Wme) :-
	retractall(memo(_,_,_)),
	prove(path,_,[],_,Wme0),
	prove(X,Wme0,Wme).

prove(X := Y) --> hash_term(X,H), prove(X,Y,H).
prove(fail)   --> !,fail.
prove(true)   --> [].
prove((X,Y))  --> !, prove(X), prove(Y).
prove((X;Y))  --> !,(prove(X); prove(Y)).
prove({X})    --> {X}.
prove(X)      --> {t(lives,L,X)}, L < 1,!.
prove(X)      --> {t(nToDo,0,X)},!.
prove(X)      --> {t(items,[],X)},!.
prove(All)    -->
	{isa(t,All),!,
	pop(One,All,Rest)},
	(prove(One) ; {oops}),!,
	prove(Rest).

prove(X,Y,H)  --> {memo(H,X,Z), !, \+ nogood(X,Y,X,Z)}.
prove(X,_,_)  --> w(path,Path,[X|Path]), \+ member(X,Path).
prove(X,Y,H)  --> {function(X,Y,Z), Z}, bassert(memo(H,X,Y)).

nogood(X,Y,X,Z) :- Y \= Z.