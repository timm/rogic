% stats- stuff to load everything else

:- load_files([config
              ,utils
              ,hist
	      ,dcgplus
	      ,accessor
              ,o
	      ,demos
	      ],[silent(true)]).

:-
        format('\n~s\n\n',["Welcome to STATS-PACK (Version 0.1);
Copyright (c) 2001 Your Group's Name (yoursecretaries@name.com).
Copy policy: GPL-2 (see www.gnu.org)
There are lies, damned lies, and statistics. 

Hint:
:- demo(2). "]).

:- oStatus.

