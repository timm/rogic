% some details
:- dynamic used/1, val/2.

% define terms in a language


% clear working memory
reset :- retractall(used(_)).

% forward chaining interpreter
fChain :- reset, steps.

steps  :- step, !, steps.
steps.

step :-  if(X,then(Y,Z)), step1(X,Y,Z).

step1(X,Y,Z) :-
	\+ used(X),Y, assert(used(X)),
	!, Z.

% faster forward chainer: pre-compiles
% the rules into raw Prolog.
fastChain :- reset, run.

runs :- run,!, runs.
runs.

% fastChain's optimizer: looks up interpreter
% code at load time.
term_expansion(if(X,then(Y,Z)),(run :- Body)) :-
	clause(step1(X,Y,Z),Body).
%goal_expansion(X, (Y,print(X),nl)) :-
goal_expansion(X, Y) :-
	\+ predicate_property(X,built_in),
	clause(X,Y).

% language verbs
say(X)         :- print(X),nl.
and(A,B)       :- A,B.
or(A,B)        :- A;B.
in(A, ..(B,C)) :- val(A,X), X >= B, X < C.
upto(A, B)     :- val(A,X), X =< B.
below(A,B)     :- val(A,X), X <  B.
equals(A,B)    :- val(A,B).
over(A,B)      :- val(A,X), X > B.
downto(A,B)    :- val(A,X), X >= B.

:- op(999,xfx,if).
:- op(998,xfx,then).
:- op(997,xfy,or).
:- op(996,xfy,and).
:- op(995,fy,not).
:- op(700,xfx,[upto,below,equals,over,downto,in]).
:- op(700,fx,say).
:- op(1, xfx, .. ).


% sample knowledge base
r1 if age below 30
      and name equals 'ying'
      or not (sex equals male
              and age downto 40
	     )      
   then say hello(ying).
