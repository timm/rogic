%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% do any global set up required to
% use the wme
wmeSetUp.
 
% empty all contents of Wmes
wmeReset(Wmes,Wmes).
 
%return a fresh wme
wmeInit(_) :- wmeReset(_,_).
 

wmeA(X,Y,Z):-avl_insert(X,Y,Z).
wmeR(X,Y,Z):-avl_delete(X,Y,Z).
wmeF(X,Y,Y):-avl_find(X,Y).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

avl_insert(Pairs,W0,W):-
	%avl_is(W0),
	avl_inserts(Pairs,W0,W),avl_is(W).
avl_delete(Pairs,W0,W):-
	%avl_is(W0),
	avl_deletes(Pairs,W0,W),avl_is(W).

avl_find(Pairs,W0):-
	%avl_is(W0),
	avl_look(Pairs,W0).

avl_inserts([],T,T).
avl_inserts([Key-Value|Rest],T0,T):-
	add_elem_avl(Key-Value,T0,T1),
	avl_inserts(Rest,T1,T).

avl_deletes([],T,T).
avl_deletes([Key-Value|Rest],T0,T):-
	del_elem_avl(Key-Value,T0,T1),
	avl_deletes(Rest,T1,T).

avl_look([],_T).
avl_look([Key-Value|Rest],T0):-
	elem_in_avl(Key-Value,T0),
	avl_look(Rest,T0).

%is_valid(_).
is_valid(X) :- avl_is(X).

avl_is(-) :- !, fail.
avl_is(nil/0).
avl_is(t(A/B,C,D/E)/F):-
        not var(C),
        number(B), B >= 0,
        number(E), E >= 0,
        number(F), F >= 0,
	F is max(B,E) + 1,
	Diff is abs(B - E),
	Diff =< 1,
        avl_is(A/B),
        avl_is(D/E).

% add_elem_avl( +X, +T1, -T2) :-
%
%	the avltree T2 contains X
%	and all the elements of the avltree t1.


add_elem_avl( X, T1, T2) :-
	add_elem_avl2( T1, X, T2).


add_elem_avl2( nil/0, X, t(nil/0,X,nil/0)/1).

add_elem_avl2( t(L,Y,R)/H, X, T2) :-
	compare( Op, X, Y),
	add_elem_avl3( Op, X, L, Y, R, H, T2).


add_elem_avl3( <, X, L, Y, R, _, T2) :-
	add_elem_avl( X, L, t(L1,Z,L2)/_),
	combine( L1, Z, L2, Y, R, T2).

add_elem_avl3( =, X, L, X, R, H, t(L,X,R)/H).

add_elem_avl3( >, X, L, Y, R, _, T2) :-
	add_elem_avl( X, R, t(R1,Z,R2)/_),
	combine( L, Y, R1, Z, R2, T2).
/*
balance( Hl, H, Hr) :-
	(	var( Hr)	->	sum( Hl, 1, H),
					sum( Hr, 1, H)
				|	sum( Hr, 1, H),
					sum( Hl, 1, H)
	).

balance( Hl, H, Hr) :-
	(	var( Hr)	->	sum( Hl, 1, H),
					sum( Hr, 2, H)
				|	sum( Hr, 2, H),
					sum( Hl, 1, H)
	).

balance( Hl, H, Hr) :-
	(	var( Hr)	->	sum( Hl, 2, H),
					sum( Hr, 1, H)
				|	sum( Hr, 1, H),
					sum( Hl, 2, H)
	).


balanced( Hl, H, Hr) :-
	(	var( Hr)	->	sum( Hl, 1, H),
					sum( Hr, 1, H)
				|	sum( Hr, 1, H),
					sum( Hl, 1, H)
	).

balanced( Hl, H, Hr) :-
	(	var( Hr)	->	sum( Hl, 1, H),
					sum( Hr, 2, H)
				|	sum( Hr, 2, H),
					sum( Hl, 1, H)
	).

balanced( Hl, H, Hr) :-
	(	var( Hr)	->	sum( Hl, 2, H),
					sum( Hr, 1, H)
				|	sum( Hr, 1, H),
					sum( Hl, 2, H)
	).

*/
% combine( T1, Item1, T2, Item2, T3, +CombinedAvlTree) :-
%
%	the three avltree fragments T1, T2 and T3,
%	along with the intervening data items Item1 and Item2,
%	are combined into a balanced CombinedAvlTree.
%
%	This is not a general-purpose routine, but has subtle preconditions
%	involving the heights of T1, T2 and T3.


combine( T1/H1, A, t(T21,B,T22)/H2, C, T3/H3, t(t(T1/H1,A,T21)/Ha,B,t(T22,C,T3/H3)/Hc)/Hb) :-
	H2 > H1,
	H2 > H3,
	!,
	Ha is H1 + 1,
	Hc is H3 + 1,
	Hb is Ha + 1.

combine( T1/H1, A, T2/H2, C, T3/H3, t(T1/H1,A,t(T2/H2,C,T3/H3)/Hc)/Ha) :-
	H1 >= H2,
	H1 >= H3,
	!,
	max1( H2, H3, Hc),
	max1( H1, Hc, Ha).

combine( T1/H1, A, T2/H2, C, T3/H3, t(t(T1/H1,A,T2/H2)/Ha,C,T3/H3)/Hc) :-
	H3 >= H2,
	H3 >= H1,
	!,
	max1( H1, H2, Ha),
	max1( Ha, H3, Hc).


% combine2( T1, H1, A, T2, H2, B, T3, H3, Tl, Hl, X, Tr, Hr) :-
%
%	this one minimises structure turnover (I hope).


combine2( T1, H1, A, T2, H2, B, T3, H3, Tl, Hl, X, Tr, Hr) :-
	(	H2 > H1,
		H2 > H3		->	T2 = t(T21,X,T22),
					Tl = t(T1/H1,A,T21),
					Hl is H1+1,
					Tr = t(T22,B,T3/H3),
					Hr is H3+1
	|(	H1 >= H2,
		H1 >= H3	->	Tl = T1,
					Hl = H1,
					Tr = t(T2/H2,B,T3/H3),
					max1( H2, H3, Hr),
					X = A)
	|(	H3 >= H2,
		H3 >= H1	->	Tl = t(T1/H1,A,T2/H2),
					max1( H1, H2, Hl),
					Tr = T3,
					Hr is H3,
					X = B)
	).

% del_elem_tree( +Element, +Set1, ?Set2)
% is true when Set1 and Set2 are both sets represented by ordered
% AVL trees. Set2 = Set1 - {Elem}. (This implies that if Set1
% does not contain Element then Set1 and Set2 will be equal). It 
% may only be used to calculate Set2 given Elem and Set1. If Set1
% is not a set and has duplicates it will only remove the 
% first occurrence.

del_elem_avl(X, Tree, Newtree) :- del_elem_avl( X, Tree, Newtree, _).
del_elem_avl( _,nil/0,nil/0, 0).
del_elem_avl( X, t(nil/0, X, R)/_, R, -1):- !.
del_elem_avl( X, t(L, X, nil/0)/_, L, -1):- !.
del_elem_avl( X, t(L, X, R)/H, Newtree, Shrink) :-
       del_min_avl( Y, R, R1, Rightshrink),
       rebalance_right( Rightshrink, Shrink, H, Y, L, R1, Newtree).
del_elem_avl( X, t(L, Root, R)/H, Newtree, Shrink) :-
      X @< Root, 
      del_elem_avl( X, L, L1, Leftshrink),
      rebalance_left( Leftshrink, Shrink, H, Root, R, L1, Newtree), !.
del_elem_avl( X, t(L, Root, R)/H, Newtree, Shrink):-
      del_elem_avl( X, R, R1, Rightshrink),
      rebalance_right( Rightshrink, Shrink, H, Root, L, R1, Newtree).


del_min_avl( Y, t(nil/0, Y, R)/_, R, -1).
del_min_avl( Y, t(L,Root,R)/H, Newtree, Shrink) :-
       del_min_avl( Y, L, L1, Leftshrink),
       rebalance_left( Leftshrink, Shrink, H, Root, R, L1, Newtree).


% elem_in_avl( ?Elem, +Tree)
% is true when Tree is an ordered AVL tree and Elem occurs in it
% It may be used to test for an element in Tree if Elem is a nonvar term,
% or it may be used to enumerate all elements of Tree by backtracking if
% Elem is an uninstantiated variable.

elem_in_avl( X, Tree) :-
    nonvar( X), !, 
    in_avl( X, Tree);
    gen_elem_in_avl( X, Tree).

gen_elem_in_avl( X, t(Left, _, _)/_) :-
     gen_elem_in_avl( X, Left).
gen_elem_in_avl( X, t(_, X, _)/_).
gen_elem_in_avl( X, t(_, _, Right)/_) :-
     gen_elem_in_avl( X, Right).

in_avl( X, t(_,X,_)/_):- !.
in_avl( X, t(Left, Root, Right)/_) :-
     X @> Root, !,
     in_avl( X, Right);
     in_avl( X, Left).

max1( U, V, M) :-
	(	U > V
	->	M is U+1
	|	M is V+1
	).

rebalance_left( _, Shrink, H, Val, nil/0, nil/0, t(nil/0,Val,nil/0)/1):-
       Shrink is 1 - H, !.
rebalance_left( _, Shrink, H, Val, nil/0, L/H2, t(nil/0,Val,L/H2)/NH) :-
       NH is H2 + 1,
       Shrink is NH - H, !.
rebalance_left( Leftshrink, Shrink, H, Val, t(RL,RX,RR)/H1,
                   L1/H2, Newtree/NH) :-
        (Leftshrink = -1, 2 is H1 - H2, !,
        combine( L1/H2, Val, RL, RX, RR, Newtree/NH);
        max1( H2, H1, NH),
        Newtree = t(L1/H2, Val, t(RL,RX,RR)/H1)),
        Shrink is NH - H.


rebalance_right( _, Shrink, H, Val, nil/0, nil/0, t(nil/0,Val,nil/0)/1):-
       Shrink is 1 - H , !.
rebalance_right( _, Shrink, H, Val, nil/0, R/H2,t(nil/0,Val,R/H2)/NH) :-
       NH is H2 + 1,
       Shrink is NH - H, !.

rebalance_right( Rightshrink, Shrink, H, Val, t(LL,LX,LR)/H1,
                   R1/H2, Newtree/NH) :-
       (Rightshrink = -1, 2 is H1 - H2, !,
       combine( LL,LX,LR, Val, R1/H2,Newtree/NH);
       max1( H2, H1, NH),
       Newtree = t( t(LL,LX,LR)/H1, Val, R1/H2)),
       Shrink is NH - H.

