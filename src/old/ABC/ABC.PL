term_expansion((X+Y),Out) :-
	term_expansion((X+Y :- true),Out).

term_expansion((X+Y :- Z),Out) :-
	xpands((X+Y :- Z),Out).

 tidies(A,All)   :- tidies(A,0,All).
 tidies(A,M,All) :- bagof(C,A^tidy(A,M,C),All).
% add clause ids

 tidy(A,M,C) :- tidy1(A,M,B), (B= (D:- true)-> C=D; C=B).

 tidy1(A,M,C) :- once(tidy0(A,M,B)), tidy2(B,M,C)).
 
 tidy0(X,                     _,'_self'(A)) :- var(A).
 tidy0((true;A),                _,'_do'(A)).
 tidy0((A;true),                _,'_do'(A)).
 tidy0((X;Y),                      _,(X;Y)).
 tidy0(A,                    _, '_self'(A)) :- var(A).
 tidy0((A,B),      _,('_self'(A),'_do'(B))) :- var(A).
 tidy0((A,B),      _,('_do'(A),'_self'(B))) :- var(B).
 tidy0(((A,B),C),                _,(A,B,C)). 
 tidy0((true,A),                _,'_do'(A)).
 tidy0((A,true),                _,'_do'(A)).
 tidy0((A=A,B),    1,              '_do'(B).
 tidy0((A,B=B),    1,              '_do'(A).
 tidy0((A0->B0),                _,(A -> B)).
 tidy0(not(A0),                   _,not(A)).
 tidy0((A :- B),                  _,(A:-B))
 tidoer0(A,                   _,'_self'(A)).

 tidy2('_self'(A),_,     A).
 tidy2('_do'(A0), M,     A) :- tidy1(A0,M,A).
 tidy2(not(A0),   M,not(A)) :- tidy1(A0,M,A).
 tidy2((X;Y),     1,     Z) :- tidy(X,M,Z);  tidy(Y,M,Z).
 tidy2((X0;Y0),   0, (X;Y)) :- tidy(X0,M,Z), tidy(Y0,M,Y).
 tidy2((A :- B), M,R) :-
	tidy1(B,M,TB),(TB=true->R=A; R=(A:-TB)).
  tidy2((A0 -> B0), M,R) :-
	tidy1(A0,M,A),
	tidy1(B0,M,B), (A=true-> R=B; R=(A->B)).
 tidy2((A,B),M,R) :-
	tidy1(A,M,TA), tidy1(B,M,TB), (TB=true -> R=TA; R=(TA,TB)).
 
wme_(F := V,   D) --> wme_(F/_/V,D).
wme_(F=V,      D) --> wme_(F/V/V,D).
wme_((X,Y),    D) --> wme_(X,D), wme_(Y,D).

wme0(F/V0/V,[F| _],[V0| Vs], [ V|Vs]).
wme0(F/V0/V,[_|Fs],[V1|Vs1], [V1|Vs]) :- wme0(F/V0/V,Fs,Vs1,Vs). 

about(W,Fs,Vs) :- def(W,_,Fs), length(Fs,N), length(Vs,N).

find(wme(W,Id,Values),Fields) :- about(W,Fields,Values), =wme(W,Id,Values).