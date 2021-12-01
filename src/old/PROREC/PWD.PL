
% operators used in this paper.
:- op(999,xfx,if), op(998,xfx,then), op(997,xfx,or), op(996,xfx,and), 
   op(995,fx,not), op(50,xf,++),     op(50,xf,--),   op(50,xfx,in),
   op(10,fx,rule), op(9,xfx,at).

rule    'check for badly paying job; version 4' 
at      10                                       % rule priority
if      employee(Name,Job,_Age) and 
        salary(Job,0)
then    print(error(Name-poorlyPaid(Job))).

rTrans2(rule Name at Priority if Lhs0 then Rhs, 
        rule(Name,UsedIds,Ages,Specificity,Priority,Lhs,Rhs)) :-
        rTrans2(Lhs0,Lhs,[],Ages,0,Specificity,[],UsedIds).

rTrans2(A0 and B0,A and B,Ages0,Ages,       Spec0,Spec,  UsedIds0,UsedIds) :- !, 
        rTrans2(A0,A,     Ages0,Ages1,      Spec0,Spec1, UsedIds0,UsedIds1),
        rTrans2(B0,B,     Ages1,Ages,       Spec1,Spec,  UsedIds1,UsedIds).
rTrans2(A0 or B0, A or B, Ages0,Ages,       Spec0,Spec,  UsedIds0,UsedIds) :- !,
        rTrans2(A0,A,     Ages0,Ages1,      Spec0,Spec1, UsedIds0,UsedIds1),
        rTrans2(B0,B,     Ages1,Ages,       Spec1,Spec,  UsedIds1,UsedIds).
rTrans2(not A0, not A,    Ages0,Ages,       Spec0,Spec,  UsedIds0,UsedIds) :- !,
       rTrans2(A0,A,      Ages0,Ages,       Spec0,Spec,  UsedIds0,UsedIds).
rTrans2(A0,A,             Ages0,[Age|Ages0],Spec0,Spec,  UsedIds0,[Id|UsedIds0]) :-
        A0 =.. [Functor|Args],
        A  =.. [Functor,Id,Age|Args],
        Spec is Spec0 + 1.

rTrans(rule Name at Priority if Lhs0 then Rhs,Rule) :- 
        create(rule,[name=Name, priority=Priority, rhs=Rhs, lhs=Lhs], Rule0),
        rTrans(Lhs0,Lhs,Rule0,Rule).

rTrans(A0 and B0,A and B) --> !, rTrans(A0,A), rTrans(B0,B).
rTrans(A0 or B0, A or B)  --> !, rTrans(A0,A), rTrans(B0,B).
rTrans(not A0, not A)     --> !, rTrans(A0,A).
rTrans(A0,A) -->
        { A0 =.. [Functor|Args],
          A  =.. [Functor,Id,Age|Args] },
        o([ages<<Age,specificity++,usedIds<<Id]).

fChain1 :-  fChain1([]). % initialise the bindings
fChain1(Bindings0) :-
        rule Name if Lhs then Rhs,
        satisfied(Lhs),
        newBinding(Name,Lhs,Bindings0,Bindings), !,
        execute(Rhs),
        fChain1(Bindings).
fChain1(_).

satisfied(A  or B) :- !, (satisfied(A) ; satisfied(B)).
satisfied(A and B) :- !, satisfied(A), satisfied(B).
satisfied(not A)   :- !, \+ satisfied(A).
satisfied(A)       :- A.

newBinding(Name,Lhs,Bindings, [Name-Lhs|Bindings]) :- %don't repeat old bindings      
       \+ member(Name-Lhs,Bindings).

execute(A and B)   :- !, execute(A), execute(B).
execute(A)         :- A.

rule    'check for badly paying job'
if      employee(Name,Job,_Age) and 
        salary(Job,0)
then    print(error(Name-poorlyPaid(Job))).

rule    'check for badly paying job; version 2' 
==      [Id1,Id2]
if      employee(Id1,Name,Job,_Age) and 
        salary(Id2,Job,0)
then    print(error(Name-poorlyPaid(Job))).

fChain2 :-  fChain2([]). % initialise the bindings
fChain2(Bindings0) :-
        rule Name == UsedIds if Lhs then Rhs,
        satisfied(Lhs),
        newBinding(Name,UsedIds,Bindings0,Bindings), !,
        execute(Rhs),
        fChain2(Bindings).
fChain2(_).

rule    'check for badly paying job; version 3' 
if      employee(Name,Job,_Age) and 
        salary(Job,0)
then    print(error(Name-poorlyPaid(Job))).

rTrans1(Name if Lhs0 then Rhs, Name == UsedIds if Lhs then Rhs) :-
        rTrans1(Lhs0,Lhs, [],     % initialise used Ids to the empty set
                          UsedIds % final value of the used Ids
        ).

rTrans1(A0 and B0,A and B,UsedIds0,UsedIds) :- !, 
        rTrans1(A0,A,UsedIds0,UsedIds1),
        rTrans1(B0,B,UsedIds1,UsedIds).
rTrans1(A0 or B0, A or B,UsedIds0,UsedIds) :- !,
        rTrans1(A0,A,UsedIds0,UsedIds1),
        rTrans1(B0,B,UsedIds1,UsedIds).
rTrans1(not A0, not A, UsedIds0,UsedIds) :- !,
       rTrans1(A0,A,UsedIds0,UsedIds).

rTrans1(A0,A,UsedIds0,[Id|UsedIds0]) :-
        A0 =.. [Functor|Args],
        A  =.. [Functor,Id|Args].

rTrans1Test(What) :-
        rule  What if Lhs0 then Rhs0,
        rTrans1(rule What if Lhs0 then Rhs0,Out),
        print(Out),nl.

rTrans2Test(What) :-
        rule  What at Priority if Lhs0 then Rhs0,
        rTrans2(rule What at Priority if Lhs0 then Rhs0,Out),
        print(Out),nl.

rTrans3(rule Name at Priority if Lhs0 then Rhs,Rule) :- 
        create(rule,[name=Name, priority=Priority, rhs=Rhs, lhs=Lhs], Rule0),
        rTrans3(Lhs0,Lhs,Rule0,Rule).

rTrans3(A0 and B0,A and B,R0,R) :- !, rTrans3(A0,A,R0,R1), rTrans3(B0,B,R1,R).
rTrans3(A0 or B0, A or B, R0,R) :- !, rTrans3(A0,A,R0,R1), rTrans3(B0,B,R1,R).
rTrans3(not A0,   not A,  R0,R) :- !, rTrans3(A0,A,R0,R).
rTrans3(A0,       A,      R0,R) :-
        A0 =.. [Functor|Args],
        A  =.. [Functor,Id,Age|Args],
        o([ages<<Age,specificity++,usedIds<<Id],R0,R).

o0(F,Term,V) :- o1(Term,F,V0),!,V = V0.
o0(F,Term,V) :- write(failed(o0(F,Term,V))), nl, fail.

% updates
o(Field=New, T0,T)    :- o0(Field,T0,_), swap(T0,_,Field,T,New).
% accessors
o(Field==X,     T, T) :- o0(Field,   T,X).

% queries
o(\+ X,         T, T) :- \+ o(X,          T,_).                 % negation
o(Field>=Value, T, T) :-    o(Field==X,   T,T), X >= Value.     % comparisons
o(Field> Value, T, T) :-    o(Field==X,   T,T), X > Value.
o(Field\=Value, T, T) :-    o(Field==X,   T,T), X \= Value.
o(Field< Value, T, T) :-    o(Field==X,   T,T), X < Value.
o(Field=<Value, T, T) :-    o(Field==X,   T,T), X =< Value.     
o(Field in List,T, T) :-    o(Field==X,   T,T), member(X,List). % membership

% updates
o(Field++, T0,T) :- o(Field + 1,       T0,T).                   % increment
o(Field--, T0,T) :- o(Field + -1 ,     T0,T).                   % decrement
o(Field-N, T0,T) :- o(Field + (-1 * N),T0,T).                   % minus
o(Field<<X, T0,T) :-                                            
        o(Field==Old,T0,T1),                                    % list append
        New = [X|Old],                                          % to head
        o(Field=New,T1,T).                                      % (fast)
o(Field+N, T0,T) :-                                             % plus
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
        retract(meta(Type,Skeleton, Match,Swap)),
        retractall(create(Type,_)),
        retractall((o1(Skeleton, _, _))),
        retractall(Match),
        retractall((swap(Skeleton, _,_,_,_))),
        retractall(Swap),
        retractall(portray(Skeleton)), 
        !.
undefineRecord(_).

% pretty print a record
printRec(R) :- nl,o1(R,F,V), print(F=V),nl, fail.
printRec(_).

% print all assertions by defRecord/2.
records :- record(_), fail.
records.

% print all assertions relating to Type
record(Type) :-
        meta(Type, Skeleton,Match,Swap), nl, 
        write('%------| '),write(Type),write(' |----------------------------'),nl,
        myListing([     meta(Type, Skeleton,Match,Swap), 
                      portray(Skeleton), create(Type,Skeleton),
                      o1(Skeleton,_,_), swap(Skeleton,_,_,_,_), 
                      Match,Swap]).

myListing(L) :- member(X,L), nl, clause(X,Y), portray_clause((X :- Y)), fail.
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
        (portray(Term) :- write('[Rec:'),write(Functor/Arity),write(']'))) :-
       functor(Term,Functor,Arity).

defRecord1(Functor,Arity,_Inits,MagicName,meta(Functor,Skeleton,MatchG,SwapG)) :-
        functor(Skeleton,Functor,Arity),
        functor(MatchG,MagicName,3),
        functor(SwapG,MagicName,5).

defRecord1(Functor,Arity,_,MagicName,(o1(Term,Field,Value) :- Body)) :-
        Body =.. [MagicName,Field,Term,Value],
        functor(Term,Functor,Arity).

defRecord1(Functor,Arity,_,MagicName,(swap(Term0,V0,Field,Term,V) :- Body)) :-
        Body =.. [MagicName,Field,Term0,V0,Term,V],
        functor(Term0,Functor,Arity).

% create the primitive accessors
defRecord1(Functor,Arity,Inits,MagicName,MatchGoal) :-
        aField(Inits,Pos,Field),
        MatchGoal =.. [MagicName,Field,Term,Value],
        functor(Term,Functor,Arity),
        arg(Pos,Term,Value).

defRecord1(Functor,Arity,Inits,_,create(Functor,Creation)) :-
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
           age=<100, age in [3,4,5]],           R0),
        
        % use the system in update mode        
        o([age=45, age++, age++,   age--,   
           duties<<planning  ,duties<<auditing
           ], R0,R1),
        nl, write('oTest1: '), 
        printRec(R1).

defRecordTimingTest :-
        defRecord(rule, [name,lhs,rhs,usedIds=[],
                  ages=[],specificity=0,priority=0]),
        defRecordTimingTest1(Rule1),
        defRecordTimingTest1(Rule2),
        timeIt(rTrans2(Rule1,_),500,T1),
	timeIt(rTrans( Rule2,_),500,T2),
	SlowDown is (T2 - T1) /T1,
	print(rTrans2(T1)), nl,print(rTrans(T2)), nl,
        print(costOfDefRecord(SlowDown)),nl.

% generate a BIG rule
defRecordTimingTest1(rule test at 10 if Lhs then print(1)) :-
        functor(C1, a,10), functor(C2, b,10), functor(C3, c,10),
        functor(C4, d,10), functor(C5, e,10), functor(C6, f,10),
        functor(C7, g,10), functor(C8, h,10), functor(C9, i,10),
        functor(C10,j,10), functor(C11,k,10), functor(C12,l,10),
        functor(C13,m,10), functor(C14,n,10), functor(C15,o,10),
        Lhs =    
          (C1 and not C2 or (C3 and not (C4 or C5)) and 
           not (not C6 or C7 and not (C8 or C9)) or
           C10 and (C11 or C12 and not C13 and C14 or C15)).

timeIt(G,T) :- timeIt(G,10,T).

timeIt(G,N,Time) :- timeIt1(true,N,T1),timeIt1(G,N,T2),Time is T2 -T1.

timeIt1(Goal, N,T) :- 
        T1 is cputime, timeIt2(Goal,N), T2 is cputime, T is (T2 - T1)/N.

timeIt2(Goal, Repeats) :- between(1,Repeats,_), Goal, fail.
timeIt2(_,_).

