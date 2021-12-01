term_expansion(def(F,A,L),Out) :- defWme(def(F,A,L),Out).

defWme(def(F,A,L),Out) :-
	length(L,Arity),
	bagof(One,F^A^L^Arity^defWme1(F,A,Arity,L,One),Out).

defWme1(Functor,_,Arity,Fields,X) :-
	nth1(N,Fields,Name is Default),
	functor(In, Functor,Arity),
	functor(Out,Functor,Arity),
	joinArgs(N,Old,New,In,Out),
	X =.. [Functor,Name,Old,New
              ,Default,In,Out].
defWme1(Functor,_,Arity,_,
       (portray(X) :- nonvar(X),X=Y,
                      o(cost=C,X,_),
	              o(chances=Ch,X,_),
                      write(sack(Functor,c(C),ch(Ch))))) :-
	functor(Y,Functor,Arity).
defWme1(_,A,_,_,(:- discontiguous A/3)).
defWme1(_,A,_,_,(:- op(999,fx,A))).
defWme1(Functor,Access,_,Fields,Out) :-
	clause('#S'(A,B,C),D),
	runiv(('#S'(A,B,C) :- D),
                ['#F'/Functor
                ,'#I'/Fields
                ,'#S'/Access
                ],Out).

defWme1(Functor,Access,Arity,_, (touch(Wme0,Action,Wme1):- X)):-
	functor(Wme0, Functor,Arity),
	X    =.. [Access,Action,Wme0,Wme1].
defWme1(Functor,Access,_,_, (goal_expansion(Goal,X):-nonvar(A))):-	
	Goal =.. [Access,A = B,In,Out],
        X    =.. [Functor,A,B,B,_,In,Out].
defWme1(Functor,Access,_,_, (goal_expansion(Goal,X):-nonvar(A))):-	
	Goal =.. [Access,A ^ B ^ C,In,Out],
        X    =.. [Functor,A,B,C,_,In,Out].
defWme1(Functor,Access,_,_,  (goal_expansion(Goal,X):-nonvar(A))):-
        Goal =.. [Access,A is B,In,Out],
        X    =.. [Functor,A,_,B,_,In,Out].

goal_expansion(=(A,B,C,C),A=B).
goal_expansion(is(A,B,C,C),A is B).
/* one of those middle-of-the-night bright ideas that did not work
defWme1(Functor,Access,Arity,_, 
        (goal_expansion(Goal,true) :- noBody(Goal,Term))) :- 
        functor(Term,Functor,Arity),
        Goal =.. [Access,_,_,Term].


noBody(Goal,Term) :-	
     nonvar(Goal),
     predicate_property(Goal,file(_)),
     clause(Goal,Term),
     arg(1,Goal,A), 
     nonvar(A).
*/
joinArgs(N,Old,New,T1,T2) :-
    T1 =.. [_|L0],
    T2 =.. [_|L],
    joinArgs(1,N,L0,Old,New,L).
joinArgs(N,N,[Old|Rest],Old,New,[New|Rest]).
joinArgs(N0,N1,[X|L0],Old,New,[X|L]) :-
    N0 < N1,
    N2 is N0 + 1,
    joinArgs(N2,N1,L0,Old,New,L).

'#S'(new)      --> '#S'('#I').
'#S'(X is A)   --> '#F'(X,_,A,_).
'#S'(X ism A)   --> {Y is A}, '#F'(X,_,Y,_).
'#S'(reset(X)) --> '#F'(X,_,A,A).
'#S'(X=A)      --> '#F'(X,A,A,_).
'#S'(X ^ A ^ B)--> '#F'(X,A,B,_).
'#S'(+ X)      --> '#F'(X,Y,Z,_), {Z is Y + 1}.
'#S'(- X)      --> '#F'(X,Y,Z,_), {Z is Y - 1}.
'#S'(X * Y)    --> '#F'(X,Old,Z,_), {Z is Old * Y}.
'#S'(X + Y)    --> '#F'(X,Old,Z,_), {Z is Old + Y}.
'#S'(X / Y)    --> '#F'(X,Old,Z,_), {Z is Old / Y}.
'#S'(X - Y)    --> '#F'(X,Old,Z,_), {Z is Old - Y}.
'#S'(X >= Y)   --> '#F'(X,Z,Z,_), {Z >= Y}.
'#S'(X >  Y)   --> '#F'(X,Z,Z,_), {Z >  Y}.
'#S'(X <  Y)   --> '#F'(X,Z,Z,_), {Z <  Y}.
'#S'(X =< Y)   --> '#F'(X,Z,Z,_), {Z =< Y}.
'#S'(X << H)   --> '#F'(X,T,[H|T],_).
'#S'(X >> H)   --> '#F'(X,Old,New,_), {oneLess(Old,H,New)}.
'#S'([])       --> [].
'#S'([H|T])    --> '#S'(H), '#S'(T).
'#S'(show)     --> {nl}, '#S'(numbervars), '#S'(X=Y), {format('~20P = ~p\n',[X,Y]),fail}.
'#S'(show)     --> [].
'#S'(numbervars,W,W) :- numbervars(W,0,_).
'#S'(W0//W,W0,W).
'#S'(copy(Y),X,X) :- copy_term(X,Y).


%-------------------------------------

goodWhat(X,Y,Z) :- 
	goodWhat1(X,Y,Z), 
	(Y=0; true),
	(Z=1; true),
	!.
goodWhat1(A and B,X,Y) :- !, goodWhat1(A,X,Y), goodWhat1(B,X,Y).
goodWhat1(cost=C,C,_) :- !.
goodWhat1(chances=C,_,C) :- !.
goodWhat1(X,_) :- yuck(notCostChances(X)).

term_expansion(Who says What,[]) :-
        saysThis(Who, What).

saysThis(Who,What) :-
        good(who,Who),
	global(author,_,Who),
	goodWhat(What,Cost0,Chances0),
        inRange(Cost0,Cost),
        inRange(Chances0,Chances),
	global(cost,_,Cost),
	global(chances,_,Chances).

term_expansion(costRange=X,label(costRange,Y)) :- !,
	inRange(X,Y).

term_expansion(domain=X,[]) :- !,
	global(author,_,someone),
	global(cost,_,0),
        global(chances,_,1),
        global(domain,_,X).

term_expansion(A=L,[label(who,A)|All]) :-
        A \= known,
	bagof(label(A,Item),L^member(Item,L),All).

term_expansion(known=L,All) :-
	bagof(label(known,Item),
                 L^member(Item,[true|L]),
              All).

good(known,maybe(B)) :- label(known,B),!.
good(A,B) :- label(A,B),!.
good(A,B) :- functor(B,F,1),label(A,F),!.
good(A,B) :- format('% bad ~w: ~w\n',[A,B]),
	     fail.

goodItem(A,B,C) :- good(A,B=L), member(C,L).

term_expansion((Label if Y then X), Out) :-
	ruleHeadBody((X if Y),Label,Out).

ruleHeadBody((not X if Y),Label, Out) :-
        global(cost,Cost,Cost),
	global(chances,Chances,Chances),
	ruleHeadBody1(X,f,Y,Label,Cost,Chances,Out).

ruleHeadBody((X if Y),Label,Out) :-
        global(cost,Cost,Cost),
	global(chances,Chances,Chances),
	ruleHeadBody1(X,t,Y,Label,Cost,Chances,Out).

ruleHeadBody1(X,V,Y,Label,Cost0,Chances0,
	      (rule(X,?X=V,Label,Cost,Chances,A,B) :- 
	           do(Body,A,B))
              ) :-
	filterN(cost,Cost0,Cost),
	filterN(chances,Chances0,Chances),
	%Cost0=Cost,
	%Chances0=Chances,
	good(known,X),
	ruleBody(Y,Body).

filterN(_,0,0) :- !.
filterN(chances,1,1) :- !.
filterN(_Z,X,range(Y,Z,0.5)) :- number(X), !, Y is X*0.7, Z is X*1.3.
filterN(_Z,X,X).

ruleBody(In,Out) :-
	cond(In,A),  print(1),nl,
        t2l(A,B),
	buildrops(L), 
	groupHeads(B,L,C),
	buildr(C,Out).

cond(A,B) :- once(cond1(A,B)).

cond1(no  X,             _)     :- \+prim(X),!,yuck(no(compound)).
cond1(yes  X,             _)     :- \+prim(X),!,yuck(yes(compound)).

cond1(not (A  rand B), Out)     :- cond(not A ror  not B,Out).
cond1(not (A  and  B), Out)     :- cond(not A or   not B,Out).

cond1(not (_  rany   _),  _) :- !,yuck(not( rany)).
cond1(not (_  ors   _),  _) :- !,yuck(not( ors)).
cond1(not (_  rors  _),  _) :- !,yuck(not(rors)).
cond1(not (A  ror  B), Out) :- cond(not A rand not B,Out).
cond1(not (A  or   B), Out) :- cond(not A and  not B,Out).
cond1(A0 ror  B0,  A ror B) :- cond(A0,A), cond(B0,B).
cond1(A0 or   B0,  A or B) :- cond(A0,A), cond(B0,B).
cond1(A0 ors   B0, A ors B)  :- cond(A0,A), cond(B0,B).
cond1(A0 rors   B0, A rors B) :- cond(A0,A), cond(B0,B).
cond1(A0 rany   B0, A rany B) :- cond(A0,A), cond(B0,B).
cond1(A0 rand B0, A rand B):- cond(A0,A), cond(B0,B).
cond1(A0 and  B0, A and B) :- cond(A0,A), cond(B0,B).
cond1(not  no X,     _) :- !,yuck(notNo(X)).
cond1(not  yes X,     _) :- !,yuck(notYes(X)).
cond1(not  ?A \=   B, ?A=B) :- good(known,A).
cond1(not  A,         ?A=f) :- good(known,A).

cond1(no   ?A= X,    no(?all(A)=X)) :- good(known,A).


cond1(yes   ?A= X,  yes(?all(A)=X)) :- good(known,A).


cond1(no   A,  no(?all(A)=t)) :- good(known,A).


cond1(yes   A,  yes(?all(A)=t)) :- good(known,A).


cond1(     ?A =  B, ?A=B) :- good(known,A).
cond1(     ?A \= B, ?A\=B) :- good(known,A).
cond1(     A,       ?A=t) :- good(known,A).

prim(X) :- atomic(X).
prim(_ =  _).
prim(_ \= _).

yuck(X) :- 
	source_location(File, Line),
	format('% illegal: ~w near ~w \n\t[~w]\n',[File,Line,X]),fail.

t2l(?X=Y,?X=Y) :- !.
t2l(?X\= Y,?X \= Y) :- !.
t2l(Term0,L) :-
        Term0 =..L0,
        once(maplist(t2l1, L0, L)).

t2l1(H,H) :- var(H).
t2l1(?X=Y,?X=Y).
t2l1(X=Y,X=Y).
t2l1(H,H) :- atomic(H).
t2l1(H0,H):- t2l(H0,H).

groupHeads([H,A0,B0],S,Out) :- !,
	groupHeads(A0,S,A1),
	groupHeads(B0,S,B1),
	groupHeads1(H,A1,A2),
	groupHeads1(H,B1,B2),
	groupHeads2(H,A2,B2,S,Out).
groupHeads(L,_,L).

groupHeads1(H,[H|A],A) :- !.
groupHeads1(_,X    ,X).

groupHeads2(H,X,[Y|T],S,[H,X,Y|T]) :- 
	\+ is_list(X),
%	atomic(X), 
	\+ member(Y,S),
	!.
groupHeads2(H,X,[Y|T],_,[H,X,[Y|T]]) :- 
	is_list(X).
%       atomic(X).
groupHeads2(H,X,Y,_,[H,X,Y]).

buildr([Op|X0],Term) :- 
	buildrop(Op), 
        !,
	maplist(buildr,X0,X), 
	Term =.. [Op, X].
buildr([H0  |T0],[H|T]):- !,
	maplist(buildr,[H0|T0],[H|T]).
buildr(X,X).

buildrop(ror).
buildrop(or).
buildrop(ors).
buildrop(rors).
buildrop(rand).
buildrop(and).
buildrop(rany).
buildrop(not).
buildrop(yes).
buildrop(no).
buildrop(all).



buildrops(L) :- bagof(X,buildrop(X),L).

term_expansion(( ?X = Y  if Z),Out) :- 
	xpand((?X = Y if Z),Out).

xpand((?In = Out if Y),
        [(rule(In,?In=Out,Label,0,1,A,B) :- do(Body,A,B))]) :-
	ruleBody(Y,Body),
	gensym(rLabel,Label).

