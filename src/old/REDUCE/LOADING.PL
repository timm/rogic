% load time control

% there's lots of repeatition in this code- deliberately slow. my first
% version did lots of same things togethe and had all manner of strange
% variable bindings. this one is much stupidier, easier to read, etc. etc.

% XXX use that dcg trick to simplify parsing of the clause ehaders
% XXX let claude heads be structures
% XXX add a meta(X) var to handle my stuff

:- discontiguous swap0/5,about/3.
:- [as,loadingh].

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
knownp(X) :- format('E> unknown: ~p\n',[X]),nl,fail.

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
	swaps0(F,Details,Out)
        ;index0(F,Details,Out)
        ;about0(F,Details,Out)
        ;filter0(F,Details,Out).

%---------------------
swaps0(F,Details,swap0(Old,Name,OldV,NewV,New)) :-
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

