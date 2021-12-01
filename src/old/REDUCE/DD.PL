% otuer facts get a first arg Iid
% 

%at X, what do we expect
%@ X.

:- [header,sysdd]. % must start the "-" definitions

:- dot(a).

@aka(A:key,B:asString,X=meta) :-
	X@meta 
        rand @xid(A) 
        rand @string(B).

:- dot(c).

@cost(A) :- 
	rin(A,[0,1,2,3,4]).

:- dot(d).

@dec10(X) :-
	rnum(0.05,1,0.05,X).

:- dot(e).

@effect(A:key,B,C,M=meta) : sometimes :-
	@fId(A)
	rand @pId(B)
        rand @dec10(C)
	rand M@meta.

:- dot(e).

@f(A:key,B,C,D,L,M=meta) : sometimes :-
	@gen(A,B,C,D,M)
	rand fId // L.
@fId(A) :-
	f(A,_,_,_,_,_),
	rsym(A).
@gen(A,B,C,D,M) :- % no inter-connections- so "," ok
	@sym(A)
	rand @strength(B) 
	rand @probability(C)
	rand @cost(D)
	rand M@meta.
@impact(A:key,B,C,M) : sometimes :-
	@fId(A)
	rand @rId(B)
	rand M@meta
	rand @dec10(C).
:- dot(i).

@liklihood(X) :- 
	@dec10(X).
@meta(A=source,B=charmed) :-
	@boolean(B) 
        rand @sourceId(A).
@p(A:key,B,C,D,L,M=meta) : sometimes :-
	@gen(A,B,C,D,M)
	rand pId // L.
@pId(A) :-
	p(A,_,_,_,_,_),
	rsym(A).
@probability(X) :-
	rnum(0,100,P),
	X is P/100.

:- dot(r).

@r(A:key,B,C,D,L,M=meta) : sometimes :-
	@gen(A,B,C,D,M)
        rand  rId // L.
@rId(A) :-
	r(A,_,_,_,_,_), 
        % when to check for existance?, when to add its?
        rsym(A).
@sourceId(X)  :-
	source(X,_,_,_),
	rsym(X).
@source(A : key, % note- 1st arg not always a key
             B, When = when,
	     M): sometimes :- 
	M@meta
        rand @sym(A) 
	rand @sym(B) 
        rand When@when.
@strength(X) :- 
	rnum(1,10,X).
@uid(X) :- rsym(X).
@xid(X) :-
	@pId(X) ror @fId(X) ror  @rId(X) ror @uid(X).

:- dot(x).
%:- verify.