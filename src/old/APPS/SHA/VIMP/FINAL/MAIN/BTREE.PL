%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% do any global set up required to
% use the wme
wmeSetUp.
 
% empty all contents of Wmes
wmeReset(Wmes,Wmes).
 
%return a fresh wme
wmeInit(_) :- wmeReset(_,_).
 

wmeA(X,Y,Z):-btree_finds(X,Y,Z).
wmeR(X,Y,Z):-btree_deletes(X,Y,Z).
wmeF(X,Y,Y):-btree_finds(X,Y).
is_value(X) :- btree_is(X).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

btree_deletes([],W,W).
btree_deletes([Key-Value|Rest]) -->
	btree_delete(Key,Value),
	btree_deletes(Rest).

btree_finds([],W,W).
btree_finds([Key-Value|Rest]) -->
	btree_find(Key,Value),
	btree_finds(Rest).

btree_find(Key,Value,t(Key,Value,L,R),t(Key,Value,L,R)) :- !.
btree_find(Key,Value,t(Key0,Value0,L0,R),t(Key0,Value0,L,R)) :-
	Key @< Key0, !,
	btree_find(Key,Value,L0,L).
btree_find(Key,Value,t(Key0,Value0,L,R0),t(Key0,Value0,L,R)) :-
	btree_find(Key,Value,R0,R).

btree_delete(Key,Value,t(Key,Value,t(K1,V1,L1,R1),R),t(K1,V1,L1,R)) :- !.
btree_delete(Key,Value,t(Key0,Value0,L0,R),t(Key0,Value0,L,R)) :-
	Key @< Key0, !,
	btree_delete(Key,Value,L0,L).
btree_delete(Key,Value,t(Key0,Value0,L,R0),t(Key0,Value0,L,R)) :-
	btree_delete(Key,Value,R0,R).

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

