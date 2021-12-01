{X} :- load_files(X,[silent(true)]).

%%%%%%%%%%%%%%%%%%%%%
:- {utils}.

:- op(999,xfx,if).
:- op(998,xfx,then).
:- op(998,xfy, or).
:- op(997,xfy,and).
:- op(996, fy,not).
:- op(895,xfy,with).
:- op(895,xfx,in).   
:- op(895,xfx,has).   
:- op(701,xfy,of).
:- op(2,fx,rule).
:- op(1,xfx,for).
:- dynamic about/3, alreadyUsed/5, orderings/2.
:- discontiguous touch/3,def/3,if/6,
                 then/5,about/3,orderings/2.
:- index(if(  1,1,1,1,0,0)).
:- index(then(1,1,0,0,0)).
:- {pansion}.

:- dynamic shutUp/0.
:- {infer}.

:- {dd},{kb}.

:-
        format('~s\n\n',["Welcome to BAGGER (Version 0.1);
Copyright (c) 2001 Tim Menzies (tim@menzies.com).
Copy policy: GPL-2 (see www.gnu.org)
Remember, chips need Pepsi. "]).

