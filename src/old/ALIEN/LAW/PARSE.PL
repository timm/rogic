:- load_files([ops],[silent(true)]).

parse(X            ,_,fail(var(X))) :- var(X),!.
parse((X then Y)   ,T,(Z1@T=W :-   {From,Id,Cost},X1)) :- !,
				   Cost=1,
	                           myFlag(id,Id),
				   myFlag(from,From),
	                           memberA(Z,Y), 
                                   parse(X,T,X1), parse(Z,T,Z1@T=W),
				   T=t(1).
			           
parse((X and Y)    ,T,(X1,Y1))    :- !,parse(X,T,X1), parse(Y,T,Y1).
parse((X or Y)     ,T,X1)         :- !,(parse(X,T,X1); parse(Y,T,X1)).
parse((X and Y)    ,T,(X1,Y1))    :- !,parse(X,T,X1), parse(Y,T,Y1).
parse(not (X and Y),T,Out )       :- !,parse(not X or not Y,T,Out).
parse(not (X or Y) ,T,Out )       :- !,parse(not X and not Y,T,Out).
parse(not X        ,T,Out )       :- !,negate(X,Y),parse(Y,T,Out).
parse(X>=Y         ,T,X@T >= Y)   :- numericP(X),number(Y),!.
parse(X>Y          ,T,X@T  > Y)   :- numericP(X),number(Y),!.
parse(X is Y       ,T,X@T is Y)   :- numericP(X),number(Y),!.
parse(X = Y        ,T,X@T  = Y)   :- rangeP(X,Y),!.
parse(X<Y          ,T,X@T  < Y)   :- numericP(X),number(Y),!.
parse(X=<Y         ,T,X@T =< Y)   :- numericP(X),number(Y),!.
parse(X            ,T,X@T  = t)   :- rangeP(X,t),!.
parse(X            ,_,_) :- write('% '),print(fail(unknown(X))),nl,fail.


negate(X=_,    -(unknown(X))) :- \+ rangeP(X,_), !.
negate(X      ,X =f) :- rangeP(X,f),!.
negate(X=Y    ,X =Z) :- rangeP(X,Z), \+ Y=Z.
negate(X>=Y   ,X <Y).
negate(X>Y    ,X=<Y).
negate(X is Y ,X <Y or 
               X >Y).
negate(X<Y    ,X>=Y).
negate(X=<Y   ,X >Y).
