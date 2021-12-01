% do any global set up required to
% use the wme
wmeSetUp.
wmeReset(Wmes,Wmes).
 
%return a fresh wme
wmeInit(_) :- wmeReset(_,_).

wmesAssert(Key,Term, Wmes0,Wmes) :- oset_addel(Wmes0,Key-Term,Wmes).
wmesRetract(Key,Term,Wmes0,Wmes) :- oset_delel(Wmes0,Key-Term,Wmes).
wmesFind(Key,Term,Wmes,Wmes)    :- oset_el(Key-Term,Wmes).
 
wmeA(X,Y,Z):-oset_insert(X,Y,Z).
wmeR(X,Y,Z):-oset_delete(X,Y,Z).
wmeF(X,Y,Y):-oset_find(X,Y). 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


oset_insert(Pairs,W0,W):-
	oset_inserts(Pairs,W0,W),
	oset_is(W0),
	oset_is(W).
oset_delete(Pairs,W0,W):-
	oset_deletes(Pairs,W0,W),
	oset_is(W0),
	oset_is(W).
oset_find(Pairs,W0):-
	oset_look(Pairs,W0),
	oset_is(W0).
oset_inserts([],T,T).
oset_inserts([Key-Value|Rest],W0,W):-
	oset_addel(W0,Key-Value,W1),
	oset_inserts(Rest,W1,W).
oset_deletes([],T,T).
oset_deletes([Key-Value|Rest],W0,W):-
	oset_delel(W0,Key-Value,W1),
	oset_deletes(Rest,W1,W).
oset_look([],_T).
oset_look([Key-Value|Rest],W0):-
	oset_el(Key-Value,W0),
	oset_look(Rest,W0).

is_valid(X):-oset_is(X). 
oset_is(-) :- !, fail.    % var filter
oset_is([]).
oset_is([H|T]) :-
    oset_is(T, H).

oset_is(-, _) :- !, fail.  % var filter
oset_is([], _H).
oset_is([H|T], H0) :-
    H0 @< H,               % use standard order
    oset_is(T, H).



% oset_union(+OSet1, +OSet2, -Union).
% -----------------------------
oset_union([], Union, Union).
oset_union([H1|T1], L2, Union) :-
    union2(L2, H1, T1, Union).

union2([], H1, T1, [H1|T1]).
union2([H2|T2], H1, T1, Union) :-
    compare(Order, H1, H2),
    union3(Order, H1, T1, H2, T2, Union).

union3(<, H1, T1,  H2, T2, [H1|Union]) :-
    union2(T1, H2, T2, Union).
union3(=, H1, T1, _H2, T2, [H1|Union]) :-
    oset_union(T1, T2, Union).
union3(>, H1, T1,  H2, T2, [H2|Union]) :-
    union2(T2, H1, T1, Union).


% oset_int(+OSet1, +OSet2, -Int)
%   ordered set intersection
% ------------------------------
oset_int([], _Int, []).
oset_int([H1|T1], L2, Int) :-
    isect2(L2, H1, T1, Int).

isect2([], _H1, _T1, []).
isect2([H2|T2], H1, T1, Int) :-
    compare(Order, H1, H2),
    isect3(Order, H1, T1, H2, T2, Int).

isect3(<, _H1, T1,  H2, T2, Int) :-
    isect2(T1, H2, T2, Int).
isect3(=, H1, T1, _H2, T2, [H1|Int]) :-
    oset_int(T1, T2, Int).
isect3(>, H1, T1,  H2, T2, [H2|Int]) :-
    isect2(T2, H1, T1, Int).


% oset_diff(+InOSet, +NotInOSet, -Diff)
%   ordered set difference
% --------------------------------------
oset_diff([], _Not, []).
oset_diff([H1|T1], L2, Diff) :-
    diff21(L2, H1, T1, Diff).

diff21([], H1, T1, [H1|T1]).
diff21([H2|T2], H1, T1, Diff) :-
    compare(Order, H1, H2),
    diff3(Order, H1, T1, H2, T2, Diff).

diff12([], _H2, _T2, []).
diff12([H1|T1], H2, T2, Diff) :-
    compare(Order, H1, H2),
    diff3(Order, H1, T1, H2, T2, Diff).

diff3(<,  H1, T1,  H2, T2, [H1|Diff]) :-
    diff12(T1, H2, T2, Diff).
diff3(=, _H1, T1, _H2, T2, Diff) :-
    oset_diff(T1, T2, Diff).
diff3(>,  H1, T1, _H2, T2, Diff) :-
    diff21(T2, H1, T1, Diff).


% oset_dunion(+SetofSets, -DUnion)    
%   distributed union
% --------------------------------
oset_dunion([], []).
oset_dunion([H|T], DUnion) :-
    oset_dunion(T, H, DUnion).

dunion([], _DUnion, _DUnion).
dunion([H|T], DUnion0, DUnion) :-
    oset_union(H, DUnion0, DUnion1),
    dunion(T, DUnion1, DUnion).


% oset_dint(+SetofSets, -DInt)    
%   distributed intersection
% ---------------------------- 
oset_dint([], []).
oset_dint([H|T], DInt) :-
    dint(T, H, DInt).

dint([], DInt, DInt).
dint([H|T], DInt0, DInt) :-
    int(H, DInt0, DInt1),
    dint(T, DInt1, DInt).


% oset_power(+Set, -PSet)
%   ordered set powerset
% -----------------------
oset_power(S, PSet) :-
    pset(S, [[]], PSet0),
    sort(PSet0, PSet).

pset([], PSet, PSet).
pset([H|T], PSet0, PSet) :-
    happ(PSet0, H, PSet1),
    pset(T, PSet1, PSet).

happ([], _, []).
happ([S|Ss], H, [[H|S],S|Rest]) :-
    happ(Ss, H, Rest).

oset_addels(Adds,Out) :-
	oset_addels(Adds,[],Out).

oset_addels([],Out,Out).
oset_addels([H|T],In,Out) :-
	oset_addel(In,H,Temp),
	oset_addels(T,Temp,Out).

% oset_addel(+Set, +El, -Add)  
%   ordered set element addition
% ------------------------------
oset_addel([], El, [El]). 
oset_addel([H|T], El, Add) :-
    compare(Order, H, El),
    addel(Order, H, T, El, Add).

addel(<, H, T,  El, [H|Add]) :-
    oset_addel(T, El, Add).
addel(=, H, T, _El, [H|T]). 
addel(>, H, T,  El, [El,H|T]).


% oset_delel(+Set, +el, -Del)  
%   ordered set element deletion
% ------------------------------
oset_delel([], _El, []).
oset_delel([H-Value1|T], El-Value2, Del) :-
    compare(Order, H, El),
    delel(Order, H,Value1, T, El, Value2,Del).

delel(<,  H, Value1,T,  El, Value2,[H-Value1|Del]) :-
    oset_delel(T, El-Value2, Del).
delel(=, _H, Value, T, _El, Value,T).
delel(>,  H, Value, T, _El, _Value,[H-Value|T]).

% oset
oset_el(Key1-Value1,[Key2-Value2|T]) :-
	compare(Order,Key1,Key2),
	findel(Order,Key1,Value1,Value2,T).

findel(=,_,Value,Value,_).
findel(>,Key,Value,_,T) :- oset_el(Key-Value,T).



