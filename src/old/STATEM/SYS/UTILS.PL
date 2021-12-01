%%%%% control stuff 
pattern(jump,x_(X))      :- once(x1_(X)).
pattern(jump,x1_([])).  
pattern(jump,x1_([X|Y])) :- x_(X), x_(Y).
pattern(jump,x1_((X,Y))) :- x_(X), x_(Y).
pattern(walk,x1_(X))     :- X.

:- m(X), member(Y,[jump,walk]), swaps(Y,[x/must,x1/must1],X).
must1(X) :- barph(not,X).

:- m(X), member(Y,[jump,walk]), swaps(Y,[x_/might,x1_/might1],X).
might1(X) :- oops(not,X).

:- m(X), swaps(jump,[x_/force,x1_/force1],X).
force1((X;_)) :- X,!.
force1((_;Y)) :- must(Y).

%%%%% io stuff
oops(X,Y)  :- swi(format(user_error,'%W> ~w ~w ~n',[X,Y])), fail.
barph(X,Y) :- swi(format(user_error,'%E> ~w ~w ~n',[X,Y])), halt.

%%%% string stuff
%
asString(F,Args,Out) :- 
	swi(sformat(S,F,Args)), swi(string_to_atom(S,Out)).
%
nchars(N,Out) :- nchars(N,32,Out).
nchars(0,_,[]).
nchars(N0,C,[C|Rest]) :- 
	N0 > 0, N is N0 - 1, nchars(N,C,Rest).
%
say(X,Y) :- writef('%20R : %p\n',[X,Y]).
%
sizedAtom(In,Size,Out) :- 
	sizedAtom(In,Size,r,Out).
sizedAtom(In,Size,Where,Out) :- 
	string_length(In,Size0),
	compare(C,Size0,Size),
	sizedAtom1(C,Size0,Size,Where,In,Out).

sizedAtom1(<,Size0,Size,Where,In,Out) :-
	 nchars(Size - Size0,Pad0),
	 string_to_atom(Pad0,Pad),
	 member(Where=Args,[l=[Pad,In],r=[In,Pad]]),
	 asString('~w~w',Args,Out).
sizedAtom1(=,_,_ ,_,In,In).
sizedAtom1(>,_,Size,_,In,Out) :-
	name(In,String1), 
	firstN(Size,String1,String2), 
        string_to_atom(String2,Out).

%%%%% list stuff
firstN(0,_,[]).
firstN(N0,[H|T],[H|Rest]) :- 
	N0 > 0, N is N0 -1, firstN(N,T,Rest).

members([],_).
members([F=V/D|T],L) :- !,
	(member(F=V,L) -> true ; V=D),
        members(T,L).
members([F=V|T],L) :- 
        member(F=V,L),
	members(T,L).

asList(X,X) :- is_list(X),!.
asList(X,[X]).