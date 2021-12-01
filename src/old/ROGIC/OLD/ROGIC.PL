
%and if we dont know anything about X, we just ignore it 

:- op(999,xfx,@).
:- [lookup,lib].


about(X=Y@Z,X,Y,Z).

assume(X,In,Out) :-
	about(X,Key,Value,When),!,
	lookup(Key,Old,New,In,Out),
	assume1(Key

assume(_,Out,Out).




