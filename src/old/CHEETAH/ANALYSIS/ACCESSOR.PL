portray(X) :- var(X),!, write(X).

% auto-writing the accesor
term_expansion(X is Y - L,Out) :-
        makeAccessors(X is Y - L,Out).

makeAccessors(X,Out) :-
        bagof(One,X^makeAccessor1(X,One),Out).

makeAccessor1(Op is Functor - Fields,Y) :-
	gensym(term,SecretInternalName),
	length(Fields,Arity),
	makeAccessor2(SecretInternalName,Op,
                      Functor,Arity,Fields,Y).

makeAccessor2(_,  Op,_,_,_, (:- op(899,fx,(Op)))).
makeAccessor2(_,  _, F,A,_, (:- dynamic F/A)).
makeAccessor2(_,  Op,_,_,_, (:- discontiguous (Op)/3)).
makeAccessor2(XXX,_, F,A,_, (portray(Hide) 
                               :- write(+F/A))):-functor(Hide,XXX,A).
makeAccessor2(XXX,Op,F,A,_, (Head :- Term)) :-
	Head =.. [Op,get,Hide,Hide],
	length(Args,A),
	Hide =.. [XXX|Args],
	Term =.. [F|Args].

% serious prolog guru magic starts
makeAccessor2(XXX,Op,_,A,Fields,Out) :-
        functor(Term1,XXX,A),
        functor(Term2,XXX,A),
        nth1(Pos,Fields,Item),
        joinArgs(Pos,Old,New,Term1,Term2),
        Out =.. [Op,Item,Old,New,Term1,Term2].

joinArgs(N,Old,New,T1,T2) :-
    T1 =.. [_|L0],
    T2 =.. [_|L],
    joinArgs(1,N,L0,Old,New,L).
joinArgs(N,N,[Old|Rest],Old,New,[New|Rest]).
joinArgs(N0,N1,[X|L0],Old,New,[X|L]) :-
    N0 < N1,
    N2 is N0 + 1,
    joinArgs(N2,N1,L0,Old,New,L).

