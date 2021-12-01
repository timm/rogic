:- dynamic options/2.

toggle(X,Old,New) :-
	global(X,Old,off),
	toggle_opposite(Old,New),
	set_option(X,New).
	
global(X,Y,_D) :- options(X,Y),!.
global(_,D,D).

set_option(X,Y) :-
	retractall(options(X,_)),
	assert(options(X,Y)).

set_option_on(X) :- set_option(X,yes).
set_option_off(X) :- set_option(X,no).

option(X) :- global(X,yes,no).

toggle_opposite(yes,no).


itOr(Goal,_Default,_Out) :- Goal,!.
itOr(_Goal,Default,Default).

inside(_,Y)     :- var(Y),  !, fail.
inside(X,Y)     :- listp(Y),!, member(X,Y).
inside(X,(Y,Z)) :-          !, (X = Y | inside(X,Z)).
inside(X,X).

	
:- dynamic flags/2.

myflag(X,Y,Z) :-
	retract(flags(X,Y)),
	!,
	New is Z,
	assert(flags(X,New)).
myflag(X,_,Z) :-
	New is Z,
	assert(flags(X,New)). 

tick_init(X) :-
	retractall(flags(X,_)),
	Tick is cputime,
	assert(flags(X,[init - Tick])).

tick(X,Y) :-
	retract(flags(X,Old)),
	!,
	Tick is cputime,
	assert(flags(X,[Y-Tick|Old])).
tick(X,Y) :-
	write(tickFailed(X,Y)).

tick_done(X) :-
	retract(flags(X,Ticks0)),
	tick_summary(Ticks0,Ticks),
%	nl,print(ticks(Ticks0)),write('.'),nl,
	nl,print(ticks(Ticks)),write('.'),nl,
%	tick_report(Ticks),
	!.
tick_done(X) :- 
	format('% tick finalisation failure: ~q',X).

tick_report([Item1 - Finish|Rest]) :-
	last(_ - Start,Rest),
	Elapsed is Finish - Start,
	(Elapsed > 0
	->	tick_report1([Item1 - Finish|Rest],Elapsed)
	|	tick_report2([Item1 - Finish|Rest])).

tick_report1([init - _],_).
tick_report1([_ - Time1,Item0 - Time0|Rest],Elapsed) :-
	Delta is Time1 - Time0,
	Percent is (Delta*100/Elapsed),
	format('~q = ~1f (~1f%)~n',[Item0,Delta,Percent]),
	tick_report1([Item0 - Time0|Rest],Elapsed).

tick_report2([init - _]).
tick_report2([_ - _,Item0 - Time0|Rest]) :-
	format('~q = ~1f (~1f%)~n',[Item0,0,0]),
	tick_report2([Item0 - Time0|Rest]).

tick_summary([Item1 - Finish|Rest],
	     [total - Elapsed /100|Out]) :-
	last(_ - Start,Rest),
	Elapsed is Finish - Start,
	(Elapsed > 0
	->	tick_summary1([Item1 - Finish|Rest],Elapsed,Out)
	|	tick_summary2([Item1 - Finish|Rest],Out)).

tick_summary1([_ - _,init - _],_,[]).
tick_summary1([_ - Time1,Item0 - Time0|Rest],
	      Elapsed,[Item0 - Delta/Percent|Rest1]) :-
	\+ Item0 = init,
	Delta is Time1 - Time0,
	Percent is integer((Delta * 100) / Elapsed),
	tick_summary1([Item0 - Time0|Rest],Elapsed,Rest1).
	
tick_summary2([_ - _,init - _],[]).
tick_summary2([_ - _,Item0 - Time0|Rest],
	      [Item0 - 0/0|Rest1]) :-
	\+ Item0 = init,
	tick_summary2([Item0 - Time0|Rest],Rest1).


n(G,N) :-
	gensym(ncounting,Flag),
	flag(Flag,_,0),
	n1(Flag,G,N).

n1(Flag,G,N) :-
	G,
	flag(Flag,N,N+1),
	fail.
n1(Flag,_,N) :-
	flag(Flag,N,N).
	
%-----------------
% return copy of the input, with all constants
% replaced by variables. 

skeleton(In,Out,Vars) :-
	skeleton(In,Out,[],Vars).

skeleton(In,Out,Vars0,Vars) :-
	In =.. [H|T0],
	skeleton1(T0,T1,Vars0,Vars),	
	Out =.. [H|T1].

skeleton1([],[],Vars,Vars).
skeleton1([H0|T0],[H1|T1],Vars0,Vars) :-
	var(H0), !,
	track_vars(Vars0,H0==H1,Vars1),
	skeleton1(T0,T1,Vars1,Vars).
skeleton1([H0|T0],[H1|T1],Vars0,Vars) :-
	functor(H0,_,0),!,
	track_vars(Vars0,H0==H1,Vars1),
	skeleton1(T0,T1,Vars1,Vars).
skeleton1([H0|T0],[H1|T1],Vars0,Vars) :-
	skeleton(H0,H1,Vars0,Vars1),
	skeleton1(T0,T1,Vars1,Vars).

track_vars([],         X==Y, [X==Y   ]).
track_vars([X0==Y|T ], X==Y, [X0==Y|T]) :- X == X0, !.
track_vars([H    |T0], X==Y, [H    |T]) :- track_vars(T0,X==Y,T).

%-----------------
normalise_alist(In,Out) :-
	sum_alist(In,N),
	normalise_alist1(In,N,Out). 

sum_alist(X,Y) :-
	sum_alist(X,0,Y).
sum_alist([],Out,Out).
sum_alist([_ = N|T],In,Out) :-
	Temp is In + N,
	sum_alist(T,Temp,Out).

normalise_alist1([],_,[]).
normalise_alist1([A=Old|T],Max,[A=New|T1]) :-
	New is Old / Max,
	normalise_alist1(T,Max,T1).

%-------------------------------
% given lists storing frequency counts of X,Y, etc
% of the form [X = N1,Y = N2,..], randomly return N of X,Y, etc
% with the same liklihood as the rations N1, N2, ...

random_amember(Alist,Member) :- % default is to return one only
	random_amember(Alist,1,Member).

random_amember(Alist,N,Member) :-
	accumulate_alist(Alist,0,AC,Max),!,
	between(1,N,_),
	Random is random(Max) + 1,
	random_amember1(AC,Random,Member).

accumulate_alist([],Max,[],Max).
accumulate_alist([H=V0|T0],Current,[H=V1|T],Max) :-
	V1 is V0 + Current,
	accumulate_alist(T0,V1,T,Max).

random_amember1([H=V0|_Rest],Goal,H)  :- Goal =< V0,!.
random_amember1([H|T],Goal,Out)  :- random_amember2([H|T],Goal,Out).

random_amember2([H=_],_,H).
random_amember2([_H=V0,Next=V1|_Rest],Goal,Next) :-
	Goal > V0, Goal =< V1,!.
random_amember2([_,H|Rest],Goal,Out) :-
	random_amember2([H|Rest],Goal,Out).

%---------
% random member of a list.
random_member(List,Member) :- % default is to return one only
	random_member(List,1,Member).

random_member(List,N,Member) :-
	length(List,Max),
	between(1,N,_),
	Random is random(Max) + 1,
	nth(List,Random/Member).

random_delete(List0,Member,List) :- 
	length(List0,Max),
	Random is random(Max) + 1,
	random_delete1(List0,1,Random,Member,List).

random_delete1([H|T],Goal,Goal,H,T) :- !.
random_delete1([H|T],Position,Goal,Out,[H|T1]) :- 
	Position1 is Position + 1,
	random_delete1(T,Position1,Goal,Out,T1).


random_members(List,N,Members) :-
	length(List,Max),
	random_numbers(N,Max,Numbers),
	random_members1(Numbers,1,List,Members).

random_members1([],_,_,[]).
random_members1([N|Rest],N,[H|T],[H|Others]) :- !,
	N1 is N + 1,
	random_members1(Rest,N1,T,Others).
random_members1([H|Rest],N,[_|T],Out) :-
	N1 is N + 1,
	random_members1([H|Rest],N1,T,Out).

random_numbers(N,Max,S) :-
	set_new(S0),
	random_numbers(N,Max,S0,S).

random_numbers(0,_,S,S) :- !.
random_numbers(N,Max,S0,S) :-
	Random is random(Max) + 1,
	(set_newel(S0,Random,S1)
	->	N1 is N - 1,
		random_numbers(N1,Max,S1,S)
	;	random_numbers(N,Max,S0,S)).
	
