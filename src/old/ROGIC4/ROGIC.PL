
+X :- load_files(X,[silent(true)]).

:- +[ops,lib,xpand,functions,abduce].

welcome :- 
	format('\n~s\n\n',[
"Welcome to ROGIC (ver 4, build 0); 
Copyright (c) 2001 Tim Menzies (tim@menzies.com). 
Copy policy: GPL-2 (see www.gnu.org)\n
For all is but a woven web of guesses.
-- Xenophanes
"]).
