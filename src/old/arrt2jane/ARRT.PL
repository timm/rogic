%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% config stuff

:- load_files([arrtrc],[silent(true),if(changed)]).


% tell martin
% +r(r11,1,1,0,v1).
%          ^---------- defaults to 1 for leaf requirements
%                        "      to 0 for non-leaf.

%+aka(goal,goal,v1).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compiler stuff

:- discontiguous edge/4, node/3.
:- index(node(1,1,0)).
:- index(edge(1,1,0,0)).

xpand(tempnode(A,B,0),node(A,B,0)) :- !.
xpand(tempnode(A,B,C0),node(A,B,C)) :- 
	C is around(C0).
xpand(tempedge(A,B,1,D),edge(A,B,1,D)) :- !.
xpand(tempedge(A,B,C0,D),edge(A,B,C,D)) :-
	C is prob(around(C0)).

xpand((+r(Require,W,S,_,_) :- From),Out) :- 
	c2l(From,L),
	bagof(tempedge(One,Require,W,+),L^ member(One,L),Temp),
	xpand([tempnode(r,Require,S)|Temp],Out).


xpand((+p(Require,W,S,_,_) :- From),Out) :- 
	c2l(From,L),
	bagof(tempedge(One,Require,W,+),L^ member(One,L),Temp),
	xpand([tempnode(p,Require,S)|Temp],Out).

xpand((+f(Require,W,S,_,_) :- From),Out) :- 
	c2l(From,L),
	bagof(tempedge(One,Require,W,+),L^ member(One,L),Temp),
	xpand([tempnode(f,Require,S)|Temp],Out).


xpand(+effect(Fault,Pact,W,_),Out) :-
	xpand(tempedge(Pact,Fault,W,-),Out).
	%Out = edge(Pact,Fault,W,-).
xpand(+impact(Fault,Require,W,_),Out) :-
	xpand(tempedge(Fault,Require,W,*),Out).
	%Out = edge(Fault,Require,W,*).
xpand(+X,Out) :-
	functor(X,F,5),
	member(F,[r,f,p]),
	arg(1,X,One),
	arg(2,X,Two),
	xpand(tempnode(F,One,Two),Out).
	%Out = node(F,One,Two).

xpand([H|T],Out) :- maplist(xpand,[H|T],Out).
xpand(_,[]).

c2l((X,Y),[X|T]) :- !, c2l(Y,T).
c2l(X,[X]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% main
gos(N,In) :- forall(between(1,N,_), go(In,goal)).
go       :- go(goal).

:- write('To run, try ''gos(10,eg003)'''),nl.

go(Top)  :- runtime(go1(Top)).
go(File,Top) :- go1(File,Top).

go1(Top) :- reset, run(Top), report(Top).
go1(File,Top) :-
	retractall([edge/4,node/3]),
	load_files([File],[silent(true)]),
	go1(Top).

reset :-
	retractall(memo0(_,_)),
	retractall(known(_)),
	nodes(p,Pacts),  rsome(Pacts, UsedP), maplist(yes,UsedP,_).

yes(X,X) :- assert(known(X)).

run(Top) :-
	forall(memo(r(Top,_Out)),true).
report(Top) :-
	%details,
	%dd,
	data(Top).

details :-
	fail, % currently disabled
	format('\n\n% ----------------------------\n',[]),
	write('% IF\ttrue\n'),
	mysetof(known(X),known(X),Knowns),
	forall(member(known(X),Knowns),
	       format('% \t~w\n',[X])),
	write('% THEN '),
	mysetof(memo0(X),H^memo0(H,X),Memos),
	forall(member(memo0(Y),Memos),
	       (arg(1,Y,Key),
	        arg(2,Y,Value),
		format('\t~w = ~w\n%',[Key,Value])
	      )).
	
data :- data(goal).
data(Top) :-
	todo(optimize),
	write('data'),
	forall((node(p,P1,_),leaf(P1)),
	        ((known(P1) -> A5=1 ; A5=0),
		format(',~w',[A5]))),
	memo(r(Top,Topc)),
	format(',~w\n',[Topc]).

data(Top) :-
	todo(sensitize),
	write('data'),
	forall(edge(_,_,A3,_),
	        format(',~w',[A3])),
	forall((node(f,FF,A4),leaf(FF)),
	        format(',~w',[A4])),
	memo(r(Top,Topc)),
	format(',~w\n',[Topc]).

dd :- todo(sensitize), write('\ndd'),
	forall(edge(A,B,_,_),
	        format(', ~w/~w',[A,B])),
	forall((node(f,A1,_),leaf(A1)),
	        format(', ~w',[A1])),
	write(',goal\n').

dd :- todo(optimize), write('\ndd'),
	forall((node(p,A2,_),leaf(A2)),
	        format(',~w',[A2])),
	write(',goal\n').

% what to show where?



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% all of arrt in 22 lines
f(F,S) :- node(f,F,S0), f1(F,S0,S).
p(P,S) :- node(p,P,S0), p1(P,S0,S).
r(R,S) :- node(r,R,S0), r1(R,S0,S).

f1(F,S0,S) :- bagof(P, F^pactsEdge(F,P) ,All),        !, prod(All,Prod), S is S0 * Prod.
f1(F,S0,S) :- bagof(F1,F^faultEdge(F,F1),All),        !, sum(All,Sum),   S is S0 + Sum.
f1(_,S,S).

p1(P,S0,S) :- bagof(P1,P^pactsEdge(P,P1),All),        !, sum(All,Sum),   S is S0 + Sum.
p1(P,S,S)  :- known(P).

r1(R,S0,S) :-  bagof(Fx,R^faultEdge(       R,Fx),All),!, sum(All,Sum),   S is S0 * prob(Sum).
r1(R,S0,S) :-  bagof(Fx,R^requirementsEdge(R,Fx),All),!, sum(All,Sum),   S is S0 + Sum.
r1(_,S, S). 

requirementsEdge(To,S) :- touchedBy(To,From,r,S0), memo(r(From, R)),     S is S0 * R.
faultEdge(       To,S) :- touchedBy(To,From,f,S0), memo(f(From, F)),     S is S0 * F.
pactsEdge(       To,S) :- touchedBy(To,From,p,S0), memo(p(From, P)),     S is 1  - (S0*P).

touchedBy(Me,Him,Type,S) :- edge(Him,Me,S,_),node(Type,Him,_).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% graph query stuff
nodes(All) :-	setof(Thing,What^W^node(What,Thing,W),All).
node1(One) :-	nodes(All),member(One,All).

nodes(What,All) :-	setof(Thing,What^W^node(What,Thing,W),All).
node1(What,One) :-	nodes(What,All),member(One,All),leaf(One).

leaf(X) :- \+ edge(_,X,_,_).

parents(X,S,All) :-
	bagof(Y/W,X^S^(edge(Y,X,W,S),known(Y)),All),
	once(edge(_,X,_,S)).

anyParents(X,S,All) :-
	bagof(Y/W,X^S^(edge(Y,X,W,S)),All),
	once(edge(_,X,_,S)).

connectors :- forall(connector(X),(print(X),nl)).

connector(T1/T2) :-
	L=[p,r,f],
	member(T1,L),
	member(T2,L),
	T1 @=< T2, 
	once((node(T1,A,_),
	      edge(A,B,_,_),
	      node(T2,B,_))).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% display kb stuff

% text dump: boring!
kb :- listing(edge), listing(node/3), listing(known).

nedges(N) :- sumOf(1,A^B^C^D^edge(A,B,C,D),N).
nnodes(N) :- sumOf(1,A^B^C^node(A,B,C),N).

% show as a graph: cool!
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
	forall(node1(Thing),
	      describeNode(Thing)),
	forall(edge(A,B,C,D),
	       describeEdge(edge(A,B,C,D))),
	write('}').
describeEdge(edge(A,B,C,D)) :-
	D=(+)
        -> format(' ~w -> ~w\n',[A,B])
	;  format(' ~w -> ~w [label=\"~w~w\"]\n',[A,B,D,C]).
	
describeNode(Thing) :-
	node(What,Thing,Score),
	tag(Thing,Name0),
	newlines(Name0,Name),
	shape(What,Shape),
	(Score=0
        ->  format(' "~w" [label="~w:\\n~s ",shape=~w]\n',
	          [Thing,Thing,Name,Shape]) 
	;   format(' "~w" [label="~w:\\n~s@~w",shape=~w]\n',
	           [Thing,Thing,Name,Score,Shape])).
			 
shape(p,box).
shape(r,ellipse).
shape(f,plaintext).

newlines([],[]).
newlines([32|T0],[92,110|T]) :- !,newlines(T0,T).
newlines([H|T0], [H|T]     ) :- newlines(T0,T).

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

:- arithmetic_function(rr/0).
:- arithmetic_function(beta/1).
:- arithmetic_function(around/1).
:- arithmetic_function(prob/1).

around(X,Out) :-
	jiggle(J), skew(S),
	range(X-(X*J),X+(X*J),S,Out).

range(X,Y,Z,Out) :-
	Out is (beta(Z)*(Y-X)) + X.

prob(A,B) :- B is min(1,max(0,A)).
rr(N)     :- N  is random(10000)/10000.

beta(N,X) :- beta1(N,X),!.
beta(N,X) :- N1 is 1 - N, beta1(N1,Y),X is 1 - Y.

beta1(0.50,X) :- X is rr.
beta1(0.60,X) :- X is rr^0.67.
beta1(0.67,X) :- X is rr^0.5.
beta1(0.75,X) :- X is rr^0.33.
beta1(0.80,X) :- X is rr^0.25.
beta1(0.9,X)  :- X is rr^(1/9).
beta1(1,1).

rsome(L,Some) :-
	length(L,X),
	N is random(X+1),
	once(rsome(N,L,Some)).

rsome(0,_,[]).
rsome(N0,L,[One|Some]) :-
	N0 > 0,
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

memo(X) :-  X.
/*
	arg(1,X,Key),
	functor(X,F,_),
	hash_term(F=Key,Hash),
	(memo0(Hash,X)
        ;  X,
	   assert(memo0(Hash,X))).
*/
runtime(X) :-
	T1 is cputime,
	X,
	T2 is cputime,
	T is T2 - T1,
	format('\n% runtime = ~w secs',[T]).

sum([],0).
sum([H|T],Out) :- sum(T,H,Out).
sum([],X,X).
sum([H|T],In,Out) :- Temp is H + In, sum(T,Temp,Out).

prod([],1).
prod([H|T],Out) :- prod(T,H,Out).
prod([],X,X).
prod([H|T],In,Out) :- Temp is H * In, prod(T, Temp,Out).

unique(X,Y) :- unique(X,[],Y).

unique([],X,X).
unique([H|T],Seen,Out) :- member(H,Seen), !, unique(T,Seen,Out).
unique([H|T],Seen,Out) :- unique(T,[H|Seen],Out).
	
mysetof(A,B,C) :- setof(A,B,C),!.
mysetof(_,_,[]).

mybagof(A,B,C) :- bagof(A,B,C),!.
mybagof(_,_,[]).

sumOf(A,B,C) :- mybagof(A,B,Temp), sum(Temp,C).

prodOf(A,B,C) :-mybagof(A,B,Temp), prod(Temp,C).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% stuff to go last

term_expansion(+aka(X,Y,_),    tag(X,Y)).
term_expansion((+Head :- Body),Out) :- xpand((+Head :- Body),Out).
term_expansion(+In,Out)             :- xpand(+In,Out).
