:- op(1,fx,?).
:- op(1001,xfy, :).

?a.
?a :- b : g : c.

term_expansion((?X :- Y),Out) :- !,
	bagof(Bigger,X^Y^xpand(X,Y,Bigger),Out).
term_expansion(? X,Out) :- 
	term_expansion((?X :- true),Out).

xpand((Head,Heads), Body0,[One|Rest]) :- !,
	gensym(heads_,Sym),
	TempHead =.. [Sym,In,Out],
	c2l((Head,Heads),L),
	bagof((XHead :- TempHead),
                L^In^Out^xpandHeads(L,In,Out,XHead),Rest),
	xpandBody(Body0,In,Out,Body),
	xpand1(TempHead,L,Body,One).

xpand(Head0,Body0, Out) :-
	plus2(Head0,In,Out,Head),
	xpandBody(Body0,In,Out,Body),
	xpand1(Head,[Head0],Body,Out).

xpand1(Head,What,Body,(
	Head :- 
		believable_(What),
		Body,
		believe_(What)
	).

xpandHeads(L0,In,Out,HeadPlus2) :- 
	oneLess(L0,Head,_),
	plus2(Head,In,Out,HeadPlus2).

xpandBody((X0,Y0),In,Out,shuffle_(N,Items)) :- !,
	xpandBody(X0,In,Temp,X),
	xpandBody(Y0,Temp,Out,Y),
	c2l((X,Y),L),
	numberoff(L,Items,0,N).
xpandBody((X0:Y0),In,Out,(X,Y)) :- !,
	xpandBody(X0,In,Temp,X),
	xpandBody(Y0,Temp,Out,Y).
xpandBody({X},In,In,X) :- !.
xpandBody((X;Y),In,Out,Z) :- !, 
	(Z0=X;Z0=Y), xpandBody(Z0,In,Out,Z).
xpandBody(not(X0),In,_,no(X)) :- !,
	plus2(X0,X). 
xpandBody(X,In,Out,Y) :- plus2(X,In,Out,Y).


numberOff([],[],N,N).
numberOff([H|T],[N0/H|Rest],N0,N) :-
	N1 is N0 + 1,
	numberOff(T,Rest,N1,N).
	
		xpandHead(Heads,In,Out,Rest,Head,HeadPlus2).

xpandHead(Heads0,In,Out,Head,HeadPlus2),
	c2l(Heads0.Heads),
	oneLess(Heads,Head,Rest),
	plus2(Head,In,Out,HeadPlus2).

xpand1((X;Y),Head,Rest,

%%%% general utils (yawn)

plus2(In,One,Two,Out) :-
	In =.. L0,
	append(L0,[One,Two],L),
	Out =.. L.

c2l((X,Y),[X|Z]) :- !, c2l(Y,Z).
c2l(X,[X]).

oneLess([X|Y],X,Y).
oneLess([X|Y],Z,[X|T]) :- oneLess(Y,Z,T).
