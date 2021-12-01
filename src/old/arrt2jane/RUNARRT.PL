%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compiler stuff
term_expansion(+aka(X,Y,_),tag(X,Y)).
term_expansion((+Head :- Body),Out) :- xpand((+Head :- Body),Out).
term_expansion(+In,Out)            :- xpand(+In,Out).

:- discontiguous e/4, type/2.
xpand((+r(Require,W,_,_,_) :- From),[type(r,Require)|Out]) :-
	c2l(From,L),
	bagof(e(One,Require,W,+),L^ member(One,L),Out).

xpand(+effect(Fault,Pact,W,_),e(Pact,Fault,W,-)).
xpand(+impact(Fault,Require,W0,_),e(Fault,Require,W,*)) :- W is 1 - W0.
xpand(+X,type(F,One)) :- functor(X,F,5), member(F,[r,f,p]), arg(1,X,One).
xpand(_,[]).
c2l((X,Y),[X|T]) :- !, c2l(Y,T).
c2l(X,[X]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% main
go(Top) :- time(go1(Top)).

go1(Top) :- reset, run(Top), report(Top).

reset :-
	retractall(memo0(_)),
	retractall(known(_)),
	nodes(p,Pacts),  rsome(Pacts, UsedP), maplist(yes,UsedP,_),
	nodes(f,Faults), rsome(Faults,UsedF), maplist(yes,UsedF,_).
run(Top) :-
	forall(memo(rxr(Top,_Out)),true).
report(Top) :-
	format('--| ~w |------\n',[Top]),
	write('IF '),
	setof(known(X),known(X),Knowns),
	forall(member(known(X),Knowns),
	       format('\t~w\n',[X])),
	write('THEN '),
	setof(memo0(X),memo0(X),Memos),
	forall(member(memo0(Y),Memos),
	       (arg(1,Y,Key),
	        arg(2,Y,Value),
		format('\t~w = ~w\n',[Key,Value])
	      )).

yes(X,X) :- assert(known(X)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pacts effecting faults
fxp(F,Out) :-
	type(f,F),
	(parents(F,_,Pacts)
	-> maplist(arg(2),Pacts,Nums),
	   sum(Nums,Total),
	   Out is max(0,min(1,1 - Total))
        ;  Out=1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% faults effecting requirements
rxf(R,Total) :-
	type(r,R),
	(parents(R,_,Faults)
        -> maplist(rxf1,Faults,Nums),
	   sum(Nums,Total0),
	   Temp is (1 - Total0)
         ; Temp is 1),
	 Total is max(0,Temp).

rxf1(Fault/N,Out) :-
	memo(fxp(Fault,Total)),
	Out is (Total)*N.

rxr(R,Out) :-
	type(r,R),
	anyParents(R,+,B),
	length(B,N),
	maplist(rxr1(N),B,Nums),
	sum(Nums,Sum),
	Out is Sum.
	
rxr1(N,R/_,Out) :-
	memo(rxf(R,Total)),
	Out is Total/N.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% graph query stuff
nodes(All) :-	setof(Thing,What^type(What,Thing),All).
node(One) :-	nodes(All),member(One,All).

nodes(What,All) :-	setof(Thing,What^type(What,Thing),All).
node(What,One) :-	nodes(What,All),member(One,All).

parents(X,S,All) :-
	bagof(Y/W,X^S^(e(Y,X,W,S),known(Y)),All),
	once(e(_,X,_,S)).

anyParents(X,S,All) :-
	bagof(Y/W,X^S^(e(Y,X,W,S)),All),
	once(e(_,X,_,S)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% graph display suff
dot :- dot(report).
dot(F) :-
	string_concat(F,'.dot',Dot),
	string_concat(F,'.eps',Eps),
	tell(Dot),
	dot1,
	told,
	dotty(Dot,Eps).
dot1 :-
	write('digraph G {'),nl,
	forall(node(Thing),
	      (type(What,Thing),
	      shape(What,Shape),
	      format(' ~w [shape=~w]\n',[Thing,Shape]))),
	forall(e(A,B,C,D),
	       format(' ~w -> ~w [label=\"~w~w\"]\n',[A,B,D,C])),
	write('}').

shape(r,square).
shape(f,ellipse).
shape(p,plaintext).

dotty(Dot,Eps) :-
	sformat(Todo1,
	      'cmd /c "c:\\program files\\graphviz\\bin\\dotty.exe" ~w',
	       [Dot]),
	sformat(Todo3,
	        'cmd /c "c:\\program files\\graphviz\\bin\\dot.exe" -Tps ~w > ~w',
	        [Dot,Eps]),
	win_exec(Todo1,iconic),
	win_exec(Todo3,iconic).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% random stuff
rsome(L,Some) :-
	length(L,X),
	N is random(X) + 1,
	once(rsome(N,L,Some)).

rsome(1,L,[X]) :-
	rone(L,X,_).
rsome(N0,L,[One|Some]) :-
	N0 > 1,
	rone(L,One,Rest),
	N is N0 - 1,
	rsome(N,Rest,Some).

rone(L,X) :- rone(L,X,_).

rone([H],H,[]) :- !.
rone([H|T],X,Out) :-
	length([H|T],N),
	Pos is random(N) + 1,
	less1(Pos,[H|T],One,Rest),
	rone1(X,One,Out,Rest).

rone1(X,X,Out,Out).
rone1(X,One,[One|Tail],Rest) :- rone(Rest,X,Tail).

less1(1,[H|T],H,T) :- !.
less1(N0,[H|T],X,[H|Rest]) :- N is N0 - 1, less1(N,T,X,Rest).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% standard utilities
memo(X) :- memo0(X),!.
memo(X) :- X, assert(memo0(X)).

sum([],0).
sum([H|T],H + Rest) :- sum(T,Rest).

prod([],1).
prod([H|T],(H*Rest)) :- prod(T, Rest).

unique(X,Y) :- unique(X,[],Y).

unique([],X,X).
unique([H|T],Seen,Out) :- member(H,Seen), !, unique(T,Seen,Out).
unique([H|T],Seen,Out) :- unique(T,[H|Seen],Out).
	
