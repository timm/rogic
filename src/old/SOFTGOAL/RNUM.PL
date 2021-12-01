
level(t(_,_,N,L,_),N0,N1,N) :-
	bSize(N0,L),
	N1 is N0 + 1.

% return an item in a binary tree, in any order
rtree(K=V,t(K0,V0,N,L,R)) :-
	level(t(K0,V0,N,L,R),T1,T2,Size),
	Num is random(Size)+1,
	What2Do is random(6),
	r(What2Do,Control),
        rtree1(Control,Num,T1,T2,t(K0,V0,N,L,R),K=V).
	
rtree1(2,Num,T1,_ ,t(_,_,_,T,_),K=V) :- Num =< T1, rtree(K=V,T).
rtree1(3,Num,_ ,T2,t(_,_,_,_,T),K=V) :- Num =< T2, rtree(K=V,T).
rtree1(1,_  ,_ ,_ ,t(K,V,_,_,_),K=V).

r(0,1). r(0,2). r(0,3).
r(1,1). r(1,3). r(1,2).
r(2,2). r(2,1). r(2,3).
r(3,2). r(3,3). r(3,1).
r(4,3). r(4,1). r(4,2).
r(5,3). r(5,2). r(5,1).

rtreeDemo :-
	between(1,10,_),
	nl,
	l2t([k=1,m=2,s=5,a=4,n=2
            ,b=0,g=19,f=1,z=0,y=2],B),
	rtree(X,B),
	format(' ~w',[X]),
	fail.
rtreeDemo :- nl.

roneStuff :- roneStuff(10000,T), format('~e\n',[T]).
roneStuff(N1,T) :-
       L0=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20],
       append(L0,L0,L1),
       append(L1,L1,L),
       T1 is cputime,
       bagof(One,I^L^Rest^N1^(between(1,N1,I),once(rone(L,One,Rest))),Out),
	T2 is cputime,
	bagof(One,I^N1^(between(1,N1,I),true),Out),
	T3 is cputime,
	T is ((T2 - T1) - (T3 - T2))/N1,
       dist(5,5,50,Out).	

someRandomKeys(N,All) :-
	bagof(One,N^someRandomKey(N,One),All).

someRandomKey(N,X=a) :-
	between(1,N,_),
	Y is random(1000),
	X is Y + (random(1000)/1000).

% rnum(M,N,X): same method as above, now 
% it is randomly selected numbers
rnum(M,N,X) :-
	M =< N,
        D is (N - M) // 2,
	What2Do is random(5),
	r(What2Do,Control),
        rnum1(Control,M,N,D,X).

rnum1(1, M,_,D,X) :-  X is M+D.
rnum1(2, M,_,D,X) :-  Upper is M+(D-1), rnum(M,Upper,X).
rnum1(3, M,N,D,X) :-  Lower is M+(D+1), rnum(Lower,N,X).

% and just cause i can- M to N numbers by steps of "O"
rnum(M,N,O,Out) :-
	Top is (N-M)// O,
	rnum(0,Top,X),
	Out is M + X*O.

%---------------------------------------------
% histogram stuff
bins(L,B) :-  msort(L,L1), bins(L1,[],B).

bins([],X,X).
bins([H|T],[H-N0|Rest],Out) :- !,
	N is N0 + 1, bins(T,[H-N|Rest],Out).
bins([H|T],In,Out) :-
	bins(T,[H-1|In],Out).

dist(L) :- dist(5,5,3,L).

% histogram display stuff
% W1,W2= width of columns 1 and 2
% W3 = round off factor for column 3
dist(W1,W2,W3,L) :-
	sformat(S,'~~~w>  ~~~w> ~~~w*\n',[W1,W2,W3]),
	bins(L,Bins),
	nl,
	format(S,[item,frequency,0]),
	forall(member(What-N,Bins),format(S,[What,N,N])).

histDemo :-
	bagof(X,I^(between(1,10000,I),
	           X is floor((random(1000)/1000)*20)
	          ),All),
	dist(5,5,20,All).

%---------------------------------------------
% stuff for right justified printing and printing stars
:- format_predicate('>',padChars(_,_)).
:- format_predicate('*',stars(_,_)).

padChars(default,A) :- padChars(5,A).
padChars(S,A) :-
	sformat(String,'~p',[A]),
	string_length(String,N),
	Pad is S - N, 
        forall(between(1,Pad,_),put(32)),
        write(A).

stars(default,A) :- stars(25,A).
stars(W,N) :-
	N1 is round(N/W),
	forall(between(1,N1,_),write('*')).

indent(N0,C) :-
	N is N0, forall(between(1,N,_),write(C)).
