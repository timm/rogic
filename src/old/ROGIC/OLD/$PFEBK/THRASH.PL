term_expansion(vars=Slots,Out) :-
	length(Slots,N),
	functor(Term,w,N),
	findall(slot(Slot,Pos,Term),nth1(Pos,Slots,Slot),Out).
	

:- op(999,xfx,in).
[] in _.
[X|Y] in Term :- X in Term, Y in Term.

Slot+New in Term :- 
	slot(Slot,Pos,Term), 
	setarg(Pos,Term,New).
Slot-Old+New in Term :- !,
	slot(Slot,Pos,Term),
	arg(Pos,Term,Old), 
	setarg(Pos,Term,New).
Slot=Old in Term :- 
	slot(Slot, Pos,Term), 
	arg(Pos, Term, Old).
+Slot in Term :- 
	Slot-Old+New in Term,
	New is Old+1.
Slot << X in Term :-
	Slot-(N-Old)+(N1-[X|Old]) in Term,
	N1 is N + 1.
reset in Term :- 
	[list0(done), list0(todo)] in Term.
list0(Slot) in Term :-
	Slot+(0-[]) in Term.

vars = [best,goals,todo,done].
init(T) :-
	[thashes+1
	,fiddles+0
	] in T.

:- op(1002,xfy,ror).
:- op(1001,xfy,rand).
:- dynamic val/2,in/2,best/1.

sometimes :- 0 is random(2).

X ror  Y :- sometimes -> (X;Y) ; (Y;X).
X rand Y :- sometimes -> X,Y   ; Y,X.

assume(X,Y) :- in(X,Z), !,Y=Z.  %q: what about outs?
assume(X,Y) :- val(X,Z),!,Y=Z.
assume(X,Y) :- assert(val(X,Y)).
assume(X,Y) :- retract(val(X,Y)), fail.

go(Goals) :-
	length(Goals,N),
	[goals=Goals,nGoals=N] in V.

step(Todo,Done,W) :- 
	[done=(NDone-Done),todo=(_-Todo),best=Best0] in W,
	(NDone > Best0
	->	retractall(best(_)),
		forall(a(X,Y), assert(best(a(X,Y)))
		best+NDone in W
	;	true),	
	retractall(a(_,_)),
	reset in W,
	fiddle1

fiddle(W) :-
	step(W).
fiddle(Todo0,Done0,W).
	try(Todo0,W),
	try(Done0,W),
	[done=Done,todo=Todo] in W,
	fiddle(W).

try([],_).
try([A=B|Y],W) :-
	(assume(A,B), try1(X)  -> Memo=done ; Memo=todo),
	Memo<<X,
	try(Y,W).
	

	

	




