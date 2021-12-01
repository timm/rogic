demo0 :-
     Dist=round(ranf(10,40,0.75)),
    inserts(40*Dist,T0),
    printt(T0).

demo1 :-
    Dist=round(ranf(10,40,0.75)),
    inserts(40*Dist,T0),
    prune(4,T0,T),
    inserts(20*Dist,T,T1),
    printt(T0),
    nl,nl,printt(T),
    nl,nl,printt(T1).


demo2 :-
    Dist=round(ranf(0,100,0.5)),
    inserts(1000*Dist,T0),
    prune(4,T0,T),
    printt(T),nl,
    collectt(T,C),
    print(C),nl.

:- current_prolog_flag(max_integer,X), X1 is X - 1, 
   retractall(inf(_)), assert(inf(X1)).

:- arithmetic_function(inf/0).

box_muller(M,S,N) :-
     w(W0,X),
     W is sqrt((-2.0 * log(W0))/W0),
     Y1 is X * W,
     N is M + Y1*S.

w(W,X) :-
     X1 is 2.0 * ranf - 1,
     X2 is 2.0 * ranf - 1,
     W0 is X1*X1 + X2*X2,
     (W0  >= 1.0 -> w(W,X) ; W0=W, X = X1).

ranf(Min,Max,B,X) :-
    beta(B,Y),
    X is Min + (Max-Min)*Y.
    
beta(B,X) :- beta1(B,X),!.
beta(B,X) :- B1 is 1 - B, beta1(B1,Y),X is 1 - Y.

beta1(0.50,X) :- X is ranf.
beta1(0.60,X) :- X is ranf^0.67.
beta1(0.67,X) :- X is ranf^0.5.
beta1(0.75,X) :- X is ranf^0.33.
beta1(0.80,X) :- X is ranf^0.25.
beta1(0.9,X)  :- X is ranf^(1/9).
beta1(1,1).

:- arithmetic_function(ranf/0).
:- arithmetic_function(ranf/3).
:- arithmetic_function(normal/2).

ranf(X) :-    X is random(inf+1)/inf.
normal(M,S,X) :- box_muller(M,S,X).
	
inserts(L,T) :-
	inserts(L,_,T).

inserts([],T,T).
inserts([Key=Value|T]) --> !,insert(e(Key,Value)), inserts(T).
inserts(0*_) --> !.
inserts(N0*Y) --> !,
	{N is N0 - 1, 
	 X is Y},
	insert(X),
	inserts(N*Y).
inserts(=(0)) --> !.
inserts(=(N0)) --> !,
	{N is N0 - 1, 
	 X is N0},
	insert(X),
	inserts(=(N)). 
inserts([H|T]) --> !,insert(H), inserts(T).
	
collectt(X,L)   :- bagof(One,X^collectt1(X,One),L).

collectt1(n(X,null,        null),X) :- !.
collectt1(n(X,null,    n(_,_,_)),X).
collectt1(n(_,null,    n(X,L,R)),Y) :- !, collectt1(n(X,L,R),Y).
collectt1(n(X,n(_,_,_),    null),X).
collectt1(n(_,n(X,L,R),    null),Y) :- !, collectt1(n(X,L,R),Y).
collectt1(n(X,n(_,_,_),n(_,_,_)),X).
collectt1(n(_,n(X,L,R),n(_,_,_)),Y) :- collectt1(n(X,L,R),Y).
collectt1(n(_,n(_,_,_),n(X,L,R)),Y) :- collectt1(n(X,L,R),Y).

printt(X) :- \+ \+ printt(X,'',0).
printt(X,_,_) :- var(X),!.
printt(e(X,_),_,_) :- var(X),!.
printt(n(X,L,R),B4,In) :-
	tab(In), write(B4), print(X), nl,
	printt(L,'<',In+2),
	printt(R,'>',In+2).
	
prune(_,X,_) :- var(X), !.
prune(0,n(X,_,_),n(X,_,_)) :- !.
prune(N0,n(X,L0,R0),n(X,L,R)) :-
    N is N0 - 1,
    prune(N,L0,L),
    prune(N,R0,R).

access(V, Item, Tree, NewTree):-
    bst(access(V), Item, Tree, NewTree).

insert(Item, Tree, NewTree):-
    bst(insert, Item, Tree, NewTree).

del(Item, Tree, NewTree):-
    bst(access(true), Item, Tree, n(Item, Left,Right)),
    join(Left, Right, NewTree).

join(Left, Right, New):-
    join(L-L, Left, Right, New).

split(Item, Tree, Left, Right):-
    bst(access(true),Item, Tree, n(Item, Left, Right)).

less(e(X,_), e(Y, _)):- !, X < Y.
less(X, Y):-   X < Y.

bst(Op, Item, Tree, NewTree):-
    bst(Op, 1/2,Item, L-L, Tree, R-R, NewTree).

bst(access(null),  _,_Item, _L, null, _R, _Tree):- !.
bst(access(true),  _,Item, Left-A, n(Item, A, B), Right-B, n(Item, Left, Right)).
bst(insert,Max/Max,Item, Left-A,    n(_,A,B),  Right-B, n(Item,Left,Right)) :- !.
bst(insert,_,Item, Left-A, n(Item, A, B), Right-B, n(Item, Left, Right)).

% Zig:
bst(access(null), _,Item, Left-_L, n(X, null, B), Right-B, n(X, Left, Right)):-
    less(Item, X), !.
bst(Op, N0/Max,Item, Left, n(X, n(Item, A1, A2), B), R-n(X, NR,B), New):-
    less(Item, X), !,
    N is N0 + 1,
    bst(Op, N/Max,Item, Left, n(Item, A1, A2), R-NR, New).

% Zig-Zig:
bst(Op, N0/Max,Item, Left, n(X, n(Y, Z, B), C), R-n(Y, NR, n(X, B, C)), New):-
    less(Item, X), less(Item, Y), !,
    N is N0 + 1,
    bst(Op, N/Max,Item, Left, Z, R-NR, New).

% Zig-Zag:
bst(Op, N0/Max,Item, L-n(Y, A, NL), n(X, n(Y, A, Z), C), R-n(X, NR, C), New):-
    less(Item, X), less(Y,Item),!,
    N is N0 + 1,
    bst(Op,N/Max,Item, L-NL, Z, R-NR, New).

% Zag:
bst(access(null), _,Item, Left-B, n(X, B, null), Right- _R, n(X, Left, Right)):-
    less(X, Item), !.  % end of the road.
bst(Op, N0/Max,Item, L-n(X, B, NL), n(X, B, n(Item, A1, A2)), Right, New):-
    less(X, Item), !,
    N is N0 + 1,
    bst(Op, N/Max,Item, L-NL, n(Item, A1, A2), Right, New).

% Zag-Zag:
bst(Op, N0/Max,Item, L-n(Y, n(X, C, B), NL), n(X, C, n(Y, B, Z)), Right, New):-
    less(X, Item), less(Y,Item),!,
    N is N0 + 1,
    bst(Op, N/Max, Item, L-NL, Z, Right, New).

% Zag-Zig:
bst(Op, N0/Max, Item, L-n(X, A, NL), n(X, A, n(Y, Z, C)), R-n(Y, NR, C), New):-
    less(X, Item), less(Item, Y),!,
    N is N0 + 1,
    bst(Op, N/Max,Item, L-NL, Z, R-NR, New).

join(Left-A, n(X, A, var), Right, n(X, Left, Right)):-!.
join(Left-n(X, A, B), n(X, A, n(Y, B, var)), Right, n(Y, Left, Right)):- !.
join(Left-n(Y, n(X, C, B), NL), n(X, C, n(Y, B, n(Z, A1, A2))), Right, New):-
    join(Left-NL, n(Z, A1, A2), Right, New).

/*
http://www.onthenet.com.au/~grahamis/int2008/week10/lect10.html

% 
      Splay tree at node r
        p parent of r
        g grandparent of r
while (p not NULL)
   /* while p is not the root */
   if (g is NULL) 
      /* r is a child of the root node */
      if (r left of p) zig 
      else zag
   else if (g not NULL) 
      /* r has parent and grandparent */
      if (r left of p and p left of g)
         zig-zig 
      else if (r right of p and p right of g)
         zag-zag
      else if (r right of p and p left of g)
         zig-zag
      else
         zag-zig



typedef struct splay_node {   
   Item Value;
   struct splay_node *Left;
   struct splay_node *Right;
   struct splay_node *Parent;
} SplayNode


*/


