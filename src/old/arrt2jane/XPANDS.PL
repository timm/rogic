:- + [plog].

rule= r(id,conditions).

kb = k(in,out,known,domain,source,
	   aka,who,domain,stuff).

me(kb).
domain(X) <--
	:: domain := domain(X).
source(_Who,Word,when(Year,Month,Day,_,_,_)) <--
	:: source << (Word=[month=Month,day=Day,year=Year]),
	:: who := Word.
aka(X,Y0,_) <--
	{name(Y,Y0)},
	:: aka << (portray(X) :- write(Y)).
(r(Id,_,Chances,Cost,_) :- Subs) <--
	{c2r(Subs,R)},
	:: who = Who,
	rule::[id=Id,conditions=R,self(Rule)],
	:: stuff << (Who says cost=Cost and chances=Chances),
	:: stuff << Rule.
r(Id,_,Chances,Cost,_)  <--
	:: who = Who,
	:: stuff << (Who says cost= Cost and chances=Chances),
	:: stuff << (Id/true).
f(A,B,C,D,E) <--
	:: stuff << f(A,B,C,D,E).
p(A,B,C,D,E) <--
	:: stuff << p(A,B,C,D,E).
impact(f(X),r(Y),N,_) <--
	:: stuff << impact(A,B,C,D).
effect(f(X),r(Y),N,_) <--
	:: stuff << effect(A,B,C,D).
init <--
	   :: in    := 'in.pl',
	   :: out   := 'out.pl',
	   :: known := [],
	   :: stuff := [],
	   :: who   := [],
	   :: aka   := [].
          
go(I,S) <--
	::[in=I,self(S)].

- ::do(_).
do([])      <-- [].
do([X=Y|T]) <-- !,::[X:=Y,do(T)].
do([H|T])   <-- ::H, !, ::do(T).
do([H|T])   <-- {huh(failed,H)}, ::do(T).

inits <-- ::init, {commandLine(C)}, ::do(C).

go <--       ::inits,
	     ::in=I,
	     ::{readsPlus(I,All)},
	     ::do(All).

kb(go) :- kb(go,_,_).

readsPlus(F,L) :-
	see(F), read(X), readsPlus1(X,L), seen,!.

readsPlus1(end_of_file,[]) :- !.
readsPlus1((+X:- Y),[(X :- Y)|T]) :- !,
	read(Z),
	readsPlus1(Z,T).
readsPlus1(+X, [X|T]) :-
	read(Y),
	readsPlus1(Y,T).

c2r((A,B),(A ror C)) :-  !, c2r(B,C).
c2r(A,A).