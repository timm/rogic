% handle the compile time expansion
:- Stuff = (recordDefinition/1, blank/3, update/1,
            a/2, a/3, touch/3, bridge/3,
            recordDefinition/1),
   (multifile     Stuff),
   (discontiguous Stuff).

term_expansion(record(Term),All) :- records(Term,All).

records(Term0,[recordDefinition(Term0)|All]) :-
	Term0 =.. [F|Args],
        accessorName(F,Ac),
        % add in space for the id
	Term  =.. [F,id|Args],
        % collect all the things we need to assert 
	bagof(One,Term^Ac^(defrec(Term,Ac,One)),All). 

oo(Commands,R) :- oo(Commands,R,_).

oo([],R,R).
oo([H|T],R0,R) :- o(H,R0,R1), oo(T,R1,R).

o(X,R0,R) :- bridge(R0,X,R).
o(X,R0) :- bridge(R0,X,_).

create(What,New) :- 
	create(What,[],New).
create(What,Com0,New) :-
    asList(Com0,Com),
    blank(What,Id,Blank),
    flag(id, Id, Id+1),
    oo([defaults,id(_,Id)|Com],Blank,New).

aRec(What,Rules) :- aRec(What,Rules,_).
aRec(What,Rules,One) :-
    a(What,Got),
    (is_list(Rules)
    -> oo(Rules,Got,One)
    ;  o(Rules,Got,One)).

exist(What,Rules,Out) :-
	exists(What,Rules,Some), member(Out,Some).
exists(What,Rules,Out) :- 
	exists(What,Rules,[],Out).
exists(What,Rules,In,Out) :-
	aRec(What,Rules,_)
        -> Out = In
        ;  create(What,Rules,New),
           Out= [New|In].

join(X,Id,Rules) :- 
	a(X,Id,Temp), 
	bridge(Temp,Rules,_).
join(X,Id,Rules,One) :- 
	a(X,Id,Temp), 
	bridge(Temp,Rules,One).

showRecordSideEffects(R) :- 
    recordDefinition(R0),
    functor(R0,R,_),
    format('% input: ~p~n% output...~n ~n',[record(R0)]),
    term_expansion(record(R0),Some),
    member(One,Some),
    portray_clause(One),
    fail.
showRecordSideEffects(_).










