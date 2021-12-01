:- write('% Welcome to ROGIC (Version 0.2) 
% Copyright (c) 2000 Tim Menzies
% Copy policy: GPL-2 (see http://www.gnu.org)
% Documentation: http://www.tim.menzies.com/rogic
% Some random peeking finds (nearly) as much as long slow staring?'),nl,nl.

:- op(1200, xfx,   <-).
:- op(998,   fy,    o).
:- op(998,  xfy,    o).
:- op(997,  xfy,  ror).
:- op(996,  xfy, rand).
:- op(995,  xfx,   so).
:- op(993,   fy,  not).
:- op(990,  xfx,  ask).
:- op(990,  xfx, keep).
:- op(751,  xfx,   do).
:- op(750,  xfx,  was).
:- op(748,  xfx,  now).
:- op(740,  xfx,   :=).
:- op(720,  xfx,   of).
:- op(710,  xfx,    @).
:- op(1,     fx,   as).
:- op(1,     fx,   ++).
:- op(1,     fx,   +-).
:- op(1,     fx,   -+).
:- op(1,     fx,   --).

portray(A/_) :- nonvar(A), once(o1(A,_,_)),write(' #'(A)),write(' ').

:-  X=(o1/3,aoIndex/3,in/3, (o)/5),
   (dynamic X),(discontiguous X),(multifile X),
   index(o1(1,1,0)), 
   index(o(1,1,0,0,0)), 
   index(aoIndex(1,1,0)), 
   index(in(1,1,0)).
   
:- dynamic cautious/0.
% comment out the following to stop typos checking in accessors
% (which is faster, but not as safe).
cautious.

:- expand_file_name('bin/*.pl',L), 
   load_files(L,[silent(true)]).
   
:- arithmetic_function(myrand/1).

% use a generator with seed control
%myrand(R,N)  :- my_random(R,N).
%seed0(13).
%:- (dynamic seed/1),reset_seed.

% use prolog's random number generator
myrand(R,N)  :- N is random(R).

%%% 
% bunch of back-compatability stuff)
:- op(900, fx, (*)).
:- op(850, fx, if ).
:- op(825,xfx,then).
:- op(800,xfx,(++)).
:- op(800,xfx,(--)).
:- op(800,xfx,+-+).
:- op(800,xfx,+--).
:- op(800,xfx,--+).
:- op(800,xfx,---).
:- op(1,   fx,no).

term_expansion((*if no X then Y  ++ Z), Out):- !,xpand((-X,(Z <-   Y)),Out).
term_expansion((*if no X then Y  -- Z), Out):- !,xpand((-X,(Z <-  -Y)),Out).
term_expansion((*if no X then Y +-+ Z), Out):- !,xpand((-X,(Z <- ++Y)),Out).
term_expansion((*if no X then Y +-- Z), Out):- !,xpand((-X,(Z <- +-Y)),Out).
term_expansion((*if no X then Y --+ Z), Out):- !,xpand((-X,(Z <- -+Y)),Out).
term_expansion((*if no X then Y --- Z), Out):- !,xpand((-X,(Z <- --Y)),Out).
term_expansion((*if    X then Y  ++ Z), Out):- !,xpand(( X,(Z <-   Y)),Out).
term_expansion((*if    X then Y  -- Z), Out):- !,xpand(( X,(Z <-  -Y)),Out).
term_expansion((*if    X then Y +-+ Z), Out):- !,xpand(( X,(Z <- ++Y)),Out).
term_expansion((*if    X then Y +-- Z), Out):- !,xpand(( X,(Z <- +-Y)),Out).
term_expansion((*if    X then Y --+ Z), Out):- !,xpand(( X,(Z <- -+Y)),Out).
term_expansion((*if    X then Y --- Z), Out):- !,xpand(( X,(Z <- --Y)),Out).
term_expansion((*             Y  ++ Z), Out):- !,xpand((   Z <-   Y),Out).
term_expansion((*             Y  -- Z), Out):- !,xpand((   Z <-  -Y),Out).
term_expansion((*             Y +-+ Z), Out):- !,xpand((   Z <- ++Y),Out).
term_expansion((*             Y +-- Z), Out):- !,xpand((   Z <- +-Y),Out).
term_expansion((*             Y --+ Z), Out):- !,xpand((   Z <- -+Y),Out).
term_expansion((*             Y --- Z), Out):- !,xpand((   Z <- --Y),Out).

% end back-compatiabiliy stuff

term_expansion((B+A of O = V --> C),X) :-  !,
	term_expansion((B+(A of O) = V --> C),X).
term_expansion(B+(A of O) = V,X) :- !,
	term_expansion((B+(A of O = V) --> true),X).
term_expansion((B*A=Out-->C),X) :- !,
	rules0((B+A=Out--> C),X).
term_expansion((B*A -->C),X) :- !,
	rules0((B+A=_--> C),X).
term_expansion((B+A=Out-->C),X) :- !,
	rule0((B+A=Out--> C),X).
term_expansion((B+A-->C), X) :- !,
	rule0((B+A=_  --> C),X).
term_expansion(B+A=Out, X) :- !,
	rule0((B+A=Out--> true),X).
term_expansion(B=L,X) :- 
	is_list(L), !, def(B,L,X).
term_expansion(B+A,X) :- 
	rule0((B+A=_  --> true),X).
term_expansion((X <- Y) ,All) :- 
	findall(One,xpand((X <- Y),One),All). 
term_expansion([rx=Rx|Results],Out) :-
	genScenario([rx=Rx|Results],Out).



:- dynamic a/5, best/1.
:- index(a(1,1,1,0,0)).

:- expand_file_name('dd/*.pl',L),
   load_files(L,[silent(true)]).
   
%% load the model we are processing 
% (passed using a -m flag)

:- ignore((unix(argv(Argv))
          ,append(_PrologArgs,['-m',File|_], Argv)
          ,[File]
         )).