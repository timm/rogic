%% misc set stuff based on R. O'K's ordered sets
 
% increment a counter (set to 1 if absent)
set_incel([],Key=1,[Key=1]).
set_incel([Key0=Value0|T],Key=Value,Add) :-
	compare(Order,Key0,Key),
	set_incel(Order,Key0=Value0,T, Key=Value,Add).

set_incel(<, H,       T,X,       [H      |Add]) :- set_incel(T,X,Add).
set_incel(=, Key=Old, T,Key=New, [Key=New|T  ]) :- New is Old + 1.
set_incel(>, H,       T,Key=_,   [Key=1,H|T  ]).

% add a new Key/Value pair- fail if Key already there
set_newel([],Key=Value,[Key=Value]).
set_newel([Key0=Value0|T],Key=Value,Add) :-
	compare(Order,Key0,Key),
	set_newel(Order,Key0=Value0,T, Key=Value,Add).

set_newel(<,H,     T,    X,[H        |Add]) :- set_newel(T,X,Add).
set_newel(>,H,     T,Key=X,[Key=X,H|T]).

% check if an old Key/Value pair is known
set_oldel([Key0=Old|T],Key=Value) :-
	compare(Order,Key0,Key),
	set_oldel(Order,Old,T, Key=Value).

set_oldel(<,_,  T,X) :- set_oldel(T,X).
set_oldel(=,Old,_,_=Old).

% union of 2 ordered sets
set_union([], Union, Union).
set_union([H1|T1], L2, Union) :-     
	union2(L2, H1, T1, Union).

union2([], H1, T1, [H1|T1]).
union2([H2|T2], H1, T1, Union) :- 
	compare(Order, H1, H2), 
	union3(Order, H1, T1, H2, T2, Union).

union3(<, H1, T1,  H2, T2, [H1|Union]) :- union2(T1, H2, T2, Union).
union3(=, H1, T1, _H2, T2, [H1|Union]) :- set_union(T1, T2, Union).
union3(>, H1, T1,  H2, T2, [H2|Union]) :- union2(T2, H1, T1, Union).

