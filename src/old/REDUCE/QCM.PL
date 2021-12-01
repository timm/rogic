% bunch of back-compatability stuff)
:- op(1001,xfx,<-).
:- op(950,xfy,ror).
:- op(950,xfy,rand).
:- op(900, fx, (*)).
:- op(850, fx, if ).
:- op(825,xfx,then).
:- op(800,xfx,(++)).
:- op(800,xfx,(--)).
:- op(800,xfx,+-+).
:- op(800,xfx,+--).
:- op(800,xfx,--+).
:- op(800,xfx,---).
:- op(1,  fx,  no).
:- op(1,  fx,  ++).
:- op(1,  fx,  +-).
:- op(1,  fx,  -+).
:- op(1,  fx,  --).


term_expansion((*if no X then Y  ++ Z), Out):- !,xpand((-X,(Z <-   Y)),Out).
term_expansion((*if no X then Y  -- Z), Out):- !,xpand((-X,(Z <-  -Y)),Out).
term_expansion((*if no X then Y +-+ Z), Out):- !,xpand((-X,(Z <- ++Y)),Out).

term_expansion((*if no X then Y +-- Z), Out):- !,xpand((-X,(Z <- +-Y)),Out).
term_expansion((*if no X then Y --+ Z), Out):- !,xpand((-X,(Z <- -+Y)),Out).
term_expansion((*if no X then Y --- Z), Out):- !,xpand((-X,(Z <- --Y)),Out).
term_expansion((*if    X then Y  ++ Z), Out):- !,xpand(( X,(Z <-   Y)),Out).
term_expansion((*if    X then Y  -- Z), Out):- !,xpand(( X,(Z <-  -Y)),Out).
term_expansion((*if    X then Y +-+ Z), Out):- !,xpand(( X,(Z <- ++Y)),Out).
term_expansion((*if    X then Y +-- Z), Out):- !,xpand(( X,(Z <- +-Y)),Out).
term_expansion((*if    X then Y --+ Z), Out):- !,xpand(( X,(Z <- -+Y)),Out).
term_expansion((*if    X then Y --- Z), Out):- !,xpand(( X,(Z <- --Y)),Out).
term_expansion((*             Y  ++ Z), Out):- !,xpand((   Z <-   Y),Out).
term_expansion((*             Y  -- Z), Out):- !,xpand((   Z <-  -Y),Out).
term_expansion((*             Y +-+ Z), Out):- !,xpand((   Z <- ++Y),Out).
term_expansion((*             Y +-- Z), Out):- !,xpand((   Z <- +-Y),Out).
term_expansion((*             Y --+ Z), Out):- !,xpand((   Z <- -+Y),Out).
term_expansion((*             Y --- Z), Out):- !,xpand((   Z <- --Y),Out).

%%%%%%%%%%%%%%%%%%
% rule compiler

xpand((-X,(Y <- -+Z)),Out) :- !, xpands([(Y <- -now(X), -+Z),(Y <-  X)],Out).
xpand((-X,(Y <- ++Z)),Out) :- !, xpands([(Y <- -now(X), ++Z),(Y <- -X)],Out).
xpand((-X,(Y <-  -Z)),Out) :- !, xpands([(Y <- -now(X),  -Z),(Y <-  X)],Out).
xpand((-X,(Y <-   Z)),Out) :- !, xpands([(Y <- -now(X),   Z),(Y <- -X)],Out).
xpand(( X,(Y <- -+Z)),Out) :- !, xpands([(Y <-  now(X), -+Z),(Y <- -X)],Out).
xpand(( X,(Y <- ++Z)),Out) :- !, xpands([(Y <-  now(X), ++Z),(Y <-  X)],Out).
xpand(( X,(Y <-  -Z)),Out) :- !, xpands([(Y <-  now(X),  -Z),(Y <- -X)],Out).
xpand(( X,(Y <-   Z)),Out) :- !, xpands([(Y <-  now(X),   Z),(Y <-  X)],Out).
xpand((X <- Y),(Head :- Body)) :-
%    \+ number(Y), !,
    xpand(Y,V,Body),
    makeGoal(X,V,Head).


/*xpand((X <- N),Out) :-
    number(N),
    expand_term((wme+val of X= N --> o hop(val of X =N,true)),Out).
*/

xpand((X0 | Y0), V,(X , Y))    :- !, xpand(X0,V,X), xpand(Y0,V,Y).
xpand((X0 , Y0), V,(X , Y))   :- !, xpand(X0,V,X), xpand(Y0,V,Y).
xpand(-now(X),   _, G) :- !,makeGoal(X,-1,G).
xpand( now(X),   _, G)  :- !,makeGoal(X,1,G).

xpand(    ++X,V,  (creator(V,V1),     G)) :- !,makeGoal(X,V1,G).
xpand(    +-X,V,  (destroyer(V,V1),   G)) :- !,makeGoal(X,V1,G).
xpand(    -+X,V,  (invcreator(V,V1),  G)) :- !,makeGoal(X,V1,G).
xpand(    --X,V,  (invdestroyer(V,V1),G)) :- !,makeGoal(X,V1,G).
xpand(     -X,V,  (inverse(V,V1),     G)) :- !,makeGoal(X,V1,G).
xpand(      X,V,  (direct(V,V1),      G)) :-   makeGoal(X,V1,G).

direct(       1, 1).
direct(      -1,-1).
creator(      1, 1).
destroyer(    1,-1).
invcreator(  -1, 1).
invdestroyer(-1,-1).
inverse(      1,-1).
inverse(     -1, 1).

makeGoal(X,Y,step(X,Y)).

:- index(xx(1,1)).
:- discontiguous xx/2.
:- multifile xx/2.

step(X,std) :-
    ((clause(jump(X, 1),Body), Body  -> A=1; A=0) rand
     (clause(jump(X,-1),Body), Body  -> B=1; B=0)
    ),
    (A=1,B=1 % proved via competing influences
    ;A=0,B=0 % proved via isolation
    ).

jump(X,V) :- knownInput(X,V).

%XXX
/*xpands(X,Y) :- xpands(X,[],Y).
xpands([],Out,Out).
xpands([H|T],In,Out) :-
    xpand(H,Temp0),
    asList(Temp0,Temp1),
    append(In,Temp1,Temp2),
    xpands(T,Temp2,Out).
    */
xpands(L,All) :-
    setof(One,L^xpands1(L,One),All).
xpands1(These,One) :-
    member(Item,These),
    xpand(Item,X),
    asList(X,L),
    member(One,L).

asList(X,X) :- is_list(X),!.
asList(X,[X]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% table of experimental results compiler
genScenario([rx=Rx0|Results],Out) :-
    allIns(Rx0,All),
    getIns(Rx0,All,Rx),
    maplist(additR,[rx=Rx|Results],S1),
    transpose(S1,S),
    expand_term(scenarios(S),Out).

additR(X=L,Out) :- maplist(addit(X),L,Out).
addit(X,Y,X/Y).

allIns(Ins,All) :-
    setof(Y,X^Ins^(member(X,Ins),
                    member(Y,X)),All).

getIns([],_,[]).
getIns([Rx0|Rxs0],All,[Rx|Rxs]) :-
    getIns1(All,Rx0,Rx),
    getIns(Rxs0,All,Rxs).

getIns1([],_,[]).
getIns1([Action0|Actions0],Mentioned,[Action|Actions]) :-
    getIns2(Action0,Mentioned,Action),
    getIns1(Actions0,Mentioned,Actions).

getIns2(Action,Mentioned,Action/1) :-
    member(Action,Mentioned),!.
getIns2(Action,_,Action/ -1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% gizmo that turns results table into  i/o pairs
getScenario(S,N,In,Goals) :-
    flag(nthScenario,_,1),
    twoMembers(S,[rx/Rx1|E1],[rx/Rx2|E2]),
    delta(E1,E2,Goals,_),
    delta(Rx1,Rx2,In0,InsNow),
    append(In0,InsNow,In),
    flag(nthScenario,N1,N1+1),
    N=N1.

delta([],_,[],[]).
delta([X/ValX|Xs],[X/ValY|Ys],
      [val(X,Delta)|Rest]
      %XXX??? ,[now of X=ValY |Nows]   
      ) :-
    number(ValX),number(ValY),!,
    compare(Comp,ValY,ValX),
    delta1(Comp,Delta),
    delta(Xs,Ys,Rest,Nows).
delta([_|Xs],[_|Ys], Rest,Nows) :-
    delta(Xs,Ys,Rest,Nows).

delta1(<,-1). delta1(=,0). delta1(>,1).
