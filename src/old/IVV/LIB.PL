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
