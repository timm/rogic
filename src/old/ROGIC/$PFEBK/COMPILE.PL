/*term_expansion((X <- Y) ,All) :-
	findall(One,xpand((X <- Y),One),All). 

xpand((X <- Y),(kb1(X,V,T,Rin) :- Tail)) :-
	xpand(Y,V,_,T,_,Rin,Tail).
xpand((X0 or Y0), V0,V,T0,T,R0,R,(X ror Y)) :- !,
	xpand(X0,V0,V,T0,T,R0,R,X),
	xpand(Y0,V0,V,T0,T,R0,R,Y).
xpand(-X, V0,V,T,T,R0,R,(fx(-,V0,V),kb1(Goal,About))) :- !,

xpand(X , V0,V,T,T,R0,R,(fx(+,V0,V),kb1(X,V,T,R0,R))).
*/

*rx     = [     [],   [dex],  [coldSwim],  [dex,coldSwim]].
*nna    = [  0.122,  0.105,       0.210,       0.246].
*cortico= [129,     11.3,      1232.0,        32.8].
*acth   = [ 89,      0.0,       240.0,         0.0].

kb1(dex=up,Out,Out).

kb1(nna=V0,In,Out) :-
	ror([Out1=In1+(
		fx(+,V0,V1),
		kb(coldSwim=V1,In1,Out1)
	     	)
	    ,Out2=In2+(
		fx(-,V0,V2),
		kb(temp=V2,In2,Out2)
		)
	    ],In,Out).

kb1(cortico=V0,In,Out) :-	
	ror([Out1=In1+(
		fx(+,V0,V1),
		kb(acth=V1,In1,Out1)
		)
	    ],In,Out).

kb1(temp=V0,In,Out) :-
	ror([Out1=In1+(
		fx(+,V0,V1),
		kb(cortico=V1,In1,Out1)
		)
             ,Out2=In2+(
		fx(+,V0,V2),
		kb(dex=V2,In2,Out2)
		)
	     ],In,Out).

kb1(acth=V0,In,Out) :-
	ror([Out1=In1+(
		fx(-,V0,V1),
		kb(temp=V1,In1,Out1)
		)
	    ,Out2=In2+(
		fx(+,V0,V2),
		kb(nna=V2,In2,Out2)
		)
	    ],In,Out).
 	
