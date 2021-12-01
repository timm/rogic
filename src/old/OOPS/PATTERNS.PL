thing(p_, 'parent thing').
thing(t,  'type symbol')
thing(t_, 'type symbol plus dash suffix').
thing(b,  'blank term of type t').
thing(n,  'a new term of type f').
thing(i,  'id of term t').
thing(f,  'somefact about type t').
thing(q,  'a query about type t').
thing(v,  'variable within t_').
thing(nth,'position of v in t_').

pattern(prim(value),[t_,p], t_(value(X),p(X),p(X))).
pattern(fact,       [t_,p], t_(p,Y,Y)).
pattern(oo(blank),  [t,i,b], blank(t,i,b)).
pattern(oo(isa),    [t_,p_], t_(M,In,Out)) :-
	\+ local(f_(M0,_,_), M0,M)),
        p_(M,In,Out).
pattern(oo(bridge), [b,t_], o(b,M)) :-
	t_(M,b,_).
pattern(oo(bridge), [b,t_], o(b,M,Out)) :-
	t_(M,b,Out).
pattern(oo(new),    [t_,n], t_(new,n,n)).
pattern(oo(get),    [t_,n], t_(v(Old),T,T)) :- 
	arg(nth,T,Old).
pattern(oo(looping),[t_],  t_([],T,T)).
pattern(oo(looping),[t_],  t_([One|Rest],T0,T)) :- 
	t_(One, T0,T1), 
	t_(Rest,T1,T).
pattern(oo(put),    [v,nth],t_(v(Old,New),T,T)) :- 
	arg(nth,T,Old),
	setarg(nth,T,New).
pattern(oo(isa),    [t_,p_], t_(isa(p_),X,X)).
pattern(oo(super),  [t_,p],  t_(super(M),In,Out)) :-
	p_(M,In,Out).











