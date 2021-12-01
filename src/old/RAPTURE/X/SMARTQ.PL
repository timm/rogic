
:- module(pq,[smartq/1,smartq/2,smartq/3]).

smartq(new, 
          sq(0,   % size
	  1.5, % rebalance thresehold
          0,   % total queries
          0,   % max depth of queries
          Q    % a heap of difference lists
          )) :- q(Q).

resortNow(sq(Size,T,Queries,Depth,_)) :-
	Depth/Queries/(ln(Size)*T) > 1.

resport(sq(Size,T,_,_,Q0),sq(Size,T,0,0,Q)) :-
	q2l(Q0,L),

