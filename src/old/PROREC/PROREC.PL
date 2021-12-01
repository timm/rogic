
% operators used in this paper.
:- op(999,xfx,if),  op(998,xfx,then), op(997,xfx,or), 
   op(996,xfx,and), op(995,fx,not),   op(50,xf,++),     
   op(50,xf,--),    op(50,xfx,in),    op(50,fx,self),
   op(10,fx,rule),  op(9,xfx,at).

rule    'check for badly paying job; version 4' 
at      10     % rule priority
if      employee(Name,Job,_Age) and 
        salary(Job,0)
then    print(error(Name-poorlyPaid(Job))).

rTransB(rule Name at Priority if Lhs0 then Rhs, 
        rule(Name,UsedIds,Ages,Specificity,Priority,Lhs,Rhs)) :-
        rTransB(Lhs0,Lhs,[],Ages,0,Specificity,[],UsedIds).

rTransB(A0 and B0,A and B, Ages0,Ages,Spec0,Spec, UsedIds0,UsedIds):-!, 
        rTransB(A0,A, Ages0,Ages1, Spec0,Spec1, UsedIds0,UsedIds1),
        rTransB(B0,B,Ages1, Ages, Spec1,Spec, UsedIds1,UsedIds).
rTransB(A0 or B0, A or B, Ages0,Ages, Spec0,Spec, UsedIds0,UsedIds):-!,
        rTransB(A0,A, Ages0,Ages1, Spec0,Spec1, UsedIds0,UsedIds1),
        rTransB(B0,B, Ages1,Ages,  Spec1,Spec, UsedIds1,UsedIds).
rTransB(not A0, not A,Ages0,Ages, Spec0,Spec, UsedIds0,UsedIds) :- !,
       rTransB(A0,A, Ages0,Ages, Spec0,Spec, UsedIds0,UsedIds).
rTransB(A0,A,Ages0,[Age|Ages0],Spec0,Spec, UsedIds0,[Id|UsedIds0]) :-
        A0 =.. [Functor|Args],
        A  =.. [Functor,Id,Age|Args],
        Spec is Spec0 + 1.

rTrans(rule Name at Priority if Lhs0 then Rhs,Rule) :- 
        create(rule,[name=Name, priority=Priority, 
                     rhs=Rhs,lhs=Lhs], Rule0),
        rTrans(Lhs0,Lhs,Rule0,Rule).

rTrans(A0 and B0,A and B) --> !, rTrans(A0,A), rTrans(B0,B).
rTrans(A0 or B0, A or B)  --> !, rTrans(A0,A), rTrans(B0,B).
rTrans(not A0, not A)     --> !, rTrans(A0,A).
rTrans(A0,A) -->
         {A0 =.. [Functor|Args],
          A  =.. [Functor,Id,Age|Args]} ,
        o([ages<<Age,specificity++,usedIds<<Id]).

fChainA :-  fChainA([]). % initialise the bindings
fChainA(Bindings0) :-
        rule Name if Lhs then Rhs,
        satisfied(Lhs),
        newBinding(Name,Lhs,Bindings0,Bindings), !,
        execute(Rhs),
        fChainA(Bindings).
fChainA(_).

satisfied(A  or B) :- !, (satisfied(A) ; satisfied(B)).
satisfied(A and B) :- !, satisfied(A), satisfied(B).
satisfied(not A)   :- !, \+ satisfied(A).
satisfied(A)       :- A.

%don't repeat old bindings      
newBinding(Name,Lhs,Bindings, [Name-Lhs|Bindings]) :- 
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

fChainB :-  fChainB([]). % initialise the bindings
fChainB(Bindings0) :-
        rule Name == UsedIds if Lhs then Rhs,
        satisfied(Lhs),
        newBinding(Name,UsedIds,Bindings0,Bindings), !,
        execute(Rhs),
        fChainB(Bindings).
fChainB(_).

rule    'check for badly paying job; version 3' 
if      employee(Name,Job,_Age) and 
        salary(Job,0)
then    print(error(Name-poorlyPaid(Job))).

rTransA(Name if Lhs0 then Rhs, 
        Name==UsedIds if Lhs then Rhs) :-
        rTransA(Lhs0,Lhs, 
           [],     % initialise used Ids to the empty set
           UsedIds % final value of the used Ids
        ).

rTransA(A0 and B0,A and B,UsedIds0,UsedIds) :- !, 
        rTransA(A0,A,UsedIds0,UsedIds1),
        rTransA(B0,B,UsedIds1,UsedIds).
rTransA(A0 or B0, A or B,UsedIds0,UsedIds) :- !,
        rTransA(A0,A,UsedIds0,UsedIds1),
        rTransA(B0,B,UsedIds1,UsedIds).
rTransA(not A0, not A, UsedIds0,UsedIds) :- !,
       rTransA(A0,A,UsedIds0,UsedIds).

rTransA(A0,A,UsedIds0,[Id|UsedIds0]) :-
        A0 =.. [Functor|Args],
        A  =.. [Functor,Id|Args].

rTransATest(What) :-
        rule  What if Lhs0 then Rhs0,
        rTransA(rule What if Lhs0 then Rhs0,Out),
        print(Out),nl.

rTransBTest(What) :-
        rule  What at Priority if Lhs0 then Rhs0,
        rTransB(rule What at Priority if Lhs0 then Rhs0,Out),
        print(Out),nl.

rTransC(rule Name at Priority if Lhs0 then Rhs,Rule) :- 
        create(rule,[name=Name, priority=Priority, 
                     rhs=Rhs,   lhs=Lhs], Rule0),
        rTransC(Lhs0,Lhs,Rule0,Rule).

rTransC(A0 and B0,A and B,R0,R) :- !, 
        rTransC(A0,A,R0,R1), rTransC(B0,B,R1,R).
rTransC(A0 or B0, A or B, R0,R) :- !, 
        rTransC(A0,A,R0,R1), rTransC(B0,B,R1,R).
rTransC(not A0,   not A,  R0,R) :- !, 
        rTransC(A0,A,R0,R).
rTransC(A0,       A,      R0,R) :-
        A0 =.. [Functor|Args],
        A  =.. [Functor,Id,Age|Args],
        o([ages<<Age,specificity++,usedIds<<Id],R0,R).

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
o(self T,       T, T).

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
        writeList(['%Re-defining [',Type,'].']),
        retractall(create(Type,_)),
        retractall((o1(Skeleton, _, _))),
        retractall(Match),
        retractall((swap(Skeleton, _,_,_,_))),
        retractall(Swap),
        retractall(portray(Skeleton)).
undefineRecord(Type) :-
        writeList(['%Defining [',Type,'].']).      % new
	

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

defRecordTimingTest :-
        defRecord(rule, [
          name,usedIds=[],ages=[],specificity=0,priority=0,lhs,rhs]),
        defRecordTimingTest1(Rule1),
        defRecordTimingTest1(Rule2),
        timeIt(rTransB(Rule1,_),500,T1),
        timeIt(rTrans( Rule2,_),500,T2),
        defRecordTimingTest1(Rule3),rTrans( Rule3,Out2), 
        defRecordTimingTest1(Rule4),rTransB(Rule4,Out1), 
        (\+var(Out1), \+ var(Out2), Out1 = Out2 
        -> write('same output; good') 
        ; write('different output; bad')), nl,
        SlowDown is (T2 - T1) /T1,
        print(rTransB(T1)), nl,print(rTrans(T2)), nl,
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

timeIt(G,N,Time) :- 
        timeIt1(true,N,T1),timeIt1(G,N,T2),Time is T2 -T1.

timeIt1(Goal, N,T) :- 
        T1 is cputime, timeIt2(Goal,N), 
        T2 is cputime, T is (T2 - T1)/N.

timeIt2(Goal, Repeats) :- between(1,Repeats,_), Goal, fail.
timeIt2(_,_).

rTransE(A0,A,T0,T) :-
          A0 =.. [Functor|Args],
          A  =.. [Functor,Id,Age|Args] ,
        rule0(ages,       T0,Ages, T1,[Age|Ages]),
        rule0(specificity,T1,Spec0,T2,Spec), Spec is Spec0 + 1,
        rule0(usedIds,    T2,Ids,  T,[Id|Ids]).

fChainC :- 
	wmesCreateA(W),
	fChainC(W,_).
fChainC(W) :- 
	fChainC(W,_).
fChainC(W0,W) :-
        match(Matches,W0),!,     % what rules could fire?
        select(Matches,One),     % select one to be fired
        act(One,W1),             % fire it
        fChainC(W1,W).           % loop
fChainC(W,W).

match(Matches,W) :-
        setof([Priority,   % most important conflict resolution rule
               Age,        % next most important
               Specificity % least important
              ]  - (Rule/NewBindings),      
            W^match1(Rule,NewBindings,Age,Specificity,Priority,W),
         Matches).

match1(Rule,NewBindings,Age,Specificity,Priority,W) :-
        access(rule1,[wmeIn==W,priority==Priority0,
                      specificity==Specificity0,
                      name==Name,
                      ages==Age0,lhs == Lhs],
               Rule),
        Lhs,
        newBindingsA(Rule,NewBindings,W),
        average(Age0,Age1),
	negates([Age1,Priority0,Specificity0],
                [Age, Priority, Specificity]),
	writeList(['%--triggerred',Name]).

newBindingsA(Rule,NewBindings,W) :-
	o(refractionMemory==OldBindings,W),
	o([usedIds==Used0,name==Name],Rule),
	sort(Used0,Used),
	create(refractionMemory,[name=Name,usedIds=Used],NewBindings),
	\+ member(NewBindings,OldBindings).

negates([],[]).
negates([H0|T0],[H|T]) :- H is -1 * H0, negates(T0,T).

select([_ - Rule/NewBindings|_],Rule/NewBindings) :-
	o(name==Name,Rule),
	writeList(['%--selecting',Name]).
	

act(Rule/NewBindings,W) :-
	%fWrite(Rule),
	o([wmeOut==W0,rhs==Rhs],Rule),
	o(refractionMemory<<NewBindings,W0,W), 
	Rhs,
	!.
act(Rule/_,_) :-
	o(name==Name,Rule),
	oops(['failed action [',Name,']']).

fWrite(Term) :-
	Term =.. L,
	nth(L,Nth/Item),
	write(Nth : Item),
	nl,
        fail.
fWrite(_).

% new operators for this chapter
:- op(999,xfx,:), op(800,xfy,with), op(10,xfx,@), op(10,fx,*).

fChainCRule(demo1,
        (wmeDefineA(emp,[name,age,showSize,job]), % wmes for demo1
         wmeDefineA(salary,[job,income]),
         wmeDefineA(log,[event,what])),
        [   rule     :    demo1
            ,priority :    10
            ,if       :    log@L  with what  == somethingToDo and
                           emp@E  with name  == Who with age > 60
                                  with job   == cleaner and 
                           salary with job   == cleaner 
                                  with  income < 30000
            ,write    :    'promoting' and Who
            ,modify   :    E with job = executiveCleaner
            ,assert   :    log with event = promote 
                                with what = Who
            ,retract  :    L]).

reservedWmeField(id, id).
reservedWmeField(age,'$wage').

:- dynamic isWme/1.

wmeDefineA(W,Inits) :-
        wmeUndefine(W),
        reservedWmeField(id,Id),   next(Id,Id0),
        reservedWmeField(age,Age), next(Age,Age0),
        defRecord(W,[Id=Id0, Age=Age0|Inits]),
        wmeExampleA(W,Eg),
        assert((portray(Eg):-wmePrintA(Eg))),
        assert(isWme(W)).

wmeUndefine(W) :-
	wmeExampleA(W,Eg),
	!,
	retractall(portray(Eg)),
	retractall(isWme(W)),
	undefineRecord(W).
wmeUndefine(_).

wmeUndefines :- wmeUndefine(_), fail.
wmeUndefines.	

next(X,Y) :- flag(X,Y,Y+1). 
wmes(Ws)  :- setof(W,isWme(W),Ws).

wmePrintA(Wme) :-
        functor(Wme,Type,_),arg(1,Wme,Id), arg(2,Wme,Age),
        write('{'), write(Type), write('#'), write(Id), 
        write('.'), write(Age),  write('}').

wmeExampleA(Type,Eg) :-  
        example(Type,Eg).
wmeExampleA(Type,Eg,Id,Age) :- 
        wmeExampleA(Type,Eg), arg(1,Eg,Id),arg(2,Eg,Age).

wmeCreateA(Type,Inits,New) :- 
	reservedWmeField(age,A),
	next(A,Age), 
        create(Type,[A=Age|Inits],New).
wmeCreateA(Type,New)       :- wmeCreateA(Type,[],New).

aboutOp1(X,Field,About) :- aboutOp1(X,About), arg(1,X,Field).

aboutOp1(_ >= _, query). aboutOp1(_ >  _, query).
aboutOp1(_ \= _, query). aboutOp1(_ <  _, query).
aboutOp1(_ =< _, query). aboutOp1(_ in _, query).
aboutOp1(_ == _, query). aboutOp1(self _, query).

aboutOp1(_ ++,   update). aboutOp1(_ --,   update).
aboutOp1(_ +  _, update). aboutOp1(_ =  _, update).
aboutOp1(_ << _, update).

typeId(Type@Pointer,_,_) :- 
        \+ (ground(Type) , var(Pointer)),
        !, oops(['bad wme pointer',Type@Pointer]).
typeId(Type@_,_,_) :- 
        \+ isWme(Type),
        !, oops(['unknown wme type',Type]).
typeId(Type@(Type-Id),Type,Id) :- !.
typeId(Type,Type,_).


queries2List(X0 with Y0,Wme,[X|Y] ) :- !, 
        isQuery(X0,Wme,X),
        queries2List(Y0,Wme,Y).
queries2List(X0,Wme,[X] ) :- 
        isQuery(X0,Wme,X).

isQuery(X,Wme,_) :- 
        aboutOp1(X,update),
        !,
        arg(0,Wme,Type), oops(['update found in IF',Type - X]).
isQuery(Query,Wme,_) :-
        aboutOp1(Query,Field,query),
        \+ o(Field==_,Wme),
        !,
        arg(0,Wme,Type), oops(['unknown field in IF',Type - Field]).
isQuery(Query,_,Query).

updates2List(X0 with Y0,Wme,[X|Y] ) :- !, 
        isUpdate(X0,Wme,X),
        updates2List(Y0,Wme,Y).
updates2List(X0,Wme,[X]) :-  
        isUpdate(X0,Wme,X).

isUpdate(Query,Wme,_) :- 
        aboutOp1(Query,query),
        !,
        oops(['query in modify',Wme - Query]).
isUpdate(Query,Wme,_) :-
        aboutOp1(Query,Field,update),
        \+ o(Field==_,Wme),
        !,
        oops(['unknown field in modify',Wme - Field]).
isUpdate(Update,_,Update).

defAssertion(Type,Inits) :-
        length(Inits,Arity),
        (dynamic Type/Arity),
        defRecord(Type,Inits).

:- defAssertion(rule1,[name,lhs,rhs,usedIds=[],ages=[],
                   specificity=0, priority=0,
                   help = '.' , 
                   write=true,    do=true, 
                   if=fail,       modify=true,
                   retract=true,  assert=true,
                   wmeIn,wmeOut
                   ]).

defRule(Spec) :- defRule(Spec,_).
defRule([rule : Name|Attributes],Rule) :-
        undefineRule(Name),
        create(rule1,[name=Name],Rule0),
        os(Attributes,Rule0,Rule1),
        rTransF(Rule1,Rule),
        assert(Rule).

undefineRules :- access(rule1,Rule),retract(Rule), fail.
undefineRules.

os([],X,X).
os([Field : Value|Items],X0,X) :- 
        o(Field=Value,X0,X1), os(Items,X1,X).

undefineRule(Name) :- 
        access(rule1,name==Name,Rule),!,
        writeList(['%Re-defining rule [',Name,']']),
        retract(Rule).
undefineRule(Name) :-
        writeList(['%Defining rule [',Name,']']).

rTransF(Rule0,Rule) :- 
        o([if ==I0,     do==D0,      write==P0,  help==H0,
                        retract==R0, modify==M0, assert==A0],
          Rule0,Rule1), 
        rTransFIf(I0,I,W0,W1,Rule1,Rule2),
        rTransFDo(D0,D),
        rTransFWrite(P0,P),
        rTransFHelp(H0,H),
        rTransFRetract(R0,R,W1,W2),
        rTransFModify(M0,M,W2,W3),
        rTransFAssert(A0,A,W3,W),
        o([wmeIn=W0, wmeOut=W, help=H, lhs=I, rhs=(P,D,R,M,A)],
          Rule2,Rule).

rTransFIf(A0 and B0,(A,B),W0,W)  --> !,
        rTransFIf(A0,A,W0,W1), 
        rTransFIf(B0,B,W1,W).
rTransFIf(A0 or B0,(A;B),W0,W)  --> !, 
        rTransFIf(A0,A,W0,W1), 
        rTransFIf(B0,B,W1,W).
rTransFIf(not A0,(\+ A),W0,W) --> !, 
        rTransFIf(A0,A,W0,W).
rTransFIf({A},A,W,W) --> !, [].
rTransFIf(X with Fields,Query,W0,W) --> {
        Query = (wmeFindA(Type,Id,Age,Wme,W0,W), o(Todo,Wme)),
        typeId(X,Type,Id),
        wmeExampleA(Type,Wme,Id,Age),
        queries2List(Fields,Wme,Todo),
        length(Todo,Spec0),
        Spec is Spec0 + 1
        },
        o([usedIds<<Id,ages<<Age,specificity+Spec]).



rTransFDo(X and Y0,(X,Y)) :- !,rTransFDo(Y0,Y).
rTransFDo({X},     X) :- !.
rTransFDo(X,       X).

rTransFWrite(X,write(X)) :- var(X), !.
rTransFWrite(true,true) :- !.
rTransFWrite(X and Y,(write(X), write(' '),Rest)) :-  !,
        rTransFWrite(Y,Rest).
rTransFWrite(X,(write(X),nl)).

rTransFHelp(X,Y) :- rTransFWrite('>>' and X,Y).

rTransFRetract(X0 and Y0,(X,Y),W0,W) :- !,
        rTransFRetract(X0,X,W0,W1),
        rTransFRetract(Y0,Y,W1,W).
rTransFRetract(true,true,W,W) :- !.
rTransFRetract(Type-Id,
               wmeRetractA(Type,Id,W0,W),W0,W).

rTransFModify(X0 and Y0,(X,Y),W0,W) :- !,
        rTransFModify(X0,X,W0,W1),
        rTransFModify(Y0,Y,W1,W).
rTransFModify(true,true,W,W) :- !.
rTransFModify(Type-Id with Changes0,
              wmeChangeA(Type,Id,Changes,W0,W),W0,W) :-
        wmeExampleA(Type,Wme),
        updates2List(Changes0,Wme,Changes).

rTransFAssert(X0 and Y0,(X,Y),W0,W) :- !,
       rTransFAssert(X0,X,W0,W1),
       rTransFAssert(Y0,Y,W1,W).
rTransFAssert(true,true,W,W) :- !.
rTransFAssert(Type with Inits0,
              wmeAssertA(Type,Inits,W0,W),W0,W) :-
        wmeExampleA(Type,Wme),
        updates2List(Inits0,Wme,Inits).

% to be called after all other wmes are known
wmesSetupA :- 
        wmeDefineA(refractionMemory,[name,usedIds]),
	wmes(Wmes0), 
	addInits(Wmes0,Wmes),
        defRecord(workingMemory,Wmes).

addInits([],[]).
addInits([X|T0],[X=[]|T]) :- addInits(T0,T).

wmesInitsA(W) :- 
        create(workingMemory,W0),
	o(refractionMemory=[],W0,W).


wmeFindA(Type,Id,Age,Wme,W0,W) :- 
        workingMemory0(Type,W0,Types0,W,[Wme|Types1]),
        wmeExampleA(Type,Wme,Id,Age),
        oneLess(Types0,Wme,Types1).

wmeChangeA(Type,Id, Changes,W0,W) :-
        workingMemory0(Type,W0,Types0,W,[Wme|Types1]),
        wmeExampleA(Type,Wme0,Id,_),
        oneLess(Types0,Wme0,Types1),
        reservedWmeField(age,AgeField),
        next(AgeField,NewAge),
        o([AgeField=NewAge|Changes],Wme0,Wme).

oneLess([A|B], A, B).
oneLess([A|B], C, [A|D]) :- oneLess(B, C, D).

wmeAssertA(Type,Inits,W0,W) :-
        workingMemory0(Type,W0,Types0,W,[New|Types0]),
        wmeCreateA(Type,Inits,New).

wmeAssertsA(Type,Headers,Data,W0,W) :-
	wmeCreateA(Type,New),
	wmeAssertsA1(Data,Headers,Headers,Type,New,W0,W).
 
wmeAssertsA1([],_,_,W,W).
wmeAssertsA1(Data0,Headers,Type,W0,W) :-
	wmeAssertsA2(Headers, Data0,Data,Inits),
	wmeAssertA(Type,Inits,W0,W1),
	wmeAssertsA1(Data,Headers,Type,W1,W).

wmeAssertsA2([],Data,Data,[]).
wmeAssertsA2([Field|Fields],[Datum|Data],Todo,[Field=Datum|Rest]) :-
	wmeAssertsA2(Fields,Data,Todo,Rest).

wmeRetractA(Type,Id,W0,W) :- 
        workingMemory0(Type,W0,Types0,W,Types),
        wmeExampleA(Type,Wme,Id,_),
        oneLess(Types0,Wme,Types).


defRuleTest :- 
        fChainCRule(demo1,Setup,Rule0),
	Setup,
        defRule(Rule0,Rule),
        o([lhs==Lhs,rhs==Rhs,
           name==Name, wmeIn==W0,wmeOut==W,
           specificity==Spec, priority==Prior],Rule),
        portray_clause((rule([name==Name, wmeIn==W0,wmeOut==W,
                              specificity==Spec, priority==Prior]) 
                       :- lhs,Lhs,rhs,Rhs)).	

fChainTest :-
	wmesSetupA,	
        fChainTestInits(W0),
        fChainC(W0).

fChainTestInits(W) :-	
        undefineWmes,
	fChainCRule(demo1,Setup,ARule),
	Setup,
	defRule(ARule),
	defRule([rule     : wmes0
                ,priority : 1000
                ,if       : log    with self L1 and 
                            emp    with self E1 and
                            salary with self S1
                ,write    : 'Initial memory'
                ,do       : printRec(L1) and printRec(E1) and 
                            printRec(S1)]),
	defRule([rule     : wmesLast
                ,if       : log    with self L2 and 
                            emp    with self E2 and
                            salary with self S2
                ,write: 'Final memory'  
                ,do   : printRec(L2) and printRec(E2) and 
                        printRec(S2)]),
        wmesSetupA,
	wmesInitsA(W0),
	wmeAssertA(emp,   [name =tim,age =61, job=cleaner],W0,W1),
	wmeAssertA(log,   [what=somethingToDo],            W1,W2),
	wmeAssertA(salary,[job=cleaner,income=20000],      W2,W).

printRecs(Rs) :- member(R,Rs), printRec(R), fail.
printRecs(_).

printCs((X,Y)) :- !, tab(8), print(X), nl, printCs(Y).
printCs(X)     :- tab(8), print(X), nl.

bagger :-
	wmesSetupA,	
        baggerWmes(W0),
	baggerFacts(W0,W),
	baggerRules,
        fChainC(W).

baggerWmes(W0) :-
	undefineWmes,
	defWme(step,[name]),
        defWme(grocery,[name,container,size,frozen]),
        wmesSetupA,
	wmesInitsA(W0).

baggerFacts -->
	wmeAssertA(step,[name=checkOrder]),
        wmeAssertsA(
         grocery,
         [name,        container,               size,           frozen],
         [bread,       bag(plastic),		medium,		n,
          glop,        jar,			small,		n,
          granola,     box(cardboard),		large,		n,
          iceCream,    carton(cardboard), 	medium, 	y,
          pepsi,       bottle,			large,		n,
          potatoChips, bag(plastic),		medium,		n]).

%baggerRules :-
%	undefineRules,	
%	defRule([rule   : b1
%                 ,if	: task with name == checkOrder and
%                          item with name == potatoChips and
%                          not item with type == bottle 
%                 ,assert : item name == pepsi
%%%%% ]).
	



% generate a term that is N long, add it to WME it, access x% of it 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inits
wmesInitsB([]). % new working memory for oset

wmesInitsC(_) :-  % new working memory for asserts
	meta(_,Term,_,_),
	retractall(Term),
	functor(Term,F,A),
	(dynamic F/A),
	fail.
wmesInitsC(_).

wmesInitsC3(_) :- %  working memory for asserts (triples)
	(dynamic triple/3),
	(dynamic isTriple/1),
	retractall(triple(_,_,_)),
	retractall(isTriple(_)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% find a term
wmesFindB(Id,_Table,Term,W,W) :-  % oset
	
	member(Term,W),
	arg(1,Term,Id). % sha!!
wmesFindC(Id, Table, Term,W,W) :-   % find assert
	meta(Table,Term,_,_),
	Term,
	arg(1,Term,Id).
wmesFindC3(Id,_Table,Id,W,W) :- % find a triple
	isTriple(Id).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% extract from a term the required field
wmesExtractB(_Id,Field,Term,Value) :-
	o(Field==Value,Term).

wmesExtractC(_Id,Field,Term,Value) :-
	o(Field==Value,Term).

wmesExtractC3(Id,Field,_,Value) :-
	triple(Id,Field,Value).

wmesExtracts([],_Id,_Term,[]).
wmesExtracts([Field|Fields],Id,Term,[Value|Values]) :-
	wmesExtract(Id,Field,Term,Value),
	wmesExtracts(Fields,Id,Term,Values).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% wmeAssert
wmesAssertB(Id,Term,W,[Term|W]) :-
	arg(1,Term,Id).

wmesAssertC(Id,Term,W,W) :- 
	arg(1,Term,Id),
	assert(Term).
	

wmesAssertC3(Id,Term,W,W) :-
	assert(isTriple(Id)),
	o1(Term,Field,Value),
	assert(triple(Id,Field,Value)),
	fail.
wmesAssertC3(Id,_Term,W,W) :-
	assert(isTriple(Id)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% which schema are we currently using
wmesInits(X) :- b, wmesInitsB(X).
wmesInits(X) :- c, wmesInitsC(X).
wmesInits(X) :- c3, wmesInitsC3(X).

wmesFind(Id,Table, X,W0,W)    :- b, wmesFindB(Id, Table, X,W0,W).
wmesFind(Id,Table, X,W0,W)    :- c, wmesFindC(Id, Table, X,W0,W).
wmesFind(Id,Table, X,W0,W)    :- c3,wmesFindC3(Id,Table, X,W0,W).

wmesAssert(Id, X,W0,W)    :- b,  wmesAssertB(Id,X,W0,W).
wmesAssert(Id, X,W0,W)    :- c,  wmesAssertC(Id,X,W0,W).
wmesAssert(Id, X,W0,W)    :- c3, wmesAssertC3(Id,X,W0,W).

wmesExtract(Id,Field,X,V) :- b,  wmesExtractB(Id,Field,X,V).
wmesExtract(Id,Field,X,V) :- c,  wmesExtractC(Id,Field,X,V).
wmesExtract(Id,Field,X,V) :- c3, wmesExtractC3(Id,Field,X,V).
	
:- dynamic b/0, c/0, c3/0.

b.
c.
c3.

shaTest :-
	retractall(b),
	retractall(c),
	retractall(c3),
	defRecord(timeControl,[
			type=b,
                        repeats=100,
                        size=10,
			accessed=20,
			tableName=fact]),
	create(timeControl,Control),
	shaTest1(Control).

shaTest1(Control) :-
	o([size==S,   type== Type, accessed==Percent,
           repeats==R,tableName==Table],Control),
	assert(Type),
	randomFields(S,Fields,Names),
	defRecord(Table,[id|Fields]),
	wmesInits(Wme0),
	flag(id,Id,Id+1),
	create(Table,id=Id,New),
	wmesAssert(Id,New,Wme0,Wme1),
	Get is integer(S * (Percent/100)), 
	shaTest2(R,Get,Table,Names,Wme1,Wme),
	write(Wme).

randomFields(0,[],[]).
randomFields(N0,[F=N0|Fields],[F|Names]) :- 
	gensym(field,F),
	N0 > 0, 
	N is N0 - 1,
	randomFields(N,Fields,Names).
 
shaTest2(0,_Get,_Table,_Names,Wmes,Wmes).
shaTest2(R0,Get,Table,Names,Wmes0,Wmes) :-
	R0 > 0,
	R is R0 -1,
	random_members(Names,Get,SomeFields),
	wmesFind(Id,Table,Wme,Wmes0,Wmes1),
	wmesExtracts(SomeFields,Id,Wme,Values),
	print(Id-Values),nl,
	shaTest2(R,Get,Table,Names,Wmes1,Wmes).
	
random_members(List,N,Members) :-
        length(List,Max),
        random_numbers(N,Max,Numbers),
        random_members1(Numbers,1,List,Members).

random_members1([],_,_,[]).
random_members1([N|Rest],N,[H|T],[H|Others]) :- !,
        N1 is N + 1,
        random_members1(Rest,N1,T,Others).
random_members1([H|Rest],N,[_|T],Out) :-
        N1 is N + 1,
        random_members1([H|Rest],N1,T,Out).

random_numbers(N,Max,S) :-
        set_new(S0),
        random_numbers(N,Max,S0,S).

random_numbers(0,_,S,S) :- !.
random_numbers(N,Max,S0,S) :-
        Random is random(Max) + 1,
        (set_newel(S0,Random,S1)
        ->      N1 is N - 1,
                random_numbers(N1,Max,S1,S)
        ;       random_numbers(N,Max,S0,S)).

set_new([]).



%----- set add new element
% fails if new element already in set.
set_newel([], El, [El]). 
set_newel([H|T], El, Add) :- 
        compare(Order, H, El), newel(Order, H, T, El, Add).

newel(<, H, T,  El, [H|Add]) :- set_newel(T, El, Add).
%newel(=, H, T, _El, [H|T]). 
newel(>, H, T,  El, [El,H|T]).



