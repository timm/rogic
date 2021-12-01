%% demo of selector system
:- + [records, lib/lists, lib/io]. 

record(person(name,age=0,jobs=[])).

person0(newJob(New))  --> person0(jobs(Old,[New|Old])).
person0(nameIs(Name)) --> person0(name(_,Name)).
person0(older(N))     --> person0(age(Old,New)), {New is Old+ N}.

person0(sayHello) -->
    person0(asList(L)),
    {members([id=I,name=N,jobs=J],L),
     format('~n---------~nemp#~p) ~a works at ~p~n',[I,N,J])}.

person0(sayHelloFaster,person(I,N,A,J),person(I,N,A,J)) :-
    format('~n---------~nemp#~p) ~a works at ~p~n',[I,N,J]).

main1 :-
    showRecordSideEffects(person),
    create(person,_),
    create(person,_),
    create(person,P),  % just checking the ids increment
    oo([nameIs(tim), 
       older(10), 
       newJob(cleaning),
       newJob(scrubbing),
       sayHello,
       nameIs(fasterTim),
       sayHelloFaster
      ],P).

go :- watch(main1).






