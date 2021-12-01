% wme stuff for ht6 
def(wme,o,[succinct  is y
          ,debug     is 1
          ,tries1    is 1
          ,tries2    is 1
          ,cooked    is n

          ,goals     is []
          ,maxProved is 0
          ,done      is []
          ,todo      is []        
          ,best      is []
          ,inputs    is []

	  ,maxCost   is 10
          ,orsCostCombine    is max
          ,orsChancesCombine is sum
	  
          ,andCostCombine    is sum
          ,andChanceCombine  is product
          
          ,cost      is 0
          ,chances   is 1
          ,known     is [true=v(t,0,1)] 
          ,path      is []
          ]).

o andCost(X,L) --> 
	o andCostCombine = C, 
	{combine(C,L,Y)}, 
	o cost ism X+Y.
o andChance(X,L) --> 
	o andChanceCombine = C, 
	{combine(C,L,Y)}, 
	o chances ism X*Y.
o orsCost(X,L)   --> 
	o orsCostCombine   = C, 
	{combine(C,L,Y)},
	o cost ism X+Y.
o orsChance(X,L) --> 
	o orsChancesCombine = C, 
	{combine(C,L,Y)},
	o chances ism prob(X*Y).
o newPath  --> o reset(path).
o init  -->
	 o resetBeliefs,
	 o goals = G,
	 o done is [],
	 o todo is G,
	 {rone([sum,max],OrsCost)}, 
         o orsCostCombine is  OrsCost.
o maybeResetSeed --> 
	o cooked = y, !, 
	o shoutln(resetingSeed),
	{reset_seed}.
o maybeResetSeed --> [].
o resetBeliefs -->
	o inputs=F0,
	{sort(F0,F),
         maplist(vs,F,F1)},
	 o known  is F1.

o seeJaneRun -->
	o succinct=n,!,
        {get_time(X),convert_time(X,Y),
	 format('\nJANE (v0.1) and CHEETAH (v0.1):',[]),

         globalVar(domain,Domain),
         L=[slogan='Cheetah chase Jane. Run Jane, run!'
           ,'copyright'= '(c) 2001 Tim Menzies (tim@menzies.com)' 
           ,'copy policy'='GPL-2 (see http://www.gnu.org)'
           ,date=Y
           ,domain=Domain
           ],
         forall(member(A=B,L),
                format('\n~5<~17. ~w',[' ',A,B])),nl}.
o seeJaneRun --> [].

o findings -->

	o succinct=n,!,

        o goals=G,
        {maplist(arg(1),G,Goals)},
        o known=Known,
        {format('\n\nFINDINGS:',[])},
	{forall((member(One=Blah,Known),member(One,Goals)),
                (v(value,Value,Blah),
                 v(cost,Cost0,Blah),
		 sformat(Cost,'~3f',[Cost0]),
                 v(chances,Chances0,Blah),
		 sformat(Chances,'~3f',[Chances0]),
                 format('\n~17>=~2P @~6P and $~6P ',
                        [One,Value,Chances,Cost])))}.
o findings --> [].

o reasons -->
	o succinct=n,!,

 %       o path=P,
  %      o known=K,
        {format('\n\nREASONS:',[])},
	o best=Best0,

%  {print(known(K)),nl,
%print(path(P)),nl,
%print(best(Best0)),nl},

	{sort(Best0,Best)},
{forall((member(One=Blah,Best)),
                (v(value,Value,Blah),
                 v(cost,Cost0,Blah),
		 sformat(Cost,'~3f',[Cost0]),
                 v(chances,Chances0,Blah),
		 sformat(Chances,'~3f',[Chances0]),
                 format('\n~17P=~2P @~6P and $~6P',
                       [One,Value,Chances,Cost])))}.

        %{forall(member(B=V,Best)
         %      ,(nl,v(print,B,V)))}.
o reasons --> [].

o policies --> 
         o succinct=n,!,
         {format('\n\nPOLICIES:',[])},
         o W//W ,
         {forall(member(Field, [orsCostCombine
                               ,orsChancesCombine
                               ,andCostCombine
                               ,andChanceCombine]),
                 (o(Field=Value,W,_),
                  format('\n~20P : ~w',[Field,Value])))}.
o policies --> [].

o proved(P) -->
	o goals=G,
	o best=B,
	{intersection(B,G,P)}.
o maxxed -->
	o todo = [].
o spy(X=Y) --> 
	o debug=3, !, 
	o path=P,
	{numbervars((X=Y,P),0,_),
	forall(member(_,P),  write('.. ')), 
	print(?X=Y),nl}.
o spy(_) --> [].
o end(X) --> o debug=3,!,{print(X),nl,nl}.
o end(_) --> [].
o say(X) --> o debug=2,!,{write(X),nl}.
o say(_) --> [].
o shoutln(X) --> o debug=1,!,{write(X),nl}.
o shoutln(_) --> [].
o shout(X) --> o debug=1,!,{write(X)}.
o shout(_) --> [].
o nl     --> o debug=2,!,{nl}.
o nl     --> [].
o report --> o debug = 0,!.
o report -->
        o succinct=n,!,
	o done=D, 
%	o todo=T,	
	{length(D,L1)}, 
	o goals=G, 
	{length(G,L2), 
	X is round((L1*100)/L2), 
	format('~4P% ~5S\n',[X,X])}.
o report -->  [].


combine(min,    L,X) :- !,min(L,X).
combine(max,    L,X) :- !,max(L,X).
combine(average,L,X) :- !,average(L,X).
combine(sum,    L,X) :- !,sum(L,X).
combine(product,L,X) :- !,prod(L,X).
combine(X,_,_) :- yuck(combinationRule(X)).

vs(X=Y,X=V) :-
  v(value,Y,V),
  v(cost,0,V),
  v(chances,1,V).
	
