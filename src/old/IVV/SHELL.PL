%value must be whole term

:- [lib, %frames,
	lurch,ranges].

reworkByPhase(Who,A,B,C,D) :-
	reworkByPhase(Who,A,B,C),
	D is 1*(C/B)*C.

normalize(M0,M) :- 
	once(normalize1(M0,M)).
normalize1(M0,M) :-
	sums(M0,Sums),
	defectDensity(_,Density),
	ksloc(K),
	TotalErrors is K*Density,
	Factor is TotalErrors/Sums,
	maplist(normalize2(Factor),M0,M).

normalize2(F,L0,L) :- maplist(normalize3(F),L0,L).

normalize3(F,N0,N) :- N is F * N0.

randomize(M0,M) :-
	doubts(D), 
	maplist(randomize1(D),M0,M).

randomize1(D,L0,L) :- maplist(randomize2(D),L0,L).

randomize2(D,N0,N) :-  
	S is N0 * D,
	N is max(0,normal(N0,S)).

leaks(L) :-
	 leakages(L0),
	 normalize(L0,L1),
	 randomize(L1,L).
	
%leakage(A,B,C) :- 
%	once(leakage1(A,B,C)).

leakage(From,To, Leak) :-
	leaks(All),
	nth1( To0,All,Row),
	To is To0 + 1,	
        nth1(From,Row,  Leak). 

reworkByPhase(N,X) :- 
	reworkByPhase(_,A,B,C,D),  
	arg(N,reworkByPhase(A,B,C,D),X).

rework(I,R) :-	rework(I,0,I,R).

rework(J,K,I,Out) :- 
	(J=1 -> X= (-); X= (+)),
	rework1(X,J,K,I,Out).

rework1(-,_,_,_,0).
rework1(+,J0,K0, I,L*C*F+Rest) :-
		J is J0 - 1, 
		X is I - J, 
		K is K0 + 1, 
        	Y is I - K, 
		leakage(X,I,L),
		costToFix(I,C),
		reworkByPhase(Y,F),
		rework(J,K,I,Rest).	

reworks(L,X) :- reworks(L,0,X).

reworks([],In,In).
reworks([H|T],X1,Out) :-
	rework(H,X2),
	X3 is X1 + X2,
	reworks(T,X3,Out).

maxIVVBenefit(C,L,MaxSavedRework,MaxRework,Savings,PBenefit) :-
	reworks(L,MaxSavedRework),
	cmmRework(C,Percent0),
	reworkSaved(_,Factor),
	Percent is Factor * Percent0,	
	budget(K), 
	MaxRework is Percent*K,
	Savings is max(0,MaxRework - MaxSavedRework),
	PBenefit is round(Savings)*100/K.

benefit1(Type,C,Savings,PBenefit) :- 	
	cmm(C),
	ivv(Type,Phases), 
	maxIVVBenefit(C,Phases,_,_,Savings,PBenefit).

benefit :-
	benefit1(Type,C,Savings,PBenefit),
	format(
        '~w IV&V: level ~w project; reduce rework by $~w (i.e. ~w% of budget)\n',
         [Type,C,Savings,PBenefit]).

dot :- write('.'),flush_output(user).

n0 :- flag(nn,_,0).
n  :- flag(nn,B,B+1).

data(N) :- time((
		tell('ivv.data'),
		benefits(N),
		told)).

benefits(N) :-  repeats(N,benefits1).

benefits1 :- 
	once(lurch(benefit1(_,_,_,P0),L)), 
	 reports(L),
	P is round(P0), 
	%range(P,Range),
	
	format('~w\n',P).

reports(L0) :-
	sort(L0,L),
	allChoices(All),
	(All=L
	-> memberRs(All,Flat,_N),
	   forall(member(Show,Flat),
	          showIt(Show))
	;  print(user,barph(L)),
           nl(user),
           abort).

memberRs(All,L,N) :- 
	findall(Z,(member(X,All),
                   choice(X,_,_,Y),
                   memberR(Z,Y)),
                L),
	length(L,N).

memberR(X,X) :- atomic(X), X \= [].
memberR(X,Y) :-
	compound(Y),
	arg(_,Y,Z),
	memberR(X,Z).

showIt(X) :- var(X),  !,format('~w,','?').
showIt(X) :- float(X),!,format('~2f,',X).
showIt(X) :- format('~w,',X).
 
header :- 
	tell('ivv.names'),
	header1,
	told.

header1 :- 
	write('0,10,20,30,40,50,60\n'),
	allChoices(L),
	forall(header2(L),true).

header2(L) :-
	member(What,L),
	clause(choice(What,Name,Type,Value),_),
	header3(Type,What,Name,Value),
	telling(X),
	flush_output(X).
	
header3(continuous,leaks([H|T]),_,_) :- !,
	leaks([H|T]),
	length(H,Cols),
	length([H|T],Rows),		 
	between(1,Rows,Row),
	between(1,Cols,Col),
	Row1 is Row + 1,	
	phase(Row1,Phase1),
	phase(Col ,Phase2),
	format('\n''~w'' : continuous',[from(Phase2)/to(Phase1)]).
	
header3(continuous,_,Name,_) :- 
	format('\n~w : continuous',[Name]).
header3(descrete,What,Name,Value) :-
	format('\n~w : ',Name),
	findall(Value,What,L0), sort(L0,L),
	printl(L,', ').

allChoices(All) :-
	setof(X,choices(X,X),All).


	
