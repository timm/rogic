demo :-
	demo1(-), % for finding the worst treatment
	nl,
	demo1(+). % for finding the best treatment

demo1(Dir) :-
	forall(
	   weightedSets(Dir,4,   % max size of the treatments
	                    15,  % number of treatments to propose
			    Rx),
	   (print(Rx),nl)).


/*
  lets say that the attribute ranges
  a,b,c,d,e,f,g,h,i,k,l,l,m

  have the confidence1 histogram

  -4:~~~~~~~~~~                      [     1 -  8%] 
  -1:~~~~~~~~~~                      [     1 -  8%] 
   0:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  [     3 - 23%] 
   1:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  [     3 - 23%] 
   2:~~~~~~~~~~~~~~~~~~~~            [     2 - 15%] 
   5:~~~~~~~~~~                      [     1 -  8%] 
   6:~~~~~~~~~~                      [     1 -  8%] 
  10:~~~~~~~~~~                      [     1 -  8%] 
*/

% i'll store this in prolog as follows
histogram([
             [a]=10,    [b]=6, [c]=5,
	     [d,e]=2,    [f,g,h]=1, 
             [i,j,k]=0, [l]= -1, [m]= -4
	     ]).

% e.g. historgrams is ([Item|Items] = Level)+

/*******************************************************

sample output

?- make.
% c:/temp/tar3.pl compiled 0.00 sec, 0 bytes

Yes
?- demo.
[i, d, c, a]
[i, d]
[l, k]
[m, f, a]
[m, l, h, f]
[l]
[l]
[l, k, c]
[l]
[m, k, c, a]
[l, f, c]
[l, j, h, g]
[k]
[m]
[m, l, h, g]

[a, b, e]
[m]
[e]
[a, b, c]
[b, c, d]
[c, d, e]
[b, c, f]
[a]
[a]
[m]
[e, m]
[a]
[d]
[a, d]
[b]

Yes
?-

*****************************************************/

% if the histogram has negative numbers, shift
% up the bottom above 1 (otherwise one of the
% calcs below will crash)

reset(+,CF0,CF) :-
	last(_=N0,CF0),
	N is N0 * -1,
	maplist(stepup(N),CF0,CF).

reset(-,CF0,CF) :-
	reverse(CF0,CF1),
	maplist(negate,CF1,CF2),
	reset(+,CF2,CF).

% helper predicates for reset/3
negate(List=Level0,List=Level) :-
	Level is Level0 * -1.
stepup(N,List=Level0,List=Level) :-
	Level is N + Level0 + 1.



        % Jump is true if we are to jump
% to the next item at a probability
	% set by comparing this confidence levels 
	% to the next confidence level
jump(Level1,Level2) :-
	magicNumber(N),
	Thresehold is ((Level1 - Level2)/Level1)^N,
	random(1000) < Thresehold*1000.

magicNumber(0.3).

% main driver: generate some treatments and
% include attributes into the treatments,
% favoring the attribute ranges that occur
% near the top of the histogram

weightedSets(Dir,MaxChanges0,Repeats,Rx) :-
	histogram(Items0),
        reset(Dir,Items0,Items),
	% for 1 = 1 to repeats do
	between(1,Repeats,_),
	% pick a treatment size at random
	MaxChanges is random(MaxChanges0) + 1,
	% try and produce a treatment of that size
	once(someOf(MaxChanges,Items,Rx)).


% a top-down once parser
someOf(A,B,C) :- once(someOf1(A,B,C)).

someOf1(0,_ ,[]).              % found enough changes

someOf1(_,[],[]).              % no more items found at any level

someOf1(N,[[]= _|Rest],Out) :- % no more items found at this level
	someOf(N,Rest,Out).    % so goto next level

someOf1(N,[_   =Level1         % maybe jump this level
	 ,Items=Level2
         |Rest],Out) :-
	jump(Level1,Level2),
	someOf(N,[Items=Level2|Rest],Out).

someOf1(N0,[Items=Level|Rest  ], % base action:
 	   [One|Others]) :-      % pull an item at random from this level
	N is N0 - 1,
        rone(Items,One,LessItems),
	someOf(N, [LessItems=Level|Rest], Others).

% low-level driver. yawn.
rone(L,One,Less) :-
	length(L,N),
	rone(L,N,One,Less,_).
rone([H],_,H,[],0) :- !.
rone([H|T],N0,X,Out,N) :-
	N is N0 - 1,
	Pos is random(N0) + 1,
	oneLessN(Pos,[H|T],One,Rest),
	(X=One, Out=Rest
	; Out=[One|Tail],
	  N1 is N0 - 1,
	  rone(Rest,N1,X,Tail,_)).

oneLessN(1,[H|T],H,T) :- !.
oneLessN(N0,[H|T],X,[H|Rest]) :-
	N is N0 - 1,
	oneLessN(N,T,X,Rest).