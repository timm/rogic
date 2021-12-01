% every box gets the following tools
% '#S' is the accessor atom
% '#F' is the functor of the bag
% '#I' is the intialization list
% '#B' is the empty fella

'#S'(new)  -->  
	{gensym('#Fun',I)},
	'#S'(blank(B)), 
	'#S'(_//B), 
	{arg(1,B,I)},
	'#S'('#I').

'#S'(blank('#B')) --> [].
'#S'(blank('#Fun','#B')) --> [].
'#S'(X is A)   --> '#F'(X,_,A,_).
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
'#S'(X >> H)   --> '#F'(X,L,Less,_),{oneLess(L,H,Less)}.
'#S'(X has V)   --> '#F'(X,A,A,_), V in A.
'#S'([])       --> [].
'#S'([H|T])    --> '#S'(H), '#S'(T).
'#S'(show)     --> nl, 
	'#S'(numbervars), 	
	('#S'(w(W)),
         {arg(1,W,Y)}
         ,X ='#Fun'
	 ;'#S'(X=Y)
         ),
	format('~12P = ~w\n',[X,Y]),
	fail.
'#S'(show)     --> [].
'#S'(numbervars,W,W) :- numbervars(W,0,_).
'#S'(W0//W,W0,W).
'#S'(w(W),W,W).
'#S'(copy(Y),X,X) :- copy_term(X,Y).
'#S'(bad(X)) --> '#F'(X,A,A,_), \+ '#S'(ok(X,A)).
'#S'(oks) --> \+ '#S'(bad(_)).
'#S'(get,'#B','#B') :- '#B'.
'#S'(id(X),W,W) :- '#S'(blank(W),W,W),arg(1,W,X).
'#S'(commit,W,W) :- asserta(W).
'#S'(change) --> '#S'(zap), '#S'(commit).
'#S'(zap,W,W) :- arg(1,W,Id), arg(1,'#B',Id), retractall('#B').
'#S'(zapall)         --> {retractall('#B')}.
'#R'(ok('#X'))       --> '#F'('#X',A,A,_), {range('#Type',A)}.
'#R'(ok('#X',Value)) --> {range('#Type',Value)}.

term_expansion(F=Meta + Fields,Out) :- 
    defWme(F, Meta,Fields,Out).

defWme(F,Meta,L,[def(F,A,L)|Out]) :-
        ins([iname=I,prefix=A],Meta),
        L1 = ['_id' = _ of numeric|L],
	length(L1,Arity),
	bagof(One,F^A^L^I^Arity^defWme1(F,A,I,Arity,L1,One),Out).

defWme1(Functor,_,Internal,Arity,Fields,X) :-
	nth1(N,Fields,Name is Default of _),
	functor(In, Functor,Arity),
	functor(Out,Functor,Arity),
	joinArgs(N,Old,New,In,Out),
	X =.. [Internal,Name,Old,New
              ,Default,In,Out].
defWme1(Functor,_,_,Arity,_,
       (portray(X) :- nonvar(X),X=Y,
                      write(sack(Functor)))) :-
	functor(Y,Functor,Arity).
defWme1(_,A,_,_,_,(:- discontiguous A/3)).
defWme1(F,_,_,Arity,_,(:- dynamic F/Arity)).
defWme1(_,A,_,_,_,(:- op(899,fx,A))).
% optimiser stuff
defWme1(Functor,Access,_,Arity,_,(touch(Wme0,Action,Wme1):- X)):-
	functor(Wme0, Functor,Arity),
	X    =.. [Access,Action,Wme0,Wme1].
defWme1(_,Access,Internal,_,_, (goal_expansion(Goal,X):-nonvar(A))):-	
	Goal =.. [Access,A = B,In,Out],
        X    =.. [Internal,A,B,B,_,In,Out].
defWme1(_,Access,Internal,_,_,(goal_expansion(Goal,X):-nonvar(A))):-	
	Goal =.. [Access,A ^ B ^ C,In,Out],
        X    =.. [Internal,A,B,C,_,In,Out].
defWme1(_,Access,Internal,_,_,  (goal_expansion(Goal,X):-nonvar(A))):-
        Goal =.. [Access,A is B,In,Out],
        X    =.. [Internal,A,_,B,_,In,Out].
defWme1(Functor,Access,Internal,Arity,Fields,Out) :-
        maplist(arg(1),Fields,[_|Inits]),
	functor(Term,Functor,Arity),
	clause('#S'(A,B,C),D),
	runiv(('#S'(A,B,C) :- D),
                ['#F'/Internal
                ,'#I'/Inits
	        ,'#B'/Term
                ,'#S'/Access
                ,'#Fun'/Functor
                ],Out).
defWme1(Functor,Access,_,_,Fields,Out) :-
        member(Field is _ of Range,Fields),
	rangeType(Range,Type),
	clause('#R'(A,B,C),D),
        runiv(('#R'(A,B,C) :- D),
                ['#R'/Access
                ,'#X'/Field
                ,'#Type'/Type
                ,'#F'/Functor
                ],Out).

rangeType(X,X) :- atom(X). 
rangeType([X],eq(X)) :- atom(X).
rangeType([X - Y],between(X,Y)).
rangeType([X,Y|Z],member([X,Y|Z])).

/*too clever!
rangeType(list of Y, list of Y).
range(F           ,C) :-     
	functor(C,F,A), 
	def(F,_,Fields), 
	length(Fields,A),
        touch(C,oks,_).
range(list of Y,      Cs) :-  member(C,Cs), range(Y,C).
*/

range(eq(C)       ,C).
range(between(A,B),C) :- A =< C, C >= B.
range(member(L)   ,C) :- member(C,L).
range(string      ,C) :- atom(C).
range(number      ,C) :- numeric(C).
range(atom        ,C) :- atomic(C).

	
joinArgs(N,Old,New,T1,T2) :-
    T1 =.. [_|L0],
    T2 =.. [_|L],
    joinArgs(1,N,L0,Old,New,L).
joinArgs(N,N,[Old|Rest],Old,New,[New|Rest]).
joinArgs(N0,N1,[X|L0],Old,New,[X|L]) :-
    N0 < N1,
    N2 is N0 + 1,
    joinArgs(N2,N1,L0,Old,New,L).

goal_expansion(=(X,Y,W,W), X =  Y).
goal_expansion(>=(X,Y,W,W),X >= Y).
goal_expansion(>(X,Y,W,W), X >  Y).
goal_expansion(<(X,Y,W,W), X <  Y).
goal_expansion(=<(X,Y,W,W),X =< Y).

goal_expansion(in(X,L,W,W),member(X,L)).
goal_expansion(say(X,A,A),print(X)).
goal_expansion(sayln(X,A,A),(print(X),nl)).
goal_expansion(nl(X,X),nl).
goal_expansion(format(A,B,C,C),format(A,B)).
goal_expansion(fail(X,X),fail).
goal_expansion(bagof(X,Y,Z,W,W),bagof(X,Y,Z)).
goal_expansion(sumof(X,Y,Z,W,W),sumof(X,Y,Z)).

show(X) :- touch(X,show,_).

term_expansion(rule Id for Group if If then Then,Out) :-
	xpandRule(Id,Group,If,Then,Out).

xpandRule(Id,Group,If0,Then0,Out) :-
        addChange(Then0,Then1),
	xpand(Then1,then,0,_,_,_,Then2),
	xpands(If0,Then2,Group,Id,Out).

addChange(A0 and B0,A and B) :- !,
	addChange(A0,A),
	addChange(B0,B).
addChange(A=New with B,A=new with C) :- 
	nonvar(New), new=New,!,
	addChange1(B,C).
addChange(A=X with B,A with w(X) with C) :- !,
	addChange1(B,C).
addChange(A with B,A  with C) :- !,
	addChange1(B,C).
addChange(A,A).

addChange1(A with B,A with C) :- !,
	addChange1(B,C).
addChange1(change,change) :- !.
addChange1(A,A with change).

xpands(If0,Then,Group,Id,All) :-
	bagof(One,  If0^Group^Id^Then^
                   xpands1(If0,Then,Group,Id,One),
	     All).

xpands1(If0,Then,Group,Id,Out) :-
	 xpand(If0,if,0,Spec,[],Wme,If1),
         vars(If1,Vars1),
         vars(Then,Vars2),
         intersectV(Vars1,Vars2,Vars),
         gensym(r,Label),
         (expand_term((if(Group,  Label,Spec,Id,Wme,Vars) :- If1 ),Out)
         ;expand_term((then(Group,Label,     Id,Wme,Vars) :- Then),Out)
         ;Out=about(Group, Label,Spec)
         ).

xpand(A0 and B0, What,S0, S,W0, W,(A,B))  :- !, 
	xpand(A0,What,S0,S1,W0,W1,A),
	xpand(B0,What,S1, S,W1, W,B).
xpand(A0 or B0,  What,S0, S,W0,W,X)  :- !,
	(xpand( A0,What,S0,S,W0,W,X)
        ;xpand( B0,What,S0,S,W0,W,X)).
xpand(not A0,     What,S0,S,W0,W0, \+ A)  :- !, 
	xpand(A0, What,S0,S,W0,_,A).
xpand(A = New with B,then,S0,S,W,W,Stuff) :-  
	nonvar(New), new=New,!,
	def(A,Acc,_),
	with2list(new with B,Acc,S0,S,_,_,Stuff).
xpand(A0 with B,What,S0,S,W,[Id|W],Out) :-  !,
	nameId(A0,A,Id),
        Id=New,
	def(A,Acc,_),
	touch(Blank,blank(A,Blank),_),
	with2list(B,Acc,S0,S,Blank,New,Stuff),
        (What = if -> Out = (Blank,Stuff) ; Out=Stuff).
xpand(A,_,S0,S,W,W,A) :-
	S is S0 + 1.

nameId(A=Id,A,Id) :- !.
nameId(A,A,_).

with2list(X0 with Y, Acc,S0, S,W0, W,(X,Rest)) :- !, 
	with2list(X0,Acc,S0,S1,W0,W1,X), 
	with2list(Y, Acc,S1, S,W1, W,Rest).
with2list(X,Acc,S0,S,W0,W,Y) :- 
	Y =.. [Acc,X,W0,W],
	S is S0 + 1.

term_expansion(end_rules,Out) :-
	endRulesPrims(Out).

endRulesPrims(All) :-
	setof(One, endRulesPrim(One),All).

groups(All) :- setof(One,R^S^about(One,R,S),  All).
specs(G,All):- 
	setof(One,G^R^about(G,  R,One),Temp),
	reverse(Temp,All).

endRulesPrim(orderings(G,Orderings)) :-
	groups(Gs),
	member(G,Gs),
	specs(G,Orderings).

rule(N) :-
	clause(then(G,L,N,W,V),Body1),
	Then = (then(G,L,N,W,V) :- Body1),
	clause(if(G,L,Specs,N,W,V),Body2),
	If =   (if(G,L,Specs,N,W,V) :- Body2),
	numbervars(If,0,Top),
	Next is Top + 1,
	numbervars(Then,Next,_),
	portray_clause(If),
	portray_clause(Then).


if(N) :- spy(if), if(_,_,_,N,_,_).
