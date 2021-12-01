 % load a theory, and assert lots of side-effect stuff
 th(X) :- wmeZap, [th/X], accessors, makeDefs.
 
 % define the stuff we assert 
 wme(context(_,_,_,_,_)).
 wme(p(_,_,_,_)).
 wme(defs(_X,_N)). % _X is defined in _N rules
 wme(used(_X)).    % _X is a symbol seen in a rule.
 
 % high level wme controllers 
 wmeSetup :- forall(wme(X), wmeSetup1(X)).
 wmeZap   :- forall(wme(X), wmeZap1(X)).
 wmeShow  :- forall(wme(X), wmeShow1(X)).
 
 % death to wme elements
 wmeZap1(X)   :- retractall(X).
 % show wme elements
 wmeShow1(X)  :- functor(X,F,A),listing(F/A).
 % make all wme stuff changable and spreadable
 wmeSetup1(X) :- functor(X,F,A), dynamic(F/A), discontiguous(F/A).
 
 :- wmeSetup.
 
 % X is abducible if it is defined in no rule.
 makeDefs :-
	forall(definitions(X,N),
	       assert(defs(X,N))).

 definitions(X,Ones) :-
	used(X),
	bagof(One, X^definition(X,One),Ones).
 definitions(X,[]) :-
	used(X),
	\+ definition(X,_).

 definition(X,p(X,V,W0,W)=Body) :-
	clause(p(X,V,W0,W),Body).

 % grab all the symbols used in the rules
 % and create a working memory for those symbols.
 accessors :-
 	bagof(One,used(One),All),
 	Structure=..[c|All],
 	forall(capsule(context=Structure,Accessor),
 	       assert(Accessor)).
 
 capsule(Handle = Term,Out) :-
 	functor(Term,F,Arity),
 	arg(Pos,Term,Item),
         joinArgs(F,Arity,Pos,Old,New,Term1,Term2),
 	Out =.. [Handle,Item,Old,New,Term1,Term2].
 
 joinArgs(F,Arity,Pos,Old,New,Term1,Term2) :-
 	length(L1,Arity),
 	Pos0 is Pos - 1,
 	length(Before,Pos0),
 	append(Before,[Old|After],L1),
 	append(Before,[New|After],L2),
 	Term1 =.. [F|L1],
 	Term2 =.. [F|L2].
 
 % context/3: run down a list
 context([]) --> [].
 context([X=V|Rest]) --> context(X,V,V), context(Rest).
 
 % context/4: access one var
 context(X,V) --> context(X,V,V).
 
 % show the context stuff
 show(W) :- nl, numbervars(W,0,_),
            context(F,V,V,W,W),
 	   format('~10> = ~w\n',[F,V]),
 	   fail.
 show(_).
 
 
