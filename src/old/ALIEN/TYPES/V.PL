:- +[records, lib/lists].

record(v(attr,op,value,time,kind)).

v0(print,v(I,A,O,V,T,K),v(I,A,O,V,T,K)) :-
	format('~p : ~p ~p ~p @ ~p (~p)',[I,A,O,V,T,K]).

v0(and,v(I,_  ,_,_,T,and ),
       v(I,and,=,t,T,and)).
v0(or,v(I,_  ,_,_,T,or ),
       v(I,_,_,_,T,or)).

v0(allowed,v(I,A,O,V,T,K),v(I,A,O,V,T,K)) :- \+culled(I).

v0(contradicts(V1id),v(I,A,Op1,V,T,K),v(I,A,Op1,V,T,K)):-
	v(V1id,A,Op2,V1,T,K),
	\+ (V1=V,Op1=Op2). % wrong for maths ops but we'll literalise those later

v0(outOfEnv(Env),v(I,A,O2,V2,T,K),v(I,A,O2,V2,T,K)) :-
	member(comp(A,O1,V1),Env),
	\+ (V1=V2,O1=O2).
 
v0(I@T,v(I,A,O,V,T,K),v(I,A,O,V,T,K)).

v0(simultaneous(V1),v(I, A,O,V,T,K),v(I,A,O,V,T,K)) :-
 	            v(V1,_,_,_,T,_).

v0(kid(K))    --> v0(id(Me)), {join(e,_,[from(Me),to(K)])}.
v0(parent(P)) --> v0(id(Me)), {join(e,_,[from(P),to(Me)])}.

v0(name(A@Details),v(I,A,O,V,T,K),v(I,A,O,V,T,K)) :-
	Details =.. [O,T,V].

vName(Id,Name) :- join(v,Id,name(Name)).



