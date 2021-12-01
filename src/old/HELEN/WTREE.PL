wt0(-).
wtAdd(Key=Value,wt(Key,Value,L,R)

% new: entry itnot new- just add
wtAt(-,X,wt(-,X,1,-,1)).

% old: ok balance. increment counts, do nothing
wtAt(wt(L,X1,Xn,R,,N0), X2, Out) :- 
      compare(Op,X1,X2),
      N is N0 +1,
      wtAt1(Op,wt(L,X1,Xn,R,N),X,Out).

wtAt1(=,wt(L, X,Xn0,R, N),wt(L,X,Xn,R,N)) :- Xn is Xn0+1.
wtAt1(<,wt(L0,X,Xn, R, N),wt(L,X,Xn,R,N)) :- wtAt(L0,X,L).
wtAt1(>,wt(L, X,Xn, R0,N),wt(L,X,Xn,R,N)) :- wtAt(R0,X,R).

% old: unbalanced- split unbalanced bit


wtAt(wt(0,X,0,,X,X/1).
wtAt(X/N0,X,X/N) :-  N is N0+1.
