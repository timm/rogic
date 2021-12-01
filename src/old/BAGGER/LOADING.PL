% load time control

goal_expansion(This with Args,Out) :-  
	xpandArgs(This,Args,Out).
term_expansion((+X :- Y),Out) :-
	knownp(X),
	expand_term((+X :- Y),Out).
term_expansion(+X,Out) :- 
	knownp(X), 
	expand_term(X,Out).
term_expansion((@X0 : _  :- Y),
               [(@X :- Y),(:- dynamic F/A)|Rest]) :- !,
	def(X0,X,Rest),
	functor(X0,F,A).
term_expansion((@X0 :- Y),[(@X :- Y)|Rest]) :- !,
	def(X0,X,Rest).
term_expansion(@X0:_,[@X,(:- dynamic F/A)|Rest]) :- !, 
	def(X0,X,Rest),
	functor(X0,F,A).
term_expansion(@X0,[@X|Rest]) :- 
	def(X0,X,Rest).

knownp(X) :- clause(@X,_),!.
knownp(X) :- format('E> unknown: ~p\n',[X]),fail.

%---------------------
def(Term0, % input Term with funny squiggles
    Term,  % output blank term
    All
    ) :-
	term2Details(Term0,Details),
	Term0 =.. [F|_],
	maplist(h(value),Details,L),
	Term =.. [F|L],
	mybagof(One,F^Details^def1(F,Details,One), All).

def1(F,Details,Out) :-
	member(Todo,[places0
                    ,blanks0
                    ,swaps0
                    ,index0
                    ,about0
                    ,filter0
                    ]),
	call(Todo,F,Details,Out).

%---------------------
places0(F,Details,place(F,Name,Pos)) :-
	member(Detail,Details),
	h(pos,Detail,Pos),
	h(name,Detail,Name), 
	nonvar(Name).

%---------------------
blanks0(F,Details,blank(F,Blank)) :-
	length(Details,A),
	functor(Blank,F,A),
	\+ blank(F,_).

%---------------------
swaps0(F,Details,swap0(Name,OldV,NewV,Old,New)) :-
	length(Details,A),
	member(Detail,Details),
	h(name,Detail,Name),
	nonvar(Name),
	h(pos,Detail,Pos),
	functor(Old,F,A),  Old =.. [F|Lold],
	functor(New,F,A),  New =.. [F|Lnew],
	joinArgs(1,Pos,Lold,OldV,NewV,Lnew).

joinArgs(N,N,[Old|Rest],Old,New,[New|Rest]).
joinArgs(N0,N1,[X|L0],Old,New,[X|L]) :- 
	N0 < N1,
	N2 is N0 + 1,
	joinArgs(N2,N1,L0,Old,New,L).

%---------------------
index0(F,Details,(:- index(Index))) :-
	maplist(h(key),Details,L),
	Index =.. [F|L].

%---------------------
about0(F, Details,about(Term,Inputs,Keys)) :-
	length(Details,A),
	functor(Term,F,A),  
	keys(Details,Term,Keys),
	inputs(Details,Term,Inputs),
	(Keys \= [] ; Inputs \= []).

keys(Details,Term,Keys) :-
	bagof(One,Details^
                      keys1(Details,Term,One),
                     Keys).
keys(_,_,[]).

keys1(Details,Term,V) :-
	member(Detail,Details),
	h(key, Detail, 1),
	h(pos, Detail, N),
	arg(N,Term,V).

inputs(Details, Term,Inputs) :-
	bagof(One,Details^
                      inputs1(Details,Term,One),
                    Inputs).
inputs(_,_,[]).

inputs1(Details,Term,V) :-
	member(Detail,Details),
	h(inputp,Detail,+),
	h(pos,Detail,N),
	arg(N,Term,V).

%---------------------
filter0(F,Details,(term_expansion(Term1,Term2) :- Filters)) :-
	length(Details,A),
	functor(Term1,F,A),
	functor(Term2,F,A),
	maplist(filterps1(Term1,Term2),Details,Filters0),
	delete(Filters0,true,Filters1),
	l2c(Filters1,Filters).

filterps1(Term1,Term2,Detail,F) :-
	h(pos,Detail,N),
	arg(N,Term1,In),
	arg(N,Term2,Out),
	(h(filterp,Detail,+) 
         -> h(filter,Detail,Filter),
            F =.. [Filter,In,Out]
          ; F = true, 
            In = Out).

l2c([H],H) :- !.
l2c([H|T],(H,Rest)) :- l2c(T,Rest).

%-------------------

h(key,    h(A,_,_,_,_,_,_), A).
h(name,   h(_,B,_,_,_,_,_), B).
h(filter, h(_,_,C,_,_,_,_), C).
h(inputp, h(_,_,_,D,_,_,_), D).
h(value,  h(_,_,_,_,E,_,_), E).
h(pos,    h(_,_,_,_,_,F,_), F).
h(filterp,h(_,_,_,_,_,_,G), G).

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

%-------------------------------
% showwhat we got.


at(X) :-
        clause(@Y,Z),
	functor(Y,X,A),
	functor(Blank,X,A),
	bagof((@Y:-Z), X^A^(clause(@Y,Z),
	                    functor(Y,X,A)),
                       All),
	forall(member(Item,All), portray_clause(Item)),
	nl, forall(at1(Blank,Comment), 
                     portray_clause(Comment)).

at1(Blank, (:- dynamic F/A)) :-
	predicate_property(Blank,dynamic),
	functor(Blank,F,A).
at1(Blank,(:- index(Blank))) :- 
	predicate_property(Blank,indexed(Blank)).
at1(Blank, place(F,B,C)) :-
	functor(Blank,F,_),
	place(F,B,C).
at1(Blank, about(Blank,Inputs,Id)) :-
	about(Blank,Inputs,Id).
at1(Blank, blank(F,Blank)) :-
	functor(Blank,F,_),
	blank(F,Blank).
at1(Blank, swap0(Blank,X,Y,Z,New)) :-
        swap0(Blank,X,Y,Z,New).
at1(Blank, (term_expansion(Blank,New) :- Body)) :-
	clause(term_expansion(Blank,New),Body).
	


%---------------


xpandArgs(This @F,Args,Out) :-  !,
	xpandArgs1(Args,F,This,ToDo),
	l2c([blank(F,This)|ToDo],Out).
xpandArgs(F, Args,Out) :-
	xpandArgs(_@F,Args,Out).

xpandArgs1([],_,_,[]).
xpandArgs1([A=Term with  Args1|Args],F,This,[Goal|Todo]) :- !,
	xpandArgs(B@Term,Args1,Goal),
	xpandArgs1([A=B|Args],F,This,Todo).
xpandArgs1([with  Args1|Args],F,This,Todo) :- !,
	xpandArgs1([globals with  Args1|Args],F,This,Todo).
xpandArgs1([A=B|Args],F,This,[arg(Pos,This,B)|Todo]) :- 
	place(F,A,Pos),
	xpandArgs1(Args,F,This,Todo).
xpandArgs1([Arg|Args],F,This,[Arg|Todo]) :-
	xpandArgs1(Args,F,This,Todo).

%---------------
% load time fix stuff

asString(X,X) :- var(X),!.
asString(X,Y) :- string_to_atom(X,Y).
posnum(X,X)   :- number(X), X >= 0.

