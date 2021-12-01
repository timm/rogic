:- + [records].

record(person(name,age=0,jobs=[])).

person0(init) --> 
    create(person).
   
person0(print) -->
    o([asList(L)]),
    members([id=I,name=N,jobs=J],L),
    {format('emp#~p) ~a works at ~p\n',[I,N,J])}.

main :-
    o([type is person,
      name(_,tim), 
      inc(age,10), 
      newJob(cleaning),
      newJob(scrubbing),
      print
     ]).
 
% output:
% emp#0) tim works at [scrubbing, cleaning]

