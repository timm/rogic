
%and if we dont know anything about X, we just ignore it 

:- op(999,xfx,@).
:- [lookup,lib].


about(X=Y@Z,X,Y,Z).

assume(X,In,Out) :-
	about(X,Key,Value,When),!,
	wme(Key,Old,New,In,Out),
	oneLess(

assume(_,Out,Out).




