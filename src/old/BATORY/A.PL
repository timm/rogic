% if no answer, what about a partial answer?
% if > 1 answer, what about options control? (e.g. most specific)

/*:- op(xfx,1,:).

term_expansion((*X :- Y),Out) :-
	bagof(One,X^Y^xpand_((X:-Y),One),Out).

xpand~((X :- Y),[(a(X,Head) :- Head)|Out]) :-
	xpand(Y,Body,[],Args0),
	reverse(Args0,Args),
	Head =.. [X|Args],
	(Body0=true
        -> Out=Head
        ;  Out=(Head :- Body)).

xpand((X;Y),Z,A0,A)      :-  !, (Z0=X;Z0=Y),xpand(Z0,Z,A0,A).
xpand((X0,Y0),(X,Y))     --> !, xpand(X0,X),xpand(Y0,Y).
xpand({X},X,A,A)         :-  !.
xpand(X,true,A0,[X|A0])  :-  atomic(X),!.
xpand([],[],A,A)         :-  !.
xpand([X0|Y0],[X|Y])     --> !,xpand(X0,X),xpand(Y0,Y).
xpand((X0,Y0):T,(X,Y))   --> !,xpand(X0:T,X), xpand(Y0:T,Y).
xpand(X:T,F,A0,[A|A0])   --> A=[X,Arg],F=[T,
xpand(X0,X,A0,[A)        :-  X =.. [F|L0], xpand(  A=.. [F|L].

*amethod :- heap(d:node) ; unord(d:node) ; bplus((d,i):node); 
            isam((d,i):node) ; hash(d:node) ; grid(d:node).
*node    :- ord_prim_only(p:block) ; unord_prim_only(p:block) ;
            ord_prim_shar((p,o):block) ; unord_prim_shar((p,o):block).
*block   :- fix_anch ; var_acnh ; fix_unach ; var_unanch.
*/
:- discontiguous a/2.

a(amethod,X)   :- amethod(X).
a(amethod,[X,Y]) :- amethod(X,Y).

:- discontiguous amethod/1, amethod/2.
amethod(heap(D)) :- node(D).
amethod(unord(D)) :- node(D).
amethod(bplus(D)) :- node(D).
amethod(isam(D0),isam(D1)) :- node(D0),node(D1).
amethod(hash(D)) :- node(D).
amethod(grid(D)) :- node(D).

a(node,X) :- node(X).
a(node,[X,Y]) :- node(X,Y).

:- discontiguous node/1, node/2.
node(ord_prim_only(P)) :- block(P).
node(unord_prim_only(P)) :- block(P).
node(ord_prim_shar(P,O)) :- block(P), block(O).
node(unord_prim_shar(P,O)) :- block(P), block(O).

a(block,X) :- block(X).
:- discontiguous block/1.
block(fix_anch).
block(var_anch).
block(fix_unanch).
block(var_unanch).





