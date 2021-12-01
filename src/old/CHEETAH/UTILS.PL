term_expansion((+X,Y),Out) :- pluses(X,Y,Out).

pluses(X,Y,Out) :-
	bagof(Z,X^Y^(Y,expand_term(X,Z)),Out).

global(X,Y,Z) :- retract(globalVar(X,Y)), !,assert(globalVar(X,Z)).
global(X,_,Z) :- assert(globalVar(X,Z)).

eds :- unix(shell('xemacs *.pl &')). 

oneLess([One|Less],One,Less).
oneLess([H|Tail],One,[H|Less]) :- oneLess(Tail,One,Less).

sub([],[]).
sub([_|T0],T) :- sub(T0,T).
sub([H|T0],[H|T]) :- sub(T0,T).

sumof(X,Y,Z) :- bagof(X,Y,L), sum(L,Z).

averageOf(N,X,Y,_) :- 
	flag(averageOf,_,0),
	between(1,N,_),
	Y,
	flag(averageOf,Old,Old+X),
	fail.
averageOf(N,_,_,Z) :-
	flag(averageOf,Sum,Sum),
	Z is Sum/N.

isList([]).
isList([_|_]).

asList(X,X) :- is_list(X),!.
asList(X,[X]).

c2l((X,Y),[X|Rest]) :- !, c2l(Y,Rest).
c2l(X,[X]).

average(L,A) :-  sum(L,0,S), length(L,N), A is S/N.

prod([H|T],Out) :- prod(T,H,Out).

prod([],X,X).
prod([H|T],In,Out) :- Temp is In * H, prod(T,Temp,Out).

sum([H|T],Out) :- sum(T,H,Out).

sum([],X,X).
sum([H|T],In,Out) :- Temp is In + H, sum(T,Temp,Out).

max([H|T],Out) :- max(T,H,Out).

max([],X,X).
max([H|T],In,Out) :- Temp is max(In,H), max(T,Temp,Out).

min([H|T],Out) :- min(T,H,Out).

min([],X,X).
min([H|T],In,Out) :- Temp is min(In,H), min(T,Temp,Out).

middle(H,[H]) :- !.
middle(M,L)   :- mid1(L,L,M).

mid1([A|_],[]     ,A).
mid1([A|_],[_]    ,A).
mid1([_|B],[_,_|T],Mid) :-mid1(B,T,Mid).

%=========================

% histogram stuff
bins(L,B) :-
	msort(L,L1),
	bins(L1,[],B).

bins([],X,X).
bins([H|T],[H-N0|Rest],Out) :- !,
	N is N0 + 1,
	bins(T,[H-N|Rest],Out).
bins([H|T],In,Out) :-
	bins(T,[H-1|In],Out).

dist(L) :- dist(5,5,3,L).
  
dist(W1,W2,W3,L) :-
	sformat(S,'~~~wP  ~~~wP ~~~wS\n',[W1,W2,W3]),
	bins(L,Bins),
	nl,
	format(S,[item,frequency,0]),
	forall(member(What-N,Bins),format(S,[What,N,N])).

% misc print utilities (needed for the histogram stuff)

pblanks(A,X) :-
	forall(between(1,A,_),write(X)).

pdots(default,A) :- pdots(5,A).
pdots(S,A) :-
	writeThing(A,Thing,N),
	Pad is S - N,
	write(Thing), 
	pdots1(Pad,' ','.').

pdots1(N0,C1,C2) :-
	N0> 0,!,
	N is N0 - 1,
	write(C1),
        pdots1(N,C2,C2).
pdofts1(_,_,_).

padChars(default,A) :- padChars(5,A).
padChars(S,A) :-
	writeThing(A,Thing,N),
	Pad is S - N,
	forall(between(1,Pad,_),put(32)),
	write(Thing).

charsPad(default,A) :- charsPad(5,A).
charsPad(S,A) :-
	writeThing(A,Thing,N),
	atom_length(A,N),
	Pad is S - N,
	write(Thing),
	forall(between(1,Pad,_),put(32)).
    
writeThing(X,S,L) :- sformat(S,'~w',[X]), string_length(S,L).

twiddle(default,A) :- twiddle(25,A).
twiddle(W,N) :-
	N1 is round(N/W),
	forall(between(1,N1,_),put(126)).

%-----------------

rmembers(X,All) :- setof(One,X^rmember(X,One),All).

rmember(X,X)     :- var(X),!,fail.
rmember(X,X)     :- atom(X),!.
rmember([],_)    :- !,fail.
rmember([H|T],X) :- !,member(One,[H|T]), rmember(One,X).
rmember(Term,X) :-
	compound(Term),
	arg(_,Term,Y),
	rmember(Y,X).

runiv(Term0, Swaps,Term) :-
        Term0 =..L0,
        once(maplist(runiv1(Swaps), L0, L)),
	Term =.. L.

runiv1(_,H,H)  :- var(H).
runiv1(Swaps,Old,New)  :- atomic(Old), member(Old/New,Swaps),!.
runiv1(_,H,H) :- atomic(H).
runiv1(Swaps,H0,H) :- runiv(H0,Swaps,H).
	
rPrint(Term) :- t2l(Term,L),numbervars(L,0,_),lPrint(L).

lPrint(L) :- forall(lPrint(L,-1,'|    '),true).

lPrint(L,Level,Before) :-
    is_list(L),!,
    member(X,L),
    lPrint(X,Level+1,Before).
lPrint(X,Level,Before) :-
    N is Level,
    forall(between(1,N,_), write(Before)),
    write(X),nl.


%===========
showl(L) :- showl(L,'[',',',']').

showl([H|T],Before,Between,After) :-
	write(Before),
	write(H),
	forall(member(X,T),(write(Between),write(X))),
	write(After).

	