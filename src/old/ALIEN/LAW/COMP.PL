:- +[records,types/e,types/v, types/o,
     lib/io, lib/asserts, lib/meta, law/parse].

:- discontiguous statement/2,output/1,rangeP/2.
:- dynamic oneOfP/2.
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

output(authorP).
term_expansion(* author are Y,Out) :-
	isPs(author,Y,Out).

output(numericP).
term_expansion(* numeric are Y,Out) :-
	newObjects(Y,Objects),
	isPs(numeric,Y,OtherStuff),
	append(Objects,OtherStuff,Out).

term_expansion(* author = Who,(:- change(from,Who))).
term_expansion(* N if X then Y,Out) :-
	ruleXpands(N if X then Y,Out).

output(obj).
newObjects(X,Objects) :-
	bagof(Object,X^newObject(X,Object),Objects).
newObject(X,O) :- 
	member(Y,X),
	create(obj,O0),
	o(name(Y),O0,O).

isPs(Rule,X,Y) :- maplist(isP(Rule),X,Y).

isP(Rule,In,Out) :- p(Rule,P), Out =.. [P,In].

p(X,Y) :- string_concat(X,'P',S), string_to_atom(S,Y).

output(statement).
ruleXpands(N if X then Y,[statement(N,N if X then Y)
                          |Rest]) :-
	change(id,N),
	bagof(One,Time^X^Y^parse((X then Y),Time,One),Rest).

{_}.

