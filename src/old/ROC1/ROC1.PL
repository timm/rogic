:- discontiguous datum/2,header/2,h/3.
:- flag(n,_,1).

term_expansion(header=X,Out) :- 
	bagof(One,X^header(X,One),Out).
term_expansion(datum =X,tagged(I,Datum)) :- 
	flag(n,I,I+1), 
	Datum =.. [datum|X].
	
header(L,h(Name,Type,Id)) :- nth1(Id,L,Name=Type).

classes(L) :- bagof(X,class(X),L0),bins(L0,L).

class(X) :- tagged(_,Datum), argN(Datum,X).

sum([H|T],Sum) :- sum(T,H,Sum).
sum([],Sum,Sum).
sum([H|T],Temp0,Sum) :- Temp is Temp0+1, sum(H,Temp,Sum).

bins(L0,L) :- bins(L0,_,_,L).

bins(L0,Min,Max,L) :- 
	msort(L0,[Min|L1]), 
	bins([Min|L1],[],Min,Max,L).

bins([],X,Max,Max,X).
bins([H|T],[H-N0|Rest],_,Max,Out) :- !, 
	N is N0 + 1, 
	bins(T,[H-N|Rest],H,Max,Out).
bins([H|T],In,Min,Max,Out) :-   
	bins(T,[H-1|In],Min,Max,Out).

argN(T,Last) :- functor(T,_,A), arg(A,T,Last).


	

