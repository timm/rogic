% do any global set up required to
% use the wme
wmeSetUp.
wmeReset(Wmes,Wmes).
 
%return a fresh wme
wmeInit(_) :- wmeReset(_,_).

 
wmeA(X,Y,Z):-oset_insert(X,Y,Z).
wmeR(X,Y,Z):-oset_delete(X,Y,Z).
wmeF(X,Y,Y):-oset_find(X,Y). 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


oset_insert(Pairs,W0,W):-
	oset_inserts(Pairs,W0,W).
oset_delete(Pairs,W0,W):-
	oset_deletes(Pairs,W0,W).
oset_find(Pairs,W0):-
	oset_look(Pairs,W0).
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

%is_valid(X):-oset_is(X). 
oset_is(-) :- !, fail.    % var filter
oset_is([]).
oset_is([H|T]) :-
    oset_is(T, H).

oset_is(-, _) :- !, fail.  % var filter
oset_is([], _H).
oset_is([H|T], H0) :-
    H0 @< H,               % use standard order
    oset_is(T, H).


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



