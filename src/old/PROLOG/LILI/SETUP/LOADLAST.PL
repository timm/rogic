:- dynamic error/2, warning/2.

usedNotSet(X,Where) :-
	used(X,Where),
	\+ set(X,_).

setNotUsed(X,Where) :-
	set(X,Where),
	\+ used(X,_).

missingInAction :-
	usedNotSet(What,Where),
	sformat(Msg,'~w: not set but used in [~w]',[What,Where]),
	barph(Msg),
	assert(error(What,Msg)),
	fail.
missingInAction :-
	setNotUsed(What,Where),
	sformat(Msg,'~w: not used but set in [~w]',[What,Where]),
	warn(Msg),
	assert(warning(What,Msg)),
	fail.
missingInAction.

emptyObjects :- 
	all
	emptyObject.

emptyObject :-
	object(X,Attr),
	\+ ground(Attr),
	member(A=V,Attr),
	var(V),
	sformat(Msg,'~w of ~w not completed',[A,X]),
	assert(warning(X,Msg)),
	warn(Msg).

checks :-
	retractall(error(_,_)),
	retractall(warning(_,_)),
	assert(error(any,'sigh')),
	assert(warning(any,'sigh1')),
	missingInAction,
	emptyObjects.

:- checks.