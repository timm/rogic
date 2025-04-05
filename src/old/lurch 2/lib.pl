try(X) :- X.
try(_).

spit(X) :- print(X), nl,pause.

pause :- get_single_char(_).

min([H|T],Min) :- min(T,H,Min).

min([],X,X).
min([H|T],In,Out) :- 
	(In < H -> Temp=In ; Temp=H),
	min(T,Temp,Out).

average(L,A) :-
	sum(L,S),
	length(L,N),
	A is S/N.
	
sum([H|T],N) :- sum(T,H,N).

sum([],Z,Z).
sum([H|T],X,Z) :-  Y is X + H,  sum(T,Y,Z).
 
sums(L0,S) :- flatten(L0,L), sum(L,S).

=(K,V,Old, [K=V|Less])  :- less1(Old,K=V0,Less),!, V0 = V. 
=(K,V,Old, [K=V|Old]). 

less1([H | T],H,T).
less1([H0|T0],H,[H0|T]) :- less1(T0,H,T).

:- dynamic knownBuiltIn/1.

 makeBuiltin(X) :- knownBuiltIn(X),!.
 makeBuiltin(X) :- assert(knownBuiltIn(X)).

 :- forall(predicate_property(X,built_in), makeBuiltin(X)).

:- arithmetic_function(normal/2).

normal(M,S,N) :-
        box_muller(M,S,N).

% classical fast method for computing
% normal functions using polar co-ords
% (no- i dont understand it either)
box_muller(M,S,N) :-
        w(W0,X),
        W is sqrt((-2.0 * log(W0))/W0),
        Y1 is X * W,
        N is M + Y1*S.

w(W,X) :-
        X1 is 2.0 * ranf - 1,
        X2 is 2.0 * ranf - 1,
        W0 is X1*X1 + X2*X2,
        % IF -> THEN ; ELSE
        % same as xx :- IF,!, THEN,
        %         xx :- ELSE
        % vars bound in IF not available to ELSE
        % no backtracking within the IF
        % -> ; precendence higher than ,
        (W0  >= 1.0 -> w(W,X) ; W0=W, X = X1).

:- arithmetic_function(ranf/0).

ranf(X) :-
        N =  65536,
        % X is random(N) returns a
        % random number from 0 .. N-1
        X is random(N)/N.

repeats(N,X) :-
	between(1,N,I),
	memo(I),
	once(X),
	fail.
repeats(_,_).

memo(X) :- 0 is X mod 250, !, write(user,X), nl(user), flush_output(user).
memo(_).

printl([X|Y],Sep) :- 
	write(X), 
	forall(member(Z,Y),format('~w~w',[Sep,Z])).

oneof(X,Y,Z) :-
	bagof(X,Y, L),
	rone(L,Z,_).
	
bassert(X) :- assert(X).
bassert(X) :- retract(X),fail.

variable(X) :- var(X), barph('var found').

barph(X) :- format('E> ~w\n',[X]), abort.

d2l((X;Y),[X|Rest]) :- !,d2l(Y,Rest).
d2l(X,    [X]).

c2l((X,Y),[X|Rest]) :- !,c2l(Y,Rest).
c2l(X,    [X]).
 
rone(L,One,Rest) :- length(L,N), rone(L,N,One,Rest,_).

rone([H],_,H,[],0) :- !.
rone([H|T],N0,X,Out,N) :-
        N is N0 - 1,
        Pos is random(N0) + 1,
        less1(Pos,One,[H|T],Rest),
        (X=One,
         Out=Rest
        ; Out=[One|Tail],
          N1 is N0 - 1,
          rone(Rest,N1,X,Tail,_)).

less1(1,H,[H|T],T) :- !.
less1(N0,X,[H|T],[H|L]) :-  N is N0 - 1, less1(N,X,T,L).
