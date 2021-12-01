
%----------------------------------------------------------
% set routines
% adapted from jan jagger's from the SWI Prolog bin
% set_empty
% set_ordered_with
% set_with
% set_is
% set_member_chk
% set_union
% set_int
% set_no_int
% set_diff
% set_dunion
% set_dint
% set_power
% set_adde1
% set_adds
% set_dele1
% set_subset


my_setof(X,Y,Z) :- setof(X,Y,Temp), !, set_ordered_with(Temp,Z).
my_setof(_,_,Empty) :- set_empty(Empty).

%---- set_empty
set_empty([]).

set_new([]).

%----- sets_empty
sets_empty([]).
sets_empty([H|T]) :- set_empty(H), sets_empty(T). 

%---- set with
set_with(Items,Set) :- sort(Items,Set).

%---- set_ordered_with
set_ordered_with(X,X).

%---- set_is(+OSet)
set_is(-) :- !, fail.    % var filter
set_is([]).
set_is([H|T]) :- set_is(T, H).

set_is(-, _) :- !, fail.  % var filter
set_is([], _H).
set_is([H|T], H0) :- H0 @< H,  set_is(T, H).

%---- set_member_chk(+E,+Set)
set_member_chk(E,[E|_]) :- !.
set_member_chk(E,[_|T]) :- set_member_chk(E,T).

%---- set_member(+E,+Set)
set_member(E,[E|_]).
set_member(E,[_|T]) :- set_member(E,T).

%----- set_union(+OSet1, +OSet2, -Union).
set_union([], Union, Union).
set_union([H1|T1], L2, Union) :-     union2(L2, H1, T1, Union).

union2([], H1, T1, [H1|T1]).
union2([H2|T2], H1, T1, Union) :- 
	compare(Order, H1, H2), union3(Order, H1, T1, H2, T2, Union).

union3(<, H1, T1,  H2, T2, [H1|Union]) :-    union2(T1, H2, T2, Union).
union3(=, H1, T1, _H2, T2, [H1|Union]) :- 	set_union(T1, T2, Union).
union3(>, H1, T1,  H2, T2, [H2|Union]) :-    union2(T2, H1, T1, Union).


%----- set_union_new(+OSet1, +OSet2, -Union).
set_union_new([], Union, Union).
set_union_new([H1|T1], L2, Union) :-     union_new2(L2, H1, T1, Union).

union_new2([], H1, T1, [H1|T1]).
union_new2([H2|T2], H1, T1, Union) :- 
	compare(Order, H1, H2), union_new3(Order, H1, T1, H2, T2, Union).

union_new3(<, H1, T1,  H2, T2, [H1|Union]) :-   union_new2(T1, H2, T2, Union).
%union_new3(=, H1, T1, _H2, T2, [H1|Union]) :- 	set_union_new(T1, T2, Union).
union_new3(>, H1, T1,  H2, T2, [H2|Union]) :-   union_new2(T2, H1, T1, Union).

%----- set_int(+OSet1, +OSet2, -Int)
set_int([], _Int, []).
set_int([H1|T1], L2, Int) :-     isect2(L2, H1, T1, Int).

isect2([], _H1, _T1, []).
isect2([H2|T2], H1, T1, Int) :-
    compare(Order, H1, H2), isect3(Order, H1, T1, H2, T2, Int).

isect3(<, _H1, T1,  H2, T2, Int)     :-      isect2(T1, H2, T2, Int).
isect3(=, H1, T1, _H2, T2, [H1|Int]) :- 	set_int(T1, T2, Int).
isect3(>, H1, T1,  H2, T2, [H2|Int]) :-      isect2(T2, H1, T1, Int).

%----- set_no_int
set_no_int([],_).
set_no_int([H1|T1],L2) :- nosect1(L2,H1,T1).

nosect1([],_,_).
nosect1([H2|T2],H1,T1) :- 
	compare(Order,H1,H2), 
	nosect2(Order,H1,T1,H2,T2).

%noint1(=,_,_,_,_). fail this case.
nosect2(<,_H1,T1, H2,T2) :- nosect1(T1,H2,T2).
nosect2(>, H1,T1,_H2,T2) :- nosect1(T2,H1,T1).

%----- set_diff
set_diff([], _Not, []).
set_diff([H1|T1], L2, Diff) :-     diff21(L2, H1, T1, Diff).

diff21([], H1, T1, [H1|T1]).
diff21([H2|T2], H1, T1, Diff) :-
    compare(Order, H1, H2), diff3(Order, H1, T1, H2, T2, Diff).

diff12([], _H2, _T2, []).
diff12([H1|T1], H2, T2, Diff) :-
    compare(Order, H1, H2), diff3(Order, H1, T1, H2, T2, Diff).

diff3(<,  H1, T1,  H2, T2, [H1|Diff]) :- diff12(T1, H2, T2, Diff).
diff3(=, _H1, T1, _H2, T2, Diff)      :- set_diff(T1, T2, Diff).
diff3(>,  H1, T1, _H2, T2, Diff)      :- diff21(T2, H1, T1, Diff).

%----- set_dunion(+SetofSets, -DUnion
set_dunion([], []).
set_dunion([H|T], DUnion) :- dunion(T, H, DUnion). %set_dunion(T, H, DUnion).

dunion([], _DUnion, _DUnion).
dunion([H|T], DUnion0, DUnion) :-
    set_union(H, DUnion0, DUnion1),  dunion(T, DUnion1, DUnion).

%--- set_dint
set_dint([], []).
set_dint([H|T], DInt) :- dint(T, H, DInt).

dint([], DInt, DInt).
dint([H|T], DInt0, DInt) :- %int(H, DInt0, Dint1), dint(T, DInt1, Dint).
	set_dint(H, DInt0, DInt1), dint(T, DInt1, DInt).

%----- set power
set_power(S, PSet) :- pset(S, [[]], PSet0), sort(PSet0, PSet).

pset([], PSet, PSet).
pset([H|T], PSet0, PSet) :- happ(PSet0, H, PSet1), pset(T, PSet1, PSet).

happ([], _, []).
happ([S|Ss], H, [[H|S],S|Rest]) :- happ(Ss, H, Rest).

%----- set add
set_addel([], El, [El]). 
set_addel([H|T], El, Add) :- 
	compare(Order, H, El), addel(Order, H, T, El, Add).

addel(<, H, T,  El, [H|Add]) :- set_addel(T, El, Add).
addel(=, H, T, _El, [H|T]). 
addel(>, H, T,  El, [El,H|T]).


%----- set adda

set_changea([], El=V, [El=V]). 
set_changea([H=HValue|T], El=EValue, Add) :- 
	compare(Order, H, El), changea(Order, H=HValue, T, El=EValue, Add).

changea(<, H, T,  El, [H|Add]) :- set_changea(T, El, Add).
changea(=, H=_, T, _El=Value, [H=Value|T]). 
changea(>, H, T,  El, [El,H|T]).

%----- set inc
% little trick for storing lots of counters of things
set_incel([], El, [El=1]). 
set_incel([H=Value|T], El, Add) :- 
	compare(Order, H, El), incel(Order, H=Value, T, El, Add).

incel(<, H,       T,  El, [H           |Add]) :- set_incel(T, El, Add).
incel(=, H=Old,   T,  H,  [H=New       |T])   :- New is Old + 1. 
incel(>, H=Value, T,  El, [El=1,H=Value|T]).


%----- set incs
% little trick for storing lots of counters of things
set_incsel([], El+V, [El=V]). 
set_incsel([H=Value|T], El+V, Add) :- 
	compare(Order, H, El), incsel(Order, H=Value, T, El+V, Add).

incsel(<, H,     T,  El, [H     |Add]) :- set_incsel(T, El, Add).
incsel(=, H=Old, T,  H+V,[H=New |T])   :- New is Old + V. 
incsel(>, H,     T,  El, [El,H  |T]).

%----- set add new element
% fails if new element already in set.
set_newel([], El, [El]). 
set_newel([H|T], El, Add) :- 
	compare(Order, H, El), newel(Order, H, T, El, Add).

newel(<, H, T,  El, [H|Add]) :- set_newel(T, El, Add).
%newel(=, H, T, _El, [H|T]). 
newel(>, H, T,  El, [El,H|T]).


%---- set adds
set_adds(L,S) :-
	set_new(S0),
	set_adds(L,S0,S).

set_adds([],Set1,Set1).
set_adds(Items0,Set1,Set2) :- sort(Items0,Items), set_union(Items,Set1,Set2).

%----- set_delel(+Set, +el, -Del)  
set_delel([], _El, []).
set_delel([H|T], El, Del) :- compare(Order, H, El), delel(Order, H, T, El, Del).

delel(<,  H, T,  El, [H|Del]) :- set_delel(T, El, Del).
delel(=, _H, T, _El, T).
delel(>,  H, T, _El, [H|T]).

%---- set_is_subset(+Subset,+Set)
set_is_subset(Subset,Set) :- 
	length(Subset,L1), length(Set,L2), L1 > L2,!, fail.
set_is_subset(Subset,Set) :- 
	set_diff(Subset,Set,Diff),!, Diff = [].


%---- set_size(+Set,-Size).
set_size(Set,Size) :- length(Set,Size).
