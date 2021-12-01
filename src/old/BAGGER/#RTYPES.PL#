% strings
rstring(X)  :- nonvar(X),!.
rstring(X)  :- gensym(rsym,X).

% atoms (not strings)
rsym(X)  :- nonvar(X), !,atom(X).
rsym(X)  :- var(X),  gensym(rsym,X).

rletter(X) :- 
	All=[a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z],
        (nonvar(X)
        ->  member(X,All)
        ;   rone(l(All,26),X)).

% ranges
int(Mean,Alpha,G) :- var(G),!, G is max(1,round(gamma(Mean,Alpha))).
int(_,_,G) :- G >= 0.

rnum(M,N,X) :- rnum(M,N,1,X).

rnum(M,N,_,X) :-  nonvar(X), !, number(X),M =< X, X =< N.
rnum(M,N,O,X) :- rnum1(M,N,O,X).

rnum1(M,N,_,_) :- M > N, !, fail.
rnum1(M,N,O, X) :-
	D is floor((N - M)/2/O), 
	rone(l([1,2,3],3),Control,_),
	rnum1(Control,M,N,D,O,X).

rnum1(1, M,_,D,O,X) :- 	X is M+D*O.
rnum1(2, M,_,D,O,X) :-  Upper is M+((D-1)*O), rnum1(M,Upper,O,X).
rnum1(3, M,N,D,O,X) :-  Lower is M+((D+1)*O), rnum1(Lower,N,O,X).

% lists	
rin(X,L) :- number(X),!, member(Y,L), X =:= Y. 
rin(X,L) :- nonvar(X),!, member(X,L). 
rin(X,L) :- length(L,N), rone(l(L,N),X,_).

rone(l([H]  ,_),H,l([],  0)) :- !.
rone(l([H|T],N),X,l(Out,N1)) :-
	N1 is N - 1,
	Pos is rand(N) + 1,
	oneLessN(Pos,[H|T],Y,L),
	(X=Y, Out=L
	; Out=[Y|Rest],
	  rone(l(L,N1),X,l(Rest,_))).

oneLessN(1,[H|T],H,T) :- !.
oneLessN(N0,[H|T],X,[H|Rest]) :- N is N0 - 1, oneLessN(N,T,X,Rest).	

range(Min,Max,Peak,Out) :- 
	% only defined peaks: 10,20,25,33,40,50,60,67,75,80,90
	var(Out),!,
	Out is Min + (Max-Min)*beta(Peak/100).
range(Min,Max,_,Out) :- 
	Out >= Min, Out =< Max.

splitL(L,Size,Peak,Before,After) :-
	length(L,Size),
	N1 is round(range(1,Size,Peak)),
	splitL1(N1,L,Before,After).

splitL1(0,L,[],L).
splitL1(N,[H|T],[H|Rest],L) :- 
	N > 0,
	N1 is N - 1,
	splitL1(N1,T,Rest,L).

splitN(N,Peak,Before,After) :-
	splitN(1,N,Peak,Before,After),
	After > 0.

splitN(Min,Max,Peak,Before,After) :-
	var(Before), var(After),
	Before is round(range(Min,Max,Peak)),
	After is Max - Before.
splitN(_Min,Max,_Peak,Before,After) :-
	nonvar(Before), var(After),
	After is Max - Before.
splitN(_Min,Max,_Peak,Before,After) :-
	var(Before), nonvar(After),
	Before is Max - After.
splitN(Min,Max,_,Before,After) :-
	nonvar(Before), nonvar(After),
	Before + After =:=  Max - Min + 1.

&X :- 
	bagof(X/Y,clause(X,Y),All), 
	length(All,N),
	rone(l(All,N),X/Goal,_),
	call(Goal).

P // L :- maplist(ok(P),L,L).

ok(P,X,X) :-
    Goal =.. [P,X],
    @Goal.



C @ A :- atClause(A,C,D), D.

atClause(A,C,D) :- clause(@C,D), functor(C,A,_).
