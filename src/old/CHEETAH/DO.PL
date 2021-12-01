% if ordering is possible, then it can be X or rX
% if optionally can do 1 or more, then it can be X or Xs. 

% ands, same as and so i just support and
% not, - "s" meaningless cause we are only dealing with 1
% no and nos the same so i just support no
% rno and no exist cause it bagofs the clauses

% costs get eaten once and once only 

pop(rordered,L0,   X,L) :- rone(L0,X,L).
pop(ordered, [X|L],X,L).

do( and(L)) --> doAnd(L, ordered).
do(rand(L)) --> doAnd(L,rordered).
do(rany(L)) --> doAny(L,rordered).
do(  or(L)) --> doOr( L, ordered).
do( ror(L)) --> doOr( L,rordered).
do( ors(X)) --> doOrs(X, ordered).
do(rors(X)) --> doOrs(X,rordered).
do( not(X)) --> doNot(X).
do(  no([X])) --> doYesNo(X, no).
do( yes([X])) --> doYesNo(X,yes).
do( X =  Y) --> {X=Y}.
do(?X \= Y) --> {neg(Y,Z)}, do(?X=Z). 
do(?X =  Y) --> o spy(X=Y),{fail}.
do(?true=t) --> !,
        o cost is 0,
        o chances is 1.
do(?X =  Y) --> 
	o path  ^ Path0  ^ Path,
	o known ^ Before ^ After,
	{set_newel(Path0,X=Y,Path),% fails if not new
	set_key(Before,X=Z,After,Status)}, 
         % Status= (+) if its a new key
        ({Status = (=)}
         -> {v(value,Y,Z)},
                   % this fails if ware assuming something
		   % that clashes with old beliefs
             {v(chances,Chances1,Z)},
             o chances ^ Chances0 ^ Chances, % update chances, not cost
             {Chances is prob(Chances0 * Chances1)}, 
	     o(end(X))
         ;  {v(value,Y,Z)},
            do1(X,Y,Z)).
  

do1( all(X),Y,Z) --> !,
	{v(chances,Chances,Z), v(cost,Cost,Z)}, 
	doAll(X=Y, ordered,Chances,Cost).
do1(X,  Y,Z) -->
        {v(chances,Chances,Z),
         v(cost,   Cost,   Z)},
        o chances ^ Chances0 ^ 1,
        o cost    ^ Cost0    ^ 0,
	rule(X,?X=Y,Label,Cost1a,Chances1a),
	{computeRuleValues(Label,Cost1a,Chances1a,Cost1,Chances1)},
	o cost    ^ Cost2 ^ Cost,
        o chances ^ Chances2 ^ Chances,
        {Chances is prob(Chances0 * Chances1 * Chances2),
         Cost    is Cost0    + Cost1 + Cost2}.

do1(X,     _,Z) -->
        {\+ clause(rule(X,?X=_,_,_,_,_,_),_),
	 Chances is range(0,1,0.5),
	 %label(costRange,Range),
	 Cost is 0,
         v(chances,Chances,Z),
         v(cost,  Cost,  Z)},
         o cost is Cost,
         o chances is Chances. 

v(value,   X, v(X,_,_)).
v(cost,    X, v(_,X,_)).
v(chances, X, v(_,_,X)).
v(goal(G),G=X,Y) :- 
	v(value,X,Y).
v(print,  G,X) :- 
	v(value,V,X), 
	v(cost,C,X), 
	v(chances,Ch,X),
	format('~w=~w [cost=~w,chances=~w]',
               [G,V,C,Ch]). 

neg(X,Y) :- neg1(X,Y) ; neg1(Y,X).

neg1(1,-1). 
neg1(up,down). 
neg1(t,f). 
neg1(true,false).
neg1(yes,no).
neg1(y,n).

?(A=B)     :- o(new,_,W), ?(A=B,W,_).
?(A=B,C,D) :- do(?A=B,C,D).
	
show(X) :- touch(X,show,_).

doOr(L,P) --> 
	{pop(P,L,One,_)},
        do(One).

% AND
%
% all branches must be proved
%
% allCosts= allChances=()
% push cost,chances onto allCosts,allChances 
% set cost and chances to 0, 1
% for each branch from here (ordered L-to-R or randomly)
% do
%   save path
%   try to prove that branch
%   if fail, goto FAIL
%   restore path
%   dont restore known (i.e. next branch has to be
%                            consistent with this branch)
%   push cost,chances onto allCosts,allChances 
%   set cost, chance to 0,1
% done
% combine allCosts   using andCostCombine
% combine allChances using andChanceCombine
% return 1
% :FAIL return 0
doAnd(L,P) --> 
	o cost    ^ Cost    ^ 0,
	o chances ^ Chances ^ 1,
	doAnd1(L,P,Costs,Chancess),
        o andCost(Cost,Costs),
        o andChance(Chances,Chancess).

doAnd1([],_,[],[])    --> [].
doAnd1([H|T],P,[C|Cs],[Ch|Chs]) --> 
	{pop(P,[H|T],One,Next)}, 
        o path=Path0,
	do(One),  
        o path is Path0, 
	o cost^C^0,
	o chances^Ch^1,
	doAnd1(Next,P,Cs,Chs).

% ORS
%
% try as many as you can but prove at least 1
%
% allCosts= allChances=()
% push cost,chances onto allCosts,allChances 
% set cost and chances to 0, 1
% whatever=n
% for each branch from here (ordered L-to-R or randomly)
% do
%   save path
%   try to prove that branch
%   if fail then goto NEXT;
%   whatever=t
%   restore path
%   dont restore known (i.e. next branch has to be
%                            consistent with this branch)
%   push cost,chances onto allCosts,allChances 
%   set cost, chance to 0,1
%   :NEXT
% done
% if not whatever then goto FAIL;
% combine allCosts   using orsCostCombine
% combine allChances using orsChanceCombine
% return 1
% :FAIL return 0
doOrs(L,Pfind) --> 
	o cost    ^ Cost    ^ 0,
	o chances ^ Chances ^ 1,
	doOrs1(L,tense,Pfind,[],Costs,[],Chancess),
	o orsCost(Cost,Costs),
        o orsChance(Chances,Chancess).

doOrs1([],whatever,_,Cs,Cs,Ch,Ch)    --> [].
doOrs1([H|T],Mode, P,Cs0,Cs, Chs0, Chs) --> 
	{pop(P,[H|T],One,Next)},
        o path = Path, 
	(do(One)  
	-> o cost   ^C ^0,  
	   o chances^Ch^1,
           o path is Path,
           doOrs1(Next,whatever,P,[C|Cs0],Cs,[Ch|Chs0],Chs)
        ;  doOrs1(Next,Mode, P,Cs0,    Cs,Chs0,     Chs)).

% any
%
% you've got to prove 1 thing, then afterwards prove
% any subset (including nil) of what follows
%
% allCosts= allChances=()
% push cost,chances onto allCosts,allChances 
% set cost and chances to 0, 1
% whatever=f, 
% for each branch from here (ordered L-to-R or randomly)
% do
%   if   whatever and halfTheTime 
%   then goto NEXT 
%   fi
%   try  to prove that branch
%   if   fail 
%   then goto NEXT 
%   fi
%   whatever=t
%   restore path
%   dont restore known (i.e. next branch has to be
%                            consistent with this branch)
%   push cost,chances onto allCosts,allChances 
%   set cost, chance to 0,1
%   :NEXT
% done
% if not whatever then goto FAIL;
% combine allCosts   using orsCostCombine
% combine allChances using orsChanceCombine
% return 1
% :FAIL return 0
doAny(L,Pfind) --> 
	o cost    ^ Cost    ^ 0,
	o chances ^ Chances ^ 1,
	doAny1(L,tense,Pfind,[],Costs,[],Chancess),
	o orsCost(Cost,Costs),
        o orsChance(Chances,Chancess).

doAny1([],   whatever,_,Cs, Cs, Ch,    Ch) --> [].
doAny1([H|T],tense,   P,Cs0,Cs, Chs0, Chs) --> 
	{pop(P,[H|T],One,Next)},
        o path = Path, 
	(do(One)  
	-> o cost   ^C ^0,  
	   o chances^Ch^1,
           o path is Path,
           doAny1(Next,whatever,P,[C|Cs0],Cs,[Ch|Chs0],Chs)
        ;  doAny1(Next,tense,   P,Cs0,    Cs,Chs0,     Chs)).
doAny1([H|T],whatever,P,Cs0,Cs, Chs0, Chs) --> 
	{pop(P,[H|T],One,Next)},
        ({0 is random(2)}
        -> (o path = Path, 
	    (do(One)  
	    -> o cost   ^C ^0, 
	       o chances^Ch^1,
               o path is Path,
               doAny1(Next,whatever,P,[C|Cs0],Cs,[Ch|Chs0],Chs)
            ;  doAny1(Next,whatever,P,Cs0,    Cs, Chs0, Chs)))
         ;  doAny1(   Next,whatever,P,Cs0,    Cs, Chs0, Chs)).

doNot(X) -->
        {print(deMorganFailure),nl,fail},
	o chances ^ Chance0 ^ 1,
	o cost = Cost,
	do(X),
	o cost  is Cost,
        o chances = Chance1,
	o chances ism prob(Chance0 * (1 - Chance1)).

doYesNo(X,Mode) -->
	o chances = Ch0,
	o cost    = C0,
        do(X),
	o chances ^ Ch1 ^ Ch,
	o cost    ^ C1  ^ C,
        {doYesNo1(Mode,Ch0,Ch1,Ch),
         C is C1+C0}.

doYesNo1(no, _,Ch1,Ch) :- Ch is prob(1*(1-Ch1)).
doYesNo1(yes,_,Ch1,Ch) :- Ch is prob(1*Ch1).

% All
%
% find all the ways you can prove one thing, 
% then sum the chances and cost using the orsCombine
% rules
% 
% allCosts= allChances=()
% push cost,chances onto allCosts,allChances 
% set cost and chances to 0, 1
% someFound=n
% for all ways we can prove this  (ordered L-to-R or randomly)
% do
%   save path
%   try to prove that branch
%   if fail then goto NEXT;
%   someFound=y
%   restore path
%   dont restore known (i.e. next branch has to be
%                            consistent with this branch)
%   push cost,chances onto allCosts,allChances 
%   set cost, chance to 0,1
%   :NEXT
% done
% if not someFound then goto costs=0 and chances=1
% else
%     combine allCosts   using orsCostCombine
%     combine allChances using orsChanceCombine
% fi
% return 1
% :FAIL return 0
doAll(One,Pfind,ChancesNew,CostNew) --> 
	o cost    is 0,
	o chances is 1,
        {doHows(One,Hows)},
	doAll1(Hows,tense,Pfind,[],Costs,[],Chances),!,
	o orsCost(0,Costs),
        o cost = CostNew,
        o orsChancesCombine = C,
        {combine(C,Chances,ChancesNew)},
        o chances is ChancesNew.
doAll(_,_,0,0) --> 
	o cost    is 0,
	o chances is 0.

doAll1([],   whatever,_,Cs, Cs, Ch,   Ch ) --> [].
doAll1([H|T],Mode,P,Cs0,Cs, Chs0, Chs) --> 
	{pop(P,[H|T],C0/Ch0/How,Next)},
        o path = Path, 
	(do(How)  
	-> o path is Path,
           o cost    ^ C1  ^ 0, 
           o chances ^ Ch1 ^ 1, 
           C  is C0  + C1,
           Ch is prob(Ch0 * Ch1),
           doAll1(Next,whatever,P,[C|Cs0],Cs,[Ch|Chs0],Chs)
        ;  doAll1(Next,Mode,P,Cs0,       Cs,Chs0,         Chs)).

doHows(One,Hows) :-
	bagof(How,One^doHow1(One,How),Hows).

doHow1(X=Y,Cost/Chances/How) :- 
	clause(rule(X,?X=Y,Label,Cost0,Chances0,_,_),do(How,_,_)),
	computeRuleValues(Label,Cost0,Chances0,Cost,Chances).

computeRuleValues(Label,Cost0,Chances0,Cost,Chances) :-
	(number(Cost0)
        -> Cost is Cost0
        ;  Cost is Cost0,
           assert(computedRuleValue(Label,cost,Cost))),
	(number(Chances0)
        -> Chances is Chances0
        ;  Chances is Chances0,
           assert(computedRuleValue(Label,chances,Cost))).

getComputedRuleValues(cost,Label,X) :-
	 computedRuleValue(Label,cost,X),!.
getComputedRuleValues(chances,Label,X) :-
         computedRuleValue(Label,chances,X),!.
getComputedRuleValues(cost,Label,Cost) :-
	clause(rule(_,_,Label,Cost0,_,_,_),_),
	Cost is Cost0.
getComputedRuleValues(chances,Label,Chances) :-
	clause(rule(_,_,Label,_,Chances0,_,_),_),
	Chances is Chances0.


