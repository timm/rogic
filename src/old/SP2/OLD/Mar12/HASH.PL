
% auto-writing the accessor
term_expansion(buckets(B),[buckets(B)|Out]) :-
        makeHashTable(B,Out).

makeHashTable(X,Out) :-
        bagof(One,X^makeHashTable1(X,One),Out).

empty(_,[]).

% serious prolog guru magic starts
makeHashTable1(Arity,t0(Term)) :-
        length(L,Arity),
        maplist(empty,L,L1),
        Term=.. [t|L1].



makeHashTable1(B,Out) :-
        Arity=B,
        Functor=t,
        between(0,B,Pos0),
        Pos is Pos0 + 1,
        functor(Term1,Functor,Arity),
        functor(Term2,Functor,Arity),
        joinArgs(Pos,Old,New,Term1,Term2),
        Out =.. [Functor,Pos0,Old,New,Term1,Term2].

joinArgs(N,Old,New,T1,T2) :-
    T1 =.. [_|L0],
    T2 =.. [_|L],
    joinArgs(1,N,L0,Old,New,L).
joinArgs(N,N,[Old|Rest],Old,New,[New|Rest]).
joinArgs(N0,N1,[X|L0],Old,New,[X|L]) :-
    N0 < N1,
    N2 is N0 + 1,
    joinArgs(N2,N1,L0,Old,New,L).

goal_expansion(lookup(X,Y),Y is X mod B) :- buckets(B).

buckets(4).

% main drivers
insert(Key,V,Table0,Table) :-
        lookup(Key,Hash),
	t(Hash,Bucket0,Bucket,Table0,Table),
        (oneLess(Bucket0,Key=Q0,Bucket1)
        ->      qpush(V,Q0,Q),
                Bucket=[Key=Q|Bucket1]
        ;       qpush(V,_,Q),
                Bucket=[Key=Q|Bucket0]).
         
remove(Key,V,Table0,Table) :-
        lookup(Key,Hash),
	t(Hash,Bucket0,[Key=Q|Bucket1],Table0,Table),
        oneLess(Bucket0,Key=Q0,Bucket1),
        qpop(V,Q0,Q).


swapOut([],Key,New,[Key=New]).
swapOut([Key=_|Rest],Key,New,[Key=New|Rest]) :- !.
swapOut([H|T],Key,New,[H|Rest]) :-
	swapOut(T,Key,New,Rest).

oneLess([H|T],H,T).
oneLess([H|T],X,[H|Rest]) :- oneLess(T,X,Rest).


inserts(L,T) :- t0(T0), inserts(L,T0,T).

inserts([],X,X).
inserts([X=Y|Tail],In,Out) :-
        nl,print(X=Y),nl,
	insert(X,Y,In,Temp),
	inserts(Tail,Temp,Out).

removes(Q0,Out) :- 
  remove(K,V,Q0,Q1)
  -> Out=[K=V|T],
     removes(Q1,T)
  ;  Out=[].

pqtest0b :-
	L = [0=one
	    ,1=two
	    ,1=three
	    ,2=four
	    ,2=five
	    ,2=six
	    ,3=seven
	    ,3=eight
		,4=nine
		,4=ten
		,4=eleven
		,4=twelve
             ,12=thirteen
             ,7=fourteen
	    ],
	print(L), nl, nl,
	inserts(L,Q),
        forall(t(F,V,V,Q,Q),(print(F=V),nl)),
        
	removes(Q, L2),
	print(L2), nl.
