% optionally watch the execution. if ands fail, then report ehad and current and then fail.
% verify funcking up

:- multifile (@)/1,swap0/5.
:- discontiguous (@)/1.
:- [utils].
%:- op(999,fx,'&').
%:- op(999,fx,'#'). 
:- op(999,fx,'@'). 
:- op(999,xfy,'@'). 
:- op(1002,xfy,ror).
:- op(1001,xfy,rand).
:- [rtypes,loading,demos].

at(X) :-
        clause(@Y,Z),
	functor(Y,X,A),
	functor(Blank,X,A),
	bagof((@Y:-Z), X^A^(clause(@Y,Z),
	                    functor(Y,X,A)),
                       All),
	forall(member(Item,All), portray_clause(Item)),
	nl, forall(at1(Blank,Comment), 
                     portray_clause(Comment)).

at1(Blank, (:- dynamic F/A)) :-
	predicate_property(Blank,dynamic),
	functor(Blank,F,A).
at1(Blank,(:- index(Blank))) :- 
	predicate_property(Blank,indexed(Blank)).
at1(Blank, about(Blank,Inputs,Id)) :-
	about(Blank,Inputs,Id).
at1(Blank, swap0(Blank,X,Y,Z,New)) :-
        swap0(Blank,X,Y,Z,New).
at1(Blank, (term_expansion(Blank,New) :- Body)) :-
	clause(term_expansion(Blank,New),Body).
	
portray(rand) :- write(' '), write(rand), write(' ').
portray(ror) :- write(' '), write(ror), write(' ').

rprove(Goal) :- rdo(Goal,wme(Goal,[]),_).

X ror Y  :- rany(X ror Y,Z), Z.
X rand Y :- r2l(X rand Y,All), rand1(All).

rand1(l([],0)).
rand1(l(L,N)) :- rone(l(L,N),One,Rest),One,rand1(Rest).

rany(X,Z) :- r2l(X,All), rone(All,Z,_).

rdo(fail)             --> !,fail. % catches vars as well.
rdo((X ror Y))        --> !,{r2l(X ror Y,L), rone(L,X,_)}, rdo(X).
rdo((X rand Y))       --> !,{r2l(X rand Y,L)},           rdo(L).
rdo(l([],0),W,W)      :-  !. 
rdo(l(L,N))           --> !, {rone(l(L,N),One,Rest)},rdo(One),rdo(Rest).
rdo((X,Y))            --> !,(rdo(X), rdo(Y)).
rdo((X;Y))            --> !,(rdo(X); rdo(Y)).
/*rdo(@Goal, wme(Path0,Facts0),
           wme(Path0,Facts)) :- !,
	
	?? when do i charm
        ?? when do i check for looping

if i have inpputs, outputs then inputs should always be ground
and we cahn check loopping on the inputs

        search for it in working memory.
             if contradiction found, fail
             if same found, then set "old goal" and succeed
             if not found, set "new goal" and succeed

        if old goal, then if looping, fail 
                     else,   return t

    %    if new goal, then check for looping--- no!!!

        if new goal, then recurse.


        if it is an old found goal,
        then    try and add it into working memory, 
                checking for inconsistency on the way 
 
                this will generate a new wme and we can quit here
        else
                charm it
                check we arent looping

                try and add it into working memory, 
                checking for inconsistency on the way 
 
                this will generate a new wme

                find the the subgoals and try to prove them
	    
	id(Goal,Id),
	newStep(Step,Path0,Path1), 
	(member(Var=Old,Facts0),
        -> Value=Old, 
	   Path=Path1, 
	   newFacts(Facts1,Facts0,Facts)
        ;  newFacts(Fact,Facts0,Facts1),
           bagof(Body,Goal^clause(@Goal,Body),SubGoals),
	   rin(SubGoal,SubGoals),
	   rdo(SubGoal,wme(Path1,Facts1),wme(_,Facts))).
*/
rdo(X) -->  {X}.

swap([],X,X).
swap([H|T]) --> swap1(H),swap(T).

swap1(A@B,X,X)    :- (var(B) ; B \= ( _ @ _)), !,swap0(X,A,B,B,X). 
swap1(A@B@C,X,Y) :- swap0(X,A,Old,New,Y),
                    swap1(B@C,Old,New).

swap1(A is B,X,Y) :- swap0(X,A,_,B,Y).
swap1(A<<B,X,Y)   :- swap0(X,A,Old,[B|Old],Y).
swap1(+A,X,Y)     :- swap0(X,A,Old,New,Y), New is Old + 1.
swap1(-A,X,Y)     :- swap0(X,A,Old,New,Y), New is Old - 1.

r2l(X ror Y,   l([X|Rest],N)) :- !, r2l(Y,l(Rest,N0)), N is N0 + 1.
r2l(X rand Y,  l([X|Rest],N)) :- !, r2l(Y,l(Rest,N0)), N is N0 + 1.
r2l(X,         l([X]     ,1)).

bad(X,[]) :- !, write(bad(X)),nl,fail.
bad(X,Y)  :- write((bad(X):- Y)),nl,fail.

oops(X)        :- \+ known(X),  print(unknown(X)),nl,fail.
known(X)       :- nonvar(X), clauses(Y,_,_,_), X=Y.

P // L :- maplist(ok(P),L,L).

ok(P,X,X) :- 
	Goal =.. [P,X],
	 @Goal.

charm(T0,T) :- 
            swap0(T0,meta,OldM,NewM,T),
            swap0(OldM,charmed,_,t,NewM).



verify :- 
	mine(F/A=X),
	format("\n% ~w/~w ",[F,A]),
	X, 
	(@X -> dot(+) ; format("\n%      bad: ~w",[X])), 
	fail.
verify :- nl.

kb :-
	forall(mine(F/A=_),
	       listing(F/A)).

mine(Mine) :- 
	setof(One,mine1(One),All), 
	member(Mine,All).
mine1(F/A=Blank) :- 
	clause(@X,_), 
	predicate_property(X,interpreted),
	functor(X,F,A),
	functor(Blank,F,A).

C @ A :-
	clause(@C,D),
	functor(C,A,_),
	D.
