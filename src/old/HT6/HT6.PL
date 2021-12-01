:- op(1002,xfy,ror).
:- op(1001,xfy,rand).
:- op(701,fy,?).
:- multifile touch/3,def/4.
:- arithmetic_function(rand/1).
:- dynamic seed/1. 
:- load_files([sets,utils,pansion,wme,random,  do,control], [silent(true)]).


:- 
	format('~s\n\n',["
Welcome to JANE (Version 0.6)
Copyright (c) 2001 Tim Menzies (tim@menzies.com)
Copy policy: GPL-2 (see www.gnu.org)
Can a few random peeks replace many hard stares?"]).

