% use the wme
wmeSetUp.
 
% empty all contents of Wmes
wmeReset(Wmes,Wmes).
 
%return a fresh wme

wmeInit(empty).

wmeA(X,Y,Z):-tree234__inserts(X,Y,Z).
wmeR(X,Y,Z):-tree234__del(X,Y,Z).
wmeF(X,Y,Y):-tree234__find(X,Y).


tree234__inserts(Pairs,T) :-
	%is_tree234(T0),
	wmeInit(T0),
	tree234__inserts(Pairs,T0,T).

tree234__inserts([],T,T).
tree234__inserts([Key-Value|Rest],T0,T) :-
	tree234__insert(T0,Key,Value,T1),!,
	tree234__inserts(Rest,T1,T).
tree234__inserts([Key-Value|Rest],T0,T) :-
        tree234__update(T0,Key,Value,T1),
        tree234__inserts(Rest,T1,T).

tree234__del(Pairs,T0,T):-
        %is_tree234(T0),
       % is_tree234(T),
        tree234__deletes(Pairs,T0,T).

tree234__deletes([],T,T).
tree234__deletes([Key-_|Rest],T0,T):-
        tree234__delete(T0,Key,T1),
        tree234__deletes(Rest,T1,T).
tree234__find(Pairs,T0):- 
	%is_tree234(T0),
	tree234__look(Pairs,T0).
tree234__look([],_T0).
tree234__look([Key-Value|Tail],T0):- 
	tree234__lookup(T0,Key,Value), tree234__look(Tail,T0).

is_valid(X) :- is_tree234(X).

is_tree234(-) :- !,fail.   
is_tree234(empty).
is_tree234(two(K, V, T1, T2)):- 
	number(K),not var(V),not var(T1), not var(T2),
	is_tree234(T1),is_tree234(T2).
is_tree234(three(K,V,K1,V1,T1,T2,T3)):-  
        number(K),
        number(K1),
        not var(V),
        not var(V1),
        not var(T1),
        not var(T2),
        not var(T3),
        is_tree234(T1),
        is_tree234(T2),
        is_tree234(T3).
is_tree234(four(K,V,K1,V1,K2,V2,T1,T2,T3,T4)):-
        number(K),
        number(K1),
        number(K2),      
        not var(V),      
        not var(V1),
        not var(V2),
        not var(T1),
        not var(T2),
        not var(T3),
        not var(T4),    
        is_tree234(T1),     
        is_tree234(T2),    
        is_tree234(T3),
        is_tree234(T4).	 
%------------------------------------------------------------------------------%

tree234__init(empty).

%------------------------------------------------------------------------------%
tree234__search(empty, _K, _V) :- fail.
tree234__search(two(K0, V0, T0, T1), K, V) :-
	compare(Result, K, K0),
	(
		Result = (<),
		tree234__search(T0, K, V)
	;
		Result = (=),
		V = V0
	;
		Result = (>),
		tree234__search(T1, K, V)
	).
tree234__search(three(K0, V0, K1, V1, T0, T1, T2), K, V) :-
	compare(Result0, K, K0),
	(
		Result0 = (<),
		tree234__search(T0, K, V)
	;
		Result0 = (=),
		V = V0
	;
		Result0 = (>),
		compare(Result1, K, K1),
		(
			Result1 = (<),
			tree234__search(T1, K, V)
		;
			Result1 = (=),
			V = V1
		;
			Result1 = (>),
			tree234__search(T2, K, V)
		)
	).
tree234__search(four(K0, V0, K1, V1, K2, V2, T0, T1, T2, T3), K, V) :-
	compare(Result0, K, K0),
	(
		Result0 = (<),
		tree234__search(T0, K, V)
	;
		Result0 = (=),
		V = V0
	;
		Result0 = (>),
		compare(Result1, K, K1),
		(
			Result1 = (<),
			tree234__search(T1, K, V)
		;
			Result1 = (=),
			V = V1
		;
			Result1 = (>),
			compare(Result2, K, K2),
			(
				Result2 = (<),
				tree234__search(T2, K, V)
			;
				Result2 = (=),
				V = V2
			;
				Result2 = (>),
				tree234__search(T3, K, V)
			)
		)
	).

%------------------------------------------------------------------------------%

tree234__update(empty, _K, _V, _T) :- fail.
tree234__update(two(K0, V0, T0, T1), K, V, T) :-
	compare(Result, K, K0),
	(
		Result = (<),
		tree234__update(T0, K, V, NewT0),
		T = two(K0, V0, NewT0, T1)
	;
		Result = (=),
		T = two(K, V, T0, T1)
	;
		Result = (>),
		tree234__update(T1, K, V, NewT1),
		T = two(K0, V0, T0, NewT1)
	).
tree234__update(three(K0, V0, K1, V1, T0, T1, T2), K, V, T) :-
	compare(Result0, K, K0),
	(
		Result0 = (<),
		tree234__update(T0, K, V, NewT0),
		T = three(K0, V0, K1, V1, NewT0, T1, T2)
	;
		Result0 = (=),
		T = three(K, V, K1, V1, T0, T1, T2)
	;
		Result0 = (>),
		compare(Result1, K, K1),
		(
			Result1 = (<),
			tree234__update(T1, K, V, NewT1),
			T = three(K0, V0, K1, V1, T0, NewT1, T2)
		;
			Result1 = (=),
			T = three(K0, V0, K, V, T0, T1, T2)
		;
			Result1 = (>),
			tree234__update(T2, K, V, NewT2),
			T = three(K0, V0, K1, V1, T0, T1, NewT2)
		)
	).
tree234__update(four(K0, V0, K1, V1, K2, V2, T0, T1, T2, T3), K, V, T) :-
	compare(Result0, K, K0),
	(
		Result0 = (<),
		tree234__update(T0, K, V, NewT0),
		T = four(K0, V0, K1, V1, K2, V2, NewT0, T1, T2, T3)
	;
		Result0 = (=),
		T = four(K, V, K1, V1, K2, V2, T0, T1, T2, T3)
	;
		Result0 = (>),
		compare(Result1, K, K1),
		(
			Result1 = (<),
			tree234__update(T1, K, V, NewT1),
			T = four(K0, V0, K1, V1, K2, V2, T0, NewT1, T2, T3)
		;
			Result1 = (=),
			T = four(K0, V0, K, V, K2, V2, T0, T1, T2, T3)
		;
			Result1 = (>),
			compare(Result2, K, K2),
			(
				Result2 = (<),
				tree234__update(T2, K, V, NewT2),
				T = four(K0, V0, K1, V1, K2, V2,
					T0, T1, NewT2, T3)
			;
				Result2 = (=),
				T = four(K0, V0, K1, V1, K, V,
					T0, T1, T2, T3)
			;
				Result2 = (>),
				tree234__update(T3, K, V, NewT3),
				T = four(K0, V0, K1, V1, K2, V2,
					T0, T1, T2, NewT3)
			)
		)
	).

%------------------------------------------------------------------------------%

tree234__lookup(T, K, V) :-
	(
		tree234__search(T, K, V0)
	->
		V = V0
	;
		error("tree234__lookup: key not found.")
	).

%------------------------------------------------------------------------------%

% tree234__insert is implemented using the simple top-down
% approach described in eg Sedgwick which splits 4 nodes into
% two 2 nodes on the downward traversal of the tree as we
% search for the right place to insert the new key-value pair.
% We know we have the right place if the subtrees of the node
% are empty (in which case we expand the node - which will always
% work because we already split 4 nodes into 2 nodes), or if the
% tree itself is empty.
% This algorithm is O(lgN).

tree234__insert(empty, K, V, two(K, V, empty, empty)).

tree234__insert(two(K0, V0, T0, T1), K, V, Tree) :-
	(
		T0 = empty,
		T1 = empty
	->
		compare(Result, K, K0),
		(
			Result = (<),
			Tree = three(K, V, K0, V0, empty, empty, empty)
		;
			Result = (=),
			fail
		;
			Result = (>),
			Tree = three(K0, V0, K, V, empty, empty, empty)
		)
	;
		compare(Result, K, K0),
		(
			Result = (<),
			(
				T0 = four(_, _, _, _, _, _, _, _, _, _)
			->
				tree234__four(T0, K1, V1, T2, T3),
				T4 = three(K1, V1, K0, V0, T2, T3, T1),
				tree234__insert(T4, K, V, Tree)
			;
				tree234__insert(T0, K, V, T2),
				Tree = two(K0, V0, T2, T1)
			)
		;
			Result = (=),
			fail
		;
			Result = (>),
			(
				T1 = four(_, _, _, _, _, _, _, _, _, _)
			->
				tree234__four(T1, K1, V1, T2, T3),
				T4 = three(K0, V0, K1, V1, T0, T2, T3),
				tree234__insert(T4, K, V, Tree)
			;
				tree234__insert(T1, K, V, T2),
				Tree = two(K0, V0, T0, T2)
			)
		)
	).

tree234__insert(three(K0, V0, K1, V1, T0, T1, T2), K, V, Tree) :-
	(
		T0 = empty,
		T1 = empty,
		T2 = empty
	->
		compare(Result0, K, K0),
		(
			Result0 = (<),
			Tree = four(K, V, K0, V0, K1, V1,
					empty, empty, empty, empty)
		;
			Result0 = (=),
			fail
		;
			Result0 = (>),
			compare(Result1, K, K1),
			(
				Result1 = (<),
				Tree = four(K0, V0, K, V, K1, V1,
					empty, empty, empty, empty)
			;
				Result1 = (=),
				fail
			;
				Result1 = (>),
				Tree = four(K0, V0, K1, V1, K, V,
					empty, empty, empty, empty)
			)
		)
	;
		compare(Result0, K, K0),
		(
			Result0 = (<),
			(
				T0 = four(_, _, _, _, _, _, _, _, _, _)
			->
				tree234__four(T0, K2, V2, T3, T4),
				T5 = four(K2, V2, K0, V0, K1, V1,
						T3, T4, T1, T2),
				tree234__insert(T5, K, V, Tree)
			;
				tree234__insert(T0, K, V, T3),
				Tree = three(K0, V0, K1, V1, T3, T1, T2)
			)
		;
			Result0 = (=),
			fail
		;
			Result0 = (>),
			compare(Result1, K, K1),
			(
				Result1 = (<),
				(
					T1 = four(_, _, _, _, _, _, _, _, _, _)
				->
					tree234__four(T1, K2, V2, T3, T4),
					T5 = four(K0, V0, K2, V2, K1, V1,
						T0, T3, T4, T2),
					tree234__insert(T5, K, V, Tree)
				;
					tree234__insert(T1, K, V, T3),
					Tree = three(K0, V0, K1, V1, T0, T3, T2)
				)
			;
				Result1 = (=),
				fail
			;
				Result1 = (>),
				(
					T2 = four(_, _, _, _, _, _, _, _, _, _)
				->
					tree234__four(T2, K2, V2, T3, T4),
					T5 = four(K0, V0, K1, V1, K2, V2,
							T0, T1, T3, T4),
					tree234__insert(T5, K, V, Tree)
				;
					tree234__insert(T2, K, V, T3),
					Tree = three(K0, V0, K1, V1, T0, T1, T3)
				)
			)
		)
	).

tree234__insert(four(K0, V0, K1, V1, K2, V2, T0, T1, T2, T3), K, V, Tree) :-
	T4 = two(K1, V1,
		two(K0, V0, T0, T1),
		two(K2, V2, T2, T3)
	),
	tree234__insert(T4, K, V, Tree).

tree234__four(four(K0, V0, K1, V1, K2, V2, T0, T1, T2, T3),
		K1, V1, two(K0, V0, T0, T1), two(K2, V2, T2, T3)).
%------------------------------------------------------------------------------%

tree234__delete(empty, _K, empty).

tree234__delete(two(K0, V0, T0, T1), K, Tree) :-
	compare(Result0, K, K0),
	(
		Result0 = (<),
		tree234__delete(T0, K, T2),
		Tree = two(K0, V0, T2, T1)
	;
		Result0 = (=),
		tree234__glue(T0, T1, Tree)
	;
		Result0 = (>),
		tree234__delete(T1, K, T2),
		Tree = two(K0, V0, T0, T2)
	).

tree234__delete(three(K0, V0, K1, V1, T0, T1, T2), K, Tree) :-
	compare(Result0, K, K0),
	(
		Result0 = (<),
		tree234__delete(T0, K, T3),
		Tree = three(K0, V0, K1, V1, T3, T1, T2)
	;
		Result0 = (=),
		tree234__glue(T0, T1, T3),
		Tree = two(K1, V1, T3, T2)
	;
		Result0 = (>),
		compare(Result1, K, K1),
		(
			Result1 = (<),
			tree234__delete(T1, K, T3),
			Tree = three(K0, V0, K1, V1, T0, T3, T2)
		;
			Result1 = (=),
			tree234__glue(T1, T2, T3),
			Tree = two(K0, V0, T0, T3)
		;
			Result1 = (>),
			tree234__delete(T2, K, T3),
			Tree = three(K0, V0, K1, V1, T0, T1, T3)
		)
	).

tree234__delete(four(K0, V0, K1, V1, K2, V2, T0, T1, T2, T3), K, Tree) :-
	compare(Result0, K, K0),
	(
		Result0 = (<),
		tree234__delete(T0, K, NewT0),
		Tree = four(K0, V0, K1, V1, K2, V2, NewT0, T1, T2, T3)
	;
		Result0 = (=),
		tree234__glue(T0, T1, T0_and_1),
		Tree = three(K1, V1, K2, V2, T0_and_1, T2, T3)
	;
		Result0 = (>),
		compare(Result1, K, K1),
		(
			Result1 = (<),
			tree234__delete(T1, K, NewT1),
			Tree = four(K0, V0, K1, V1, K2, V2, T0, NewT1, T2, T3)
		;
			Result1 = (=),
			tree234__glue(T1, T2, T1_and_2),
			Tree = three(K0, V0, K2, V2, T0, T1_and_2, T3)
		;
			Result1 = (>),
			compare(Result2, K, K2),
			(
				Result2 = (<),
				tree234__delete(T2, K, NewT2),
				Tree = four(K0, V0, K1, V1, K2, V2,
						T0, T1, NewT2, T3)
			;
				Result2 = (=),
				tree234__glue(T2, T3, T2_and_3),
				Tree = three(K0, V0, K1, V1, T0, T1, T2_and_3)
			;
				Result2 = (>),
				tree234__delete(T3, K, NewT3),
				Tree = four(K0, V0, K1, V1, K2, V2,
						T0, T1, T2, NewT3)
			)
		)
	).


%------------------------------------------------------------------------------%
% tree234__glue(A, B, C) is true iff C is a 234-tree which is the
% same as the 234-tree A with the 234-tree B attatched to the right-most
% node. It is used when removing a node from the a tree to glue the two
% resulting fragments together.
% XXX a better algorithm could be devised that leaves the tree more
% balanced (this algorithm is not the *proper* way to join 2 234 trees).
tree234__glue(empty, T, T).
tree234__glue(two(K0, V0, T0, T1), T, two(K0, V0, T0, NewT1)) :-
	tree234__glue(T1, T, NewT1).
tree234__glue(three(K0, V0, K1, V1, T0, T1, T2), T,
		three(K0, V0, K1, V1, T0, T1, NewT2)) :-
	tree234__glue(T2, T, NewT2).
tree234__glue(four(K0, V0, K1, V1, K2, V2, T0, T1, T2, T3), T,
		four(K0, V0, K1, V1, K2, V2, T0, T1, T2, NewT3)) :-
	tree234__glue(T3, T, NewT3).

%------------------------------------------------------------------------------%
%------------------------------------------------------------------------------%
%------------------------------------------------------------------------------%
