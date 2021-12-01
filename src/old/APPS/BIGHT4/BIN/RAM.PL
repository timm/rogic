%-----------------------------------
ensure(X) :- X,!.
ensure(X) :- assert(X).

ensures(X) :- member(C,X), ensure(C), fail.
ensures(_).

retracts(X) :- member(R,X), retract(R), fail.
retracts(_).

%----------------------------------------------------
% ram working memory management

wme_precedence([dialect,names,theory,theoryDetail,data,datum,run]).

wme_also(X,Y) :-
	wme_precedence(All),
	after(X,All,Tail),
	member(Y,[X|Tail]).

wmeClear            :- wme_precedence([H|_]),
	               wmeClear(H,_).
wmeClear(This)      :- wmeClear(This,_).

% clear 'What' and also anything dependant on it.
wmeClear(What,This) :- 
	wme_also(What,Also),
	wme(Also,W), 
	functor(W,This,_), 
	wmeRetract(W), 
	fail.
wmeClear(_,_).

wmeRetract(W) :- retract(W), fail.
wmeRetract(W) :- clause(W,Y), retract(( W :- Y)), fail.
wmeRetract(_).

wmePrint       :- wme_precedence([H|_]), wmePrint(H,_).
wmePrint(This) :- wmePrint(This,_).

wmePrint(Topic,Term) :- 
        wme_also(Topic,Also),
	wmePrint1(Term,Also),
        fail.
wmePrint(_,_).

wmePrint1(Term,Category) :-
	nl,nl,write('%---------------------------------------'),nl,
        write('% ['),
        print(Category), write('] related facts'), nl,
	wme(Category,Term),
	functor(Term,This,Arity), 
	nl, write('% '),
        print(This/Arity), nl,
	Term, 
	print(Term), 
	write('. '),
	nl, 
	fail.
wmePrint1(_,_).

wmePrint1(Term) :- 
	wme(_,W), 
	functor(W,Term,_), 
	W, 
	print(W), 
	write('. '), 
	nl, 
	fail.
wmePrint1(_).

wmeSetUp :- wme_precedence(P), wme(Type,W), \+ member(Type,P),
	    print(badWmeType(Type,wme(Type,W))), nl, fail.
wmeSetUp :- wme(_,W), functor(W,F,A), (dynamic F/A),  fail.
wmeSetUp.

 
%----------------------------------------------------
% simple query system for facts

/* demo


:- selectorShell(p,       % basic accessor
                 new_p,   % constructor
                 ps,      % shell for smart accesses ; e.g. running
                          % over a lsit of accesses, incrementing,
			 % decrementing values, etc.
                 p(id,x,cost,edges,vertices,forbids,ab, roots, type)).

:- new_p(X), 
   ps([id++,
       vertices*a, 
       forbids / Old = partial(2,3),
       edges * b],
       X,
       Y).

X = p(G2488, G2492, G2496, G2500, G2504, G2232, G2512, G2516, G2520)
Y = p(1, G2492, G2496, [b], [a], partial(2, 3), G2512, G2516, G2520)
Old = G2232 
*/

:- dynamic knownField1/2.
:- op(100,xf,--).
:- op(100,xf,++).

q(Term) :- selectorShell(Term).

selectorShell(Term) :-
	Term =.. [Selector|_],
	name(Selector,Selector1),
	name('0',New),
	name('s',S),
	append(Selector1,S,Shell0),        name(Shell,Shell0),
	append(Selector1,New,Constructor0),name(Constructor,Constructor0),
	selectorShell(Selector,Constructor,Shell,Term).

selectorShell(Selector,Constructor,Shell,Term) :-
	functor(Term,F,Arity),
	functor(Blank1,F,Arity),
	functor(Blank2,F,Arity),
	makeChecks(Selector,Term),
	makeConstructor(Blank1,Constructor),
	makeSelector(Blank1,Blank2,Arity,Selector,Term),
	makeSelectorShell(Selector,Shell).

makeChecks(Selector,Term) :-
	retractall(knownField1(_,Selector)),
	Term =.. [_|Fields],
	member(Field,Fields),
	assert(knownField1(Field,Selector)),
	fail.
makeChecks(_,_).

knownField(X,Y) :- knownField1(X,Y),!.
knownField(X,Y) :- 
	write('Failed access on unknown field ['),
	print(X), write('] in ['),
	print(Y), write('].'), nl, fail.
	
makeConstructor(Blank, MFunctor) :-
	Doomed      =.. [MFunctor,_],
	retractall(Doomed),
 	Constructor =.. [MFunctor,Blank],
	%not(not((clause(Blank,_) -> retractall(Blank) | true))),
	assert(Constructor).

makeSelector(Blank,_,Arity,SFunctor,Term) :-
 	Selector =.. [SFunctor,Field,Blank,Value],
	retractall(Selector),
	between(1,Arity,Arg),
	arg(Arg,Blank,Value),
	arg(Arg,Term,Field),
	assert(Selector),
	fail.
makeSelector(Old,New,Arity,SFunctor,Term) :-
 	Selector =.. [SFunctor,Field,Old,Value0,New,Value1],
	retractall(Selector),
	between(1,Arity,Arg),
	arg(Arg,Term,Field),
	makeUpdateSelector(1,Arity,Arg,Old,Value0,New,Value1),
	assert(Selector),
	fail.
makeSelector(Blank,_,_Arity,SFunctor,_Term) :-
	Doomed =.. [SFunctor,_,_],
	retractall(Doomed),
	Head =.. [SFunctor,Field,Value],
	Clause1 = Blank,
	Clause2 =.. [SFunctor,Field,Blank,Value],
	assert((Head :- Clause1,Clause2)),
	fail.
makeSelector(_,_,_,_,_).

makeUpdateSelector(Arity,Arity,Goal,Old,Value0,New,Value1) :- !,
	makeUpdateSelector1(Arity,Goal,Old,Value0,New,Value1).
makeUpdateSelector(Here,Stop,Goal,Old,Value0,New,Value1) :-
	makeUpdateSelector1(Here,Goal,Old,Value0,New,Value1),
	Here1 is Here + 1,
	makeUpdateSelector(Here1,Stop,Goal,Old,Value0,New,Value1).

makeUpdateSelector1(Here,Goal,Old,Value0,New,Value1) :-
	arg(Here,Old,Value2),
	arg(Here,New,Value3),
	(Here = Goal 
	->	Value0 = Value2, 
		Value1 = Value3 
	| 	Value2 = Value3).

makeSelectorShell(Selector,Shell):-
	Doomed1 =.. [Shell,_],		retractall(Doomed1),	
	Doomed2 =   (Doomed1 :- _),	retractall(Doomed2),		
	Doomed3 =.. [Shell,_,_],	retractall(Doomed3),		
	Doomed4 =   (Doomed3 :- _),	retractall(Doomed4),		
	Doomed5 =.. [Shell,_,_,_],	retractall(Doomed5),		
	Doomed6 =   (Doomed5 :- _),	retractall(Doomed6),		
	makeSelectorsSkeleton(Shell,Selector,_,S),
	assert(S),
	fail.
makeSelectorShell(_,_).


makeSelectorsSkeleton(All,_,_,S) :- S =.. [All,[]].
makeSelectorsSkeleton(All,_,_,(S :- Sub1)) :- 
	S =.. [All,X=Y],
	Sub1 =.. [All,[X=Y]].
makeSelectorsSkeleton(All,One,_,
                     (Head :- (knownField(Field,One),Sub1,Sub2))) :-
	Head =.. [All,[Field = Value | Rest ]],
	Sub1 =.. [One,Field,Value],
	Sub2 =.. [All,Rest].

makeSelectorsSkeleton(All,_,_,S) :- S =.. [All,[],_].
makeSelectorsSkeleton(All,_,_,(S :- Sub1)) :- 
	S =.. [All,X=Y,Term],
	Sub1 =.. [All,[X=Y],Term].

makeSelectorsSkeleton(All,One,Term, 
			(Head :- knownField(Field,One),
                                 Sub1,
				 Sub2)) :-
	Head =.. [All,[Field = Value | Rest ], Term],
	Sub1 =.. [One,Field,Term,Value],
	Sub2 =.. [All,Rest , Term].

makeSelectorsSkeleton(All,_,_,S) :- S =.. [All,[],Out,Out].
makeSelectorsSkeleton(All,_One,Term,(Head :- (Sub1,!,Sub2))) :-
	Head =.. [All,[Command | Rest ], Term0,Term],
	Sub1 =.. [All,Command,Term0,Term1],
	Sub2 =.. [All,Rest,Term1,Term].

makeSelectorsSkeleton(All,One,Term1,
                      (Head :- knownField(Field,One),Sub1)) :-
	Head =.. [All,Field/Old=New, Term0,Term1],
	Sub1 =.. [One,Field,Term0,Old,Term1,New].

makeSelectorsSkeleton(All,One,Term1,
                     (Head :- knownField(Field,One),Sub1,Sub2,Sub3)) :-
	Head =.. [All,Field*Addit, Term0,Term1],
	Sub1 =.. [One,Field,Term0,Old0,Term1,New],
	Sub2 =   (var(Old0) 
		  -> Old = [] 
                  ;  Old = Old0),
	Sub3 =   (listp(Addit) 
                  -> append(Addit,Old,New) 
                  ;  New = [Addit|Old]).

makeSelectorsSkeleton(All,One,Term1,
                     (Head :- knownField(Field,One), Sub1,Sub2)) :-
	Head =.. [All,Field+Addit, Term0,Term1],
	Sub1 =.. [One,Field,Term0,Old,Term1,New],
	Sub2 =   (var(Old) -> New = Addit | New is Old + Addit).

makeSelectorsSkeleton(All,_One,Term1,
	              (Head :- Sub1)) :-
	Head =.. [All,Field=New, Term0,Term1],
	Sub1 =.. [All,Field/ _Old = New,Term0,Term1].

makeSelectorsSkeleton(All,_One,Term1,(Head :- Sub1)) :-
	Head =.. [All,Field++, Term0,Term1],
	Sub1 =.. [All,Field+1,Term0,Term1].	

makeSelectorsSkeleton(All,_One,Term1,(Head :- Sub1)) :-
	Head =.. [All,Field--, Term0,Term1],
	Sub1 =.. [All,Field+ -1,Term0,Term1].	

qprint(Term) :-
	Term =.. [Head|_Tail],
	write(Head), write(':'),nl,
	Goal =.. [Head,Field,Term,Value],
	Goal,
	tab(8), 
	write(Field),write(' : '),print(Value), 
	nl,
	fail.
qprint(_).























