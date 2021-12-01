%%%% OMO Support code
%%% Multis/2
%Fast, named, assertions
%<
multis(Stuff,All) :-
	bagof(One,Stuff^multi(Stuff,One),All).

multi((Heads :- Tail),(Head :- Tail)) :-
	d2l(Heads,List),
	member(Head,List).
%>
%%% Fields/3
%Poke some values into the named fields.
%<
fields(Fields,Functor,Term) :- fields1(Fields,Functor,Term),!.
fields(_,_,[]).

fields1([],_,_).
fields1([Field|Fields],Functor,Term) :-
	fields2(Field,Functor,Term),
	fields1(Fields,Functor,Term).

fields2(Field,Functor,Term) :-
	clause(Field,(Term,_)),
	functor(Term,Functor,_),!.
fields2(Field,Functor,_) :-
	barph(badField(Functor is [Field])).
%>
%%% w/2
%Convert scores to numeric weights
%<
w(A,W) :-
	demand(s(A,S)),
	postArch(A,S,W),
	demand(num10(W)).

postArch(A,S,W) :-
	cocomo(When),
	lookUp(postArch(When,_),A,S,W).
%>
%%% Random types
%% Random strings
%<
rsym(X)  :- nonvar(X),!.
rsym(X)  :- gensym(g,X).

rsym(_,X)  :- nonvar(X),!.
rsym(A,X)  :- gensym(A,X).
%>
%% Random number within a range %<
rin(M,N,_,X) :- nonvar(X),!, number(X),M =< X, X =< N.
rin(M,N,O,X) :- Steps is integer((N-M)/O),
	        between(1,Steps,_),
		Y is random(Steps+1),
		X is min(M + Y*O,N).
%>
%% Random value of a list %<
rin(M,N,X) :- nonvar(X),!, number(X),M =< X, X =< N.
rin(M,N,X) :- Steps is integer(N-M),
	      between(1,Steps,_),
	      Y is random(Steps+1),
	      X is min(M + Y,N).

rin(X,L) :- number(X),!, member(Y,L), X =:= Y.
rin(X,L) :- nonvar(X),!, member(X,L).
rin(X,L) :- length(L,N), rmember1(L,N,X).

rmember1([H],_,H)   :- !.
rmember1([H|T],N,X) :- Pos is random(N) + 1,
                       less1(Pos,[H|T],Y,L),
                       (X=Y
                       ; N1 is N - 1,
                         rmember1(L,N1,X)).
%>

