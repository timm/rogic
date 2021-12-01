/*
parser for head parser
weclome to the classic bootstrapping problem. once the
@system is loaded, i get lots of tools for handling aribtrary structures,
but- in the meantime- i need to handle the structure of the args so
i need a quick and dirty parse system for the arg structuers
*/

%----------------------
% accessors for the header structure

h(key,    h(A,_,_,_,_,_,_), A).
h(name,   h(_,B,_,_,_,_,_), B).
h(filter, h(_,_,C,_,_,_,_), C).
h(inputp, h(_,_,_,D,_,_,_), D).
h(value,  h(_,_,_,_,E,_,_), E).
h(pos,    h(_,_,_,_,_,F,_), F).
h(filterp,h(_,_,_,_,_,_,G), G).

%----------------------
% parser

head(V,X)            :- var(V), !, h0(var,V,value,X).
head(A=B,X)          :- headVar(A,X), headNameStuff(B,X).
head(A:Stuff,X)      :- headVar(A,X), headStuff(Stuff,X).
head(V,X)            :- h0(any,V,value,X).

headVar( V,X)        :- var(V), !, headVar(-V,X).
headVar(+V,X)        :- h0(any,V,value,X), h0(plus, +,inputp,X). 
headVar(-V,X)        :- h0(any,V,value,X), h0(minus,-,inputp,X).
headVar( V,X)        :- headVar(-V,X).

headNameStuff(V,_)   :- var(V), !, fail.
headNameStuff(N:S,X) :- h0(atom,N,name,X), headStuff(S,X).
headNameStuff(N,X)   :- h0(atom,N,name,X).

headStuff(V,_)       :- var(V), !, fail.
headStuff(key:F,X)   :- h0(one,1,key,X), 
                        h0(functor,F,filter,X).
headStuff(key,  X)   :- h0(one,1,key,X).
headStuff(F,X)       :- h0(functor,F,filter,X).

h0(any,    V,   K, X)  :- h(K,X,V).
h0(var,    V,   K, X)  :- var(V),   h(K,X,V).
h0(_,      V,   _, _)  :- var(V),   !, fail.
h0(atom,   V,   K, X)  :- atom(V),  h(K,X,V).
h0(functor,V,   K, X)  :- V \= key, h0(atom,V,K,X), 
	                            Goal =.. [V,_,_],
                                    clause(Goal,_),
                                    h0(plus,+,filterp,X).
h0(one,    1,   K, X)  :- h(K,X,1).
h0(zero,   0,   K, X)  :- h(K,X,0).
h0(plus,   +,   K, X)  :- h(K,X,+).
h0(minus,  -,   K, X)  :- h(K,X,-).

%----------------------
% utils

% main driver for the translation process
term2Details(T,Details) :-
	Defaults =   [key =  0, inputp= -, filterp= -],
	T        =.. [_|L],
	term2Details(L,1,Defaults,Details),
	!.
term2Details(T,_) :-
	format('E> bad head: ~p\n',[T]),nl,fail.

term2Details([],_,_,[]).
term2Details([H|T],N0,Defaults,[Detail|Details]) :-
	h(pos,Detail,N0),
	once(head(H,Detail)),
	maplist(headComplete(Detail),Defaults,_),
	N is N0 + 1,
	term2Details(T,N,Defaults,Details).

% fill in the gaps or, do nothing
headComplete(X,A=B,_)  :- h(A,X,B), !.
headComplete(_,_,_).

% a print utility
hPrint(X) :- h(K,X,V), print(K=V),nl,fail.
hPrint(_) :- nl.

