:- Made=(defined/1, e/3, lambda/2, n/2),
   (discontiguous Made),
   (dynamic Made).

:- index(e(1,1,1)).
:- index(n(1,1)).
:- index(lambda(1,1)).
:- index(cutEdge(1,1)).
:- index(zprime(1,1)).
:- index(zprime2(1,1)).

:- op(1001,  fx, if). 
:- op(1000, xfx, then). 
:- op(999,  xfy, or). 
:- op(998,  xfy, and). 
:- op(995,   fy, not).

:- load_files( [ wme
               , pq
	       , util
	       , pqwrap
	       , xpand
	%       , topoi
	       , timtrans
	      , egs/t016
	       , demos
	       , samples
	       , sp2
	       , coax
	       , sp2wrap ], [silent(true)] ).

:- 	format('~s\n\n',["Welcome to RAPTURE (Version 1.12); 
Copyright (c) 2001\nTim Menzies (tim@menzies.com)\nClaudia Chiang (claudia_chiang@email.com). 
+++ Fast reasoning till the end of time +++"]).

