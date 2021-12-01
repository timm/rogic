% time pl -g [tar2],go,halt > tar2.out

:- dynamic optimizing/1.
%optimizing(2).

:- op(100,xfx, (in) ).
:- op(99, xfx, (..) ).

:- (Stuff= (accessor/2, baseAccessor/2)),
	dynamic(Stuff),
	discontiguous(Stuff),
	multifile(Stuff).

:- load_files([lib,standard,accessor,shell,
	%climb,
	run,demos,
	%oddsr1000
	art1
        ],
	[silent(true)]).

:- 
	format('~s\n\n',["Welcome to TARZAN (Version 2.0); 
Copyright (c) 2001 Tim Menzies (tim@menzies.com). 
Copy policy: GPL-2 (see www.gnu.org)
Looking for a few good nudges...."]).

