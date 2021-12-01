:- multifile optimise/1.
:- dynamic   optimise/1.

:- [answer,utils,ram,abduct].

wmeGroups([setup,run]).

:- style_check(-singleton).

wme(setup,askable(X)).
wme(setup,out(X)).
wme(setup,in(X)).
wme(setup,assumable(X)).
wme(setup,mutex(X,Y)).
wme(setup,rule0(X,Y)).
wme(run,answer(X,Y)).

:- style_check(+singleton).

:- wmeSetUp.

:- [rules].

:- wmeClear(optimise),
	forall(optimise(X), 
	       (print(optimised(X)),nl)).


