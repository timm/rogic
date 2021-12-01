edge(x,y).
edge(y,z).
edge(y,a).
edge(z,b).

path(A,B,How) :- path(A,B,[],How).

path(A,B,Path,[B|Path]) :- edge(A,B).
path(A,B,Path0,Path) :-
	\+ member(A,Path0),
	edge(A,C),
	path(C,B,[A|Path0],Path).

addt(X,T0,T) :-
	in(+,X,T0,T).

deletet(X,T0,
membert(X,T) :- in(=,X,T,T).

emptyt(nil)

egMemberT :- list2tree([name=eric,age=23,home=australia, 
	               income=high, car=fast],_,T),
		       printt(T),
		       membert(name=Who,T),
		        membert(income=What,T),
		       print(Who=What),nl.

in(+,X,T, t(T,X,T)) :- emptyt(T).
in(Mode,X,t( L, Root, R),T)  :-
	compare(Op,X,Root),
	in1(Op,Mode,X,t(L,Root,R),T).

in(=,_, Root,t(L, Root,R), t(L,Root,R)).
in1(>,Mode,X,t(L, Root,R0),t(L,Root,R)) :- in(Mode,X,R0,R).
in1(<,Mode,X,t(L0,Root,R ),t(L,Root,R)) :- in(Mode,X,L0,L).



egIn :- lists(5,L), list2tree(L,T), printt(T).

list2tree(L,T) :- emptyt(Empty),list2tree(L,Empty,T).
list2tree([],T,T).
list2tree([X|Y],T0,T) :- in(+,X,T0,T1), list2tree(Y,T1,T).

printt(T) :- printt(T,2,''),nl.
printt(Empty,_,_) :- emptyt(Empty).
printt(t(X,Y,Z),Indent,Prefix) :-
	nl,tab(Indent),write(Prefix),write(Y),
	printt(X,Indent+4,<),
	printt(Z,Indent+4,>).



split( _, [], [], []).
split( X, [Y|Tail], [Y|Small], Big)  :-
	X @> Y, !,
    split( X, Tail, Small, Big).
split( X, [Y|Tail], Small, [Y|Big])  :-
   split( X, Tail, Small, Big).

quicksort( [], []).
quicksort( [X|Tail], Sorted)  :-
   split( X, Tail, Small, Big),
   quicksort( Small, SortedSmall),
   quicksort( Big, SortedBig),
   append( SortedSmall, [X|SortedBig], Sorted).

quicksort2(List,Sorted) :-
	quicksort2a(List,Sorted-[]).

quicksort2a( [], Z - Z).

quicksort2a( [X | Tail], A1 - Z2)  :-
   split( X, Tail, Small, Big),
   quicksort2a( Small, A1 - [X | A2] ),
   quicksort2a( Big, A2 - Z2).

lists(N,L) :- bagof(R,N^lists1(N,R),L).

lists1(N,R) :-
	between(1,N,_),
	R is random(10000).

egSort :-
	lists(10000,X),
	time(quicksort(X,_)), % 503,114 inferences in 0.62 secs
	time(quicksort2(X,_)) % 411,705 inferences in 0.26 secs 
	time(sort(X,_)).      % 1 inferences in 0.01 secs

