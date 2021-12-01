:- load_files([meta,lib,tables,config,demos],
	      [silent(true)]).

ver :-
        format('\n~s\n\n',
	       ["Welcome to CHEETAH (Version 2);
Copyright (c) 2001 Tim Menzies (tim@menzies.com).
Copy policy: GPL-2 (see www.gnu.org)
Quickly peeking."]).

:- ver.





