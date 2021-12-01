:- [main,t028].

or(Out) :-
	
	clause(x(A,_,C),Body),
	(Out=[C]-(A=C)
	;membera(x(B,_,D),Body),
	 Out=[D]-(B=D)),
	Out \= [0]-_.

ors(All,N) :- 
	setof(One,or(One),All), length(All,N).

:- dynamic n/2.
:- index(n(1,1,1)).

n0(n(X,Y,N1)) :- 
	ors(All,_), 
	nth1(N,All,One),
	arg(2,One,X=Y),
	(Y = -1
	-> Delta = 0
	;  Delta = 1),
	N1 is N + Delta.
	
flip(X=1  , X= -1, X=1).
flip(X= -1, X=  1, X= -1).

n0s :- 
	retractall(n(_,_,_)), 
	forall(	n0(X),
		assert(X)).



%rule(IF,Then).

rulesp :-
	rules(All),
	length(All,N2),
	N is N2 /2,
	write(N),nl,
	forall(member(One,All),format('~a ~a ~a ~a~n',One)).

rules(All) :-
	setof(One,rule1(One),All).

rule1(Out) :-
	rule2(A0,P0,C0,W),
	flip(P0,BPa=BPv,Pa=Pv),
	flip(C0,BCa=BCv,Ca=Cv),
	n(Pa,Pv,P),
	n(Ca,Cv,C),
	n(BPa,BPv,BP),
	n(BCa,BCv,BC),
	(Out = [A0,P,C,W]
	;Out = [A0,BP,BC,W]
	).
	
rule2(0,C=D,A=B,0) :-
	clause(x(A,_,B),x(C,_,D)),
	B \= 0.

rule2(1,X=Y,A=B,0) :-
	clause(x(A,_,B),(x(C,_,D),x(E,_,F))),
	B \= 0,
	member(X=Y,[C=D,E=F]).


:- n0s.

io(N,Out,In) :-
	clause(go(_,_,_),ht0(N,Out0,In0,_,_)),
	findall(X=Y,(member(X=Y,In0), Y \= 0,n(X,Y,_)),In),
	findall(X=Y,(member(X=Y,Out0),Y \= 0,n(X,Y,_)),Out).


main(Ins) :- 
	io(N,Outs,Ins),
	sformat(Fname,'~p.m',[N]),
	tell(Fname),
	rulesp,
	length(Ins,Size),
	nl,
	write(Size),nl,
	forall(member(A=B,Ins),
		(n(A,B,C)
		,format('0 0 ~p 0~n',[C ])
		)),
	told,
	sformat(OutName,'~p.c',[N]),
	tell(OutName),	
	prins(Outs),
	told.

nis(A=B,N) :- n(A,B,N).
prins(L) :-
	maplist(nis,L,[H|T]),
	write('if('),
	prin1('     ',H,_),
	maplist(prin1('     && '),T,_),
	write('
   ){
     printf("Property is True\\n");
} else {
     printf("Property is False\\n");
}
').

prin1(P,S,_) :-
	format('~n~w(S[~p]==1 || T[~p]==1)',[P,S,S]).

