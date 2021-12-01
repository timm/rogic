bins([Num|Nums],Bins) :- bins(Nums,[Num-1],Bins).

bins([],B,B).
bins([H|T],[H-N0|Rest],Bin) :- !,N is N0 + 1,bins(T,[H-N|Rest],Bin).
bins([H|T],Rest,Bin)        :- bins(T,[H-1|Rest],Bin).

%%%%%%%%%%%%%%%%%%%%%%%%%%
:- dynamic dataSetId/1.
	
dataset(N) :- asserta(dataSetId(N)).
currentDataSetId(N) :- dataSetId(N),!.

%%%%%%%%%%%%%%%%%%%%%%%%%%

:- op(100,xfx,in).
:- op(99,xfx, .. ).

X in Y .. Z :-	X >= Y, X <Z.

infinity(X) :- X is (2^(31))+1.

portray(X in Y .. Z) :- 
  infinity(Z0),
  Z0 =:= Z
  -> format('~w in ~w .. ~w',[X,Y,infinity])
  ; format('~w in ~w .. ~w',[X,Y,Z]).


%%%%%%%%%%%%%%%%%%%%%%%%



groups(L,N,Gs) :- 
	length(L,Size),
	N1 is max(integer(Size/N),1),
	groups(L,N1,1,blah,Gs).

groups([],_,_,_,[]).
groups(L,N,Id0,Last,Out) :- 
	head(N,L,Min,Max,Rest),!,
	G=group(Id0,Min,Max),
	Next=group(_,Min,Max),
	(G=Last
         ->  groups(Rest,N,Id0,Next,Out)
        ;    Id is Id0 + 1,
             Out=[G|Gs],
             groups(Rest,N,Id, Next,Gs)).

groups([Min|_],_,Id,_,[group(Id,Min,Inf)]) :- infinity(Inf).

head(1,[H|T],H,H,T) :- !.
head(N,In,Min,Max,Rest) :- 
	N0 is N - 1,
	length([Min|T],N0), 
	append([Min|T],[Max|Rest],In).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- format_predicate('-',twiddles(_,_)).

twiddles(default,A) :- !,twiddles(1,A).
twiddles(Pack,A) :-
	N is round(A/Pack),
	forall(between(1,N,_),put(126)).

:- format_predicate('<',charsPad(_,_)).
:- format_predicate('>',padChars(_,_)).

padChars(default,A) :- !,padChars(5,A).
padChars(S,A) :-
        writeThing(A,Thing,N),
        Pad is S - N,
        forall(between(1,Pad,_),put(32)),
        write(Thing).

charsPad(default,A) :- !,charsPad(5,A).
charsPad(S,A) :-
        writeThing(A,Thing,N),
        Pad is S - N,
        write(Thing),
        forall(between(1,Pad,_),put(32)).

writeThing(X,S,L) :-
        sformat(S,'~w',[X]),
        string_length(S,L).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

l2c([X],X) :- !.
l2c([X|Y],(X,Rest)) :- l2c(Y,Rest).

%%%%%%%%%%%%%%%%%%%%%%%%%
unique(L0,L) :-  removeDupsKeepOrder(L0,L).

removeDupsKeepOrder(In,Out) :- 
	removeDupsKeepOrder(In,[],Out).

removeDupsKeepOrder([],_,[]).
removeDupsKeepOrder([H|T],Seen,Out) :-
	member(H,Seen),!,
	removeDupsKeepOrder(T,Seen,Out).
removeDupsKeepOrder([H|T],Seen,[H|Out]) :-
	removeDupsKeepOrder(T,[H|Seen],Out).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nOf(X,N) :-
	gensym(nOf,Sym),
	flag(Sym,_,0),
	forall(X,flag(Sym,N0,N0+1)),
	flag(Sym,N,N).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



sub([],[]).
sub([_|T],Rest) :- sub(T,Rest).
sub([H|T],[H|Rest]) :- sub(T,Rest).

%===========
showl(L) :- showl(L,'[',',',']').

showl([H|T],Before,Between,After) :-
	write(Before),
	write(H),
	forall(member(X,T),(write(Between),write(X))),
	write(After).
