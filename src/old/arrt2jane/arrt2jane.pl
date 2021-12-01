starlog :-
	format('\nWelcome to StarLogOne
Copyright (c) 2001 Tim Menzies (tim@menzies.com)
Copy policy: GPL-2 (see www.gnu.org)\n\n',[]).

:- starlog.

:- load_files([lib],[silent(true),if(changed)]).

:- + xpands.


