%--------------------------------------------
%% boot stuff

ver :- format('~s\n\n',
        [     "Welcome to HELEN (Build 0); 
(HELEN = HELEN's Elegant Electrical Logic, Economical Notation)
Copyright (c) 2001 Tim Menzies (tim@menzies.com). 
Copy policy: GPL-2 (see www.gnu.org)"]).

:- ver.

:- op(999,xfx,has).
:- op(998,xfy,by). % for circuits in parrallel
:- op(997,xfy,to). % for circuits in series 

:- [qr,lib].

%--------------------------------------------
%% pre-processing stuff
prep(X,W,Z) :- xpand(X,Y), unify(Y,Z,[],W).

% xpand stuff
xpand(X,Y) :- xpand1(X,Y),!.
xpand(X,_) :- bad(expand,X).

xpand1(Type=Id,Thing=Id) :-
	about(Thing,Type,_,_).
xpand1(Type,   Thing)    :-
	about(Thing,Type,_,_).
xpand1(to(A0,to(B,C)), to(_,_,[A|Rest])) :- !,
	xpand(A0,A),
	xpand(to(B,C), to(_,_,Rest)).    
xpand1(to(A0,B0), to(_,_,[A,B])) :- 
	xpand(A0,A),
	xpand(B0,B).
xpand1(by(A0,by(B,C)), by(_,_,[A|Rest])) :- !,
	xpand(A0,A),
	xpand(by(B,C), by(_,_,Rest)).
xpand1(by(A0,B0), by(_,_,[A,B])) :- 
	xpand(A0,A),
	xpand(B0,B).

% stuff for matching up terms
unify(X,Y,Wme0,Wme) :- unify1(X,Y,Wme0,Wme),!.
unify(X,_,_)        :- bad(unify,X).

unify1([],      [],    W, W).
unify1([H0|T0], [H|T], W0,W) :-
	unify(H0,H,W0,W1),
	unify(T0,T,W1,W).
unify1(to(V,A,L0),to(V,A,L),W0,W) :-
	unify(L0,L,W0,W).
unify1(by(V,A,L0),by(V,A,L),W0,W) :-
	unify(L0,L,W0,W).
unify1(X=Id,X,W, W) :-
	member(Id1=X,W), Id1==Id. % XXXX
unify1(X=Id,X,W, [Id=X|W]).
unify1(X,X,W, W) :-
	about(X,_,_,_).

%--------------------------------------------
%% main stuff
% stuff to run main driver and catch results in a file
go :-
	do(What,Where),
	tell(Where),
	forall(go(What,_),true),
	told.

%% main driver stuff
go(X,Db) :-
	get(X,Y),
	prep(Y,Db,Circuit),
	inits(I),
	sets(I,Db),
	run(Circuit),
	shines(Db,S),
	checklist(report,Db),
	write(S),nl.

% accessing stuff
get(X,Y) :- X has Y.

%initial constraints stuff
sets([],_).
sets([H|T],Db) :- sets(H,Db), sets(T,Db).
sets(A=State,Db) :-
	set(State,Thing),
	member(A=Thing,Db).

set(ok,  bulb(_,_,ok,_,_)).
set(on,  switch(_,_,on)).
set(off, switch(_,_,off)).

% reporting stuff
report(bat=_) :- !.
report(_=B) :- print(B),write(',').

shines(Db,Out) :-
	bagof(One,Db^shine(Db,One),All),
	total(All,Out).
shine(Db,S) :-
	member(_=bulb(_,_,_,_,S),Db).

%--------------------------------------------
%% reasoning stuff
run(by(V,A,L))       :- parrallel(L,_,A,V).
run(to(V,A,L))       :- series(   L,_,V,A).
run(bulb(A,B,C,D,E)) :- bulb(A,B,C,D,E).
run(switch(A,B,C))   :- switch(A,B,C).
run(battery(A,B))    :- battery(A,B).

% electrical stuff
% same V across all things in parrallel
% A's sum
parrallel([],            A, A,_).
parrallel([Thing|Things],A0,A,V) :-
	about(Thing,_,V,A1),
	run(Thing),
	sum(A0,A1,A2),
	parrallel(Things,A2,A,V).

% same A thru all things in series
% V's sum
series([],             V,V,_).
series([Thing|Things],V0,V,A) :-
	about(Thing,_,V1,A),
	run(Thing),
	sum(V0,V1,V2),
	series(Things,V2,V,A).

%--------------------------------------------
%% accessing stuff
about(bulb(V,A,_,_,_),  bulb,    V,A).
about(switch(V,A,_),    switch,  V,A).
about(battery(V,A),     battery, V,A).
about(to(V,A,_),        circuit, V,A).
about(by(V,A,_),        circuit, V,A).

%printing stuff
portray(X) :- value(Y,_,X), write(Y).

value(Sw,    switch,  switch(_,_,Sw)).
value(Light, bulb,    bulb(_,_,Light,_,_)).
value(V,     battery, battery(V,_)).
