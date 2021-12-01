term_expansion((X - Y = Z :- Body),
               (test1(X,Y) :- Body 
                             ->  portray_clause((test(X,Y)  :- Z)) 
                              ;  format('E> test case failed: [~p - ~p]\n'
                                        ,[X,Y]),
                                 fail)).	

X-Y :- clause(test1(X,Y),_),!,time(test1(X,Y)).
X-Y :- format('E> unknown test case: [~p - ~p]\n',[X,Y]).

loading- 1 = X :- 
	goal_expansion(when with   [day=1
                                 ,sad
                                 ,month=2
                                 ,happy
                                 ],X).

loading- 2 = X :-
	goal_expansion(when with   [day=1
                                 ,sad
                                 ,second= day with [month=41]
                                 ,month=2,happy
                                 ],X).

bagger - 1 = X :-
	once(@cond(X)), 
	print(X),
	runiv(X,Y), 
	nl, 
	lPrint(Y).
% show that the average of a gamma distribution is it's mean
stats- 1 = D :-
        A=1000,
        nSum(A, B is gamma(40, 1), B, _C, D).

% show that the mean of a beta is its mean
stats- 2 = D :-
        A=1000,
        nSum(A, B is beta(0.67), B, _C, D).

stats -3 = D :-
	A=10000,
        nSum(A,range(-10,20,0.67,B),B,_C,D).

stats - 4 = t :-
	forall(member(Bin/Mean,[0.1/10,0.1/25,0.1/60,0.1/90]),
	       sampleBeta(5000,Mean,Bin)).

stats - 5 = t :- 
	forall(member(Bin/A,[30/1,20/2,10/8,5/20]),
               sampleGamma(40,5000,Bin,A)),nl.

sampleBeta(A,Mean,Bin) :-
	format('
  |--------------|
__| mean=~d      |___________________
  | repeats=~d |
  |--------------|
'
              ,[Mean,A]),
	bagof(B,I^(between(1,A,I),
                   B is round(range(0,1,Mean)/Bin)*Bin),
              L),
	sum(L,Sum),
	Av is Sum/A,
	nl,write('  '),print(average=Av),nl,
        dist(5,5,100,L).

sampleGamma(M,N,F,A) :-
	format('
  |--------------|
  | mean=~d      |
--| alpha=~2P     |-------------------
  | repeats=~d |
  |--------------|
'
              ,[M,A,N]),
	findall(B,(between(1,N,_),
                   B is round(gamma(M,A)/F)*F),L),
	sum(L,Sum),
	Av is Sum/N,
	nl,write('  '),print(average=Av),nl,
	dist(5,5,50,L).
	
