:- op(999,xfy,ror).
:- op(998,xfy,rand).
:- op(997,fx,&).
:- op(996,xfx,with).
:- op(996,fx,with).
:- op(990,fx,@).
:- op(990,xfx,@).

:- X= (swap0/5,about/3,(@)/1,place/3,blank/2),
   (discontiguous X),
   (multifile X).
:- index(swap0(1,0,0,1,0)).
:- index(places(1,1,0)).
:- dynamic seed/1.

:- arithmetic_function(rand/1), 
   arithmetic_function(r/0),
   arithmetic_function(beta/1),          
   arithmetic_function(gamma/2),
   arithmetic_function(range/3).

:- L=[randror1    % randdro0 switches eveything back to SLD
     ,rtypes
     ,stats
     ,quotes
     ,rand0       % true random numbers. use rand1 for seed control.
     ,utils
     ,loading
     ,sysdd
     ,timedd
     ,dd
     ,bagger
     ,tests
    ], load_files(L,[silent(true)]).

hello :- 
	format('~s\n\n',["
Welcome to Bagger (Version 1.0)
Copyright (c) 2000 Tim Menzies (tim@menzies.com)
Copy policy: GPL-2 (see www.gnu.org)"]),
	& quotation(Words,Author),
        format('~s\n\t-- ~s\n\n',[Words,Author]).

