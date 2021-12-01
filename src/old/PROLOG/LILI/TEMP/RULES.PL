rule(a,[and,[not, b],c,d]).
rule(c,[and,[or,b,z],g,h,k]).
rule(h,[and,l]).
rule(k,[and, z]).

say boolean; b,z.

numeric(X) :- not(boolean(X)).

say askable; b;d;g;h;k;l;x.

say out	;a is t.

say in	;b is t
	;z is t 
	;b is f
	;z is t.

% everthing is assumable.
assumable(X) :- not(fact(X)).

fact(X) :- in(X) ; out(X).

opp(t,f).
opp(X = A, X /= A).
opp(X >  A, X =< A).
opp(X >= A,X < A).

mutex(X,Y) :- opp(X,Y).
mutex(X is A, X is B) :- opp(A,B).
mutex(b is t, z is t).
