:- op(1001,  fx, if). 
:- op(1000, xfx, then). 
:- op(999,  xfy, or). 
:- op(998,  xfy, and). 
:- op(995,   fy, not).

:- index(wme(1, 1, 0)).

:- (discontiguous wme/3),
   (dynamic wme/3),
   load_files( [ wme
               , pq
	       , sp2_utils
               , utils
               , pqwrap
               , xpand
               , timtrans
               , randomxpd
	       , random/random
	       , goals
               , demos
               , sp2
               , coax
               , sp2wrap
               , pqtests
               ], [silent(true)] ).

:- 	format('~s\n\n',["Welcome to RAPTURE (Version 1.12); 
Copyright (c) 2001\nTim Menzies (tim@menzies.com)\nClaudia Chiang (claudia_chiang@email.com). 
+++ Fast reasoning till the end of time +++"]).

