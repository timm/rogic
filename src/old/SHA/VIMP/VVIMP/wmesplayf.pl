/*
 * splay trees in Prolog
 *  [reference: "Self-Adjusting Binary Search Trees",
 *	D. D. Sleator and R. E. Tarjan, J. ACM. V32, N3
 *	(July 1985), pg. 668. ]
 *
 * original formulation by Vijay Saraswat <vijay.saraswat@c.cs.cmu.edu>
 *  [reference: Prolog Digest, V5, N20 (March 23, 1987) ]
 *
 */

/*
 * [function access( i, t ) -
 *	"if item i is in tree t, return a pointer to its location;
 *	otherwise return a pointer to the null node" ]
 *
 * predicate access( V, I, T, New ) -
 *	"V is unified with 'null' if item I is not in tree T.
 *	V is unified with 'true' if item I is in tree T (and
 *	I is unified with that item)"
 */

  % do any global set up required to
% use the wme
wmeSetUp.
 
% empty all contents of Wmes
wmeReset(Wmes,Wmes).
 
%return a fresh wme
wmeInit(_).
 
wmeA(X,Y,Z):- splay_inserts(X,Y,Z).
wmeR(X,Y,Z):- splay_deletes(X,Y,Z).
wmeF(X,Y,Z):- splay_find(X,Y,Z).

splay_inserts(Pairs,T0,T):-
	%is_splay(T0),
	inserts(Pairs,T0,T).
	%is_splay(T).

inserts([],T,T).
inserts([Key-Value|Rest],T0,T):-
	insert(Key-Value,T0,T1),
	inserts(Rest,T1,T).

splay_deletes(Pairs,T0,T):-
	%is_splay(T0),
	deletes1(Pairs,T0,T).
	%is_splay(T).

splay_find(Pairs,X,Y):-
	%is_splay(X),
	look(Pairs,X,Y).
	%is_splay(Y).

look([],T,T).
look([Key-Value|Rest],T0,T):-
	access(_,Key-Value,T0,T1),
	look(Rest,T1,T).
	

deletes1([],T,T).
deletes1([Key-Value|Rest],T0,T):-
	%nl,nl,nl,print('111111111111'),
	deleteSP(Key-Value,T0,T1),
	%print(Key-Value),nl,
	%print(T1),nl,
	deletes1(Rest,T1,T).


printsp(Tree) :-
	printsp(Tree,'',0).
printsp(X,_,_) :- var(X),!.
printsp(n(Key-Value,L,R),Prefix,Indent) :-
	tab(Indent),write(Prefix),
	print(Key-Value),nl,
	printsp(L,' << ',Indent+4),	
	printsp(R,' << ',Indent+4).	
	
% NOT RITE!!
is_valid(X):- is_splay(X).
is_splay(-) :- !, fail.

is_splay(n(Key-Value,X,Y)):-
        ground(Key),
        ground(Value),
        var(X),var(Y),!.

is_splay(n(Key-Value,Y,Z)):-
        ground(Key),
        ground(Value),
        not var(Y),
        not var(Z),
        is_splay(Y),
	is_splay(Z).

is_splay(n(Key-Value,Y,Z)):-
	ground(Key),
	ground(Value), 	
	not var(Y), 
	var(Z), 
	is_splay(Y).

is_splay(n(Key-Value,Y,Z)):-
	ground(Key),
	ground(Value),
	not var(Z),
	var(Y),
	is_splay(Z).




access( V, Item, Tree, NewTree ) :-
	bst( access( V ), Item, Tree, NewTree ).

/*
 * [function insert( i, t ) -
 *	"insert item i in tree t, assuming that it is not there already" ]
 *
 * predicate insert( I, T, NewT ) -
 *	"NewT is a tree T, but with item I guaranteed to be in it
 *	(i.e. I is not inserted if it is already in the tree; it
 *	will be simply unified with the item already there)"
 */

insert( Item, Tree, NewTree ) :-
	bst( insert, Item, Tree, NewTree ).

/*
 * [function deleteSP( i, t ) -
 *	"delete item i from tree t, assuming that it is present" ]
 *
 * predicate deleteSP( I, T, NewT ) -
 *	"If item I is in tree T, then NewT is the tree which results
 *	from deleting I from T (i.e. failure if I is not in T)"
 */

deleteSP( Item, Tree, NewTree ) :-
	bst( access( true ), Item, Tree, n( Item, Left, Right ) ),
	join( Left, Right, NewTree ).
	/*	first access the element to be deleted thus bringing
	 *	it to the root, and then join its sons */

/*
 * [function join( t1, t2 ) -
 *	"Combine trees t1 and t2 into a single tree containing all items
 *	from both trees, and return the resulting tree.  The operation
 *	assumes that all items in t1 are less than all those in t2 and
 *	destroys both t1 and t2" ]
 *
 * predicate join( T1, T2, NewT ) -
 *	"NewT is the tree formed by joining trees T1 and T2, where
 *	all items in T1 are 'less than' all those in T2"
 */

join( Left, Right, New ) :-
	new_fragment( Fragment ),
	join( Fragment, Left, Right, New ).

/*
 * [function split( i, t ) -
 *	"construct and return two trees t1 and t2, where t1 contains
 *	all items it t less than i, and t2 contains all items in t
 *	greater than i.  This operation destroys t" ]
 *
 * predicate split( I, T, Left, Right ) -
 *	"tree Left contains all elements of T less than i, and
 *	tree Right contains all elements of T greater than i"
 */

split( Item, Tree, Left, Right ) :-
	bst( access( true ), Item, Tree, n( Item, Left, Right ) ).

/*
 * a node is simply an n/3 structure: n( NodeValue, LeftSon, RightSon ).
 * An empty tree is a variable.  NodeValue can be any term
 * or a r( Key, Value ) pair.

 * Hence, we define the ordering:
 */

less( r( Key1, _Value1 ), r( Key2, _Value2 ) ) :- !, Key1 @< Key2.

less( KeyValue1, KeyValue2 ) :- KeyValue1 @< KeyValue2.

/*
 * abstract data type: 'fragment'
 * i.e. hide the representation used for fragments, and the
 * details of addition and access operations upon them.
 * Note that all the operations take constant time (involve
 * only unification).
 */

new_fragment( Frag-Frag ).
	/* a fragment is a "difference-bst" structure */

access_fragment( Tree-_Difference, Tree ).

append_fragment( Tree-Difference, Difference, Tree ).
	/* append_fragment( Frag, OldSubTree, NewSubTree )
	 * is true if appending subtree OldSubTree to left- (or
	 * right-) fragment Frag yields a new left- (or right- ,
	 * respectively) fragment containing subtree NewSubTree */

/*
 * the following append functions are only necessary when the
 * generated fragment is to be used in a subgoal
 */

append_left_fragment( Tree-n(I,NL,NR), n(I,NL,NR), Tree-NR ).
	/* append_left_fragment( Frag, Add, NewFrag ) is true if
	 * left-fragment NewFrag is the result of appending subtree
	 * n(I,NL,NR) to left-fragment Frag */

append_right_fragment( Tree-n(I,NL,NR), n(I,NL,NR), Tree-NL ).
	/* append_right_fragment( Frag, Add, NewFrag ) is true if
	 * right-fragment NewFrag is the result of appending subtree
	 * n(I,NL,NR) to right-fragment Frag */

/*
 * work-horse
 */

bst( Op, Item, Tree, NewTree ) :-
	new_fragment( LeftFrag ),
	new_fragment( RightFrag ),
	bst( Op, Item, LeftFrag, Tree, RightFrag, NewTree ).

/*
 * base cases
 */

bst(	access( null ),
	_Item,
	_LeftFrag,
	null,
	_RightFrag,
	_NewTree
) :- !.

bst(	access( true ),
	Item,
	LeftFrag,
	n( Item, LeftSubTree, RightSubTree ),
	RightFrag,
	n( Item, NewLeftSubTree, NewRightSubTree )
) :-
	append_fragment( LeftFrag, LeftSubTree, NewLeftSubTree ),
	append_fragment( RightFrag, RightSubTree, NewRightSubTree ).

bst(	insert,
	Item,
	LeftFrag,
	n( Item, LeftSubTree, RightSubTree ),
	RightFrag,
	n( Item, NewLeftSubTree, NewRightSubTree )
) :-
	append_fragment( LeftFrag, LeftSubTree, NewLeftSubTree ),
	append_fragment( RightFrag, RightSubTree, NewRightSubTree ).

/*
 * zig case (reached bottom)
 */

bst(	access( null ),
	Item,
	LeftFrag,
	n( OtherItem, null, RightSubTree ),
	RightFrag,
	n( OtherItem, NewLeftSubTree, NewRightSubTree )
) :-
	less( Item, OtherItem ), !,
	access_fragment( LeftFrag, NewLeftSubTree ),
	append_fragment( RightFrag, RightSubTree, NewRightSubTree ).

/*
 * zig-zig case
 */

bst(	Op,
	Item,
	LeftFrag,
	n( Other1, n( Other2, LeftLeft, LeftRight ), Right ),
	RightFrag,
	New
) :-
	less( Item, Other1 ),
	less( Item, Other2 ),
	nonvar( LeftLeft ), !,
	append_right_fragment(	RightFrag,
		n( Other2, _NewLeft, n( Other1, LeftRight, Right ) ),
		NewRightFrag ),	
	bst(	Op,
		Item,
		LeftFrag,
		LeftLeft,
		NewRightFrag,
		New ).

/*
 * zig-zag case
 */

bst(	Op,
	Item,
	LeftFrag,
	n( Other1, n( Other2, LeftLeft, LeftRight ), Right ),
	RightFrag,
	New
) :-
	less( Item, Other1 ),
	less( Other2, Item ),
	nonvar( LeftRight ), !,
	/* make sure we don't do the case which is best left
	 * for zag below, i.e. LeftRight is a variable */
	append_left_fragment( LeftFrag,
		n( Other2, LeftLeft, _NewRight ),
		NewLeftFrag ),
	append_right_fragment( RightFrag,
		n( Other1, _NewLeft, Right ),
		NewRightFrag ),
	bst(	Op,
		Item,
		NewLeftFrag,
		LeftRight,
		NewRightFrag,
		New ).
	
/*
 * zig case (default case)
 */

bst(	Op,
	Item,
	LeftFrag,
	n( OtherItem1, n( OtherItem2, LeftLeft, LeftRight ), Right ),
	RightFrag,
	New
) :-
	less( Item, OtherItem1 ), !,
	append_right_fragment(	RightFrag,
		n( OtherItem1, _NewLeft, Right ),
		NewRightFrag ),
	bst(	Op,
		Item,
		LeftFrag,
		n( OtherItem2, LeftLeft, LeftRight ),
		NewRightFrag,
		New ).

/*
 * zag case (reached bottom)
 */

bst(	access( null ),
	Item,
	LeftFrag,
	n( OtherItem, LeftSubTree, null ),
	RightFrag,
	n( OtherItem, NewLeftSubTree, NewRightSubTree )
) :-
	less( OtherItem, Item ), !,
	access_fragment( RightFrag, NewRightSubTree ),
	append_fragment( LeftFrag, LeftSubTree, NewLeftSubTree ).

/*
 * zag-zag case
 */

bst(	Op,
	Item,
	LeftFrag,
	n( Other1, Left, n( Other2, RightLeft, RightRight ) ),
	RightFrag,
	New
) :-
	less( Other1, Item ),
	less( Other2, Item ),
	nonvar( RightRight ), !,
	append_left_fragment(	LeftFrag,
		n( Other2, n( Other1, Left, RightLeft ), _NewRight ),
		NewLeftFrag ),	
	bst(	Op,
		Item,
		NewLeftFrag,
		RightRight,
		RightFrag,
		New ).

/*
 * zag-zig case
 */

bst(	Op,
	Item,
	LeftFrag,
	n( Other1, Left, n( Other2, RightLeft, RightRight ) ),
	RightFrag,
	New
) :-
	less( Other1, Item ),
	less( Item, Other2 ),
	nonvar( RightLeft ), !,
	append_left_fragment( LeftFrag,
		n( Other1, Left, _NewRight ),
		NewLeftFrag ),
	append_right_fragment( RightFrag,
		n( Other2, _NewLeft, RightRight ),
		NewRightFrag ),
	bst(	Op,
		Item,
		NewLeftFrag,
		RightLeft,
		NewRightFrag,
		New ).

/*
 * zag case (default case)
 */

bst(	Op,
	Item,
	LeftFrag,
	n( OtherItem1, Left, n( OtherItem2, RightLeft, RightRight ) ),
	RightFrag,
	New
) :-
	less( _OtherItem, Item ), !,
	append_left_fragment(	LeftFrag,
		n( OtherItem1, Left, _NewRight ),
		NewLeftFrag ),
	bst(	Op,
		Item,
		NewLeftFrag,
		n( OtherItem2, RightLeft, RightRight ),
		RightFrag,
		New ).

/*
 * predicate join( Fragment, Left, Right, NewTree )
 *
 *	to join splay tree Left to splay tree Right,
 *		- splay the rightmost vertex in Left
 *		- then make Right its right son
 */

join(	Frag,
	n( Item, LeftLeft, LeftRight ),
	RightSubTree,
	n( Item, NewLeftSubTree, RightSubTree )
) :-
	var( LeftRight ), !,
	append_fragment( Frag, LeftLeft, NewLeftSubTree ).

join(	Frag,
	n( Item1, Left, n( Item2, _RightLeft, RightRight ) ),
	RightSubTree,
	n( Item2, NewLeftSubTree, RightSubTree )
) :-
	var( RightRight ), !,
	append_fragment( Frag, n( Item1, Left, _LeftRight ), NewLeftSubTree ).

join(	Frag,
	n( Item1, Left, n( Item2, RightLeft, RightRight ) ),
	RightSubTree,
	New
) :-
/*	nonvar( RightRight ), !, */
	append_left_fragment( Frag,
			n( Item2, n( Item1, Left, RightLeft ), _NewRight ),
			NewFrag ),
	join( NewFrag, RightRight, RightSubTree, New ).

