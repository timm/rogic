% Figure 2.14   A program for the monkey and banana problem.

% move( State1, Move, State2): making Move in State1 results in State2;
%    a state is represented by a term:
%    state( MonkeyHorizontal, MonkeyVertical, BoxPosition, HasBanana)

move( state( middle, onbox, middle, hasnot),   % Before move
      grasp,                                   % Grasp banana
      state( middle, onbox, middle, has) ).    % After move 

move( state( P, onfloor, P, H),
      climb,                                   % Climb box
      state( P, onbox, P, H) ). 

move( state( P1, onfloor, P1, H),
      push( P1, P2),                           % Push box from P1 to P2
      state( P2, onfloor, P2, H) ). 

move( state( P1, onfloor, B, H),
      walk( P1, P2),                           % Walk from P1 to P2
      state( P2, onfloor, B, H) ).                   

% canget( State): monkey can get banana in State

canget( state( M, MP, Box, has),
        L,
       [state(M,MP,Box,has)|L]).      % can 1: Monkey already has it 

canget( State1,In,Out)  :-                   % can 2: Do some work to get it
  move( State1, Move, State2),        % Do something
  canget( State2,[Move,State1|In],Out).                    % Get it now

main :- canget( state(atfloor,onfloor,atwindow,hasnot),
               [],S),
        rprintl(S).

rprintl(L0) :- reverse(L0,L), printl(L).

printl(L) :- forall(member(X,L),(print(X),nl)).
 

