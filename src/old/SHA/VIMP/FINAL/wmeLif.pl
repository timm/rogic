wmeSetUp.


wmeA(X,Y,Z):-wmeAsserts(X,Y,Z).
wmeR(X,Y,Z):-wmeRetract(X,Y,Z).
wmeF(X,Y,Z):-wmeFind(X,Y,Z).


 
% empty all contents of Wmes
wmeReset(_,[]).
 
%return a fresh wme
wmeInit([]).

%format.....

is_valid(X) :- lis_is(X).

lis_is(-):- !,fail.
lis_is([]).
lis_is([Key-Value|T]):- 
	ground(Key),
  	ground(Value),
	lis_is(T).

% Assert Key-Value Pairs.....

wmeAsserts([],W,W).
wmeAsserts([Key-Value|Rest],W0,W) :-
        wmesAssert(Key,Value,W0,W1),
        wmeAsserts(Rest,W1,W).

wmesAssert(Key,Value, Wmes0,[Key-Value|Wmes0]).

% Retract Key-Value Pairs.....

wmeRetract([],T,T).
wmeRetract([Key-Value|Rest],T1,T):-
	wmesRetract(Key,Value,T1,T2),
	wmeRetract(Rest,T2,T).
wmesRetract(_,_,[],[]) :- !.
wmesRetract(Key,Value,[Key-Value|Wmes0],Wmes0) :- !.
wmesRetract(Key,Value,[Item|Wmes0],[Item|Rest]) :- 
	wmesRetract(Key,Value,Wmes0,Rest). 


% Find Key-Value Pairs in the given list......

wmeFind([],T,T).
wmeFind([Key-Value|Rest],T1,T):-
	wmesFind(Key,Value,T1,T2),
	wmeFind(Rest,T2,T).


wmesFind(Key,Value,Wmes0,[Key-Value|Rest])    :-
	oneLess(Wmes0,Key-Value,Rest),!.

oneLess([A|B], A, B).
oneLess([A|B], C, [A|D]) :- oneLess(B, C, D).

wmeAsserts([],W,W).
wmeAsserts([Key-Value|Rest],W0,W) :-
	wmesAssert(Key,Value,W0,W1),
	wmeAsserts(Rest,W1,W).

