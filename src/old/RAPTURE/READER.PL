:- op(990,fx,*).
:- op(100,xfx,++).
:- op(100,xfx,--).

term_expansion(*[H|T],Out) :-
	flag(vid,_,0),
	flag(eid,_,0),
	xpandNames([H|T],Out).

xpandNames([],[]).
xpandNames([H|T],
	[n(H),v(Vid1,H,or),v(Vid2,bar(H),bor)|Rest]) :-
	flag(vid,Vid1,Vid1+1),
	flag(vid,Vid2,Vid2+1),
	xpandNames(T,Rest).

term_expansion(*X ++ Y,Out) :-
	bagof(One,X^Y^xpandLinks(X++Y,One),Out).

term_expansion(*X -- Y,Out) :-
	bagof(One,X^Y^xpandLinks(X--Y,One),Out).

xpandLinks(X ++ Y,Out) :-
	twins(X,Id1,Bid1),
	twins(Y,Id2,Bid2),
	(newE(Id1,  Id2,Out)
        ;newE(BId1, BId2,Out)).

xpandLinks(X -- Y,Out) :-
	twins(X,Id1,Bid1),
	twins(Y,Id2,Bid2),
	(newE(Id1,  BId2,Out)
        ;newE(BId1,  Id2,Out)).

addAnd(Out) :-
	twins(_,Id,Bid),
	w e(_,Up,Id,C1),
	w e(_,Up2,Bid,C2),
	gensym(and,And),
	n(And),
	
	n(H),v(Vid1,H,or),v(Vid2,bar(H),bor)
	member(Out,[ 
	
twins(X,Id,Bid) :- twins0(X,Id,Bid); twins0(X,Bid,Id).

twins0(X,Id,Bid) :-
	w v(Id,X,_), 
	w v(Bid,bar(X),_).

% must preserve the g-space rules	
newE(To,From,Out) :-
	twins(_,To,Bid1),
	twins(_,From,Bid1),
	newE0(To,From,Out)
	;newE0(Bid1

newE0(To,From,e(Eid,To,From,1)) :-
	flag(eid,Eid,Eid+1).

	
	
	
	

