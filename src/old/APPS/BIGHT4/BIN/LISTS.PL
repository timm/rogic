listp(-) :- !, fail.
listp([]).
listp([_|_]).
	
%-- lists
combos([],[]).
combos([L1|Others],[H|T]) :- remove1(L1,H,_), combos(Others,T).


remove1([H|T],H,T).
remove1([H1|T],X,[H1|T1]) :- remove1(T,X,T1).

removes([],_).
removes([Item|Rest],L) :- remove1(L,Item,L1), removes(Rest,L1).


nth(L,Out) :- nth(L,1,Out).
nth([H|_],N,N/H).
nth([_|T],N,Out) :- N1 is N + 1, nth(T,N1,Out).

%member(H,[H|_]).
%member(X,[_|T]) :- member(X,T).

after(X,[X|T],T).
after(X,[_|T],Y) :- after(X,T,Y).

remove2(L,X1,X2) :-
	after(X1,L,Rest),
	member(X2,Rest).

end(L,L) :- !.
end(X,L) :- end1(X,L).

end1(L,[_H|L]).
end1(L,[_H|T]) :- end1(L,T).
	


