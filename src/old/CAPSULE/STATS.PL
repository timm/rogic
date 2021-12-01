db(stats(n,least,most,sum,sumSquared)).

% quirk: can't use min,max: crashed the maths.

statsDemo :-
	isa(stats,X0),
	statsDemo1(X0,X),
	show(X),
	print(X).

statsDemo1 -->
	inits,
	adds([2,6,1,7,9,3,8,43,2,3,6,3,56,8,54,12,23,41,30,32,28,32,44]).

stats-show :-
	=average(A),
	=sd(SD),
	=error(E),
	format('~a:~4f ~a:~4f (~a:~4f .. ~a:~4f)~n~a:~4f: ~a:~4f',
               [n,      ?n,
	       average, A,
	       least,   ?least,
	       most,    ?most,
	       sd,      SD,
	       error,   E
               ]).

stats=inits :-
	!most is -1 * 2^32,
        !least is 2^32,
	!n is 0,
	!sum is 0,
	!sumSquared is 0.
stats=adds([]).
stats=adds([H|T]) :- 
	=add(H),
	=adds(T).
stats=add(X) :-
	!n is ?n + 1,
        !sum is ?sum + X,
	!most  is max(X,?most),
	!least is min(X,?least),
	!sumSquared is ?sumSquared + (X*X).
stats-average(X) :- 
	X is ?sum/?n.
stats-variance(X) :- 
	(1 is ?n
         ->X =0;
         X is ((?n*?sumSquared)-(?sum**2))/(?n*(?n-1))).
stats-sd(X):-
	1 is ?n->X is 0;-variance(V), X is sqrt(V).
stats-error(X) :-
	1 is ?n->X is 0;-sd(S), X is S/sqrt(?n-1).




