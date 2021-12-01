
% config: increased size should speed
% access time

%:- [oidset].

wmeSize(32).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% you  should not need to look
% below here

term_expansion(makeWme,Out) :- 
	makeWme1(Out).

makeWme1([wme0(New)|Rest]) :- 
	wmeSize(Size),
	length(L0,Size),
	maplist(empty,L0,L),
	New =.. [wme|L],
	bagof(Swap,Size^swapPrim(Size,Swap),Rest).

/*wme0(what,Size,Zero).

swap*/
empty([],[]).

swapPrim(Size,swap(N,V0,V,W0,W)) :-
	wmeSize(Size),
	functor(W0,wme,Size),
	functor(W,wme,Size),
	W0 =.. [wme|L0],
	W  =.. [wme|L],
	between(1,Size,N),
	joinArgs(1,N,L0,V0,V,L).

joinArgs(N,N,[Old|Rest],Old,New,[New|Rest]).
joinArgs(N0,N1,[X|L0],Old,New,[X|L]) :- 
	N0 < N1,
	N2 is N0 + 1,
	joinArgs(N2,N1,L0,Old,New,L).
	
:- op(999,xfx,of).

of(form,wme,W,W) :- !, (var(W) -> wme0(W) ; wmeSize(S), functor(W,wme,S)).
of(In,Out,W0,W) :- 
	wmeSize(Size),
	hash_term(In,Hash),
	Bucket is (Hash mod Size) + 1,
	swap(Bucket,Old,New,W0,W),
	okset(Old,In=Out,New).

okset([],Key=Value,[Key=Value]).
okset([Key0=Value0|T],Key=Value,Add) :-
	compare(Order,Key0,Key),
	okset(Order,Key0=Value0,T, Key=Value,Add).

okset(<,H,     T,    X,[H        |Add]) :- okset(T,X,Add).
okset(=,Key=X, T,Key=X,[Key=X    |T]).
okset(>,H,     T,Key=X,[Key=X,H|T]).

%association list : key-values pairs
%values is an oset
%keys in a hash table. buckets contain olists of key-values pairs sorted on key
% only  key per bucket. keys can have N values.

%%%%%%%%%%%%%%%%%%%	
% this next line MUST follow the above
makeWme.

