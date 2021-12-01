
odcg1([],[],X,X).
odcg1([H0|T0],[H|T],In,Out) :-
	odcg1(H0,H,In,Temp),
	odcg1(T0,T,Temp,Out).
odcg1(X@Y, oo(X,W,_),In,In)  :- 
	var(X),!,
	(odcg2(Y,Z) -> W=Z ; W=Y).
odcg1(up@X, oo(In,super(Y),Out),In,Out) :- !,
	(odcg1(X,Z,In,Out) -> Y=Z ; Y=X). 
odcg1(me@X, oo(In,Z,Out),In,Out) :- !,
	(odcg1(X,Y,In,Out) -> Y=Z ; X=Z). 
odcg1(X@Y, (GetPut,oo(Old,Z,New)),In,Out)  :- !,
	odcg1(X:=Old\New,GetPut,In,Temp),
	(odcg1(Y,A,Temp,Out) -> Z=A; Z=Y,Out=Temp).
odcg1(X := W,  oo(In,Call,Out), In,Out):- 
	nonvar(W),W=(Y\Z),!,
	odcg2(X := Y\Z,Call).
odcg1(X := Type@Calls0,(oo(new(Type),Calls1,New),Call),
        In,Out) :- !,
	odcg2(Calls0,Calls1),
	odcg1(X := New,Call,In,Out).
odcg1(X := Y,  oo(In,Call,Out), In,Out):- !,
	odcg2(X := _\Y,Call).
odcg1(X=Y,  oo(In,Call,Out),  In,Out):- !,
	odcg2(X=Y,Call).


odcg2([H|T],Out) :- 
	maplist(odcg2,[H|T],Out).
odcg2(X := W,Call) :-  
	nonvar(W), W=(Y\Z),!,
	asString('~wIs',[X],Method),
	Call =.. [Method,Y,Z].
odcg2(X := Y,Call) :- 
	asString('~wIs',[X],Method),
	Call =.. [Method,_,Y].
odcg2(X = Y,Call) :- 
	Call =.. [X,Y].

	





s1 is std + [callees, connections]. 
with init            --> name := phone, setOrigin(dialtone).
with setOrigin(X)    --> start := X.
with getOrigin(Y)    --> start=X, oo(state,name=dialtone,Y). 
with event(X)        --> callee(X); connection(X); dial(X); after(X).
with callee(One)     --> callees@take(One).
with connection(One) --> connections@take(One).
with dial(digit(n)).
with after(sec(15)).
with init --> up@init, 
              {oo(new(rList)@give([answers,hangsUp,answers],Callees),
	       oo(new(rList)@give([busy,connected],         Connections)
	      },
	      callees     := Callees,
	      connections := Connections,
	      commit. %?? needed

assignTypes([_|Types],Blank) :- 
	Blank =.. [_,_|Fields],
	maplist(assignType,Types,Fields).

assignType(_=Default:_,Default)    :- nonvar(Default),!.
assignType(_=Default:prim,Default) :- !.
assignType(_=_:Type,New)           :- oo(new(Type),[],New).





:- Stuff = (recordDefinition/1, blank/3, update/1,
            a/2, a/3, touch/3, bridge/3,
            recordDefinition/1),
   (multifile     Stuff),
   (discontiguous Stuff).

%thing(p_, 'parent thing').
%thing(t,  'type symbol')
%thing(t_, 'type symbol plus dash suffix').
%thing(b,  'blank term of type t').
%thing(n,  'a new term of type f').
%thing(i,  'id of term t').
%thing(f,  'somefact about type t').
%thing(q,  'a query about type t').
%thing(v,  'variable within t_').
%thing(nth,'position of v in t_').

pattern(prim(value),t_(value(X),p(X),p(X))).
pattern(fact,       t_(p,Y,Y)).
pattern(oo(blank),  blank(t,i,b)).
pattern(oo(isa),    t_(M,In,Out)) :-
	\+ local(f_(M0,_,_), M0,M)),
        p_(M,In,Out).
pattern(oo(bridge), o(b,M)) :-
	t_(M,b,_).
pattern(oo(bridge), o(b,M,Out)) :-
	t_(M,b,Out).
pattern(oo(new),    t_(new,n,n)).
pattern(oo(get),    t_(v(Old),T,T)) :- 
	arg(nth,T,Old).
pattern(oo(looping),t_([],T,T)).
pattern(oo(looping),t_([One|Rest],T0,T)) :- 
	t_(One, T0,T1), 
	t_(Rest,T1,T).
pattern(oo(put),    t_(v(Old,New),T,T)) :- 
	arg(nth,T,Old),
	setarg(nth,T,New).
pattern(oo(isa),    t_(isa(p_),X,X)).
pattern(oo(super),  t_(super(M),In,Out)) :-
	p_(M,In,Out).
% must be last
pattern(oo(bottom), t_(X,In,Out)) :- 
	not(known(t_,X)), p_(X,In,Out).







