%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% do any global set up required to
% use the wme
wmeSetUp.
 
% empty all contents of Wmes
wmeReset(Wmes,Wmes).
 
%return a fresh wme
wmeInit(_) :- wmeReset(_,_).
 
wmesAssert(Key,Value, Wmes0,Wmes) :-add_elem_avl(Key-Value, Wmes0, Wmes).
wmesRetract(Key,Value,Wmes0,Wmes) :-del_elem_avl(Key-Value, Wmes0, Wmes).
wmesFind(Key,Value,Wmes0,_Wmes)    :-elem_in_avl(Key-Value, Wmes0).

wmeA(X,Y,Z):-avl_insert(X,Y,Z).
wmeR(X,Y,Z):-avl_delete(X,Y,Z).
wmeF(X,Y,Y):-avl_find(X,Y).

wmesAssert(Key,Value, W0,W) :-avl_insert([Key-Value],W0,W).
wmesRetract(Key,Value,W0,W) :-avl_delete([Key-Value],W0,W).
wmesFind(Key,Value,W0,_W)    :-avl_find([Key-Value],W0). 
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

add( N, [Head|Templist1], Templist, Tree, Tree1) :-
	(	N == 1
	->	add_elem_avl( Head, Tree, Tree1),
		Templist = Templist1
	|	N1 is N - 1,
		add_elem_avl( Head, Tree, Tree2),
		add( N1, Templist1, Templist, Tree2, Tree1)
	).


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


addone( t(T1,T2,T3,T4), t(A1,T2,T3,T4)) :-
	A1 is T1+1.

addone( t(T1,T2,T3,T4), t(T1,A2,T3,T4)) :-
	A2 is T2+1.

addone( t(T1,T2,T3,T4), t(T1,T2,A3,T4)) :-
	A3 is T3+1.

addone( t(T1,T2,T3,T4), t(T1,T2,T3,A4)) :-
	A4 is T4+1.


% avl2map_height( M, H) :-
%
%	the avl2map M has height H.


avl2map_height( nil, 0).

avl2map_height( t(_,_,_,_,H), H).


% AVL_disjoint( +Set1, +Set2)
% is true when given the sets, Set1 and Set2, represented by ordered
% AVL trees they have no element in common. ( The intersection of the 
% two sets is the null set).

avl_disjoint( Tree1, Tree2) :-
       avl_disjoint1( [Tree1], [Tree2]).


avl_disjoint1( _, [nil/0]):- !.
avl_disjoint1( [nil/0], _):- !.
avl_disjoint1( Tree1, Tree2) :- 
       move_avl( Tree1, X, Rest1),
       move_avl( Tree2, Y, Rest2),
       compare( Order, X, Y), !,
       avl_disjoint1(Order, X, Y, Rest1, Rest2).

avl_disjoint1( < , _, Y, Rest1, Rest2) :-
       avl_disjoint1(Rest1, [n(Y)|Rest2]).
avl_disjoint1( >, X, _, Rest1, Rest2) :-
       avl_disjoint1([n(X)| Rest1], Rest2).


% avl_intersect( +Set1, +Set2)
% is true when given the sets, Set1 and Set2, represented by ordered AVL
% trees have at least one element in common. 

avl_intersect( Tree1, Tree2) :-
     avl_intersect1( [Tree1], [Tree2]).


avl_intersect1( Tree1, Tree2):-
     move_avl( Tree1, X, Rest1),!,
     move_avl( Tree2, Y, Rest2),
     compare( Order, X, Y),!,
     avl_intersect1(Order, X,Y, Rest1, Rest2).

avl_intersect1( =,_,_,_,_):- !.
avl_intersect1(<,_,Y,Rest1,Rest2) :-
     avl_intersect1(Rest1, [n(Y)|Rest2]).
avl_intersect1(>,X,_, Rest1, Rest2) :-
     avl_intersect1([n(X)|Rest1], Rest2).


% avl_intersection( +Set1, +Set2, ?Intersection)
% is true when given the sets, Set1 and Set2, represented by ordered
% AVL trees Intersection is the ordered AVL tree representation
% of their intersection.

avl_intersection( Tree1, Tree2, Intersection) :-
     avl_intersection1( [Tree1], [Tree2], Inter),
     list_to_avl( Inter, Intersection).


avl_intersection1( _, [nil/0], []) :- !.
avl_intersection1( [nil/0], _, []) :- !.
avl_intersection1( Tree1, Tree2, Inter) :-
     move_avl( Tree1, X, Rest1), !,
     move_avl( Tree2, Y, Rest2),
     compare( Order, X, Y), !,
     avl_intersection1( Order, X,Y, Rest1, Rest2, Inter).

avl_intersection1(=, X,_, Rest1, Rest2, [X | Inter]) :-
     avl_intersection1( Rest1, Rest2, Inter).
avl_intersection1(<, _, Y, Rest1, Rest2, Inter):-
     avl_intersection1( Rest1, [n(Y)|Rest2], Inter).
avl_intersection1(>, X,_, Rest1, Rest2, Inter):-
     avl_intersection1([n(X)| Rest1],Rest2, Inter).


% avl_ordset( +Set)
% is true when Set is an AVL tree ordered from left to right
% such that all value nodes in the left subtree are stictly less
% than the root value node, and that all value nodes in the right
% subtree are strictly greater than the root value node and that both 
% subtrees are also ordered in this way. Anything that satisfies this
% relation can be used on the other relations in this file.

avl_ord(nil/0):- !.
avl_ord( Tree) :- avl_ord( Tree, _, _).

avl_ord( t(nil/0, X, nil/0)/1, X, X) :- !.
avl_ord( t(nil/0, X, t(nil/0,Val,nil/0)/1)/2, Val, X) :-
     X @< Val, !.
avl_ord( t( t(nil/0,Val,nil/0)/1, X, nil/0)/2, X, Val) :-
     X @> Val, !.
avl_ord( t( L/H1, X, R/H2)/H, Max2, Min1) :-
     avl_ord( L/H1, Max1, Min1), !,
     X @> Max1, !,
     avl_ord( R/H2, Max2, Min2), !,
     X @< Min2, !,
     (H1 is H2; H1 is H2 + 1; H1 is H2 -1),!,
     max1( H1, H2, H).


% avl_product( +Set1, +Set2)
% is true when given the sets, Set1 and Set2, represented by ordered
% AVL trees, Product will be an ordered AVL tree representing 
% an ordered set of x1-x2 pairs.


avl_product( Tree1, Tree2, Product) :-
     avl_product1( [Tree1], [Tree2], Listproduct),
     list_to_avl( Listproduct, Product).


avl_product1( [nil/0], _, []):- !.
avl_product1( Tree1, Tree2, Product) :-
     move_avl( Tree1, X, Ntree1),
     avl_product1( Tree2, X, Product, Rest),
     avl_product1( Ntree1, Tree2, Rest).

avl_product1( [nil/0],_, L, L):- !.
avl_product1( Tree2, X, [X-Y|TX], TL):-
     move_avl( Tree2, Y, Rest2),
     avl_product1( Rest2, X, TX, TL).


                
% avl_seteq( +Set1, +Set2)
% is true when Set1 and Set2, represented by ordered AVL trees, represent
% the same set. If one argument is a set represented by an ordered AVL 
% tree and the other a variable - the variable will be returned as a copy 
% of the other argument (a pointless exercise!).

avl_seteq( Tree1, Tree2) :-
       avl_seteq1( [Tree1], [Tree2]).


avl_seteq1( [nil/0],[nil/0]):-!.
avl_seteq1( Tree1, Tree2) :-
       move_avl( Tree1, X, Rest1),!,
       move_avl( Tree2, Y, Rest2),!,
       X = Y,!,
       avl_seteq1( Rest1, Rest2).


% avl_subset( +Set1, +Set2)
% is true when given the sets, Set1 and Set2, represented by ordered AVL
% trees, every element of Set1 appears in Set2.

avl_subset( Tree1, Tree2) :-
     avl_subset1( [Tree1], [Tree2]).


avl_subset1( [nil/0],_) :- !.
avl_subset1( Tree1, Tree2) :-
     move_avl( Tree1, X, Rest1),
     move_avl( Tree2, Y, Rest2),!,
     compare( Order, X, Y), !,
     avl_subset1( Order, X, Y, Rest1, Rest2).

avl_subset1( = ,_,_, Rest1, Rest2):-
     avl_subset1( Rest1, Rest2).
avl_subset1( >, X, _, Rest1, Rest2) :-
     avl_subset1( [n(X)|Rest1], Rest2).


% avl_subtract( +Set1, +Set2, ?Difference)
% is true when given the sets, Set1 and Set2, represented by ordered AVL 
% trees, Difference is an ordered AVL tree containing all the elements 
% of Set1 that are not in Set2. Standard notation Difference = Set1 - Set2

avl_subtract( Tree1, Tree2, Difference) :-
     avl_subtract1( [Tree1], [Tree2], Diff),
     list_to_avl( Diff, Difference).


avl_subtract1( Debris, [nil/0], Tree1):- 
     flatten_avl( Debris, Tree1), !.
avl_subtract1( [nil/0], _, []):- !.
avl_subtract1( Tree1, Tree2, Diff) :-
     move_avl( Tree1, X, Rest1),
     move_avl( Tree2, Y, Rest2),
     compare( Order, X,Y), !,
     avl_subtract1( Order, X, Y, Rest1, Rest2, Diff).

avl_subtract1(=,_,_, Rest1, Rest2, Diff) :-
     avl_subtract1( Rest1, Rest2, Diff).
avl_subtract1(<, X, Y, Rest1, Rest2, [X | Diff]) :-
     avl_subtract1( Rest1, [n(Y)|Rest2], Diff).
avl_subtract1(>, X,_, Rest1, Rest2, Diff) :-
     avl_subtract1( [n(X)|Rest1], Rest2, Diff).


% avl_symdiff( +Set1, +Set2, ?Difference)
% is true when given the sets, Set1 and Set2, represented by ordered
% AVL trees, Difference is the ordered AVL tree representation
% of the symmetric difference of Set1 and Set2.
% Difference = ( Set1 - Set2) U ( Set2 - Set1).

avl_symdiff( Tree1, Tree2, Difference) :-
     avl_symdiff1( [Tree1], [Tree2], Diff),
     list_to_avl( Diff, Difference).


avl_symdiff1([nil/0], Debris, Tree2) :-
     flatten_avl( Debris, Tree2), !.
avl_symdiff1( Debris, [nil/0], Tree1) :- 
     flatten_avl( Debris, Tree1), !.
avl_symdiff1( Tree1, Tree2, Diff) :-
     move_avl( Tree1, X, Rest1),
     move_avl( Tree2, Y, Rest2),
     compare( Order, X, Y), !,
     avl_symdiff1(Order, X,Y, Rest1, Rest2, Diff).

avl_symdiff1( =, _,_, Rest1, Rest2, Diff) :-
     avl_symdiff1( Rest1, Rest2, Diff).
avl_symdiff1( <, X, Y, Rest1, Rest2, [X | Diff]):-
     avl_symdiff1( Rest1, [n(Y)|Rest2], Diff).
avl_symdiff1( >, X, Y, Rest1, Rest2, [Y | Diff]) :-
     avl_symdiff1( [n(X)|Rest1], Rest2, Diff).


% avl_to_ptree( +AvlTree, -Ptree) :-
%
%	Ptree is a (binary) ptree,
%	containing just the node data of AvlTree
%	(i.e. not the weights).


avl_to_ptree( t(L,X,R)/_, Xa<[Lp,Rp]) :-
	term_atom( X, Xa),
	avl_to_ptree( L, Lp),
	avl_to_ptree( R, Rp).

avl_to_ptree( nil/0, ''<[]).


% avl_union( +Set1, +Set2, ?Union)
% is true when given the sets, Set1 and Set2, represented by ordered AVL
% trees, union is the ordered AVL tree representation of the union of Set1
% and Set2

avl_union( Tree1, Tree2, Union) :-
     avl_union1( [Tree1], [Tree2], Union1),
     list_to_avl( Union1, Union).


avl_union1( Debris, [nil/0], Tree1) :- 
     flatten_avl( Debris, Tree1), !.
avl_union1( [nil/0], Debris, Tree2) :-
     flatten_avl( Debris, Tree2), !.
avl_union1( Tree1, Tree2, Union) :-
     move_avl( Tree1, X, Rest1),
     move_avl( Tree2, Y, Rest2),
     compare( Order, X, Y), !,
     avl_union1( Order, X, Y, Rest1, Rest2, Union).

avl_union1( =, X,_, Rest1, Rest2, [X | Union]):-
     avl_union1( Rest1, Rest2, Union).
avl_union1( <, X, Y, Rest1, Rest2, [ X | Union]) :-
     avl_union1( Rest1, [n(Y)|Rest2], Union).
avl_union1( >, X, Y, Rest1, Rest2, [ Y | Union]) :-
     avl_union1( [n(X)|Rest1], Rest2, Union).


% avl_update( T1/H1, X, T2/H2) :-
%
%	T2, of height H2, contains X and all the elements of T1
%	(whose height is H1).
%	This version attempts to minimise structure turnover.


avl_update( T1/H1, X, t(Tl/Hl,Y,Tr/Hr)/H) :-
	avl_update2( T1, H1, X, Tl, Hl, Y, Tr, Hr),
	max1( Hl, Hr, H).


% avl_update2( t(Ta/Ha,B,Tc/Hc), H, X, Tl, Hl, Y, Tr, Hr) :-
%
%	This is my attempt to minimise structure turnover.


avl_update2( nil, 0, X, nil, 0, X, nil, 0).

avl_update2( t(Ta/Ha,B,Tc/Hc), _, X, Tl,Hl, Y, Tr, Hr) :-
	compare( Op, X, B),
	avl_update2a( Op, Ta, Ha, B, Tc, Hc, X, Tl, Hl, Y, Tr, Hr).


% avl_update2a( <, Ta, Ha, B, Tc, Hc, X, Tl, Hl, Z, Tr, Hr) :-
%
%	serves avl_update2, which attempts to minimise structure turnover.


avl_update2a( <, Ta, Ha, B, Tc, Hc, X, Tl, Hl, Z, Tr, Hr) :-
	avl_update2( Ta, Ha, X, T1, H1, Y, T2, H2),
	combine2( T1, H1, Y, T2, H2, B, Tc, Hc, Tl, Hl, Z, Tr, Hr).

avl_update2a( =, Ta, Ha, X, Tc, Hc, X, Ta, Ha, X, Tc, Hc).

avl_update2a( >, Ta, Ha, B, Tc, Hc, X, Tl, Hl, Z, Tr, Hr) :-
	avl_update2( Tc, Hc, X, T1, H1, Y, T2, H2),
	combine2( Ta, Ha, B, T1, H1, Y, T2, H2, Tl, Hl, Z, Tr, Hr).


% avlmap_combine( +A1, +Ka, +Va, +A2, +Kb, +Vb, +A3, ?Acombined) +:-
%
%	the three avlmap fragments A1, A2 and A3,
%	along with the intervening keys and values Ka,Va and Kb,Vb,
%	are combined into a balanced avlmap Acombined.
%
%	Ahis is not a general-purpose routine, but has subtle preconditions
%	involving the heights of A1, A2 and A3.


avlmap_combine( A1/H1, Ka, Va, t(A21,Kb,Vb,A22)/H2, Kc, Vc, A3/H3, t(t(A1/H1,Ka,Va,A21)/Ha,Kb,Vb,t(A22,Kc,Vc,A3/H3)/Hc)/Hb) :-
	H2 > H1,
	H2 > H3,
	!,
	Ha is H1+1,
	Hc is H3+1,
	Hb is Ha+1.

avlmap_combine( A1/H1, Ka, Va, A2/H2, Kc, Vc, A3/H3, t(A1/H1,Ka,Va,t(A2/H2,Kc,Vc,A3/H3)/Hc)/Ha) :-
	H1 >= H2,
	H1 >= H3,
	!,
	max1( H2, H3, Hc),
	max1( H1, Hc, Ha).

avlmap_combine( A1/H1, Ka, Va, A2/H2, Kc, Vc, A3/H3, t(t(A1/H1,Ka,Va,A2/H2)/Ha,Kc,Vc,A3/H3)/Hc) :-
	H3 >= H2,
	H3 >= H1,
	!,
	max1( H1, H2, Ha),
	max1( Ha, H3, Hc).


% avlmap_update( +A1, +Knew, +Vnew, ?A2) :-
%
%	the avlmap A2 contains Vnew under Knew,
%	as well as all the key-value pairs of A1.
%
%	There is a reason for unifying A1 in the body rather than in the head:
%	can you see what it is?


avlmap_update( A1, Knew, Vnew, A2) :-
	(	A1 = nil/0
	->	A2 = t(A1,Knew,Vnew,A1)/1
	|(	A1 = t(L,K,V,R)/H
	->	(	K == Knew
		->	(	V == Vnew
			->	A2 = A1
			|	A2 = t(L,K,Vnew,R)/H
			)
		|	compare( Op, Knew, K),
			avlmap_update2( Op, Knew, Vnew, L, K, V, R, H, A2)
		)
	)).


avlmap_update2( <, Kx, Vx, L, Ky, Vy, R, _, A2) :-
	avlmap_update( L, Kx, Vx, t(L1,Kz,Vz,L2)/_),
	avlmap_combine( L1, Kz, Vz, L2, Ky, Vy, R, A2).

avlmap_update2( =, Kx, Vx, L, Kx, Vx, R, H, t(L,Kx,Vx,R)/H).
	%  I think we can improve the space turnover in this case ...

avlmap_update2( >, Kx, Vx, L, Ky, Vy, R, _, A2) :-
	avlmap_update( R, Kx, Vx, t(R1,Kz,Vz,R2)/_),
	avlmap_combine( L, Ky, Vy, R1, Kz, Vz, R2, A2).


% avls_intersection( +ListofTrees, ?Intersection)
% is true when ListofTrees is a proper list of sets represented by 
% ordered AVL trees and Intersection is their intersection.

avls_intersection( Treeslist, Inter) :-
     length( Treeslist, Num_of_trees),
     avls_intersection( Num_of_trees, Treeslist, Inter, []).

avls_intersection( 1, [I| Rest], I, Rest) :-!.
avls_intersection( 2, [A,B| Rest], I, Rest):- 
     avl_intersection( A, B, I).
avls_intersection( N, R0, I, R):-
     P is N>>1,
     Q is N- P,
     avls_intersection( P, R0, A, R1),
     avls_intersection( Q, R1, B, R),
     avl_intersection( A, B, I).


% avls_union( +ListofSets, ?Union)
% is true when ListofTrees is given as a proper list of sets represented
% by ordered AVL trees, Union is the ordered AVL tree representation
% of their union.

avls_union( Treeslist, Union) :-
     length( Treeslist, Num_of_trees),
     avls_union( Num_of_trees, Treeslist, Union, []).

avls_union( 0, R, [], R) :- !.
avls_union( 1, [U|R], U, R) :- !.
avls_union( 2, [A,B|R], U, R) :- !,
     avl_union( A, B, U).
avls_union( N, R0, U, R) :-
     P is N>>1,
     Q is N- P,
     avls_union(P, R0, A, R1),
     avls_union(Q, R1, B, R),
     avl_union( A,B,U).


%mode	avlset_to_ptree1( +avlset(_), -ptree)


avlset_to_ptree1( nil/0, '0'<[]).

avlset_to_ptree1( t(nil/0,X,nil/0)/H, Ah<[Ax<[]]) :-	%  special case
	!,
	term_atom( X, Ax),
	number_atom( H, Ah).

avlset_to_ptree1( t(Tl,X,Tr)/H, Ah<[Pl,Ax<[],Pr]) :-
	avlset_to_ptree1( Tl, Pl),
	term_atom( X, Ax),
	avlset_to_ptree1( Tr, Pr),
	number_atom( H, Ah).


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


% data_to_avl( +List, ?Tree)
% is true when given List, an unordered list of items which can contain
% duplicates, Tree will be the ordered AVL tree representation of the
% set of items in List. It will fail if there are any terms that are
% uninstantiated variables.

data_to_avl( [], nil/0) :- !.
data_to_avl( List, Tree) :-
     sort( List, [ Head | Newlist]), !,
     nonvar( Head),
     list_to_avl( [Head | Newlist], Tree).


 


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


% flatten_avl ( +Ptrlist, ?ListofElem)
% when given a list of pointers to an AVL tree, containing nodes and/or subtree
% of that tree, ListofElem will be an ordered list of the elements in that tree


flatten_avl( [nil/0], []) :- !.
flatten_avl( Debris, [X | List]) :-
    move_avl( Debris, X, NewDebris),
    flatten_avl( NewDebris, List).


gen_elem_in_avl( X, t(Left, _, _)/_) :-
     gen_elem_in_avl( X, Left).
gen_elem_in_avl( X, t(_, X, _)/_).
gen_elem_in_avl( X, t(_, _, Right)/_) :-
     gen_elem_in_avl( X, Right).


% gen_fib( +Limit, -Fibs) :-
%
%	Fibs comprises, in descending order,
%	those positive Fibonacci numbers
%	(from the series starting [0,0..])
%	not greater than Limit.
%
%	e.g. gen_fib( 10, [8,5,3,2,1,1]).


gen_fib( Limit, List) :-
	gen_fib2( Limit, 0, 1, [], List).


% PS' replacement for Sharon's effort.

gen_fib2( Item, Lastbut1, Last, SoFar, Final) :-
	Next is Lastbut1 + Last,
	(	Next < Item
	->	gen_fib2( Item, Last, Next, [Next|SoFar], Final)
	|	Final = SoFar
	).


generate( Item, Lastbut1, Last, SoFar, Final) :-
	Next is Lastbut1 + Last,
	(	Next < Item
	->	generate( Item, Last, Next, [Next|SoFar], Final)
	|	Final = SoFar
	).


in_avl( X, t(_,X,_)/_):- !.
in_avl( X, t(Left, Root, Right)/_) :-
     X @> Root, !,
     in_avl( X, Right);
     in_avl( X, Left).


% junk_avl( +N, -Avl) :-
%
%	Avl is an avlset
%	of N floats, evenly spaced between 0 and 1.


junk_avl( N, Avl) :-
	integer( N),
	var( Avl),
	(	N > 0
	->	M is N-1,
		Inc is 1/N,
		First is Inc/2,
		junk_avl2( M, Inc, First, Rest),
		list_to_avl( [First|Rest], Avl)
	|	list_to_avl( [], Avl)
	).


% junk_avl2( M, Inc, Last, Rest) :-
%
%	serves junk_avl/2.


junk_avl2( M, Inc, Last, Rest) :-
	(	M == 0
	->	Rest = []
	|	Next is Last+Inc,
		Rest = [Next|Tail],
		P is M-1,
		junk_avl2( P, Inc, Next, Tail)
	).


lbias_avl( N, List, L2, Tree, Templist) :-
	(	N =< 3
	->	list_to_avl( N, List, Tree, Templist)
	|	L2 = [X2,X3|List2],
		P is X2 - 1, 
		Q is N - P - 1, 
		lbias_avl( P, List, [X3|List2], L/H1, [Head|Listnotused]),
		(	X3 is Q + 1
		->	lbias_avl( Q, Listnotused, List2, R/H2, Templist),
			Tree = t(L/H1,Head,R/H2)/H
		|	Q1 is X3 - 1,
			lbias_avl( Q1, Listnotused, List2, R/H2, Templist1),
			Q2 is Q - X3 + 1,
			add( Q2, Templist1, Templist, t(L/H1,Head,R/H2)/H, Tree)
		),
		max1( H1, H2, H)
	).


% list_to_avl( +List, ?Tree)
% is true when given List, a proper ordered list of data items, with no
% duplicates, Tree will be the ordered AVL tree representation of the
% set of items in List.

list_to_avl( List, Tree) :-
     length( List, N), 
     list_to_avl( N, List, Tree, []).
list_to_avl( 0, List, nil/0, List) :- !.
list_to_avl( 1, [Item | Tail], t(nil/0,Item, nil/0)/1, Tail):- !.
list_to_avl( 2, [Item1, Item2 | Tail], 
     t(t(nil/0,Item1,nil/0)/1, Item2, nil/0)/2, Tail):- !.
list_to_avl( N, List, t( L/LH, Head, R/RH)/ H, Templist) :-
     P is N >> 1,
     Q is N - P - 1,
     list_to_avl( P, List, L/LH, [Head|Listnotused]),
     list_to_avl( Q, Listnotused, R/RH, Templist),
     max1( LH, RH, H).


% list_to_avl2( +List, ?Tree)
% is true when given List, a proper ordered list of data items, with no
% duplicates, Tree will be the ordered AVL tree representation of the
% set of items in List.

list_to_avl2( List, Tree) :-
     length( List, N), 
     list_to_avl2( N, List, Tree, _, []).


list_to_avl2( 0, List, nil, 0, List) :-
	!.

list_to_avl2( 1, [Item|Tail], t(nil,Item,nil,1), 1, Tail) :-
	!.

list_to_avl2( 2, [M1,M2|Tail], t(t(nil,M1,nil,1),M2,nil,2), 2, Tail) :-
	!.

list_to_avl2( N, List, t(Tl,Head,Tr,H), H, Templist) :-
     P is N//2,
     Q is N-P-1,
     list_to_avl2( P, List, Tl, Hl, [Head|Listnotused]),
     list_to_avl2( Q, Listnotused, Tr, Hr, Templist),
     max1( Hl, Hr, H).


list_to_lbias_avl( List, Tree) :-
	length( List, N),
	(	N > 3
	->	gen_fib( N, [X1,X2|List2]),
		Rest is N - X1 + 1,
		(	Rest >= X2
		->	lbias_avl( N, List, [X1,X2 | List2], Tree, [])
		|	lbias_avl( N, List, [X2 | List2], Tree, [])
	)	
	|	list_to_avl( List, Tree)
	).


max1( U, V, M) :-
	(	U > V
	->	M is U+1
	|	M is V+1
	).


% metalogical_avlmap_has_member( +Avlmap, +Key, ?Val) :-
%
%	the metalogical Avlmap
%	(which is an avlmap with possibly-nonground keys
%	arranged by internal ordering).
%	contains Val under Key.


metalogical_avlmap_has_member( t(L,K,V,R)/_, Kx, Vx) :-
	compare( Op, Kx, K),
	metalogical_avlmap_has_member1( Op, L, K, V, R, Kx, Vx).


% metalogical_avlmap_has_member1( +Op, +L, +Key, +Val, +R, +Keyx, -Valx) :-
%
%	serves metalogical_avlmap_has_member/2.
%
%	given that compare( Op, Keyx, Valx),
%	the metalogical avlmap represented by t(L,Key,Val,R)
%	contains Valx under Keyx.


metalogical_avlmap_has_member1( <, L, _, _, _, Kx, Vx) :-
	metalogical_avlmap_has_member( L, Kx, Vx).

metalogical_avlmap_has_member1( =, _, Kx, Vx, _, Kx, Vx).

metalogical_avlmap_has_member1( >, _, _, R, Kx, Vx) :-
	metalogical_avlmap_has_member( R, Kx, Vx).


% metalogical_avlset_has_member( +Avlset, +Member) :-
%
%	Member is a member of the metalogical Avlset
%	(which is an avlset of possibly-nonground terms
%	arranged by internal ordering).


metalogical_avlset_has_member( t(L,X,R), M) :-
	compare( Op, M, X),
	metalogical_avlset_has_member1( Op, L, X, R, M).


% metalogical_avlset_has_member1( +Op, +L, +Val, +R, +Member) :-
%
%	serves metalogical_avlset_has_member/2.
%
%	given that compare( Op, Member, Val),
%	the metalogical avlset represented by t(L,Val,R) contains Member.


metalogical_avlset_has_member1( <, L, _, _, M) :-
	metalogical_avlset_has_member( L, M).

metalogical_avlset_has_member1( =, _, M, _, M).

metalogical_avlset_has_member1( >, _, _, R, M) :-
	metalogical_avlset_has_member( R, M).


% move_avl( ?Elem, +Ptrlist, ?Newptrlist)
% is true when given Ptrlist, a list of pointers to an AVL tree, containing
% nodes and/or sub-trees, Elem will be the smallest element in the tree and 
% Newptrlist will be the new updated list of pointers.

move_avl( [nil/0|Tail], X, Newrest):-
     move_avl( Tail, X, Newrest).
move_avl( [t(L,Root,R)/_|Tail], X, Newrest):-
     move_avl( [ L, n(Root), R | Tail], X, Newrest).
move_avl( [n(X)|Tail], X, Tail).


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


unbals( Q) :-
	setof(	t(A1,A2,A3,A4),
		L^R^T1^T2^T3^T4^Al^Ar^A^(
			balance( L, 0, R),
			balance( T1, L, T2),
			balance( T3, R, T4),
			addone( t(T1,T2,T3,T4), t(A1,A2,A3,A4)),
			\+((
				balance( A1,Al,A2),
				balance( A3,Ar,A4),
				balance( Al,A,Ar)
			))
		),
		Q
	).


