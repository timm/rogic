o0(F,Term,V) :- o1(Term,F,V0),!,V = V0.
o0(F,Term,V) :- oops(['failed field access',F = V,' in',print(Term)]).

oops(X) :- writeList(['%..E>'|X]),fail.

writeList([H|T]) :- 
        write(H), member(Item,T),write(' '), writeListItem(Item), fail.
writeList(_) :- nl.

writeListItem(print(X)) :- !, print(X).
writeListItem(X) :- write(X).


% updates
o(Field=New, T0,T)    :- o0(Field,T0,_), swap(T0,_,Field,T,New).
% accessors
o(Field==X,     T, T) :- o0(Field,   T,X).

% queries
o(Field>=Value, T, T) :-    o(Field==X,   T,T), X >= Value.     
o(Field> Value, T, T) :-    o(Field==X,   T,T), X > Value.
o(Field\=Value, T, T) :-    o(Field==X,   T,T), X \= Value.
o(Field< Value, T, T) :-    o(Field==X,   T,T), X < Value.
o(Field=<Value, T, T) :-    o(Field==X,   T,T), X =< Value.     
o(Field in List,T, T) :-    o(Field==X,   T,T), member(X,List). 

% updates
o(Field++, T0,T) :- o(Field + 1,       T0,T).                   
o(Field--, T0,T) :- o(Field + -1 ,     T0,T).                   
o(Field-N, T0,T) :- o(Field + (-1 * N),T0,T).                   
o(Field<<X, T0,T) :-                                            
        o(Field==Old,T0,T1),                                    
        New = [X|Old],                                          
        o(Field=New,T1,T).                                      
o(Field+N, T0,T) :-                                             
        o(Field==Old,T0,T1),                                    
        New is Old + N, 
        o(Field=New,T1,T).

% queries only (ignore the output)
o(Gs,T) :- o(Gs,T,_).

o([],T,T).
o([G|Gs],T0,T) :- 
        o(G,T0,T1), 
        o(Gs,T1,T).

create(Thing,Inits,New) :- 
        create(Thing,New0), 
        o(Inits,New0,New).

undefineRecord(Type) :-
        retract(meta(Type,Skeleton, Match,Swap)), % already exists
        !,
        %writeList(['%Re-defining [',Type,'].']),
        retractall(create(Type,_)),
        retractall((o1(Skeleton, _, _))),
        retractall(Match),
        retractall((swap(Skeleton, _,_,_,_))),
        retractall(Swap),
        retractall(portray(Skeleton)).
undefineRecord(_Type) :- 
        %writeList(['%Defining [',Type,'].']).      % new
	true.
	

example(Type,Eg) :- meta(Type,Eg,_,_).

access(Type,Eg)       :- example(Type,Eg), Eg.
access(Type,Tests,Eg) :- access(Type,Eg), o(Tests,Eg).

update(X0,Changes)   :- o(Changes,X0,X), retract(X0), assert(X).

databaseTest :-
        defRecord(databaseTest,[name,age]),
        create(databaseTest,[age=1],New), 
        assert(New),
        access(databaseTest,[age==1],Found1),
        printRec(Found1),
        update(Found1,age++),
        access(databaseTest,[age==2],Found2),
        printRec(Found2).

% pretty print a record
printRec(V) :- var(V),!,oops(['variable passed to [printRec]']).
printRec(R) :- nl,o1(R,F,V), print(F=V),nl, fail.
printRec(_).

% print all assertions by defRecord/2.
records :- record(_), fail.
records.

% print all assertions relating to Type
record(Type) :-
        meta(Type, Skeleton,Match,Swap), nl, 
        write('%------| '),write(Type),
        write(' |----------------------------'),nl,
        myListing([     meta(Type, Skeleton,Match,Swap), 
                      portray(Skeleton), create(Type,Skeleton),
                      o1(Skeleton,_,_), swap(Skeleton,_,_,_,_), 
                      Match,Swap]).

myListing(L) :- 
        member(X,L), nl, clause(X,Y), portray_clause((X :- Y)), 
        fail.
myListing(_).

defRecord(Functor,Inits) :-
        undefineRecord(Functor),
        length(Inits,Arity),
        magicRecordNames(Functor,MagicName),
        defRecord1(Functor,Arity,Inits,MagicName,Assertion),
        assert(Assertion),
        fail.
defRecord(_,_).

magicRecordNames(Functor,Out) :-
        name(Functor,L0),
        name('0',Zero),
        append(L0,Zero,Out0),
        name(Out,Out0).

defRecord1(Functor,Arity,_,_,
        (portray(Term) :- write('[Rec:'),
                          write(Functor/Arity),write(']'))) :-
       functor(Term,Functor,Arity).

defRecord1(Functor,Arity,_Inits,MagicName,
                   meta(Functor,Skeleton,MatchG,SwapG)) :-
        functor(Skeleton,Functor,Arity),
        functor(MatchG,MagicName,3),
        functor(SwapG,MagicName,5).

defRecord1(Functor,Arity,_,MagicName,
                   (o1(Term,Field,Value) :- Body)) :-
        Body =.. [MagicName,Field,Term,Value],
        functor(Term,Functor,Arity).

defRecord1(Functor,Arity,_,MagicName,
                   (swap(Term0,V0,Field,Term,V) :- Body)) :-
        Body =.. [MagicName,Field,Term0,V0,Term,V],
        functor(Term0,Functor,Arity).

% create the primitive accessors
defRecord1(Functor,Arity,Inits,MagicName,MatchGoal) :-
        aField(Inits,Pos,Field),
        MatchGoal =.. [MagicName,Field,Term,Value],
        functor(Term,Functor,Arity),
        arg(Pos,Term,Value).

defRecord1(Functor,Arity,Inits,_,
                   create(Functor,Creation)) :-
        functor(Creation,Functor,Arity),
        installInitValues(Inits,1,Creation).

defRecord1(Functor,Arity,Inits,MagicName,Swap) :-
        aField(Inits,Pos,Field),
        Swap =.. [MagicName,Field,Term0,Old,Term,New],
        functor(Term,Functor,Arity),
        functor(Term0,Functor,Arity),
        Term0 =.. [_|T0_fields],
        Term  =.. [_|T_fields],
        swapVars(T0_fields,T_fields,1,Pos,Old,New).

aField(Inits,Pos,Field) :-
        nth(Inits,Pos/Item),
        (Item = (Name = _)
        ->        Field = Name
        ;        Field = Item). 

installInitValues([],_,_).
installInitValues([_=InitValue|FieldNames],N0,Term0) :- !,
        arg(N0,Term0,InitValue),
        N is N0 + 1,
        installInitValues(FieldNames,N,Term0).        
installInitValues([_|FieldNames],N0,Term0) :-
        N is N0 + 1,
        installInitValues(FieldNames,N,Term0).  

swapVars([Value0|T],[Value  |T],Pos,Pos,Value0,Value) :- !.
swapVars([H|T1],[H|T2],N0,Pos,Value0,Value) :- 
        N is N0 + 1,
        swapVars(T1,T2,N,Pos,Value0,Value).

average(L,Av) :- sum(L,Sum),length(L,N), Av is Sum/N.

sum(L,Sum) :- sum(L,0,Sum).
sum([],Out,Out).
sum([H|T],In, Sum) :- Temp is H + In, sum(T,Temp,Sum).

nth(L,Out) :- nth(L,1,Out).
nth([H|_],N,N/H).
nth([_|T],N,Out) :- N1 is N + 1, nth(T,N1,Out).

oTest :-
        defRecord(oTest,[age,duties]),
        record(oTest),
        create(oTest,[age=5,duties=[]],R0),
        nl,write('oTest0: '), 
        printRec(R0),
        % use the system in query mode
        o([age>=4, age>4, age\=20, age<100, 
           age=<100, age in [3,4,5]], R0),
        % use the system in update mode        
        o([age=45, age++, age++,   age--,   
           duties<<planning  ,duties<<auditing
           ], R0,R1),
        nl, write('oTest1: '), 
        printRec(R1).


timeIt(G,T) :- timeIt(G,10,T).

timeIt(G,N,Time) :- 
        timeIt1(true,N,T1),timeIt1(G,N,T2),Time is T2 -T1.

timeIt1(Goal, N,T) :- 
        T1 is cputime, timeIt2(Goal,N), 
        T2 is cputime, T is (T2 - T1)/N.

timeIt2(Goal, Repeats) :- between(1,Repeats,_), Goal, fail.
timeIt2(_,_).

