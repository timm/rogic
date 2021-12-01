defrec(Term,Ac,Out) :- 
    functor(Term,F,Ar),
    ( % records can asserted in many places around
      % multiple files
      Out= (:- dynamic F/Ar)
     ;Out= (:- multifile F/Ar)
     ;Out= (:- discontiguous F/Ar) 
      % accessors have arity 5 and may be broken up
      % by programmer defined code
     ;Out= (:- discontiguous Ac/3)
     ;indexTerm(Term,Out)).
defrec(Term, Ac,Out) :-
	Term =.. [F|Args0],
	maplist(secondItem,Args0,[Id|Defaults]),
	New =.. [F,Id|Defaults], 
	Out =.. [Ac,defaults,_,New].
defrec(_,Ac,(Head :- Body)) :- 
	Head=..[Ac,X,Y],
	Body=..[Ac,X,Y,Y].
defrec(_,Ac,Out) :-
        Out=..[Ac,[],X,X].
defrec(_,Ac,Out) :-
        Head=..[Ac,[H|T]],
	Sub1=..[Ac,H],
	Sub2=..[Ac,T],
	expand_term((Head --> Sub1,Sub2),Out).
defrec(Term,Ac,Touch) :-
	Term =.. [F|Args0],
	maplist(firstItem,Args0,Firsts),
	length(Firsts,Arity),
	functor(Term0,F,Arity),
	nth1(Pos,Firsts,Arg),
        copyArgs(Term0,Pos,Value0,Value,Term1),
        Head=..[Arg,Value0,Value],       
	Touch =.. [Ac,Head,Term0,Term1].
defrec(Term,Ac,AsList) :-
        Term =.. [F|Args0],
        maplist(firstItem,Args0,Firsts),
        length(Firsts,Arity),
        length(Vars,Arity),
        asEqList(Firsts,Vars,List),
        Term0 =.. [F|Vars],
        AsList =.. [Ac,asList(List),Term0,Term0].
defrec(Term,Ac,(Head :- Body)) :-
	Term =.. [_|Args],
	member(Arg,Args),
	Term1 =.. [Arg,X],
	Term2 =.. [Arg,X,X],
	Head  =.. [Ac,Term1,R0,R],
	Body  =.. [Ac,Term2,R0,R].
defrec(Term,Ac, (bridge(Term1,Arg,Term2) :- 
                        Bridge)) :-
	functor(Term,Functor,Arity),
        functor(Term1,Functor,Arity),
  	functor(Term2,Functor,Arity),
        Bridge =.. [Ac,Arg,Term1,Term2].
defrec(Term,_,blank(F,Id,Blank)) :-
	functor(Term,F,A),
	functor(Blank,F,A),
        arg(1,Blank,Id).
defrec(Term,_,(a(F,One) :- One)) :-
	functor(Term,F,A),
	functor(One,F,A).
defrec(Term,_,(a(F,Id,One) :- One)) :-
	functor(Term,F,A),
	functor(One,F,A),
	arg(1,One,Id).
defrec(Term,_,(update(New) :-         
	         (retract(Old) -> assert(New); assert(New)))) :-
	functor(Term,Functor,Arity),
	functor(Old,Functor,Arity),
	functor(New,Functor,Arity),
	arg(1,New,Id),
	arg(1,Old,Id).

