
:- +[lib/lists, lib/io, lib/asserts, lib/meta, law/parse].

:- discontiguous statement/2,output/1,rangeP/2,object/1.
:- dynamic numericP/2, rangeP/2, oneOfP/2.
:- multifile oneOfP/2,output/1.

saveOutput(F) :-
	tell(F),
	forall(output(X),listing(X)),
	told.

output(rangeP).

term_expansion(* X are List, Out) :-
	oneOfP(X,Range),!,
	newObjects(List,Objects),
	bagof(rangeP(L,R), Range^List^
                    (member(L,List),
                     member(R,Range)
                    ),
              OtherStuff),
	append(Objects,OtherStuff,Out).

output(oneOfP).
term_expansion(* X are oneOf = Range,oneOfP(X,Range)) :- !.

output(personP).
output(groupP).
output(personGroupP).

term_expansion(* authors are Y,Out) :-
	bagof(One,Y^aDetails(Y,One),Out).

aDetails(All,groupP(Group)) :- member2(groups,Group,All).
aDetails(All,Out) :-
	member2(members,Group=Persons,All),
	member(Person,Persons),
	(not( (member2(groups,Group,All),
	       member2(persons,Person=_,All)))
	 -> write('% failed '), 
            print(badPersonGroup(Group,Person)), 
            nl,
            fail
         ;  Out = personGroupP(Group,Person)).
aDetails(All,personP(Who,Elm)) :- member2(persons,Who=Elm,All).

member2(A,B,L) :- member(A=C,L), member(B,C).

output(numericP).
term_expansion(* numeric are Y,Out) :-
	newObjects(Y,Objects),
	isPs(numeric,Y,OtherStuff),
	append(Objects,OtherStuff,Out).

term_expansion(* author = Who,(:- change(from,Who))).
term_expansion(* N if X then Y,Out) :-
	ruleXpands(N if X then Y,Out).

output(object).
newObjects(X,Objects) :-
	bagof(Object,X^newObject(X,Object),Objects).
newObject(X,object(Y)) :- 
	member(Y,X),
	\+ object(Y).

isPs(Rule,X,Y) :- maplist(isP(Rule),X,Y).

isP(Rule,In,Out) :- p(Rule,P), Out =.. [P,In].

p(X,Y) :- string_concat(X,'P',S), string_to_atom(S,Y).

output(statement).

ruleXpands(N if X then Y,Rest) :-
	change(id,N),
	bagof(One,Time^X^Y^(parse(X then Y,Time,One)),Rest).

output(@).


