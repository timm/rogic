
rall(max,AO,L)--> rall1(L,AO,All), {last(Last, All)}, o _/Last.
rall(mid,AO,L)--> rall1(L,AO,All), {middle(Mid,All)}, o _/Mid.
rall(min,AO,L)--> rall1(L,AO,All), {All=[First|_]  }, o _/First.

rall1(L,AO,Scores,W0,_) :-
	rall2(L,AO,[],Scores1,W0,_),
	keysort(Scores1,Scores2),
	maplist(arg(2),Scores2,Scores).

rall2(All,or,In,Out) -->
	o Wme0/Wme0,
	{copy_term(Wme0,Temp),
         rone(All,One,Rest)}, !,
	(do(One)
	->    o cost    = X,
	      o chances = Y,
	      o Wme1/Temp,
	      {copy_term(Wme1,Wme)},
              rall2(Rest,or,[[X,Y]-Wme|In],Out)
        ;     rall2(Rest,or,In,Out)).
rall2(All,and,_,Out) -->
	{rone(All,One,Rest)}, !,
	do(One),
	o cost    = X,
	o chances = Y,
	o Wme/Wme,
        rall2(Rest,and,[[X,Y]-Wme],Out).
rall2([],_,Out,Out) --> [].   
