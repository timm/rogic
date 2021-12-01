/*
I'm embarassed to say I can't find it, although I still have the datasets
generated from it. However, I did find the little simulator of the toy
pipes and tanks model also used in that paper (Figure 2, p52). Is that
any good? It's below (uses a couple of Quintus libraries, but you can
get by without them).

Best wishes! 

Pete
*/

% File: pipes.pl
% Author: Peter Clark
% Purpose: Pipe simulator
% Date: 6th Jan 1993

%:- ensure_loaded([
%library(sets), % Need subset/2, or use defn at end of file.
%library(random) % Only need if you want to randomise initial
%]). % water levels in tanks.

/* Usage:
%% prolog
%Quintus Prolog Release 3.1.3 (Sun-4, SunOS 4.1)
%| ?- [simulator].
%| ?- simulate.
*/

% ======================================================================

simulate :- 
	Type = fixed, % do 'random' for alternative
	initial_levels(Type, Ls),
	timesteps_between_output(TOut),
	end_time(EndT),
	write('% Running simulation from T=0 to T='), write(EndT),
        write(' showing levels every '), write(TOut), write(' steps.'), nl,
	write('%             LEVELS IN TANKS:'), nl,
        write('% t1   t2    t3    t4    t5    t6    t7'), nl,
        write_levels(Ls),
	simulate(Ls, 1). 

timesteps_between_output(50).
end_time(1000).

% ======================================================================
% THE SIMULATOR
% ======================================================================

% simulate(+CurrentLevelsInTanks, +Time)
simulate(_, T) :-
	end_time(T),
	!.
simulate(Ls, T) :-
	curr_flows(Ls, T, Fs),   % calculate flows Fs in the pipes
	tanks(Ts),
	delta_levels(Ts, Fs, DLs),   % find changes in Ls
	new_levels(Ls, DLs, NewLs),   % calculate the new levels NewLs
	timesteps_between_output(TOut),
	( T is integer(T/TOut)*TOut -> write_levels(NewLs) ; true ),
	NewT is T + 1,
	simulate(NewLs, NewT).

new_levels([], [], []).
new_levels([T-L|Ls], [T-DL|DLs], [T-NewL|NewLs]) :-
	MidNewL is L + DL,
	chop(MidNewL, NewL),
	new_levels(Ls, DLs, NewLs).

% chop(+CalculatedNewLevel, -ActualNewLevel)
% This modifies the new level to handle cases of the tank being full or empty
chop(L, 0) :- L < 0, !.    % tank can't be less than empty
chop(L, Max) :- maxlevel(Max), L > Max, !. % tank overflows!!
chop(L, L).

delta_levels([], _, []).
delta_levels([T|Ts], Fs, [T-DL|DLs]) :-
	delta_level(T, Fs, DL),
	delta_levels(Ts, Fs, DLs).

% --------------------

% Given levels Ls in tanks at time T, calculate flows Fs in all the pipes
curr_flows(Ls, T, Fs) :-
	pipes(Ps),
	curr_flows(Ps, Ls, T, Fs).

curr_flows([], _, _, []).
curr_flows([P|Ps], Ls, T, [P-Flow|Flows]) :-
	flow(P, Ls, T, Flow),
	curr_flows(Ps, Ls, T, Flows).

write_levels([_-L]) :- !, format('~2f~n', [L]).
write_levels([_-L|Ls]) :- format('~2f, ', [L]), write_levels(Ls).

% ======================================================================
% THE TANK NETWORK
% ======================================================================

/*
This describes the 7-tank, 10-pipe network shown in "Using Qualitative 
Models to Guide Inductive Learning", P.Clark and S. Matwin, in Proc. MLC-93
(to appear). Change as you like to implement different networks.

Levels in tanks vary from 0 (empty) to 20 (full/overflowing).
*/

tanks([t1,t2,t3,t4,t5,t6,t7]).
pipes([p1,p2,p3,p4,p5,p6,p7,p8,p9,p10]).

initial_levels(fixed, [t1-10,t2-10,t3-10,t4-10,t5-10,t6-10,t7-10]).
initial_levels(random, Ls) :- random_levels(Ls).

random_levels(Ls) :-
	tanks(Ts),
	random_levels(Ts, Ls).

random_levels([], []).
random_levels([T|Ts], [T-L|Ls]) :-
	random(R),
	maxlevel(Max),
	L is R*Max,
	random_levels(Ts, Ls).

maxlevel(20).

% xsection(+Pipe, -CrossSectionArea)
xsection(_, 0.02). % all pipes have same cross-section

% ======================================================================
% FLOW: Calculate flow between time T and T+DeltaT in each pipe
% ======================================================================

% Flow = volume of water passing through Pipe between time T and T+DeltaT
% flow(+Pipe, +CurrentTankLevels, +T, -Flow)
% Generally: Flow in pipe = pressure * width of pipe
% and  pressure is proportional to level in the tank feeding pipe
%      (in fact, below I take pressure = level)
% I: Pipes (no valves)
flow(p2, Ls, _, Fl) :- subset([t1-L1], Ls), xsection(p2, W), Fl is W*L1.
flow(p4, Ls, _, Fl) :- subset([t1-L1], Ls), xsection(p4, W), Fl is W*L1.
flow(p6, Ls, _, Fl) :- subset([t3-L3], Ls), xsection(p6, W), Fl is W*L3.
flow(p8, Ls, _, Fl) :- subset([t5-L5], Ls), xsection(p8, W), Fl is W*L5.
flow(p9, Ls, _, Fl) :- subset([t6-L6], Ls), xsection(p9, W), Fl is W*L6.
flow(p10, Ls, _, Fl) :- subset([t7-L7], Ls), xsection(p10, W), Fl is W*L7.

% II: Pipes with valves:
% Here, the flow in the pipe is "choked" according to how full the 
% valve-controlling pipe is. 
flow(p3, Ls, _, Fl) :- 
	subset([t1-L1,t5-L5], Ls), % t5 is the valve-controlling tank
	xsection(p3, W), 
	maxlevel(Max), 
	Fl is ((Max-L5)/Max)*L1*W. % choke according to how full t5 is
flow(p5, Ls, _, Fl) :- 
	subset([t2-L2,t5-L5], Ls), 
	xsection(p5, W), 
	maxlevel(Max), 
	Fl is ((Max-L5)/Max)*L2*W.
flow(p7, Ls, _, Fl) :- 
	subset([t4-L4,t7-L7], Ls), 
	xsection(p7, W), 
	maxlevel(Max), 
	Fl is ((Max-L7)/Max)*L4*W.

% III: Input into the whole circuit
% Could simply say input pressure is constant (L0=1). 
% OR: more interesting: vary input pressure L0 with time, eg. saw-tooth wave.
flow(p1, Ls, T, Fl) :- 
% L0 = 1,       % constant in-pressure
/*or*/ TMod is integer(T/20) mod 20,             % variable in-pressure
/*..*/ ( TMod =< 10 -> L0 = TMod ; L0 is 20 - TMod ),  
xsection(p1, W), 
maxlevel(Max), 
subset([t6-P6], Ls), 
Fl is ((Max-P6)/Max)*L0*W. 

% ======================================================================
%   DELTA LEVELS: Given flow in time period T->T+DeltaT, calculate the 
%   resulting change in levels in each tank
% ======================================================================

% delta_level(+Tank, +FlowsInPipes, -ChangeInLevelInTank)
% Here the change in level DL is sum(flows into Tank) - sum(flows out of Tank)
delta_level(t1, Fs, DL) :- 
	subset([p1-F1,p2-F2,p3-F3,p4-F4], Fs), DL is F1-F2-F3-F4.
delta_level(t2, Fs, DL) :-
	subset([p2-F2,p5-F5], Fs), DL is F2-F5.
delta_level(t3, Fs, DL) :-
	subset([p3-F3,p6-F6], Fs), DL is F3-F6.
delta_level(t4, Fs, DL) :-
	subset([p4-F4,p7-F7], Fs), DL is F4-F7.
delta_level(t5, Fs, DL) :-
	subset([p5-F5,p6-F6,p8-F8], Fs), DL is F5+F6-F8.
delta_level(t6, Fs, DL) :-
	subset([p7-F7,p9-F9], Fs), DL is F7-F9.
delta_level(t7, Fs, DL) :-
	subset([p8-F8,p9-F9,p10-F10], Fs), DL is F8+F9-F10.

/* ====================================================================== */
% Utilities: Taken from the Quintus library

subset([], _).
subset([Element|Elements], Set) :- 
	memberchk(Element, Set),
	subset(Elements, Set).

memberchk(X, [X|_]) :- !.
memberchk(X, [_|Y]) :- memberchk(X, Y).

