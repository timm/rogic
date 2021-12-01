% cant refer to something else unless that something else already exists
% define leaves before internals
% do aka last

:- [header]. % must start the "-" definitions

@aka(A,B,C) :- 
	@xid(A)
        rand @string(B) 
        rand @sym(C).
@cost(A) :- 
	rin(A,[0,1,2,3,4]).
@day(Day,Mn,_) :- 
	rin(Mn,[4,6,9,11]) 
        rand rin(0,30,Day).
@day(Day,Mn,_) :- 
	rin(Mn,[1,3,5,7,8,10,12]) 
        rand rin(0,31,Day).
% leap years need more work. one day.
@day(Day,2,Yr) :- 
	@year(Yr), 
	0 is Yr mod 4, 
	rin(0,29,Day).
@day(Day,2,Yr) :- 
	@year(Yr), 
	N is Yr mod 4, 
	N > 0, 
	rin(0,28,Day).
@dec10(C) :-
	rin(C,[0.1,0.2,0.3,0.4,0.5,
               0.6,0.7,0.8,0.9,1.0]).
@effect(A,B,C,D) :-
	&fId(A), 
	&pId(B),
	&sourceId(D), 
	rin(C,[0.1,0.2,0.3,0.4,0.5,
               0.6,0.7,0.8,0.9,1.0]).
@f(A,B,C,D,E,L) :-
	@gen(A,B,C,D,E)
	rand fId // L.
@fId(f(A)) :-
	@posint(A),
	@f(A,_,_,_,_).
@gen(A,B,C,D,E) :-
	@posint(A),
	@strength(B), 
	@liklihood(C),
	@cost(D),  
	&sourceId(E).
@hour(A) :- 
	rin(0,23,A).
@impact(A,B,C,D) :-
	&fId(A), 
	&rId(B),
	&sourceId(D), 
	@dec10(C).
@liklihood(X) :- 
	@dec10(X).
@minute(A) :- 
	rin(0,59,A).
@p(A,B,C,D,E,L) :-
	@gen(A,B,C,D,E)
	rand pId // L.
@pId(p(A)) :-
	@posint(A),
	p(A,_,_,_,_,_).
@posint(A) :- 
	rin(1,65535,A).
@r(A,B,C,D,E) :-
	@gen(A,B,C,D,E).
@rId(r(A)) :-
	@posint(A),
	@r(A,_,_,_,_).
@second(X) :- 
	rin(0,59,X).
@sourceId(X) :- 
	source(X,_,_).
@source(A,B,when(C,D,E,F,G,H)) :- 
	@sym(A) 
	rand @sym(B) 
        rand @when(C,D,E,F,G,H).
@string(A) :- rstring(string,A).
@strength(X) :- 
	rin(1,10,X).
@sym(A) :- 
	rsym(x,A).
@uid(X) :- rsym(x,X).
@when(A,B,C,D,E,F) :- 
	@year(A), 
        (@day(C,B,A) 
        rand @hour(D) 
        rand @minute(E)
	rand @second(F)
	).
@xid(X) :-
	@pId(X) ror @fId(X) ror  @rId(X) ror @uid(X).
@year(X) :- 
	X= 2000 
        ror rin(1974,1999,X) 
        ror rin(2001,2050,X).



