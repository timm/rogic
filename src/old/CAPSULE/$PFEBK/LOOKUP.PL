
defWme(N,wme0(Wme)) :-
	length(L0,N),
	maplist(empty,L0,L),
	Wme =.. [wme|L].
defWme(N,(key0(In,Out) :- 
                hash_term(In,H), 
                Out is H >> X)) :-
	X is (log(N)/log(2)) - 1.
defWme(Size,delta1(I0,Old,New,T1,T2)) :-
	between(1,Size,I),
	I0 is I - 1,
	functor(T1,wme,Size),
	functor(T2,wme,Size),
	joinArgs(I,Old,New,T1,T2).

empty([],[]).

joinArgs(N,Old,New,T1,T2) :-
	T1 =.. [_|L0],
	T2 =.. [_|L],
	joinArgs(1,N,L0,Old,New,L).
joinArgs(N,N,[Old|Rest],Old,New,[New|Rest]).
joinArgs(N0,N1,[X|L0],Old,New,[X|L]) :- 
	N0 < N1,
	N2 is N0 + 1,
	joinArgs(N2,N1,L0,Old,New,L).

term_expansion(wmeSize(N),L) :-
	findall(One,defWme(N,One),L).

wmeSize(32).


delta(N,X0,X,In,Out) :-
	delta1(N,X0,X,In,Temp),
	(X0=[] -> true ; true),
	(oneLess(X0,X=Y,X)
         ->
		

oneLess([One|Less],One,Less).
oneLess([H|Tail],X,[H|Rest]) :- oneLess(Tail,X,Rest).

