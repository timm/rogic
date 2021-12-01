:- module(ram,
	[wmeClear/1
	,wmePrint/1
        ,wmesOk/0
	,win /1
        ,wout/1
	,w/1
        ,w/2
	,ok/1
	]).

:- op(1,fx,w), op(1, fx,wout), op(1,fx,win).
:- ensure_loaded([lib,ramrun]).
:- index(fpos(1,1,0)).
:- Things = (ok/1,w/1,w/2,win/1,wout/1,def/2, fpos/3),
   (discontiguous Things), (multifile Things).

term_expansion(X=L,All) :-
	bagof(One,X^L^xpandDef(X,L,One),All).

xpandDef(Category,Descriptions,
	       [(:- dynamic F/L)
               ,(w    Term    :- Access)
               ,(w(Term,Keys) :- Access)
               ,(win Term     :- Assert)
               ,(wout Term    :- retract(Term))
               ,(ok(Term)     :- oops(Tests,Term))
               ,def(Category,Term)
	       ,(:- index(Index))
               |Fpos
               ]) :- 
	member(Description,Descriptions),
	Description =.. [F|Details], 
	length(Details,L), 
	length(Fields,L), 
	Term =.. [F|Fields], 
	xpand(Details,F,1,Fpos,Fields,Keys,Tests0,Ints),
	Index =.. [F|Ints],
	Tests=[ground(Term)|Tests0],
	addChecks(ok(Term),assert(Term),Assert),
	addChecks(ok(Term),Term,        Access).
 
xpand([],[],[],[],[],[]).
xpand([Name0:Rule|Rules],
       F,N0,
       [fpos(F,Name,N0)|Fpos],
       [Field|Fields], 
       Keys, 
       [ok(Rule,Field) |Rest],
       Ints) :- !,
	xpand1(Name0,Name,Field,Keys,Keys1,Ints,Ints1),
	N is N0 + 1,
	xpand(Rules,F,N,Fpos,Fields,Keys1,Rest,Ints1).

xpand1(+Name,Name,Field,[Field|Keys], Keys,[1|Ints],Ints) :- !.
xpand1(Name, Name,_,    Keys,         Keys,[0|Ints],Ints).

addChecks(Maybe,Goal,((oks(_,active)->Maybe;true),Goal)) :-	
	oks(enabled,_),!.
addChecks(_,Goal,Goal).

:- [wme]. 

