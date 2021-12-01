wme(data(_,_,_,_)).
wme(delta()).

wmeSetup :-
	wme(X),
	functor(X,F,A),
	(dynamic F/A),
	fail.
wmeSetup.

wmeShow :-
	wme(X),
	X,
	format('~p.\n',[X]),
	fail.
wmeShow.

wmeZap :-
	wme(X), 
	retractall(X),
	fail.
wmeZap.

wmeReset :- wmeSetup, wmeZap.

wmeSize(S) :-
	bagof(1,X^(wme(X),X),L),
	length(L,S).
