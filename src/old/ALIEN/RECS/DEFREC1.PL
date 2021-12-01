% serious prolog magic
copyArgs(T0,Except,Old,New,T) :-
        T0 =.. [Functor|Args0],
        copyArgs1(Args0,1,Except,Old,New,Args),
        T  =.. [Functor|Args].
copyArgs1([],_,_,_,_,[]).
copyArgs1([Old|Args],Pos,Pos,Old,New,[New|Args]) :- !.
copyArgs1([Arg|Args0],Pos0,Except,Old,New,[Arg|Args]) :-
        Pos is Pos0+1, 
        copyArgs1(Args0,Pos,Except,Old,New,Args).

% if the record is named X, accessor is 'at_X'
accessorName(F,N) :- 
     name(F,X),name('0',Y), append(X,Y,Z), name(N,Z).

% nth item of a term, or a term if nth don't exist
firstItem(X,Y) :- arg(1,X,Y),!.
firstItem(X,X).

secondItem(X,Y) :- arg(2,X,Y),!.
secondItem(_,_).

asEqList([],_,[]).
asEqList([H|T],[Var|Vars],[H=Var|Rest]) :-
     asEqList(T,Vars,Rest).


indexTerm(Term,(:- index(Index))) :-
	functor(Term,F,A),
	functor(Index,F,A),
	indexN(1,4,A,Index).

indexN(I,_,Stop,_) :- I > Stop,!.
indexN(I0,MaxIndex,Max,Term) :-
	(I0 > MaxIndex
        -> Index=0
        ;  Index=1),
        arg(I0,Term,Index),
	I is I0 + 1,
	indexN(I,MaxIndex,Max,Term).
